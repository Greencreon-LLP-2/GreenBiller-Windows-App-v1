import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';

import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/settings/models/store_users_model.dart';

import 'package:logger/logger.dart';

class UserCreationController extends GetxController {
  // Services
  late DioClient dioClient;
  late AuthController authController;
  late CommonApiFunctionsController commonApi;
  late Logger logger;

  // Form fields
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final password = ''.obs;
  final countryCode = '+91'.obs;
  final selectedRole = 'Manager'.obs;
  final selectedRoleId = 3.obs;
  final selectedStore = Rxn<String>();
  final selectedStoreId = Rxn<int>();
  final isLoading = false.obs;
  final isLoadingStores = false.obs;
  final storeMap = <String, int>{}.obs;
  final storeUsers = Rxn<StoreUsersModelsResponse>();
  final selectedUserIndex = 4.obs;

  final userRolesMap = {
    2: 'Manager',
    3: 'Staff',
    4: 'Store Admin',
    5: 'Store Manager',
    6: 'Store Accountant',
    7: 'Store Staff',
    8: 'Biller',
  };

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    authController = Get.find<AuthController>();
    commonApi = Get.find<CommonApiFunctionsController>();
    logger = Logger();

    loadStores();
    loadStoreUsers();
  }

  Future<void> loadStores() async {
    try {
      isLoadingStores.value = true;
      final stores = await commonApi.fetchStores();

      if (stores.isNotEmpty) {
        storeMap.assignAll(stores);
        selectedStore.value = stores.keys.first;
        selectedStoreId.value = stores.values.first;
      }
    } catch (e, stack) {
      logger.e("Error in loadStores: $e", e, stack);
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> loadStoreUsers() async {
    try {
      isLoadingStores.value = true;
      final url = selectedStoreId.value != null
          ? '$storeusersUrl?store_id=${selectedStoreId.value}'
          : storeusersUrl;

      final response = await dioClient.dio.get(url);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        storeUsers.value = StoreUsersModelsResponse.fromJson(response.data);
        logger.i('Loaded store users: ${storeUsers.value!.data.length} users');
      } else {
        storeUsers.value = StoreUsersModelsResponse(
          message: 'Failed to fetch store users',
          data: [],
          total: 0,
          status: 0,
        );
        logger.w('Failed to load store users: ${response.data}');
      }
    } catch (e, stackTrace) {
      logger.e('Error loading store users: $e', e, stackTrace);
      storeUsers.value = StoreUsersModelsResponse(
        message: 'Unexpected error: $e',
        data: [],
        total: 0,
        status: 0,
      );
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> createUser() async {
    try {
      isLoading.value = true;
      final errors = _validateFields();
      if (errors.isNotEmpty) {
        Get.snackbar('Error', errors.join('\n'), backgroundColor: Colors.red);
        return;
      }
      log(selectedRoleId.value.toString());
      final response = await dioClient.dio.post(
        signUpUrl,
        data: {
          'user_level': selectedRoleId.value.toString(),
          'name': name.value.trim(),
          'email': email.value.trim(),
          'country_code': countryCode.value.trim(),
          'mobile': phone.value.trim(),
          'password': password.value.trim(),
          'password_confirmation': password.value.trim(),
          'store_id': selectedStoreId.value.toString(),
        },
      );

      if (response.statusCode == 200) {
        await loadStoreUsers(); // Refresh user list
        Get.snackbar(
          'Success',
          'New user created successfully',
          backgroundColor: Colors.green,
        );
        clearForm();
      } else {
        final decodedData = response.data;
        if (decodedData is Map && decodedData.containsKey('errors')) {
          final errors = decodedData['errors'] as Map<String, dynamic>;
          final messages = errors.values.expand((e) => e).join('\n');
          Get.snackbar('Error', messages, backgroundColor: Colors.red);
        } else {
          Get.snackbar(
            'Error',
            decodedData['message'] ?? 'Signup failed',
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (e, stackTrace) {
      logger.e('Error creating user: $e', e, stackTrace);
      Get.snackbar('Error', 'Signup failed: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  List<String> _validateFields() {
    final errors = <String>[];
    if (name.value.isEmpty) errors.add('Name cannot be empty');
    if (email.value.isEmpty) {
      errors.add('Email cannot be empty');
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email.value)) {
      errors.add('Enter a valid email address');
    }
    if (countryCode.value.isEmpty) {
      errors.add('Country code is required');
    } else if (!RegExp(r'^\+?[0-9]{1,4}$').hasMatch(countryCode.value)) {
      errors.add('Invalid country code format');
    }
    if (phone.value.isEmpty) {
      errors.add('Phone number cannot be empty');
    } else if (!RegExp(r'^[0-9]{6,15}$').hasMatch(phone.value)) {
      errors.add('Invalid phone number');
    }
    if (password.value.isEmpty) {
      errors.add('Password cannot be empty');
    } else if (password.value.length < 6) {
      errors.add('Password must be at least 6 characters');
    }
    if (selectedRole.value.isEmpty) {
      errors.add('Please select a valid role');
    }
    if (selectedStoreId.value == null || selectedStore.value == null) {
      errors.add('Please select a valid store');
    }
    return errors;
  }

  void clearForm() {
    name.value = '';
    email.value = '';
    phone.value = '';
    password.value = '';
    countryCode.value = '+91';
    selectedRole.value = 'Manager';
    selectedRoleId.value = 3;
    selectedStore.value = storeMap.isNotEmpty ? storeMap.keys.first : null;
    selectedStoreId.value = storeMap.isNotEmpty ? storeMap.values.first : null;
  }
}

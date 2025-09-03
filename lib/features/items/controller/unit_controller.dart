import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';
import 'package:logger/logger.dart';

class UnitController extends GetxController {
  final DioClient dioClient = DioClient();
  final AuthController authController = Get.find<AuthController>();
  final CommonApiFunctionsController commonApi =
      Get.find<CommonApiFunctionsController>();
  final Logger logger = Logger();

  // Reactive states
  final units = Rxn<UnitModel>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Form controllers for dialog
  final unitNameController = TextEditingController();
  final unitValueController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final selectedStoreId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    try {
      isLoading.value = true;

      final unitModel = await commonApi.viewUnit();
      units.value = unitModel;
    } catch (e, stackTrace) {
      logger.e('Error fetching units: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load units: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> deleteUnitService(int unitId) async {
    try {
      final response = await dioClient.dio.delete('$deleteUnitUrl/$unitId');
      return response.statusCode ?? 500;
    } catch (e, stackTrace) {
      logger.e('Error deleting unit: $e', e, stackTrace);
      return 500;
    }
  }

  Future<String?> addUnitService(dynamic payload) async {
    try {
      final response = await dioClient.dio.post(createUnitUrl, data: payload);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.data;
        if (body is Map && body['message'] != null) {
          return body['message'] as String;
        }
        return 'Units Detail Created Successfully';
      } else if (response.statusCode == 422) {
        final body = response.data;
        if (body is Map && body['errors'] != null) {
          return (body['errors'] as Map).values
              .expand((e) => (e as List).map((v) => v.toString()))
              .join(', ');
        }
        return body['message'] ?? 'Validation failed';
      } else {
        return 'Failed to add unit: ${response.statusCode}';
      }
    } catch (e, stackTrace) {
      logger.e('AddUnitService exception: $e', e, stackTrace);
      return 'Error: ${e.toString()}';
    }
  }

  Future<void> deleteUnit(int unitId) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Unit'),
        content: const Text('Are you sure you want to delete this unit?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        isLoading.value = true;

        final response = await deleteUnitService(unitId);
        if (response == 200) {
          Get.snackbar(
            'Success',
            'Unit deleted successfully',
            backgroundColor: Colors.green,
          );
          await fetchUnits(); // Refresh units
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete unit',
            backgroundColor: Colors.red,
          );
        }
      } catch (e, stackTrace) {
        logger.e('Error deleting unit: $e', e, stackTrace);
        Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    unitNameController.dispose();
    unitValueController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

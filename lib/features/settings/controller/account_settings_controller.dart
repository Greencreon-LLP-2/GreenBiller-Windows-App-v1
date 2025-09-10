// account_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/settings/models/account_model.dart';
import 'package:logger/logger.dart';

class AccountController extends GetxController {
  // Services
  late DioClient dioClient;
  late Logger logger;

  // State
  final accounts = <Map<String, String>>[].obs;
  final selectedAccount = Rx<Map<String, String>?>(null);
  final isEditing = false.obs;

  // Form controllers
  late TextEditingController accountNameController;
  late TextEditingController bankNameController;
  late TextEditingController accountNumberController;
  late TextEditingController ifscCodeController;
  late TextEditingController upiIdController;
  late TextEditingController openingBalanceController;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    logger = Logger();

    accountNameController = TextEditingController();
    bankNameController = TextEditingController();
    accountNumberController = TextEditingController();
    ifscCodeController = TextEditingController();
    upiIdController = TextEditingController();
    openingBalanceController = TextEditingController();

    fetchAccounts();
  }

  @override
  void onClose() {
    accountNameController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    upiIdController.dispose();
    openingBalanceController.dispose();
    super.onClose();
  }

  void clearForm() {
    accountNameController.clear();
    bankNameController.clear();
    accountNumberController.clear();
    ifscCodeController.clear();
    upiIdController.clear();
    openingBalanceController.clear();
    selectedAccount.value = null;
    isEditing.value = false;
  }

  Future<void> fetchAccounts() async {
    try {
      final response = await dioClient.dio.get(viewAccountUrl);

      if (response.statusCode == 200) {
        final accountModel = AccountModel.fromJson(response.data);
        accounts.clear();

        for (var account in accountModel.data ?? []) {
          accounts.add({
            'id': account.id?.toString() ?? '',
            'name': account.accountName ?? '',
            'bank': account.bankName ?? '',
            'number': account.accountNumber ?? '',
            'ifsc': account.ifscCode ?? '',
            'upi': account.upiId ?? '',
            'balance': account.balance?.toString() ?? '0',
          });
        }
        logger.i('Fetched accounts: ${accounts.length}');
      } else {
        Get.snackbar(
          'Error',
          'No accounts found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Failed to fetch accounts: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch accounts',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void editAccount(Map<String, String> account) {
    selectedAccount.value = account;
    isEditing.value = true;
    accountNameController.text = account['name'] ?? '';
    bankNameController.text = account['bank'] ?? '';
    accountNumberController.text = account['number'] ?? '';
    ifscCodeController.text = account['ifsc'] ?? '';
    upiIdController.text = account['upi'] ?? '';
    openingBalanceController.text = account['balance'] ?? '';
  }

  Future<bool> createAccount(
    int storeId,
    String accountName,
    String bankName,
    String ifscCode,
    String upiId,
    String balance,
    String accountNumber,
    String userId,
  ) async {
    try {
      final response = await dioClient.dio.post(
        createAccountUrl,
        data: {
          "store_id": storeId,
          "account_name": accountName,
          "bank_name": bankName,
          "ifsc_code": ifscCode,
          "upi_id": upiId,
          "balance": balance,
          "user_id": userId,
          "account_number": accountNumber,
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e('Failed to create account: $e');
      return false;
    }
  }

  Future<bool> updateAccount(
    String accountId,
    int storeId,
    String accountName,
    String bankName,
    String ifscCode,
    String upiId,
    String balance,
    String accountNumber,
    String userId,
  ) async {
    try {
      final response = await dioClient.dio.put(
        '$editAccountUrl/$accountId',
        data: {
          "store_id": storeId,
          "account_name": accountName,
          "bank_name": bankName,
          "ifsc_code": ifscCode,
          "upi_id": upiId,
          "balance": balance,
          "user_id": userId,
          "account_number": accountNumber,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e('Failed to update account: $e');
      return false;
    }
  }
}

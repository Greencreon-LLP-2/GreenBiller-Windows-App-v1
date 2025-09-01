// account_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/settings/models/account_model.dart';
import 'package:logger/logger.dart';

class AccountController extends GetxController {
  final DioClient _dioClient = DioClient();
  final Logger _logger = Logger();

  final RxList<Map<String, String>> accounts = <Map<String, String>>[].obs;
  final Rx<Map<String, String>?> selectedAccount = Rx<Map<String, String>?>(
    null,
  );
  final RxBool isEditing = false.obs;

  // Text editing controllers
  final accountNameController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final upiIdController = TextEditingController();
  final openingBalanceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    _dioClient.setAuthToken(
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIwMTk3NDQ0OS04NmEwLTcxMjEtODk2NC0yMjUzODNiZmU0MzUiLCJqdGkiOiI3OGIwZDc0NzU2MDZiM2Q3YzNlNTQ1OTMxZDlmMGMzOTFlOTM1Y2ZjZDUxNzZkODdmNjEyZmQwYzg0YWQyNzA3MWFlOTY2ODQwZmY4ZDRlMyIsImlhdCI6MTc1NjcyMDIzMS40NjY5NDYsIm5iZiI6MTc1NjcyMDIzMS40NjY5NTIsImV4cCI6MTc3MjM1ODYzMS40MTMzNDQsInN1YiI6IjYyIiwic2NvcGVzIjpbXX0.ZVMeK8uZKSU9_jbgm39gp2ai6fAarKYV-0Qh9XzGga3_ybnA-z63Q6R3w1MCPKi8k41f-BxYDXMR-uEvvOW-umbPhW0mzB5XeQbskzabIbfVSI-_-anCxzV3Z8KQWY1UAH-_P8X1NvPWGpQALuBQeZ7cwqbFOAhVwCTguwBTdrUp8YxlMldRtje2EzH1q2l-tx68mah-Wgv-Te7LZCNzDSIXH9hMuU5H17l3DoM5KV0Hi5xR8lpD7y3WSjMVhOSmw68kDQinFNzYtEeLGQs3BH5KWuDkJdr-oyB4Jgb6HIN_UzGvcnhwqZ-VQXfj3L6hNjOXPuTEyIq1Ovj81lr6fkdscWX0x6BEY9MpsN_pBPh6DzBRq8_g4wQjg8GcEbt0EDhW7Gh0hzeX5Gb1yiB_QNyD3fqYkSfxVpXdRM2whMoEELYwTtME03ONfeQyDH5UEUyhsn2OvAg27L1v6ZgbwRHCiMagPBS3xRpQ0rEFHHizf3lonIrbBth2bYXpmC0tVoI45v0aOICBuicHNkAFHAcV-dMRDydXRe5kqC1jNfteFmB00CqDla0DhUhEuhyFnn-A6vT62QC2b_sIAmQdeIv4RbAueQ_4oYh798PyK7-1hwFnh37BN67E3bqmqdylyoz1ocHUM0QRVijeui0ucV5yqMzaUxz2_gHdBGAmSI8",
    );
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
      final response = await _dioClient.dio.get(viewAccountUrl);

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
        _logger.i('Fetched accounts: ${accounts.length}');
      } else {
        Get.snackbar(
          'Error',
          'No accounts found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Failed to fetch accounts: $e');
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
      final response = await _dioClient.dio.post(
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
      _logger.e('Failed to create account: $e');
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
      final response = await _dioClient.dio.put(
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
      _logger.e('Failed to update account: $e');
      return false;
    }
  }
}

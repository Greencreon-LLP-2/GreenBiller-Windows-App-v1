import 'package:flutter/material.dart';
import 'package:green_biller/features/settings/models/account/account_model.dart';
import 'package:green_biller/features/settings/services/account_service.dart';

class AccountController {
  Future<bool> createAccount(
      String accessToken,
      String storeId,
      String accountName,
      String bankName,
      String ifscCode,
      String upiId,
      String balance,
      String accountNumber,
      String userId,
      BuildContext context) async {
    try {
      final response = await AccountService().createAccountService(
          accessToken,
          storeId,
          accountName,
          bankName,
          ifscCode,
          upiId,
          balance,
          accountNumber,
          userId);
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create account'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account: $e')),
      );
      return false;
    }
  }

  //!~~===================================================================Get All Accounts
  Future<AccountModel> viewAccountController(
      String accessToken, BuildContext context) async {
    try {
      final response = await AccountService().viewAccountService(accessToken);
      return response;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve account details: $e')),
      );
      throw Exception('Failed to retrieve account details: $e');
    }
  }
}

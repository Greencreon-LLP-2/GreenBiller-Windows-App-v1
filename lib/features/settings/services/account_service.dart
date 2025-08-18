import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/settings/models/account/account_model.dart';
import 'package:http/http.dart' as http;

class AccountService {
  //~!~ ==========================================================Create Account
  Future<bool> createAccountService(
      String accessToken,
      String storeId,
      String accountName,
      String bankName,
      String ifscCode,
      String upiId,
      String balance,
      String accountNumber,
      String userId) async {
    try {
      final response = await http.post(
        Uri.parse(createAccountUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "store_id": storeId,
          "account_name": accountName,
          "bank_name": bankName,
          "ifsc_code": ifscCode,
          "upi_id": upiId,
          "balance": balance,
          "user_id": userId,
          "account_number": accountNumber
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to create account: $e');
    }
  }

  //~!~ ===================================================================Get All Accounts
  Future<AccountModel> viewAccountService(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse(viewAccountUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return AccountModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to view account: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to view account: $e');
    }
  }

  //~!~ ================================================================To edit Account
  Future<bool> editAccount(AccountModel account) async {
    try {
      final response = await http.put(
        Uri.parse(editAccountUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to edit account: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to edit account: $e');
    }
  }
}

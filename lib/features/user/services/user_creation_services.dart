import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/user/models/store_users.dart';
import 'package:http/http.dart' as http;

class UserCreationServices {
  Future<String> signUpApi(
    String userlevel,
    String name,
    String email,
    String countryCode,
    String phone,
    String password,
    String storeId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(signUpUrl),
        body: {
          'user_level': userlevel,
          'name': name,
          'email': email,
          'country_code': countryCode,
          'mobile': phone,
          'password': password,
          'password_confirmation': password,
          "store_id": storeId,
        },
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return "sucess";
      } else {
        // Handle API validation errors
        if (decodedData is Map && decodedData.containsKey('errors')) {
          final errors = decodedData['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((e) => e) // flatten list of error messages
              .join('\n'); // separate messages with new lines
          return messages;
        }

        return decodedData["message"] ?? 'Signup failed. Please try again.';
      }
    } catch (e) {
      return 'Signup failed: ${e.toString()}';
    }
  }

  Future<StoreUsersResponse> getStoreUsersList(
      String accessToken, String? storeId) async {
    final url =
        storeId != null ? '$storeusersUrl?store_id=$storeId' : storeusersUrl;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] != null && json['status'] == 1) {
          return StoreUsersResponse.fromJson(json);
        } else {
          return StoreUsersResponse(
            message: 'Failed to fetch store users',
            data: [],
            total: 0,
            status: 0,
          );
        }
      } else {
        // Gracefully return an "empty" response instead of throwing
        return StoreUsersResponse(
          message: 'Failed to fetch store users',
          data: [],
          total: 0,
          status: 0,
        );
      }
    } catch (e, stack) {
      print('StoreUsers error: $e');
      print(stack);

      // Gracefully handle unexpected exceptions
      return StoreUsersResponse(
        message: 'Unexpected error: $e',
        data: [],
        total: 0,
        status: 0,
      );
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/auth/login/services/sign_in_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class SignUpService {
  Future<String> signUpApi(
    BuildContext context,
    WidgetRef ref,
    String name,
    String email,
    String countryCode,
    String phone,
    String password,
    String referralCode,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(signUpUrl),
        body: {
          'user_level': '2',
          'name': name,
          'email': email,
          'country_code':countryCode,
          'mobile': phone,
          'password': password,
          'password_confirmation': password,
          'referralCode': referralCode,
        },
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (decodedData['status'] == true && decodedData['is_existing_user']) {
          final res = await SignInService()
              .signInWithPassword(ref, phone, countryCode, password);
          if (res == 1) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Login successful'),
            //     backgroundColor: Colors.green,
            //   ),
            // );
            // context.go('/homepage');
            return "sucess";
          }
        }

        return '';
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
}

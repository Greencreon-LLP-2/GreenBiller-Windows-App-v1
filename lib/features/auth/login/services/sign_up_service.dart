import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';

import 'package:http/http.dart' as http;

class SignUpService {
  Future<Map<String, dynamic>> signUpApi(
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
          'country_code': countryCode,
          'mobile': phone,
          'password': password,
          'password_confirmation': password,
          'referralCode': referralCode,
        },
      );

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decodedData['status'] == true) {
          // Check if user exists and needs to login
          if (decodedData['is_existing_user'] == true) {
            return {
              'status': 'success',
              'message': 'User already exists. Please sign in.',
              'needsLogin': true
            };
          } else {
            return {
              'status': 'success',
              'message': 'Signup successful',
              'data': decodedData
            };
          }
        } else {
          // Handle API errors when status is false
          return {
            'status': 'error',
            'message': decodedData['message'] ?? 'Signup failed',
            'errors': decodedData['errors'] ?? {}
          };
        }
      } else {
        // Handle validation errors (usually 422 status code)
        if (decodedData.containsKey('errors')) {
          final errors = decodedData['errors'] as Map<String, dynamic>;
          final errorMessages = errors.entries.map((entry) {
            final field = entry.key;
            final messages = entry.value is List
                ? entry.value.join(', ')
                : entry.value.toString();
            return '$field: $messages';
          }).join('\n');

          return {
            'status': 'error',
            'message': errorMessages,
            'errors': errors
          };
        }

        return {
          'status': 'error',
          'message':
              decodedData['message'] ?? 'Signup failed. Please try again.',
          'errors': {}
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Signup failed: ${e.toString()}',
        'errors': {}
      };
    }
  }
}

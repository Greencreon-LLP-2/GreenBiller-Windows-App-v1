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
          'user_level': '4',
          'name': name,
          'email': email,
          'country_code': countryCode,
          'mobile': phone,
          'password': password,
          'password_confirmation': password,
          'referralCode': referralCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': true,
          'statusCode': response.statusCode,
          'body': jsonDecode(response.body),
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': e.toString(),
      };
    }
  }
}

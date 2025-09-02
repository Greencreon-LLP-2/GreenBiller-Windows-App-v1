import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';

import 'package:green_biller/main.dart';

import 'package:http/http.dart' as http;

class OtpService {
  Future<int> sendOtpService(
    String phoneNumber,
    String countryCode,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(sendOtpUrl),
        body: {
          'name': countryCode,
          'mobile': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        logger.e(
            'OTP sent successfully to $phoneNumber ---OTp is ${jsonDecode(response.body)['otp']}');
        return response.statusCode;
      } else {
        throw Exception('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtpService(
      String otp, String phoneNumber, String countryCode) async {
    try {
      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        body: {'otp': otp, 'mobile': phoneNumber, 'country_code': countryCode},
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        // Safely check if is_existing_user exists
        final isExistingUser = decodedData.containsKey('is_existing_user')
            ? decodedData['is_existing_user'] == true
            : false;

        return {
          'status': 'success',
          'data': decodedData,
          'is_existing_user': isExistingUser,
          'message': decodedData['message'] ?? 'OTP verified successfully'
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'status': 'error',
          'message': errorData['message'] ?? 'Failed to verify OTP'
        };
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to verify OTP: $e'};
    }
  }
}

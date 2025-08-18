import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class OtpService {
  Future<void> sendOtpService(String phoneNumber, String countryCode, context,
      final int phone, final Function(String, String) onSwitchToOtp) async {
    // Implement your OTP sending logic here

    try {
      final response = await http.post(
        Uri.parse(sendOtpUrl),
        body: {
          'name': countryCode,
          'mobile': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully to $phoneNumber'),
            backgroundColor: Colors.green,
          ),
        );
        logger.e(
            'OTP sent successfully to $phoneNumber ---OTp is ${jsonDecode(response.body)['otp']}');
        onSwitchToOtp(
          phoneNumber,
          countryCode,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('Failed to send OTP: ${response.body}');
      }
    } catch (e) {
      print('Failed to send OTP: $e');
      throw Exception('Failed to send OTP');
    }
  }

  Future<void> verifyOtpService(
    String otp,
    String phoneNumber,
    BuildContext context,
    String countryCode,
    WidgetRef ref,
    final Function(String, String) onSwitchToSignUp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        body: {
          'otp': otp,
          'mobile': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['status'] == true) {
          if (decodedData['is_existing_user'] == true) {
            final data = UserModel.fromJson(decodedData);

            // ✅ Delayed ref read safely
            Future.microtask(() async {
              ref.read(userProvider.notifier).state = data;

              if (data.user != null) {
                await AuthService().saveUserData(data);
                context.pop;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User data missing in response!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please create your account to proceed'),
                backgroundColor: Colors.green,
              ),
            );
            onSwitchToSignUp(
              phoneNumber,
              countryCode,
            );
          }
        } else {
          logger.i('OTP verification Failed');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User data missing in response!'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${errorData['message']}'),
            backgroundColor: Colors.red,
          ),
        );
        // throw Exception('Failed to send OTP: ${errorData['message']}');
      }
    } catch (e) {
      print('Failed to verify OTP: $e');
      throw Exception('Failed to verify OTP');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';

import 'package:green_biller/features/auth/login/services/otp_service.dart';
import 'package:green_biller/features/auth/login/services/snackbar_service.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtpController {
  final _otpService = OtpService();

  Future<void> sendOtpController(
    String phoneNumber,
    String countryCode,
    Function(String, String) onSwitchToOtp,
  ) async {
    try {
      final statusCode = await _otpService.sendOtpService(
        phoneNumber,
        countryCode,
      );
      if (statusCode == 200) {
        SnackBarService.showSuccess('OTP sent successfully');
        onSwitchToOtp(phoneNumber, countryCode);
      }
    } catch (e) {
      SnackBarService.showError('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<void> verifyOtpController(
    BuildContext context,
    String otp,
    String phoneNumber,
    String countryCode,
    Function(String, String) onSwitchToSignUp,
    WidgetRef ref,
  ) async {
    try {
      final result = await _otpService.verifyOtpService(
        otp,
        phoneNumber,
        countryCode,
      );

      if (result['status'] == 'success') {
        final decodedData = result['data'];
        final isExistingUser = result['is_existing_user'] == true;
        if (isExistingUser) {
          final data = UserModel.fromJson(decodedData);

          // Update provider state
          ref.read(userProvider.notifier).state = data;

          // Save user data
          await AuthService().saveUserData(data);

          
          // Use safe navigation with delay
          Future.delayed(const Duration(seconds: 1), () {
            if (!navigatorKey.currentContext!.mounted) return;
            navigatorKey.currentContext!.go('/homepage');
          });

          SnackBarService.showSuccess('Login successful');

        } else {
          SnackBarService.showSuccess('Please create your account');
          onSwitchToSignUp(countryCode, phoneNumber);
        }
      } else {
        SnackBarService.showError(result['message']);
      }
    } catch (e) {
      SnackBarService.showError('OTP verification failed: $e');
    }
  }
}

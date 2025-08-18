import 'package:green_biller/features/auth/login/services/otp_service.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtpController {
  Future<void> sendOtpController(
      String phoneNumber,
      String countryCode,
      context,
      final Function(String, String) onSwitchToOtp,
      final int phone) async {
    try {
      await OtpService().sendOtpService(
          phoneNumber, countryCode, context, phone, onSwitchToOtp);
    } catch (e) {
      logger.i('Failed to send OTP: $e');
      throw Exception('Failed to send OTP');
    }
  }

  Future<void> verifyOtpController(
      String otp,
      String phoneNumber,
      context,
      String countryCode,
      final Function(String, String) onSwitchToSignUp,
      WidgetRef ref) async {
    try {
      await OtpService().verifyOtpService(
          otp, phoneNumber, context, countryCode, ref, onSwitchToSignUp);
    } catch (e) {
      logger.i('Failed to verify OTP: $e');
      throw Exception('Failed to verify OTP');
    }
  }
}

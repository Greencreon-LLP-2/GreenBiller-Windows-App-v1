import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';
import 'package:green_biller/features/auth/login/services/GoRouterNavigationService.dart';
import 'package:green_biller/features/auth/login/services/otp_service.dart';
import 'package:green_biller/features/auth/login/services/snackbar_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtpController {
  final _otpService = OtpService();

  Future<void> sendOtpController(
    String phoneNumber,
    String countryCode,
    Function(String, String) onSwitchToOtp,
  ) async {
    try {
      final statusCode =
          await _otpService.sendOtpService(phoneNumber, countryCode);
      if (statusCode == 200) {
        SnackBarService.showSuccess('OTP sent successfully');
        onSwitchToOtp(phoneNumber, countryCode);
      }
    } catch (e) {
      SnackBarService.showError('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<void> verifyOtpController(
    String otp,
    String phoneNumber,
    String countryCode,
    Function(String, String) onSwitchToSignUp,
    WidgetRef ref,
  ) async {
    try {
      final result =
          await _otpService.verifyOtpService(otp, phoneNumber, countryCode);

      if (result['status'] == 'success') {
        final decodedData = result['data'];
        final isExistingUser = result['is_existing_user'] == true;

        if (isExistingUser) {
          final data = UserModel.fromJson(decodedData);

          // Update provider state
          ref.read(userProvider.notifier).state = data;

          // Save user data
          await AuthService().saveUserData(data);

          SnackBarService.showSuccess('Login successful');

          // Use safe navigation with delay
          try {
            GoRouterNavigationService.goWithDelay('/homepage', replace: true);
          } catch (e, stack) {
            print(e);
            print(stack);
          }
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

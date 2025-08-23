import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/controllers/otp_controller.dart';
import 'package:green_biller/features/auth/login/view/widgets/ActionButtonWidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtpVerificationWidget extends HookConsumerWidget {
  final Function() onSwitchToLogin;
  final Function(String, String) onSwitchToSignUp;
  final int phone;
  final String countryCode;
  final BuildContext context;
  const OtpVerificationWidget({
    super.key,
    required this.onSwitchToLogin,
    required this.onSwitchToSignUp,
    required this.phone,
    required this.countryCode,
    required this.context,
  });

  @override
  Widget build(BuildContext worthlessContext, WidgetRef ref) {
    final digit1Controller = useTextEditingController();
    final digit2Controller = useTextEditingController();
    final digit3Controller = useTextEditingController();
    final digit4Controller = useTextEditingController();
    final isLoading = useState(false);
    final remainingSeconds = useState(60);
    final timer = useState<Timer?>(null);
    final errorMessage = useState<String?>(null); // 🔴 Store error text here
    final successMessage = useState<String?>(null); // 🟢 Optional success text

    useEffect(() {
      timer.value = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          t.cancel();
        }
      });
      return () => timer.value?.cancel();
    }, []);

    void verifyOTP() async {
      final otp = digit1Controller.text +
          digit2Controller.text +
          digit3Controller.text +
          digit4Controller.text;

      if (otp.length != 4) {
        errorMessage.value = 'Please enter complete OTP';
        successMessage.value = null;
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;
      successMessage.value = null;

      try {
        await OtpController().verifyOtpController(
          worthlessContext,
          otp,
          phone.toString(),
          countryCode,
          onSwitchToSignUp,
          ref,
        );
        successMessage.value = "OTP verified successfully!";
      } catch (e, stack) {
        print(stack);
        errorMessage.value = 'OTP verification failed';
      } finally {
        isLoading.value = false;
      }
    }

    void resendOTP() async {
      if (remainingSeconds.value == 0) {
        remainingSeconds.value = 60;
        timer.value?.cancel();
        timer.value = Timer.periodic(const Duration(seconds: 1), (t) {
          if (remainingSeconds.value > 0)
            remainingSeconds.value--;
          else
            t.cancel();
        });

        try {
          await OtpController().sendOtpController(
            phone.toString(),
            countryCode,
            (phone, code) {}, // Already on OTP screen
          );
          successMessage.value = "OTP resent successfully!";
          errorMessage.value = null;
        } catch (e) {
          errorMessage.value = "Failed to resend OTP";
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Enter OTP sent to $countryCode $phone',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 32),

          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              final controllers = [
                digit1Controller,
                digit2Controller,
                digit3Controller,
                digit4Controller
              ];
              return SizedBox(
                width: 50,
                child: TextField(
                  controller: controllers[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 3) {
                      FocusScope.of(context).nextFocus();
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: 24),
          TextButton(
            onPressed: remainingSeconds.value > 0 ? null : resendOTP,
            child: Text(
              remainingSeconds.value > 0
                  ? 'Resend in ${remainingSeconds.value}s'
                  : 'Resend OTP',
            ),
          ),

          const SizedBox(height: 16),

          // 🔴 Show error message in UI
          if (errorMessage.value != null)
            Text(
              errorMessage.value!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),

          // 🟢 Show success message in UI
          if (successMessage.value != null)
            Text(
              successMessage.value!,
              style: const TextStyle(color: Colors.green, fontSize: 14),
            ),

          const SizedBox(height: 24),
          ActionButtonWidget(
            text: isLoading.value ? "Verifying..." : 'Verify OTP',
            onPressed: isLoading.value ? () {} : verifyOTP,
          ),

          const SizedBox(height: 24),
          TextButton(
            onPressed: onSwitchToLogin,
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/view/widgets/action_button_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/custom_text_field_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/reset_password_widget.dart';

class ForgotPasswordWidget extends HookWidget {
  final VoidCallback onSwitchToLogin;
  final Function(int) onSwitchToOtp;
  final Function(String, String) onResetPassword;

  const ForgotPasswordWidget({
    super.key,
    required this.onSwitchToLogin,
    required this.onSwitchToOtp,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    final mobileController = useTextEditingController();
    final otpController = useTextEditingController();
    final currentStep = useState(0); // 0: Mobile, 1: OTP, 2: Reset Password

    // Animation for button
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final buttonAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    void onButtonHover(bool isHovered) {
      if (isHovered) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }

    Widget buildMobileStep() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Enter your mobile number to receive OTP',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // Mobile Field
          CustomTextFieldWidget(
            hintText: "9100xxxx78",
            label: 'Mobile Number',
            prefixIcon: Icons.phone_android,
            controller: mobileController,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              // Basic phone number validation (only allow digits)
              if (value.isNotEmpty && !RegExp(r'^\d*$').hasMatch(value)) {
                mobileController.text = value.replaceAll(RegExp(r'[^\d]'), '');
                mobileController.selection = TextSelection.fromPosition(
                  TextPosition(offset: mobileController.text.length),
                );
              }
            },
          ),

          const SizedBox(height: 32),

          // Send OTP Button
          MouseRegion(
            onEnter: (_) => onButtonHover(true),
            onExit: (_) => onButtonHover(false),
            child: Transform.scale(
              scale: buttonAnimation,
              child: ActionButtonWidget(
                text: 'Send OTP',
                onPressed: () {
                  // Validate mobile
                  if (mobileController.text.isEmpty ||
                      mobileController.text.length < 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid mobile number'),
                      ),
                    );
                    return;
                  }

                  // Show confirmation and proceed to OTP verification
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('OTP sent to your mobile number'),
                    ),
                  );

                  // Navigate to OTP step
                  currentStep.value = 1;
                },
              ),
            ),
          ),
        ],
      );
    }

    Widget buildOtpStep() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Enter the OTP sent to your mobile number',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // OTP Field
          CustomTextFieldWidget(
            hintText: '',
            label: 'OTP',
            prefixIcon: Icons.sms_outlined,
            controller: otpController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 32),

          // Verify OTP Button
          MouseRegion(
            onEnter: (_) => onButtonHover(true),
            onExit: (_) => onButtonHover(false),
            child: Transform.scale(
              scale: buttonAnimation,
              child: ActionButtonWidget(
                text: 'Verify OTP',
                onPressed: () {
                  // Validate OTP
                  if (otpController.text.isEmpty ||
                      otpController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid OTP'),
                      ),
                    );
                    return;
                  }

                  // Show confirmation and proceed to reset password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('OTP verified successfully'),
                    ),
                  );

                  // Navigate to reset password step
                  currentStep.value = 2;
                },
              ),
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentStep.value == 0) buildMobileStep(),
          if (currentStep.value == 1) buildOtpStep(),
          if (currentStep.value == 2)
            ResetPasswordWidget(
              onSwitchToLogin: onSwitchToLogin,
              onResetPassword: onResetPassword,
            ),
          if (currentStep.value < 2) ...[
            const SizedBox(height: 24),
            // Back to Login
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Remember your password?",
                    style: AppTextStyles.bodySmall,
                  ),
                  TextButton(
                    onPressed: onSwitchToLogin,
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

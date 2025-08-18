import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/view/widgets/action_button_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/custom_text_field_widget.dart';

class ResetPasswordWidget extends HookWidget {
  final VoidCallback onSwitchToLogin;
  final Function(String, String) onResetPassword;

  const ResetPasswordWidget({
    super.key,
    required this.onSwitchToLogin,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isConfirmPasswordVisible = useState(false);

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Set your new password',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // New Password Field
          CustomTextFieldWidget(
            hintText: "A12xxxxxx@67",
            label: 'New Password',
            prefixIcon: Icons.lock_outline,
            controller: newPasswordController,
            isPassword: true,
            passwordVisible: isPasswordVisible.value,
            onToggleVisibility: () {
              isPasswordVisible.value = !isPasswordVisible.value;
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          CustomTextFieldWidget(
            hintText: "A12xxxxxx@67",
            label: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            controller: confirmPasswordController,
            isPassword: true,
            passwordVisible: isConfirmPasswordVisible.value,
            onToggleVisibility: () {
              isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
            },
          ),

          const SizedBox(height: 32),

          // Reset Password Button
          MouseRegion(
            onEnter: (_) => onButtonHover(true),
            onExit: (_) => onButtonHover(false),
            child: Transform.scale(
              scale: buttonAnimation,
              child: ActionButtonWidget(
                text: 'Reset Password',
                onPressed: () {
                  // Validate passwords
                  if (newPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a new password'),
                      ),
                    );
                    return;
                  }

                  if (confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please confirm your password'),
                      ),
                    );
                    return;
                  }

                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match'),
                      ),
                    );
                    return;
                  }
                  // Navigate to home page after successful password reset
                  onSwitchToLogin();

                  // Call the reset password callback
                  onResetPassword(
                    newPasswordController.text,
                    confirmPasswordController.text,
                  );
                },
              ),
            ),
          ),

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
      ),
    );
  }
}

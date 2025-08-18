import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/sign_up_service.dart';
import 'package:green_biller/features/auth/login/view/widgets/action_button_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/custom_text_field_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupFormContentWidget extends HookConsumerWidget {
  final String countryCode;
  final String phone;
  final VoidCallback onSwitchToLogin;
  final Function(int) onSwitchToOtp;

  const SignupFormContentWidget({
    super.key,
    required this.countryCode,
    required this.phone,
    required this.onSwitchToLogin,
    required this.onSwitchToOtp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisible = useState(false);
    final confirmPasswordVisible = useState(false);
    final isLoading = useState(false);
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final referralCodeController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Animation for form appearance and signup button
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
          const SizedBox(height: 24),
          // Full Name Field
          CustomTextFieldWidget(
            hintText: "Enter your full name",
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            controller: nameController,
          ),
          const SizedBox(height: 16),
          // Mobile Number Field (positioned first before email)
          CustomTextFieldWidget(
            hintText: '$countryCode $phone',
            label: '$countryCode $phone',
            prefixIcon: Icons.phone_android,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            readOnly: true,
            onChanged: (value) {
              // Basic phone number validation (only allow digits)
              if (value.isNotEmpty && !RegExp(r'^\d*$').hasMatch(value)) {
                phoneController.text = value.replaceAll(RegExp(r'[^\d]'), '');
                phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: phoneController.text.length),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          // Email Field
          CustomTextFieldWidget(
            hintText: "Enter your email",
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          // Password Field
          CustomTextFieldWidget(
            hintText: "Enter your password",
            label: 'Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            passwordVisible: passwordVisible.value,
            onToggleVisibility: () {
              passwordVisible.value = !passwordVisible.value;
            },
            controller: passwordController,
          ),
          const SizedBox(height: 16),
          // Confirm Password Field
          CustomTextFieldWidget(
            hintText: "Enter your password",
            label: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            passwordVisible: confirmPasswordVisible.value,
            onToggleVisibility: () {
              confirmPasswordVisible.value = !confirmPasswordVisible.value;
            },
            controller: confirmPasswordController,
          ),
          const SizedBox(height: 24),
          CustomTextFieldWidget(
            hintText: "Enter Referral Code",
            label: "Referral Code",
            prefixIcon: Icons.card_giftcard, // more relevant than email icon
            controller: referralCodeController,
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 16),
          // Register Button
          MouseRegion(
            onEnter: (_) => onButtonHover(true),
            onExit: (_) => onButtonHover(false),
            child: Transform.scale(
              scale: buttonAnimation,
              child: ActionButtonWidget(
                  text: isLoading.value ? 'Create Account' : 'Loading',
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }

                    if (!isLoading.value) {
                      isLoading.value = true;
                      final finalCountryCode =
                          countryCode.replaceAll('+', '').trim();
                      // const finalCountryCode = "+91";
                      try {
                        final message = await SignUpService().signUpApi(
                          context,
                          ref,
                          nameController.text,
                          emailController.text,
                          finalCountryCode,
                          phone,
                          passwordController.text,
                          referralCodeController.text,
                        );
                        if (message == 'sucess') {
                          final userModel = ref.read(userProvider);
                          if (userModel?.accessToken != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login successful'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            //!====================================================================Navigate to home page
                            if (context.mounted) {
                              context.go('/homepage');
                            }
                          } else {
                            throw Exception('User state not properly updated');
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        isLoading.value = false;
                      }
                    }
                  }),
            ),
          ),
          const SizedBox(height: 24),
          // Sign In Link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/features/auth/login/services/sign_up_service.dart';
import 'package:green_biller/features/auth/login/view/widgets/ActionButtonWidget.dart';
import 'package:green_biller/features/auth/login/view/widgets/CustomTextFieldWidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupFormContentWidget extends HookConsumerWidget {
  final String countryCode;
  final String phone;
  final Function() onSwitchToLogin;
  final Function(int) onSwitchToOtp;
  final SignUpService signUpService = SignUpService();

  SignupFormContentWidget({
    super.key,
    required this.countryCode,
    required this.phone,
    required this.onSwitchToLogin,
    required this.onSwitchToOtp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final referralController = useTextEditingController();
    final phoneController = useTextEditingController();

    final isLoading = useState(false);
    final passwordVisible = useState(false);
    final errorMessage = useState<String?>(null);

    Future<void> handleSignup() async {
      errorMessage.value = null; // reset on each submit

      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        errorMessage.value = 'Please fill all required fields';
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        errorMessage.value = 'Passwords do not match';
        return;
      }

      isLoading.value = true;
      try {
        final result = await signUpService.signUpApi(
          nameController.text,
          emailController.text,
          countryCode.replaceAll('+', ''),
          phone,
          passwordController.text,
          referralController.text,
        );

        if (result['status'] == 'success') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go('/homepage');
            }
          });
        } else {
          errorMessage.value = result['message'];
        }
      } catch (e) {
        errorMessage.value = 'Signup failed: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),

          // Inline error message
          if (errorMessage.value != null) ...[
            Text(
              errorMessage.value!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],

          CustomTextFieldWidget(
            hintText: "Enter your full name",
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            controller: nameController,
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: '$countryCode $phone',
            label: '$countryCode $phone',
            prefixIcon: Icons.phone_android,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            readOnly: true,
            onChanged: (value) {
              if (value.isNotEmpty && !RegExp(r'^\d*$').hasMatch(value)) {
                phoneController.text = value.replaceAll(RegExp(r'[^\d]'), '');
                phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: phoneController.text.length),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: "Enter your email",
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
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
          CustomTextFieldWidget(
            hintText: "Enter your password",
            label: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            passwordVisible: passwordVisible.value,
            onToggleVisibility: () {},
            controller: confirmPasswordController,
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: "Enter Referral Code",
            label: "Referral Code",
            prefixIcon: Icons.card_giftcard,
            controller: referralController,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 32),
          ActionButtonWidget(
            text: isLoading.value ? 'Creating...' : 'Create Account',
            onPressed: isLoading.value ? () {} : handleSignup,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onSwitchToLogin,
            child: const Text('Already have an account? Sign in'),
          ),
        ],
      ),
    );
  }
}

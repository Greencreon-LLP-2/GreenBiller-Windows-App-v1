import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/controllers/otp_controller.dart';
import 'package:green_biller/features/auth/login/services/sign_in_service.dart';
import 'package:green_biller/features/auth/login/services/snackbar_service.dart';
import 'package:green_biller/features/auth/login/view/widgets/ActionButtonWidget.dart';
import 'package:green_biller/features/auth/login/view/widgets/CustomTextFieldWidget.dart';

class LoginFormContentWidget extends HookConsumerWidget {
  final Function(String, String) onSwitchToSignup;
  final Function(int, String) onSwitchToOtp;

  const LoginFormContentWidget({
    super.key,
    required this.onSwitchToSignup,
    required this.onSwitchToOtp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisible = useState(false);
    final mobileController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordLogin = useState(false);
    final selectedCountryCode = useState<String>('+91');
    final isLoading = useState(false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Mobile Number Field
          Row(
            children: [
              Container(
                width: 120, // Increased width to prevent overflow
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCountryCode.value,
                    isExpanded: true, // Ensure dropdown uses full width
                    items: CountryService()
                        .getAll()
                        .where((c) => c.phoneCode.isNotEmpty)
                        .map((country) {
                      return DropdownMenuItem<String>(
                        value: '+${country.phoneCode}',
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Minimize Row size
                          children: [
                            Text(
                              country.flagEmoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 4), // Reduced spacing
                            Flexible(
                              child: Text(
                                '+${country.phoneCode}',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) selectedCountryCode.value = value;
                    },
                    icon: const Icon(Icons.arrow_drop_down,
                        size: 20), // Smaller icon
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextFieldWidget(
                  hintText: 'Mobile Number',
                  label: 'Mobile Number',
                  prefixIcon: Icons.phone_android,
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (isPasswordLogin.value)
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  isPasswordLogin.value = !isPasswordLogin.value;
                },
                child: Text(
                  isPasswordLogin.value
                      ? 'Use OTP Login'
                      : 'Use Password Login',
                  style: AppTextStyles.labelMedium.copyWith(color: accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          ActionButtonWidget(
            text: isPasswordLogin.value ? 'Sign In' : 'Send OTP',
            onPressed: () async {
              if (mobileController.text.isEmpty ||
                  mobileController.text.length < 10) {
                SnackBarService.showError(
                  'Please enter a valid mobile number',
                );
                return;
              }

              if (isPasswordLogin.value && passwordController.text.isEmpty) {
                SnackBarService.showError(
                  'Please enter your password',
                );
                return;
              }

              isLoading.value = true;

              try {
                if (isPasswordLogin.value) {
                  final signInService = ref.read(signInServiceProvider);
                  final response = await signInService.signInWithPassword(
                    ref,
                    mobileController.text,
                    selectedCountryCode.value.replaceAll('+', ''),
                    passwordController.text,
                  );

                  if (response == 1) {
                    SnackBarService.showSuccess('Login successful');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        context.go('/homepage');
                      }
                    });
                  }
                } else {
                  final mobileNumber = int.parse(mobileController.text);
                  await OtpController().sendOtpController(
                    mobileNumber.toString(),
                    selectedCountryCode.value,
                    (phone, code) => onSwitchToOtp(int.parse(phone), code),
                  );
                }
              } catch (e) {
                SnackBarService.showError(
                  e.toString().replaceAll('Exception: ', ''),
                );
              } finally {
                isLoading.value = false;
              }
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

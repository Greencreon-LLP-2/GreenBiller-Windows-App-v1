import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/view/widgets/LoginFormContentWidget.dart';
import 'package:green_biller/features/auth/login/view/widgets/OtpVerificationWidget.dart';
import 'package:green_biller/features/auth/login/view/widgets/SignupFormContentWidget.dart';


class LoginFormWidget extends HookWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 0);
    final currentPage = useState(0);
    final phoneForOtp = useState<int>(0);
    final countryCodeForOtp = useState<String>('+91');

    // Navigation functions
    void switchToSignup(String countryCode, String phone) {
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    void switchToLogin() {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    void switchToOtp(int phone, String countryCode) {
      phoneForOtp.value = phone;
      countryCodeForOtp.value = countryCode;
      pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Title based on current page
          Text(
            currentPage.value == 0
                ? 'Welcome Back'
                : currentPage.value == 1
                    ? 'Create Account'
                    : 'Verify OTP',
            style: AppTextStyles.h2.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Form Pages
          SizedBox(
            height: 480,
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                currentPage.value = page;
              },
              children: [
                LoginFormContentWidget(
                  onSwitchToSignup: switchToSignup,
                  onSwitchToOtp: switchToOtp,
                ),
                SignupFormContentWidget(
                  countryCode: countryCodeForOtp.value,
                  phone: phoneForOtp.value.toString(),
                  onSwitchToLogin: switchToLogin,
                  onSwitchToOtp: (phone) {
                    phoneForOtp.value = phone;
                    switchToOtp(phone, countryCodeForOtp.value);
                  },
                ),
                OtpVerificationWidget(
                  onSwitchToLogin: switchToLogin,
                  onSwitchToSignUp: switchToSignup,
                  phone: phoneForOtp.value,
                  countryCode: countryCodeForOtp.value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

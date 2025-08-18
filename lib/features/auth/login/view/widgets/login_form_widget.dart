import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/view/widgets/forgot_password_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/login_form_content_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/otp_verification_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/page_indicator_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/signup_form_content_widget.dart';

class LoginFormWidget extends HookWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 0);
    final currentPage = useState(0);
    final phoneForOtp = useState<int>(0);
    final countryCodeForOtp = useState<String>('');

    // Define animation hooks for form appearance
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 700),
    );

    final fadeAnimation = useAnimation(
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeIn,
        ),
      ),
    );

    final slideAnimation = useAnimation(
      Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutQuint,
        ),
      ),
    );

    // Start animation when widget builds
    useEffect(() {
      animationController.forward();
      return null;
    }, []);

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

    void switchToForgotPassword() {
      pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    void switchToOtp(int phone, String countryCode) {
      phoneForOtp.value = phone;
      countryCodeForOtp.value = countryCode;
      pageController.animateToPage(
        3,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return AnimatedSlide(
      offset: slideAnimation,
      duration: const Duration(milliseconds: 100),
      child: AnimatedOpacity(
        opacity: fadeAnimation,
        duration: const Duration(milliseconds: 200),
        child: Container(
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
              BoxShadow(
                color: accentColor.withOpacity(0.03),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, 15),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade100,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Logo indicator
              if (!isMobile) ...[
                Container(
                  height: 60,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.8),
                        accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                Text(
                  currentPage.value == 0
                      ? 'Welcome Back'
                      : currentPage.value == 1
                          ? 'Create Account'
                          : currentPage.value == 2
                              ? 'Reset Password'
                              : 'Verify OTP',
                  style: AppTextStyles.h2.copyWith(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
              ],

              // Page Indicators (Only show for login/signup)
              if (currentPage.value < 2)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PageIndicatorWidget(
                        pageIndex: 0,
                        currentPage: currentPage.value,
                        label: currentPage.value == 0
                            ? 'Sign in to continue'
                            : 'Please Register First',
                        onTap: switchToLogin,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

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
                      onSwitchToSignup: (String countryCode) => switchToSignup(
                        countryCode,
                        phoneForOtp.value.toString(),
                      ),
                      onForgotPassword: switchToForgotPassword,
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
                    ForgotPasswordWidget(
                      onResetPassword: (email, phone) {
                        // TODO: Implement reset password functionality
                      },
                      onSwitchToLogin: switchToLogin,
                      onSwitchToOtp: (phone) {
                        // Get the mobile number from controller and set it for OTP screen
                        phoneForOtp.value = phone;
                        switchToOtp(phoneForOtp.value, countryCodeForOtp.value);
                      },
                    ),
                    OtpVerificationWidget(
                      onSwitchToLogin: switchToLogin,
                      onSwitchToSignUp: (countryCode, phone) {
                        switchToSignup(countryCode, phone);
                      },
                      phone: phoneForOtp.value,
                      countryCode: countryCodeForOtp.value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

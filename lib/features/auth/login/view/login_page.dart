import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/app_management/app_status_provider.dart';
import 'package:green_biller/features/auth/login/services/country_code_service.dart';
import 'package:green_biller/features/auth/login/services/snackbar_service.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';
import 'package:green_biller/features/auth/login/services/sign_in_service.dart';
import 'package:green_biller/features/auth/login/services/sign_up_service.dart';
import 'package:green_biller/features/auth/login/controllers/otp_controller.dart';

// Enum for page state
enum AuthPage { login, signup, otp }

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = useState<AuthPage>(AuthPage.login);
    final phoneForOtp = useState<String>('');
    final countryCodeForOtp = useState<String>('+91');
    final message = useState<String?>(null);
    final isError = useState<bool>(false);

    // Centralized message handler
    void showMessage(String msg, {bool error = false}) {
      message.value = msg;
      isError.value = error;
      // Auto-dismiss message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (message.value == msg) {
          message.value = null;
          isError.value = false;
        }
      });
      if (error) {
        SnackBarService.showError(msg);
      } else {
        SnackBarService.showSuccess(msg);
      }
    }

    // Navigation functions
    void switchToSignup(String countryCode, String phone) {
      phoneForOtp.value = phone;
      countryCodeForOtp.value = countryCode;
      currentPage.value = AuthPage.signup;
    }

    void switchToLogin() {
      currentPage.value = AuthPage.login;
    }

    void switchToOtp(String phone, String countryCode) {
      phoneForOtp.value = phone;
      countryCodeForOtp.value = countryCode;
      currentPage.value = AuthPage.otp;
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet =
              constraints.maxWidth >= 600 && constraints.maxWidth < 1200;
          final isDesktop = constraints.maxWidth >= 1200;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.05),
                  primaryColor.withOpacity(0.15),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 100 : 24,
                      vertical: 24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: LogoHeaderWidget(
                            message: message,
                            isError: isError,
                            imageUrl: 'assets/images/logo_image.png',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: LoginFormWidget(
                            currentPage: currentPage,
                            phoneForOtp: phoneForOtp,
                            countryCodeForOtp: countryCodeForOtp,
                            showMessage: showMessage,
                            switchToSignup: switchToSignup,
                            switchToLogin: switchToLogin,
                            switchToOtp: switchToOtp,
                            parentContext: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LogoHeaderWidget extends HookWidget {
  final ValueNotifier<String?> message;
  final ValueNotifier<bool> isError;
  final String? imageUrl;

  const LogoHeaderWidget({
    super.key,
    required this.imageUrl,
    required this.message,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = useState(0.0);

    // Animate message visibility
    useEffect(() {
      if (message.value != null) {
        opacity.value = 1.0;
      } else {
        opacity.value = 0.0;
      }
      return null;
    }, [message.value]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withOpacity(0.1),
          ),
          child: Image.asset(imageUrl!),
        ),
        const SizedBox(height: 24),

        Text(
          'Green Biller',
          style: AppTextStyles.h1.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Manage your business with ease',
          style: AppTextStyles.bodyLarge.copyWith(color: textSecondaryColor),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: opacity.value,
          duration: const Duration(milliseconds: 300),
          child: message.value != null
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isError.value
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isError.value ? Icons.error : Icons.check_circle,
                        color: isError.value ? Colors.red : Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          message.value!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isError.value ? Colors.red : Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class LoginFormWidget extends StatelessWidget {
  final ValueNotifier<AuthPage> currentPage;
  final ValueNotifier<String> phoneForOtp;
  final ValueNotifier<String> countryCodeForOtp;
  final Function(String, {bool error}) showMessage;
  final Function(String, String) switchToSignup;
  final Function() switchToLogin;
  final Function(String, String) switchToOtp;
  final BuildContext parentContext;

  const LoginFormWidget({
    super.key,
    required this.currentPage,
    required this.phoneForOtp,
    required this.countryCodeForOtp,
    required this.showMessage,
    required this.switchToSignup,
    required this.switchToLogin,
    required this.switchToOtp,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        children: [
          Text(
            currentPage.value == AuthPage.login
                ? 'Welcome Back'
                : currentPage.value == AuthPage.signup
                ? 'Create Account'
                : 'Verify OTP',
            style: AppTextStyles.h2.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 480,
            child: IndexedStack(
              index: currentPage.value.index,
              children: [
                LoginFormContentWidget(
                  onSwitchToSignup: switchToSignup,
                  onSwitchToOtp: switchToOtp,
                  showMessage: showMessage,
                  parentContext: parentContext,
                ),
                SignupFormContentWidget(
                  countryCode: countryCodeForOtp.value,
                  phone: phoneForOtp.value,
                  onSwitchToLogin: switchToLogin,
                  onSwitchToOtp: (phone) =>
                      switchToOtp(phone, countryCodeForOtp.value),
                  showMessage: showMessage,
                  parentContext: parentContext,
                ),
                OtpVerificationWidget(
                  phone: phoneForOtp.value,
                  countryCode: countryCodeForOtp.value,
                  onSwitchToLogin: switchToLogin,
                  onSwitchToSignUp: switchToSignup,
                  showMessage: showMessage,
                  parentContext: parentContext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginFormContentWidget extends HookConsumerWidget {
  final Function(String, String) onSwitchToSignup;
  final Function(String, String) onSwitchToOtp;
  final Function(String, {bool error}) showMessage;
  final BuildContext parentContext;

  const LoginFormContentWidget({
    super.key,
    required this.onSwitchToSignup,
    required this.onSwitchToOtp,
    required this.showMessage,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisible = useState(false);
    final mobileController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordLogin = useState(false);
    final selectedCountryCode = useState<String>('+91');
    final isLoading = useState(false);

    final countryCodesAsync = ref.watch(countryCodesProvider);

    useEffect(() {
      countryCodesAsync.whenData((codes) {
        print('Backend Country Codes: $codes');
        print('Codes length: ${codes.length}'); 
        if (codes.isNotEmpty) {
          if (!codes.contains(selectedCountryCode.value)) {
            selectedCountryCode.value = codes.first;
          }
        }
      });
      return null;
    }, [countryCodesAsync]);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 120,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: countryCodesAsync.when(
                  data: (backendCountryCodes) => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCountryCode.value,
                      isExpanded: true,
                      items: backendCountryCodes.map((countryCode) {
                        final country = getCountryByPhoneCode(countryCode);
                        return DropdownMenuItem<String>(
                          value: countryCode,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                country?.flagEmoji ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  countryCode,
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
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  loading: () => const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (error, stack) =>
                      const Icon(Icons.error, color: Colors.red),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isPasswordLogin.value)
            CustomTextFieldWidget(
              hintText: 'Enter your password',
              label: 'Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              passwordVisible: passwordVisible.value,
              onToggleVisibility: () {
                passwordVisible.value = !passwordVisible.value;
              },
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
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
            text: isLoading.value
                ? (isPasswordLogin.value ? 'Signing In...' : 'Sending OTP...')
                : (isPasswordLogin.value ? 'Sign In' : 'Send OTP'),
            onPressed: isLoading.value
                ? () {}
                : () async {
                    if (mobileController.text.isEmpty ||
                        mobileController.text.length < 10) {
                      showMessage(
                        'Please enter a valid 10-digit mobile number',
                        error: true,
                      );
                      return;
                    }
                    if (isPasswordLogin.value &&
                        passwordController.text.isEmpty) {
                      showMessage('Please enter your password', error: true);
                      return;
                    }

                    isLoading.value = true;
                    try {
                      if (isPasswordLogin.value) {
                        final signInService = ref.read(signInServiceProvider);
                        final response = await signInService.signInWithPassword(
                          ref,
                          mobileController.text,
                          selectedCountryCode.value,
                          passwordController.text,
                        );
                        if (response == 1) {
                          parentContext.go('/homepage');
                        } else {
                          showMessage('Sign-in failed', error: true);
                        }
                      } else {
                        final mobileNumber = mobileController.text;
                        await OtpController().sendOtpController(
                          mobileNumber,
                          selectedCountryCode.value,
                          (p, c) => onSwitchToOtp(p, c),
                        );
                        showMessage('OTP sent successfully!', error: false);
                      }
                    } catch (e) {
                      showMessage(
                        e.toString().replaceAll('Exception: ', ''),
                        error: true,
                      );
                    } finally {
                      isLoading.value = false;
                    }
                  },
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => onSwitchToSignup(
              selectedCountryCode.value,
              mobileController.text,
            ),
            child: const Text('Don\'t have an account? Sign up'),
          ),
        ],
      ),
    );
  }
}

class SignupFormContentWidget extends HookConsumerWidget {
  final String countryCode;
  final String phone;
  final Function() onSwitchToLogin;
  final Function(String) onSwitchToOtp;
  final Function(String, {bool error}) showMessage;
  final BuildContext parentContext;

  const SignupFormContentWidget({
    super.key,
    required this.countryCode,
    required this.phone,
    required this.onSwitchToLogin,
    required this.onSwitchToOtp,
    required this.showMessage,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullnameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final referralController = useTextEditingController();
    final phoneController = useTextEditingController(text: phone);
    final isLoading = useState(false);
    final passwordVisible = useState(false);
    final confPassVisible = useState(false);

    Future<void> handleSignup() async {
      if (fullnameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty) {
        showMessage('Please fill all required fields', error: true);
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        showMessage('Passwords do not match', error: true);
        return;
      }

      isLoading.value = true;
      try {
        final result = await SignUpService().signUpApi(
          fullnameController.text,
          emailController.text,
          countryCode,
          phone,
          passwordController.text,
          referralController.text,
        );

        if (result['status'] == true) {
          if (result['is_existing_user'] == true) {
            final data = UserModel.fromJson(result);
            await AuthService().saveUserData(data);
            ref.read(userProvider.notifier).state = data;
            Future.delayed(const Duration(seconds: 1), () {
              if (!navigatorKey.currentContext!.mounted) return;
              navigatorKey.currentContext!.go('/homepage');
              showMessage('Login successful', error: false);
            });
          } else {
            showMessage(
              result['errors']?.toString() ?? 'Something went wrong',
              error: true,
            );
          }
        } else {
          showMessage(result['errors'] ?? 'Email Already Exist', error: true);
        }
      } catch (e) {
        showMessage('Signup failed: $e', error: true);
      } finally {
        isLoading.value = false;
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          CustomTextFieldWidget(
            hintText: 'Enter your full name',
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            controller: fullnameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: '$countryCode $phone',
            label: '$countryCode $phone',
            prefixIcon: Icons.phone_android,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: 'Enter your email',
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: 'Enter your password',
            label: 'Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            passwordVisible: passwordVisible.value,
            onToggleVisibility: () =>
                passwordVisible.value = !passwordVisible.value,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: 'Confirm your password',
            label: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            passwordVisible: confPassVisible.value,
            onToggleVisibility: () =>
                confPassVisible.value = !confPassVisible.value,
            controller: confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm password is required';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFieldWidget(
            hintText: 'Enter Referral Code (Optional)',
            label: 'Referral Code',
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

class OtpVerificationWidget extends HookConsumerWidget {
  final String phone;
  final String countryCode;
  final Function() onSwitchToLogin;
  final Function(String, String) onSwitchToSignUp;
  final Function(String, {bool error}) showMessage;
  final BuildContext parentContext;

  const OtpVerificationWidget({
    super.key,
    required this.phone,
    required this.countryCode,
    required this.onSwitchToLogin,
    required this.onSwitchToSignUp,
    required this.showMessage,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = List.generate(4, (_) => useTextEditingController());
    final focusNodes = List.generate(4, (_) => useFocusNode());
    final isLoading = useState(false);
    final remainingSeconds = useState(60);
    final timer = useState<Timer?>(null);

    // Auto-focus first field
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNodes[0].requestFocus();
      });
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
      final otp = controllers.map((c) => c.text).join();
      if (otp.length != 4) {
        showMessage('Please enter a complete 4-digit OTP', error: true);
        return;
      }

      isLoading.value = true;
      try {
        await OtpController().verifyOtpController(
          parentContext,
          otp,
          phone,
          countryCode,
          onSwitchToSignUp,
          ref,
        );
        showMessage('OTP verified successfully!', error: false);
      } catch (e) {
        showMessage('OTP verification failed: $e', error: true);
      } finally {
        isLoading.value = false;
      }
    }

    void resendOTP() async {
      if (remainingSeconds.value == 0) {
        remainingSeconds.value = 60;
        timer.value?.cancel();
        timer.value = Timer.periodic(const Duration(seconds: 1), (t) {
          if (remainingSeconds.value > 0) {
            remainingSeconds.value--;
          } else {
            t.cancel();
          }
        });

        try {
          await OtpController().sendOtpController(
            phone,
            countryCode,
            (p, c) => {},
          );
          showMessage('OTP resent successfully!', error: false);
        } catch (e) {
          showMessage('Failed to resend OTP: $e', error: true);
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 50,
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 3) {
                      FocusScope.of(
                        context,
                      ).requestFocus(focusNodes[index + 1]);
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(
                        context,
                      ).requestFocus(focusNodes[index - 1]);
                    }
                    if (value.length == 1 && index == 3) {
                      FocusScope.of(context).unfocus();
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
              style: AppTextStyles.labelMedium.copyWith(
                color: remainingSeconds.value > 0 ? Colors.grey : accentColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ActionButtonWidget(
            text: isLoading.value ? 'Verifying...' : 'Verify OTP',
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

class CustomTextFieldWidget extends HookWidget {
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final bool passwordVisible;
  final Function()? onToggleVisibility;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String hintText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFieldWidget({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.hintText,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onToggleVisibility,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = useState(false);
    final focusNode = useFocusNode();

    useEffect(() {
      void onFocusChange() {
        isFocused.value = focusNode.hasFocus;
      }

      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    }, [focusNode]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isPassword && !passwordVisible,
        readOnly: readOnly,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: isFocused.value ? accentColor : textSecondaryColor,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: isFocused.value
                ? accentColor
                : textSecondaryColor.withOpacity(0.7),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: textSecondaryColor,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

class ActionButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;

  const ActionButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [accentColor, Color(0xFF2ECC71)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

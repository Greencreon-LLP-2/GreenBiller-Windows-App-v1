import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/controllers/otp_controller.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/country_code_service.dart';
import 'package:green_biller/features/auth/login/services/sign_in_service.dart';
import 'package:green_biller/features/auth/login/view/widgets/action_button_widget.dart';
import 'package:green_biller/features/auth/login/view/widgets/custom_text_field_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:country_picker/country_picker.dart';

class LoginFormContentWidget extends HookConsumerWidget {
  final Function(String phoneNumber) onSwitchToSignup;
  final VoidCallback onForgotPassword;
  final Function(int, String) onSwitchToOtp;

  const LoginFormContentWidget({
    super.key,
    required this.onSwitchToSignup,
    required this.onForgotPassword,
    required this.onSwitchToOtp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordVisible = useState(false);
    final mobileController = useTextEditingController(text: '9626040738');
    final passwordController = useTextEditingController(text: "Admin@143");
    final isPasswordLogin = useState(false);
    final selectedCountryCode =
        useState<String>('+91'); // Default to India's code
    final selectedCountry = useState<Country?>(null);

    // Initialize with India
    useEffect(() {
      final india = getCountryByPhoneCode('+91');
      selectedCountry.value = india;
      return null;
    }, []);

    // Animation for login button
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final buttonScaleAnimation = useAnimation(
      Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // Animation on hover
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
          const SizedBox(height: 32),
          // Mobile Number Field
          Row(
            children: [
              Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        selectedCountryCode.value = '+${country.phoneCode}';
                        selectedCountry.value = country;
                      },
                      countryListTheme: CountryListThemeData(
                        flagSize: 25,
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                        bottomSheetHeight: 500,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        inputDecoration: InputDecoration(
                          labelText: 'Search Country',
                          hintText: 'Type country name or code',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                        ),
                        searchTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Country flag
                             /* Text(
                                selectedCountry.value?.flagEmoji ?? '🇮🇳',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 4),*/
                              // Country code
                              Expanded(
                                child: Text(
                                  selectedCountryCode.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
             const SizedBox(width: 12,),
              Expanded(
                child: CustomTextFieldWidget(
                  hintText: "9876543210",
                  label: 'Mobile Number',
                  prefixIcon: Icons.phone_android,
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    // Basic phone number validation (only allow digits)
                    if (value.isNotEmpty && !RegExp(r'^\d*$').hasMatch(value)) {
                      mobileController.text =
                          value.replaceAll(RegExp(r'[^\d]'), '');
                      mobileController.selection = TextSelection.fromPosition(
                        TextPosition(offset: mobileController.text.length),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Password Field (shown when password login is active)
          if (isPasswordLogin.value)
            CustomTextFieldWidget(
              hintText: "AbD12xxxxxxxx@67",
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
          // Remember Me & Forgot Password
         Row(
         
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             TextButton(
               onPressed: () {
                 isPasswordLogin.value = !isPasswordLogin.value;
               },
               child: Text(
                 isPasswordLogin.value
                     ? 'Sign In with Phone'
                     : 'Sign In with Password',
                 style: AppTextStyles.labelMedium.copyWith(
                   color: accentColor,
                 ),
                  overflow: TextOverflow.ellipsis,
               ),
             ),
             // if (true)
           Flexible(
      child: TextButton(
        onPressed: onForgotPassword,
        child: Text(
          'Forgot Password?',
          style: AppTextStyles.labelMedium.copyWith(
            color: accentColor,
          ),
          overflow: TextOverflow.ellipsis, 
        ),
      ),
    ),
           ],
         ),
          const SizedBox(height: 24),
          // Login Button
          MouseRegion(
            onEnter: (_) => onButtonHover(true),
            onExit: (_) => onButtonHover(false),
            child: Transform.scale(
              scale: buttonScaleAnimation,
              child: ActionButtonWidget(
                text: isPasswordLogin.value ? 'Sign In' : 'Send OTP',
                onPressed: () async {
                  if (isPasswordLogin.value) {
                    // Handle password login
                    if (mobileController.text.isEmpty ||
                        mobileController.text.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid mobile number'),
                        ),
                      );
                      return;
                    }
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your password'),
                        ),
                      );
                      return;
                    }
                    //!====================================================================Handle password login- api call
                    try {
                      final countryCode =
                          selectedCountryCode.value.replaceAll('+', '');
                      final signInService = ref.read(signInServiceProvider);
                      final response = await signInService.signInWithPassword(
                        ref,
                        mobileController.text,
                        countryCode,
                        passwordController.text,
                      );

                      // Handle login response
                      if (response == 1) {
                        // Ensure the user state is updated before navigation
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
                          log('Login successful and navigated to homepage');
                        } else {
                          throw Exception('User state not properly updated');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                const UserModel().message ?? 'Login failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      // This will only run if there's a network error or JSON parsing error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(e.toString().replaceAll('Exception: ', '')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    // Handle phone login
                    if (mobileController.text.isEmpty ||
                        mobileController.text.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid mobile number'),
                        ),
                      );
                      return;
                    }

// Validate country code
                    if (selectedCountryCode.value.isEmpty ||
                        !selectedCountryCode.value.startsWith('+')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a valid country code'),
                        ),
                      );
                      return;
                    }

                    try {
                      final mobileNumber = int.parse(mobileController.text);
                      await OtpController().sendOtpController(
                        mobileNumber.toString(),
                        selectedCountryCode.value,
                        context,
                        (phone, code) => onSwitchToOtp(int.parse(phone), code),
                        mobileNumber,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid mobile number format'),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Sign Up Link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Powered by ",
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  'GreenCreon LLP',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
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

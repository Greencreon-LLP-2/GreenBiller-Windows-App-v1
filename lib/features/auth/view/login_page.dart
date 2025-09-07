import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:flutter/services.dart';


// Text styles similar to reference code
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: textSecondaryColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: accentColor,
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final phoneController = TextEditingController(text: '7012545907');
    final passwordController = TextEditingController(text: "B,%}=29Xco'XO)]+");

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Expanded(flex: 2, child: LogoHeaderWidget()),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: LoginFormContainer(
                      controller: controller,
                      phoneController: phoneController,
                      passwordController: passwordController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoHeaderWidget extends StatelessWidget {
  const LogoHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: const Icon(
            Icons.account_balance_wallet,
            size: 100,
            color: accentColor,
          ),
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
      ],
    );
  }
}

class LoginFormContainer extends StatefulWidget {
  final AuthController controller;
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  const LoginFormContainer({
    super.key,
    required this.controller,
    required this.phoneController,
    required this.passwordController,
  });

  @override
  State<LoginFormContainer> createState() => _LoginFormContainerState();
}

class _LoginFormContainerState extends State<LoginFormContainer> {
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isPasswordLogin = ValueNotifier<bool>(false);
  final ValueNotifier<String> _countryCode = ValueNotifier<String>('+91');

  @override
  void dispose() {
    _passwordVisible.dispose();
    _isPasswordLogin.dispose();
    _countryCode.dispose();
    super.dispose();
  }

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
            'Welcome Back',
            style: AppTextStyles.h2.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          LoginFormContent(
            controller: widget.controller,
            phoneController: widget.phoneController,
            passwordController: widget.passwordController,
            passwordVisible: _passwordVisible,
            isPasswordLogin: _isPasswordLogin,
            countryCode: _countryCode,
          ),
        ],
      ),
    );
  }
}

class LoginFormContent extends StatelessWidget {
  final AuthController controller;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> passwordVisible;
  final ValueNotifier<bool> isPasswordLogin;
  final ValueNotifier<String> countryCode;

  const LoginFormContent({
    super.key,
    required this.controller,
    required this.phoneController,
    required this.passwordController,
    required this.passwordVisible,
    required this.isPasswordLogin,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPasswordLogin,
      builder: (context, isPasswordLoginValue, child) {
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
                    child: Obx(() {
                      final codes = controller.countryCodes
                          .toSet()
                          .toList(); // ensure uniqueness
                      final selectedCode = controller.countryCode.value;

                      // fallback logic
                      final validSelected = (codes.contains(selectedCode)
                          ? selectedCode
                          : (codes.isNotEmpty ? codes.first : null));

                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: validSelected,
                          isExpanded: true,
                          hint: const Text('+Code'),
                          items: codes
                              .map(
                                (code) => DropdownMenuItem<String>(
                                  value: code,
                                  child: Text(
                                    code,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              controller.countryCode.value = newValue;
                            }
                          },
                          icon: const Icon(Icons.arrow_drop_down, size: 20),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Mobile Number',
                      label: 'Mobile Number',
                      prefixIcon: Icons.phone_android,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (value) =>
                          controller.phoneNumber.value = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isPasswordLoginValue)
                ValueListenableBuilder<bool>(
                  valueListenable: passwordVisible,
                  builder: (context, isVisible, child) {
                    return CustomTextField(
                      hintText: 'Enter your password',
                      label: 'Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      passwordVisible: isVisible,
                      onToggleVisibility: () {
                        passwordVisible.value = !passwordVisible.value;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30),
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                      
                      controller: passwordController,
                      obscureText: !isVisible,
                    );
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
                      isPasswordLoginValue
                          ? 'Use OTP Login'
                          : 'Use Password Login',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          ActionButton(
                            text: isPasswordLoginValue ? 'Sign In' : 'Send OTP',
                            onPressed: () {
                              if (isPasswordLoginValue) {
                                if (phoneController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  controller.loginWithPassword(
                                    phoneController.text,
                                    passwordController.text,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter phone and password',
                                    backgroundColor: Colors.red,
                                  );
                                }
                              } else {
                                if (phoneController.text.isNotEmpty) {
                                  controller.sendOtp();
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter phone number',
                                    backgroundColor: Colors.red,
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          ActionButton(
                            text: isPasswordLoginValue ? 'Send OTP' : 'Sign In',
                            onPressed: () {
                              isPasswordLogin.value = !isPasswordLogin.value;
                            },
                            isSecondary: true,
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final bool passwordVisible;
  final VoidCallback? onToggleVisibility;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onToggleVisibility,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? !passwordVisible : false,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: textSecondaryColor,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: textSecondaryColor.withOpacity(0.7),
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

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: isSecondary
            ? null
            : const LinearGradient(
                colors: [accentColor, Color(0xFF2ECC71)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSecondary
            ? null
            : [
                BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
        color: isSecondary ? Colors.transparent : null,
        border: isSecondary
            ? Border.all(color: accentColor, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: isSecondary ? accentColor : Colors.white,
        ),
        child: Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(
            color: isSecondary ? accentColor : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

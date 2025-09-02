import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/auth/validator/validator.dart';

import 'package:greenbiller/features/auth/view/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmPasswordVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: LogoHeaderWidget(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: SignUpFormContainer(controller: controller),
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

class SignUpFormContainer extends StatelessWidget {
  final AuthController controller;

  const SignUpFormContainer({super.key, required this.controller});

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
            'Create Account',
            style: AppTextStyles.h2.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join us and start managing your business',
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondaryColor),
          ),
          const SizedBox(height: 24),
          const SignUpFormContent(),
        ],
      ),
    );
  }
}

class SignUpFormContent extends StatefulWidget {
  const SignUpFormContent({super.key});

  @override
  State<SignUpFormContent> createState() => _SignUpFormContentState();
}

class _SignUpFormContentState extends State<SignUpFormContent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralController = TextEditingController();
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmPasswordVisible = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();
    _phoneController.text = authController.phoneNumber.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralController.dispose();
    _passwordVisible.dispose();
    _confirmPasswordVisible.dispose();
    super.dispose();
  }

  void _signUp() {
    
    if (!_formKey.currentState!.validate()) {
      Get.snackbar('Error', 'Please fix form errors',
          backgroundColor: errorColor, colorText: Colors.white);
      return;
    }

    final authController = Get.find<AuthController>();
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields',
          backgroundColor: errorColor, colorText: Colors.white);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: errorColor, colorText: Colors.white);
      return;
    }

    authController.signUp(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      referralCode: _referralController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Enter your full name',
            label: 'Full Name',
            prefixIcon: Icons.person_outline,
            controller: _nameController,
           validator:NameValidator.validate ,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Enter your email',
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: EmailValidator.validate
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Phone Number',
            label: 'Phone Number',
            prefixIcon: Icons.phone_android,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _passwordVisible,
            builder: (context, isVisible, child) {
              return CustomTextField(
                
                hintText: 'Enter your password',
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
                passwordVisible: isVisible,
                onToggleVisibility: () {
                  _passwordVisible.value = !_passwordVisible.value;
                },
                obscureText: !isVisible,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                ],
                validator: PasswordValidator.validate,
              );
              
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _confirmPasswordVisible,
            builder: (context, isVisible, child) {
              return CustomTextField(
                hintText: 'Confirm your password',
                label: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                controller: _confirmPasswordController,
                isPassword: true,
                passwordVisible: isVisible,
                onToggleVisibility: () {
                  _confirmPasswordVisible.value = !_confirmPasswordVisible.value;
                },
                obscureText: !isVisible,
                 inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                ],
                validator: PasswordValidator.validate,
              );
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Enter referral code (optional)',
            label: 'Referral Code',
            prefixIcon: Icons.card_giftcard,
            controller: _referralController,
          ),
          const SizedBox(height: 24),
          Obx(() => authController.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: accentColor))
              : ActionButton(
                  text: 'Create Account',
                  onPressed: _signUp,
                )),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Already have an account? Sign in',
              style: AppTextStyles.labelMedium.copyWith(color: textSecondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
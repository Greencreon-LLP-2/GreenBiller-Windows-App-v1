import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:greenbiller/features/auth/view/login_page.dart';

class OtpVerifyPage extends StatelessWidget {
  const OtpVerifyPage({super.key});

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
                    child: OtpFormContainer(controller: controller),
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

class OtpFormContainer extends StatelessWidget {
  final AuthController controller;

  const OtpFormContainer({super.key, required this.controller});

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
            'Verify OTP',
            style: AppTextStyles.h2.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter OTP sent to ${controller.countryCode.value} ${controller.phoneNumber.value}',
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const OtpVerificationContent(),
        ],
      ),
    );
  }
}

class OtpVerificationContent extends StatefulWidget {
  const OtpVerificationContent({super.key});

  @override
  State<OtpVerificationContent> createState() => _OtpVerificationContentState();
}

class _OtpVerificationContentState extends State<OtpVerificationContent> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final ValueNotifier<int> _remainingSeconds = ValueNotifier<int>(60);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _remainingSeconds.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    final authController = Get.find<AuthController>();
    if (_remainingSeconds.value == 0) {
      _remainingSeconds.value = 60;
      _startTimer();
      authController.sendOtp();
      Get.snackbar('Success', 'OTP resent successfully',
          backgroundColor: successColor, colorText: Colors.white);
    }
  }

  void _verifyOtp() {
    final authController = Get.find<AuthController>();
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 4) {
      Get.snackbar('Error', 'Please enter complete 4-digit OTP', // Changed from 6 to 4
          backgroundColor: errorColor, colorText: Colors.white);
      return;
    }
    authController.otp.value = otp;
    authController.verifyOtp();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) { // Changed from 6 to 4
            return SizedBox(
              width: 45,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: accentColor, width: 2),
                  ),
                  counterText: '',
                ),
                onChanged: (value) {
                  // Fixed navigation logic for 4 digits
                  if (value.length == 1 && index < 3) { // Changed from 5 to 3
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                  }
                  if (value.length == 1 && index == 3) { // Changed from 5 to 3
                    FocusScope.of(context).unfocus();
                    // Auto-verify when last digit is entered
                    final otp = _controllers.map((c) => c.text).join();
                    if (otp.length == 4) {
                      _verifyOtp();
                    }
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        ValueListenableBuilder<int>(
          valueListenable: _remainingSeconds,
          builder: (context, seconds, child) {
            return TextButton(
              onPressed: seconds > 0 ? null : _resendOtp,
              child: Text(
                seconds > 0 ? 'Resend in ${seconds}s' : 'Resend OTP',
                style: AppTextStyles.labelMedium.copyWith(
                  color: seconds > 0 ? textSecondaryColor : accentColor,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Obx(() {
          final authController = Get.find<AuthController>();
          return authController.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: accentColor))
              : ActionButton(
                  text: 'Verify OTP',
                  onPressed: _verifyOtp,
                );
        }),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Back to Login',
            style: AppTextStyles.labelMedium.copyWith(color: textSecondaryColor),
          ),
        ),
      ],
    );
  }
}
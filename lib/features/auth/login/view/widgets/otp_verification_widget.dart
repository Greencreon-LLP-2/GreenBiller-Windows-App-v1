import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/controllers/otp_controller.dart';
import 'package:green_biller/features/auth/login/services/otp_service.dart';
import 'package:green_biller/features/auth/login/view/widgets/action_button_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OtpVerificationWidget extends HookConsumerWidget {
  final Function() onSwitchToLogin;
  final Function(String, String) onSwitchToSignUp;
  final String? email;
  final int phone;
  final String countryCode;

  const OtpVerificationWidget({
    super.key,
    required this.onSwitchToLogin,
    required this.onSwitchToSignUp,
    required this.phone,
    required this.countryCode,
    this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create controller for each digit
    final digit1Controller = useTextEditingController();
    final digit2Controller = useTextEditingController();
    final digit3Controller = useTextEditingController();
    final digit4Controller = useTextEditingController();

    // FocusNodes for each field
    final digit1Focus = useFocusNode();
    final digit2Focus = useFocusNode();
    final digit3Focus = useFocusNode();
    final digit4Focus = useFocusNode();

    // Animation for button
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

    // Countdown timer for resend (60 seconds)
    final remainingSeconds = useState(60);
    final timer = useState<Timer?>(null);

    // Start countdown on init
    useEffect(() {
      timer.value = Timer.periodic(const Duration(seconds: 1), (t) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          t.cancel();
        }
      });

      return () {
        timer.value?.cancel();
      };
    }, []);

    void onButtonHover(bool isHovered) {
      if (isHovered) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    }

    // Format timer as MM:SS
    String formatTimer() {
      final minutes = (remainingSeconds.value / 60).floor();
      final seconds = remainingSeconds.value % 60;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    // Handle resend OTP
    void resendOTP() async {
      if (remainingSeconds.value == 0) {
        // Reset timer
        remainingSeconds.value = 60;
        timer.value?.cancel();
        timer.value = Timer.periodic(const Duration(seconds: 1), (t) {
          if (remainingSeconds.value > 0) {
            remainingSeconds.value--;
          } else {
            t.cancel();
          }
        });
        await OtpService().sendOtpService(
            phone.toString(), countryCode, context, phone, (e, s) {});
        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP has been resent')),
        );
      }
    }

    // Verify OTP
    void verifyOTP() async {
      final otp = digit1Controller.text +
          digit2Controller.text +
          digit3Controller.text +
          digit4Controller.text;

      if (otp.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter the complete 4-digit OTP')),
        );
        return;
      }

      // Switch to signup form section
      await OtpController().verifyOtpController(
          otp, phone.toString(), context, countryCode, onSwitchToSignUp, ref);
      // onSwitchToSignUp(
      //   countryCode,
      //   phone.toString(),
      // );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Enter verification code sent to your mobile',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$countryCode $phone',
            style: AppTextStyles.bodyMedium.copyWith(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOtpDigitField(
                controller: digit1Controller,
                focusNode: digit1Focus,
                nextFocus: digit2Focus,
              ),
              _buildOtpDigitField(
                controller: digit2Controller,
                focusNode: digit2Focus,
                nextFocus: digit3Focus,
                previousFocus: digit1Focus,
              ),
              _buildOtpDigitField(
                controller: digit3Controller,
                focusNode: digit3Focus,
                nextFocus: digit4Focus,
                previousFocus: digit2Focus,
              ),
              _buildOtpDigitField(
                controller: digit4Controller,
                focusNode: digit4Focus,
                previousFocus: digit3Focus,
                isLast: true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Resend Code Option
          Center(
            child: Column(
              children: [
                Text(
                  'Didn\'t receive code?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                remainingSeconds.value > 0
                    ? Text(
                        'Resend code in ${formatTimer()}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: textSecondaryColor,
                        ),
                      )
                    : TextButton(
                        onPressed: resendOTP,
                        child: Text(
                          'Resend Code',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Verify Button
          MouseRegion(
            onEnter: (_) => onButtonHover(true),
            onExit: (_) => onButtonHover(false),
            child: Transform.scale(
              scale: buttonAnimation,
              child: ActionButtonWidget(
                text: 'Verify OTP',
                onPressed: verifyOTP,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Back to Login
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Back to",
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

  Widget _buildOtpDigitField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    FocusNode? previousFocus,
    bool isLast = false,
  }) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          fillColor: Colors.grey.shade50,
          filled: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            nextFocus.requestFocus();
          } else if (value.isEmpty && previousFocus != null) {
            previousFocus.requestFocus();
          } else if (isLast && value.isNotEmpty) {
            focusNode.unfocus();
          }
        },
      ),
    );
  }
}

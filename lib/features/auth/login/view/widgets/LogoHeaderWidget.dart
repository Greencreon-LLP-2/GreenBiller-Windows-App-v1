import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';

class LogoHeaderWidget extends StatelessWidget {
  const LogoHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: Image.asset(
            'assets/images/logo_image.png',
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
        // const SizedBox(height: 16),
        Text(
          'Green Biller',
          style: AppTextStyles.h1.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Your complete billing and inventory solution',
          style: AppTextStyles.bodyLarge.copyWith(
            color: textSecondaryColor,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Image.asset("assets/images/welcome.png")),
        // const BuildFeatureCards(),
      ],
    );
  }
}
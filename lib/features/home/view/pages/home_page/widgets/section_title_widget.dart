import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllPressed;

  const SectionTitleWidget({
    super.key,
    required this.title,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed ?? () {},
          child: const Text(
            "View All",
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
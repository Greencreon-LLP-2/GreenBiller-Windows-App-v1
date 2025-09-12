import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';

class AppSnackbar {
  /// Shows a customizable snackbar in the top-right corner.
  ///
  /// If [title], [message], [color], or [icon] are not passed,
  /// defaults will be used.
  static void show({
    String? title,
    String? message,
    Color? color,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    double maxWidth = 340,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  }) {
    final screenWidth = Get.width == 0
        ? MediaQuery.of(Get.context!).size.width
        : Get.width;

    const double rightGap = 16.0;
    final double leftMargin = (screenWidth - maxWidth - rightGap).clamp(
      0.0,
      screenWidth,
    );

    final snackbar = GetSnackBar(
      titleText: Text(
        title ?? 'Heads up',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Row(
        children: [
          if (icon != null)
            Icon(icon, size: 20, color: Colors.white)
          else
            const Icon(Icons.info_outline, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message ?? 'This feature is upcoming',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(top: 16, left: leftMargin, right: rightGap),
      borderRadius: 12,
      backgroundColor: color ?? secondaryColor,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      padding: padding,
      maxWidth: maxWidth,
    );

    Get.showSnackbar(snackbar);

    // Force close if still open after duration (failsafe)
    Future.delayed(duration, () {
      if (Get.isSnackbarOpen) {
        Get.back();
      }
    });
  }
}

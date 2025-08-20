import 'package:flutter/material.dart';
import 'package:green_biller/main.dart';

class SnackBarService {
  static void showSnackBar(String message, {bool isError = false, int durationSeconds = 3}) {
    // Clear any existing snackbars first
    clearSnackBars();
    
    // Use a delayed post-frame callback
    Future.delayed(const Duration(milliseconds: 50), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final currentState = scaffoldMessengerKey.currentState;
          if (currentState != null) {
            currentState.showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: isError ? Colors.red : Colors.green,
                duration: Duration(seconds: durationSeconds),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        } catch (e) {
          // Fallback to print if scaffold messenger is not available
          print('SnackBar Error: $message');
        }
      });
    });
  }

  static void showError(String message) => showSnackBar(message, isError: true);
  static void showSuccess(String message) => showSnackBar(message);
  
  // Clear all existing snackbars
  static void clearSnackBars() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scaffoldMessengerKey.currentState?.clearSnackBars();
    });
  }
}
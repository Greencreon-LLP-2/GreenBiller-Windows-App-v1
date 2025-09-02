import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/main.dart';

class GoRouterNavigationService {
  static void goTo(String location, {bool replace = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = GoRouter.of(navigatorKey.currentContext!);
      if (replace) {
        router.go(location);
      } else {
        router.push(location);
      }
    });
  }

  static void goToHome() {
    goTo('/homepage', replace: true);
  }

  static void goToLogin() {
    goTo('/', replace: true);
  }

  static void goBack() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = GoRouter.of(navigatorKey.currentContext!);
      router.pop();
    });
  }

  // Safe navigation with delay to prevent conflicts
  static void goWithDelay(String location, {bool replace = false, int milliseconds = 100}) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      goTo(location, replace: replace);
    });
  }
}
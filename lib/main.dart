import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/push_notification_service.dart';
import 'package:greenbiller/core/hive_service.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/auth/view/login_page.dart';
import 'package:greenbiller/features/auth/view/maintenance.dart';
import 'package:greenbiller/features/auth/view/notification_page.dart';
import 'package:greenbiller/features/auth/view/otp_verify_page.dart';
import 'package:greenbiller/features/auth/view/signup_page.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:greenbiller/screens/dashboards.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    logger.i('Initializing Hive');
    final hiveService = HiveService();
    Get.put(hiveService); // Make HiveService a singleton
    await hiveService.init();
    if (!Platform.isLinux) {
      logger.i(
        'Initializing PushNotificationService on ${Platform.operatingSystem}',
      );
      Get.put(PushNotificationService());
      await Get.find<PushNotificationService>().init(
        'your-onesignal-app-id',
      ); // Replace with actual OneSignal App ID
    } else {
      logger.w(
        'PushNotificationService skipped on Linux (unsupported platform)',
      );
    }
  } catch (e, stackTrace) {
    logger.e('Initialization error: $e', e, stackTrace);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GreenBiller',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: [
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.otpVerify, page: () => const OtpVerifyPage()),
        GetPage(name: AppRoutes.signUp, page: () => const SignUpPage()),
        GetPage(
          name: AppRoutes.adminDashboard,
          page: () => const AdminDashboard(),
        ),
        GetPage(
          name: AppRoutes.managerDashboard,
          page: () => const ManagerDashboard(),
        ),
        GetPage(
          name: AppRoutes.staffDashboard,
          page: () => const StaffDashboard(),
        ),
        GetPage(
          name: AppRoutes.customerDashboard,
          page: () => const CustomerDashboard(),
        ),
        GetPage(
          name: AppRoutes.homepage,
          page: () => const CustomerDashboard(),
        ),
        GetPage(
          name: AppRoutes.maintenance,
          page: () => const Maintenance(),
        ),
        GetPage(
          name: AppRoutes.oneSignalNotificationPage,
          page: () => const NotificationDetailsPage(),
        ),
      ],
      builder: (context, child) {
        Get.put(AuthController());
        return child!;
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/hive_service.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/auth/view/login_page.dart';
import 'package:greenbiller/features/auth/view/otp_verify_page.dart';
import 'package:greenbiller/features/auth/view/signup_page.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:greenbiller/screens/dashboards.dart';

import 'package:logger/logger.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HiveService().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          logger.e('Initialization error: ${snapshot.error}', snapshot.error, snapshot.stackTrace);
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing app: ${snapshot.error}'),
              ),
            ),
          );
        }
        return GetMaterialApp(
          title: 'GreenBiller',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.login,
          getPages: [
            GetPage(name: AppRoutes.login, page: () => const LoginPage()),
            GetPage(name: AppRoutes.otpVerify, page: () => const OtpVerifyPage()),
            GetPage(name: AppRoutes.signUp, page: () => const SignUpPage()),
            GetPage(name: AppRoutes.adminDashboard, page: () => const AdminDashboard()),
            GetPage(name: AppRoutes.managerDashboard, page: () => const ManagerDashboard()),
            GetPage(name: AppRoutes.staffDashboard, page: () => const StaffDashboard()),
            GetPage(name: AppRoutes.customerDashboard, page: () => const CustomerDashboard()),
            GetPage(name: AppRoutes.homepage, page: () => const CustomerDashboard()),
          ],
          builder: (context, child) {
            Get.put(AuthController());
            return child!;
          },
        );
      },
    );
  }
}
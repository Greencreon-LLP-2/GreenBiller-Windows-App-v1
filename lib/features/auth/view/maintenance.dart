import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/routes/app_routes.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    final payload = Get.arguments as Map<String, dynamic>?;

    final body = payload?['body']?.toString() ?? 'Server Is Down';
    final showLogin = payload?['showLogin'] == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(body, textAlign: TextAlign.center),
            if (showLogin) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.offAllNamed(AppRoutes.login),
                child: const Text('Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final payload = Get.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: Center(
        child: Text(payload?['body']?.toString() ?? 'No details available'),
      ),
    );
  }
}
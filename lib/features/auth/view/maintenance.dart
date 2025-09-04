import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Maintenance extends StatelessWidget {
  const Maintenance({super.key});

  @override
  Widget build(BuildContext context) {
    final payload = Get.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(title: const Text('Maintanance Details')),
      body: Center(
        child: Text(payload?['body']?.toString() ?? 'Server Is Down'),
      ),
    );
  }
}

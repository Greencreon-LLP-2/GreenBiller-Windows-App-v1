import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar_wrapper.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminSidebarWrapper(
      title: 'Settings',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Text('Configure app settings here.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
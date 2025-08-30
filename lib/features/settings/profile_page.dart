import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar_wrapper.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return AdminSidebarWrapper(
      title: 'Profile',
      child: Obx(
        () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Profile', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text('Username: ${controller.user.value?.username ?? 'N/A'}'),
              Text('Email: ${controller.user.value?.email ?? 'N/A'}'),
              Text('Phone: ${controller.user.value?.phone ?? 'N/A'}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
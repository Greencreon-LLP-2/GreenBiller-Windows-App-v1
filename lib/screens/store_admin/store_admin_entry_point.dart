import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar_wrapper.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

class StoreAdminEntryPoint extends StatelessWidget {
  const StoreAdminEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return AdminSidebarWrapper(
      title: 'Admin Dashboard',
      child: Obx(
        () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome, Admin!', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text('Username: ${controller.user.value?.username ?? 'N/A'}'),
              Text('Email: ${controller.user.value?.email ?? 'N/A'}'),
              Text('Phone: ${controller.user.value?.phone ?? 'N/A'}'),
              Text('User Level: ${controller.user.value?.userLevel ?? 'N/A'}'),
              Text(
                'License Key: ${controller.user.value?.licenseKey ?? 'N/A'}',
              ),
              Text('Status: ${controller.user.value?.status ?? 'N/A'}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

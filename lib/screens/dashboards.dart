import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Obx(() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome, Admin!', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Username: ${controller.user.value?.username ?? 'N/A'}'),
                Text('Email: ${controller.user.value?.email ?? 'N/A'}'),
                Text('Phone: ${controller.user.value?.phone ?? 'N/A'}'),
                Text('User Level: ${controller.user.value?.userLevel ?? 'N/A'}'),
                Text('License Key: ${controller.user.value?.licenseKey ?? 'N/A'}'),
                Text('Status: ${controller.user.value?.status ?? 'N/A'}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.logout,
                  child: const Text('Logout'),
                ),
              ],
            ),
          )),
    );
  }
}

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Manager Dashboard')),
      body: Obx(() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome, Manager!', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Username: ${controller.user.value?.username ?? 'N/A'}'),
                Text('Email: ${controller.user.value?.email ?? 'N/A'}'),
                Text('Phone: ${controller.user.value?.phone ?? 'N/A'}'),
                Text('User Level: ${controller.user.value?.userLevel ?? 'N/A'}'),
                Text('License Key: ${controller.user.value?.licenseKey ?? 'N/A'}'),
                Text('Status: ${controller.user.value?.status ?? 'N/A'}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.logout,
                  child: const Text('Logout'),
                ),
              ],
            ),
          )),
    );
  }
}

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Dashboard')),
      body: Obx(() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome, Staff!', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Username: ${controller.user.value?.username ?? 'N/A'}'),
                Text('Email: ${controller.user.value?.email ?? 'N/A'}'),
                Text('Phone: ${controller.user.value?.phone ?? 'N/A'}'),
                Text('User Level: ${controller.user.value?.userLevel ?? 'N/A'}'),
                Text('License Key: ${controller.user.value?.licenseKey ?? 'N/A'}'),
                Text('Status: ${controller.user.value?.status ?? 'N/A'}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.logout,
                  child: const Text('Logout'),
                ),
              ],
            ),
          )),
    );
  }
}

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Dashboard')),
      body: Obx(() => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome, Customer!', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Text('Username: ${controller.user.value?.username ?? 'N/A'}'),
                Text('Email: ${controller.user.value?.email ?? 'N/A'}'),
                Text('Phone: ${controller.user.value?.phone ?? 'N/A'}'),
                Text('User Level: ${controller.user.value?.userLevel ?? 'N/A'}'),
                Text('License Key: ${controller.user.value?.licenseKey ?? 'N/A'}'),
                Text('Status: ${controller.user.value?.status ?? 'N/A'}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.logout,
                  child: const Text('Logout'),
                ),
              ],
            ),
          )),
    );
  }
}
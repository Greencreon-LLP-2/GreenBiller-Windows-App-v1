import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:logger/logger.dart';

class AdminSidebar extends StatelessWidget {
  final Logger logger = Logger();

  AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final currentRoute = Get.currentRoute;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.user.value?.username ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.user.value?.email ?? 'N/A',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            initiallyExpanded:
                currentRoute == AppRoutes.adminDashboard ||
                currentRoute == AppRoutes.overview ||
                currentRoute == AppRoutes.reports,
            children: [
              ListTile(
                title: const Text('Overview'),
                selected: currentRoute == AppRoutes.overview,
                onTap: () {
                  logger.i('Navigating to overview');
                  Get.toNamed(AppRoutes.overview);
                },
              ),
              ListTile(
                title: const Text('Reports'),
                selected: currentRoute == AppRoutes.reports,
                onTap: () {
                  logger.i('Navigating to reports');
                  Get.toNamed(AppRoutes.reports);
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: currentRoute == AppRoutes.profile,
            onTap: () {
              logger.i('Navigating to profile');
              Get.toNamed(AppRoutes.profile);
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            initiallyExpanded:
                currentRoute == AppRoutes.settings ||
                currentRoute == AppRoutes.accountSettings ||
                currentRoute == AppRoutes.notificationSettings,
            children: [
              ListTile(
                title: const Text('Account Settings'),
                selected: currentRoute == AppRoutes.accountSettings,
                onTap: () {
                  logger.i('Navigating to account settings');
                  Get.toNamed(AppRoutes.accountSettings);
                },
              ),
              ListTile(
                title: const Text('Account Settings'),
                selected: currentRoute == AppRoutes.accountSettings,
                onTap: () {
                  logger.i('Navigating to account settings');
                  Get.toNamed(AppRoutes.accountSettings);
                },
              ),
              ListTile(
                title: const Text('Notification Settings'),
                selected: currentRoute == AppRoutes.notificationSettings,
                onTap: () {
                  logger.i('Navigating to notification settings');
                  Get.toNamed(AppRoutes.notificationSettings);
                },
              ),

               ListTile(
                title: const Text('Users Settings'),
                selected: currentRoute == AppRoutes.usersSettings,
                onTap: () {
                  logger.i('Navigating to Users settings');
                  Get.toNamed(AppRoutes.usersSettings);
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              logger.i('Initiating logout');
              await controller.logout();
            },
          ),
        ],
      ),
    );
  }
}

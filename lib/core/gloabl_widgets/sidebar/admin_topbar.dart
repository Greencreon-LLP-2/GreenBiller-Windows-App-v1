import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

class AdminTopbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AdminTopbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return AppBar(
      title: Text(title),
      actions: [
        Obx(() => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  controller.user.value?.username ?? 'User',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
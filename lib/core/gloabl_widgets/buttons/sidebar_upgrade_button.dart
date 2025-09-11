import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/routes/app_routes.dart';

class SidebarUpgradeButton extends StatelessWidget {
  const SidebarUpgradeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 👈 changes cursor on hover
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.plans),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B6B3A), Color(0xFF24C06A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(92, 16, 68, 49),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.star, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Upgrade to Pro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

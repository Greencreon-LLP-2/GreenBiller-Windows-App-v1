import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

import 'package:greenbiller/routes/app_routes.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/trial_card.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/sidebar_upgrade_button.dart';
import 'package:logger/logger.dart';

class AdminSidebar extends StatelessWidget {
  final Logger logger = Logger();

  AdminSidebar({super.key});

  Widget _buildNavTile({
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
    required VoidCallback onTap,
    Color? color,
    double indent = 0,
  }) {
    final isSelected = currentRoute == route;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.only(left: indent + 8, right: 8, top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.green : (color ?? Colors.grey[700]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green[800] : Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final currentRoute = Get.currentRoute;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
           
            Obx(
              () => UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: Text(
                  controller.user.value?.username ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(controller.user.value?.email ?? 'N/A'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (controller.user.value?.username ?? 'U')
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: TrialCard(trialEnds: DateTime(2025, 10, 2)),
            ),

            
            Expanded(
              child: ListView(
                children: [
                  _buildNavTile(
                    title: "Dashboard",
                    icon: Icons.home,
                    route: AppRoutes.adminDashboard,
                    currentRoute: currentRoute,
                    onTap: () => Get.toNamed(AppRoutes.adminDashboard),
                  ),
                  _buildSectionHeader("Quick Actions"),
                  _buildNavTile(
                    title: "Overview",
                    icon: Icons.dashboard_outlined,
                    route: AppRoutes.overview,
                    currentRoute: currentRoute,
                    onTap: () => Get.toNamed(AppRoutes.overview),
                  ),
                  _buildNavTile(
                    title: "Create Purchase",
                    icon: Icons.add_shopping_cart,
                    route: AppRoutes.newPurchase,
                    currentRoute: currentRoute,
                    onTap: () => Get.toNamed(AppRoutes.newPurchase),
                  ),
                  _buildNavTile(
                    title: "Create Sales",
                    icon: Icons.sell,
                    route: AppRoutes.newSales,
                    currentRoute: currentRoute,
                    onTap: () => Get.toNamed(AppRoutes.newSales),
                  ),
                  _buildSectionHeader("Dashboard"),
                  _buildNavTile(
                    title: "Parties",
                    icon: Icons.person_outline,
                    route: AppRoutes.parties,
                    currentRoute: currentRoute,
                    onTap: () => Get.toNamed(AppRoutes.parties),
                  ),

                  _buildSectionHeader("Stores & Warehouses"),
                  _buildNavTile(
                    title: "View Stores",
                    icon: Icons.store_outlined,
                    route: AppRoutes.viewStore,
                    currentRoute: currentRoute,
                    onTap: () => Get.toNamed(AppRoutes.viewStore),
                  ),

                  _buildSectionHeader("Items"),
                  ExpansionTile(
                    leading: const Icon(
                      Icons.inventory_outlined,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Item Management",
                      style: TextStyle(fontSize: 15),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 16),
                    initiallyExpanded: [
                      AppRoutes.addItems,
                      AppRoutes.viewItems,
                      AppRoutes.categories,
                      AppRoutes.brands,
                      AppRoutes.units,
                    ].contains(currentRoute),
                    children: [
                      _buildNavTile(
                        title: "Add Item",
                        icon: Icons.add_circle_outline,
                        route: AppRoutes.addItems,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.addItems),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "View Items",
                        icon: Icons.list_alt,
                        route: AppRoutes.viewItems,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.viewItems),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "Item Categories",
                        icon: Icons.category_outlined,
                        route: AppRoutes.categories,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.categories),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "Brands",
                        icon: Icons.branding_watermark_outlined,
                        route: AppRoutes.brands,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.brands),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "Units",
                        icon: Icons.straighten_outlined,
                        route: AppRoutes.units,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.units),
                        indent: 16,
                      ),
                    ],
                  ),

                  _buildSectionHeader("Sales & Purchases"),
                  ExpansionTile(
                    leading: const Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Purchases",
                      style: TextStyle(fontSize: 15),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 16),
                    initiallyExpanded: [
                      AppRoutes.viewPurchaseBills,
                      AppRoutes.purchaseReturnView,
                    ].contains(currentRoute),
                    children: [
                      _buildNavTile(
                        title: "Purchase History",
                        icon: Icons.history,
                        route: AppRoutes.viewPurchaseBills,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.viewPurchaseBills),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "View Purchase Returns",
                        icon: Icons.arrow_back,
                        route: AppRoutes.purchaseReturnView,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.purchaseReturnView),
                        indent: 16,
                      ),
                   ],
                  ),

                  _buildSectionHeader("Settings"),
                  ExpansionTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Account Settings",
                      style: TextStyle(fontSize: 15),
                    ),
                    childrenPadding: const EdgeInsets.only(left: 16),
                    initiallyExpanded: [
                      AppRoutes.bankAccountSettings,
                      AppRoutes.businessProfile,
                      AppRoutes.invoiceSettings,
                      AppRoutes.usersSettings,
                    ].contains(currentRoute),
                    children: [
                      _buildNavTile(
                        title: "Bank Accounts",
                        icon: Icons.account_balance_wallet_outlined,
                        route: AppRoutes.bankAccountSettings,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.bankAccountSettings),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "Business Profile",
                        icon: Icons.business_outlined,
                        route: AppRoutes.businessProfile,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.businessProfile),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "Invoice Settings",
                        icon: Icons.receipt_outlined,
                        route: AppRoutes.invoiceSettings,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.invoiceSettings),
                        indent: 16,
                      ),
                      _buildNavTile(
                        title: "User Management",
                        icon: Icons.group_outlined,
                        route: AppRoutes.usersSettings,
                        currentRoute: currentRoute,
                        onTap: () => Get.toNamed(AppRoutes.usersSettings),
                        indent: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          
            const SidebarUpgradeButton(),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavTile(
                title: "Logout",
                icon: Icons.logout,
                route: "",
                currentRoute: "",
                color: Colors.red,
                onTap: () async {
                  logger.i('Initiating logout');
                  await controller.logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

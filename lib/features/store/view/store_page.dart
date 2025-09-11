import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/utils/subscription_util.dart';
import 'package:greenbiller/features/auth/model/user_role_model.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';
import 'package:greenbiller/features/store/view/add_store_dialog.dart';
import 'package:greenbiller/features/store/view/add_warehouse_dialog.dart';
import 'package:greenbiller/features/store/view/admin_stores_tab.dart';
import 'package:greenbiller/features/store/view/admin_warehouse_tab.dart';

class StorePage extends GetView<StoreController> {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Store Management (${UserRoleModel.nameFromId(controller.authController.user.value?.userLevel ?? 0)})',
          ),
        ),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: 'Stores'),
            Tab(text: 'Warehouses'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Super admin specific actions
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [AdminStoresTab(), AdminWarehousesTab()],
      ),
      floatingActionButton: Obx(() {
        final user = controller.authController.user.value;
        final hasAccess = SubscriptionUtil.hasValidSubscription(
          user,
          allowTrial: false,
        );

        if (!hasAccess) return SizedBox.shrink(); // hides FAB

        return _buildFloatingActionButton(
          context,
          controller.currentTabIndex.value,
        );
      }),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, int currentTabIndex) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (currentTabIndex == 0) {
          Get.dialog(
            AddStoreDialog(
              callback: () {
                controller.getStoreList();
              },
            ),
          );
        } else {
          Get.dialog(
            AddWarehouseDialog(
              onSuccess: () {
                controller.getWarehouseList();
              },
            ),
          );
        }
      },
      backgroundColor: accentColor,
      heroTag: currentTabIndex == 0 ? 'Add Store' : 'Add Warehouse',
      icon: Icon(
        currentTabIndex == 0 ? Icons.store : Icons.warehouse,
        color: Colors.white,
      ),
      label: Text(
        currentTabIndex == 0 ? 'Add Store' : 'Add Warehouse',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

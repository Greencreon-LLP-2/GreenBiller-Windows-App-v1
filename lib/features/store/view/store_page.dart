import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/model/user_role_model.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';

class StorePage extends GetView<AdminStoreController> {
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
      floatingActionButton: Obx(
        () => _buildFloatingActionButton(
          context,
          controller.currentTabIndex.value,
          UserRoleModel.fromLevel(controller.user.value?.user?.userLevel ?? 0),
          controller.user.value?.accessToken,
          controller.warehouseNameController,
          controller.warehouseAddressController,
          controller.warehouseTypeController,
          controller.warehouseEmailController,
          controller.warehousePhoneController,
          controller.user.value?.user?.id.toString(),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    int currentTabIndex,
    UserRoleModel role,
    String? accessToken,
    TextEditingController warehouseNameController,
    TextEditingController warehouseAddressController,
    TextEditingController warehouseTypeController,
    TextEditingController warehouseEmailController,
    TextEditingController warehousePhoneController,
    String? userId,
  ) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (currentTabIndex == 0) {
          Get.dialog(
            AddStoreDialog(
              callback: () {
                Get.find<ViewStoreController>().fetchStores();
              },
            ),
          );
        } else {
          Get.dialog(
            AddWarehouseDialog(
              accessToken: accessToken,
              userId: userId,
              onSuccess: () {
                Get.find<ViewWarehouseController>().fetchWarehouses();
              },
              parentContext: context,
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

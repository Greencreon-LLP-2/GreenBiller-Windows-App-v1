import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/features/parties/view/add_cutomer_dialog.dart';
import 'package:greenbiller/features/parties/view/add_supplier_dialog.dart';
import 'package:greenbiller/features/parties/view/customers_tab.dart';

import 'package:greenbiller/features/parties/view/suppliers_tab.dart';

class PartiesPage extends StatelessWidget {
  const PartiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PartiesController());
    final tabController = TabController(
      length: 2,
      vsync: Navigator.of(context),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'Parties Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Obx(
                  () => IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: controller.currentTabIndex.value == 0
                        ? controller.refreshCustomers
                        : controller.refreshSuppliers,
                  ),
                ),
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              controller: tabController,
              onTap: (index) => controller.currentTabIndex.value = index,
              tabs: const [
                Tab(text: 'Customers'),
                Tab(text: 'Suppliers'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [CustomersTab(), SuppliersTab()],
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          heroTag: 'admin_parties_floating_btn_tag1',
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          onPressed: () => _showAddDialog(
            context,
            controller.currentTabIndex.value,
            controller.currentTabIndex.value == 0
                ? controller.refreshCustomers
                : controller.refreshSuppliers,
          ),
          icon: Icon(
            controller.currentTabIndex.value == 0
                ? Icons.person_add
                : Icons.business,
          ),
          label: Text(
            controller.currentTabIndex.value == 0
                ? 'Add Customer'
                : 'Add Supplier',
          ),
        ),
      ),
    );
  }

  void _showAddDialog(
    BuildContext context,
    int currentTabIndex,
    VoidCallback refreshCallback,
  ) {
    Get.dialog(
      currentTabIndex == 0
          ? AddCustomerDialog(onSuccess: refreshCallback)
          : AddSupplierDialog(onSuccess: refreshCallback),
    ).then((_) {
      refreshCallback();
      Get.back();
    });
  }
}

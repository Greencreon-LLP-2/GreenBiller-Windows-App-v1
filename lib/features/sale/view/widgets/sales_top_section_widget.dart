// Placeholder for SalesPageTopSectionWidget
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/sale/controller/sales_create_controller.dart';

class SalesPageTopSectionWidget extends StatelessWidget {
  final SalesController controller;
  final VoidCallback onCustomerAddSuccess;

  const SalesPageTopSectionWidget({
    super.key,
    required this.controller,
    required this.onCustomerAddSuccess,
  });
  Widget _buildLoadingDropdown(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    String? value,
    required void Function(String?) onChanged,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.green.shade600, size: 20),
        ),
        dropdownColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Store"),
                  const SizedBox(height: 6),
                  Obx(
                    () => controller.isLoadingStores.value
                        ? _buildLoadingDropdown("Loading stores...")
                        : _buildDropdown(
                            items: controller.storeMap.keys.toList(),
                            value: controller.storeController.text.isEmpty
                                ? null
                                : controller.storeController.text,
                            onChanged: (value) {
                              controller.onStoreSelected(value);
                            },
                            hint: "Select Store",
                            icon: Icons.store,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Warehouse"),
                  const SizedBox(height: 6),
                  Obx(
                    () =>
                        controller.isLoadingWarehouses.value ||
                            controller.warehouseMap.isEmpty
                        ? _buildLoadingDropdown(
                            controller.warehouseMap.isEmpty
                                ? "Select store first"
                                : "Loading warehouses...",
                          )
                        : _buildDropdown(
                            items: controller.warehouseMap.keys.toList(),
                            value: controller.warehouseController.text.isEmpty
                                ? null
                                : controller.warehouseController.text,
                            onChanged: (value) {
                              // controller.onWarehouseSelected
                            },
                            hint: "Select Warehouse",
                            icon: Icons.warehouse,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sale Bill"),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.saleBillConrtoller,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "Enter bill no.",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.green.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: controller.generateBillNumber,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text(
                            "Generate",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("customer"),
                  const SizedBox(height: 6),
                  Obx(
                    () =>
                        controller.isLoadingCustomers.value ||
                            controller.customerMap.isEmpty
                        ? _buildLoadingDropdown(
                            controller.customerMap.isEmpty
                                ? "Select store first"
                                : "Loading customers...",
                          )
                        : _buildDropdown(
                            items: controller.customerMap.keys.toList(),
                            value: controller.customerController.text.isEmpty
                                ? null
                                : controller.customerController.text,
                            onChanged: (value) {
                              // controller.onWarehouseSelected
                            },
                            hint: "Select Customers",
                            icon: Icons.supervised_user_circle_rounded,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: controller.generateBillNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text("Add", style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

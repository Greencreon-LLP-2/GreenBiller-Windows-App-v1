import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/stock/controller/stock_controller.dart';
import 'package:intl/intl.dart';

class StockAdjustmentItemPage extends GetView<StockController> {
  StockAdjustmentItemPage({super.key}) {
    controller.fetchStores();
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text("Stock Adjustment"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => controller.createStockAdjustment(),
              icon: const Icon(Icons.save, size: 20),
              label: const Text(
                "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // standout color
                foregroundColor: Colors.white, // text/icon color
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: CardContainer(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Stock Adjustment Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),

              /// Store Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedStore.value,
                  decoration: _dropdownDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select Store"),
                    ),
                    ...controller.storeMap.keys.map(
                      (s) => DropdownMenuItem(value: s, child: Text(s)),
                    ),
                  ],
                  onChanged: (value) {
                    controller.selectedStore.value = value;
                    controller.selectedWarehouse.value = null;
                    controller.fetchWarehouses(
                      controller.storeMap[value],
                      true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// Warehouse Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedWarehouse.value,
                  decoration: _dropdownDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select Warehouse"),
                    ),
                    ...controller.fromWarehouseMap.keys.map(
                      (w) => DropdownMenuItem(value: w, child: Text(w)),
                    ),
                  ],
                  onChanged: (value) {
                    controller.selectedWarehouse.value = value;
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// Item ID
              TextField(
                controller: controller.itemIdController,
                decoration: _inputDecoration("Item ID"),
              ),
              const SizedBox(height: 16),

              /// Adjustment Quantity
              TextField(
                controller: controller.adjustmentQtyController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Adjustment Quantity"),
              ),
              const SizedBox(height: 16),

              /// Description
              TextField(
                controller: controller.descriptionController,
                decoration: _inputDecoration("Description"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );

  InputDecoration _dropdownDecoration() => InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );
}

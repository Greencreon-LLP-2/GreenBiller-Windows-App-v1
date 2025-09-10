import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/stock/controller/stock_controller.dart';

class StockTransferItemPage extends GetView<StockController> {
  StockTransferItemPage({super.key}) {
    controller.fetchStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text("Stock Transfer"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => controller.createStockTransfer(),
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
                "Stock Transfer Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),

              /// From Store
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedStore.value,
                  decoration: _dropdownDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select From Store"),
                    ),
                    ...controller.storeMap.keys.map(
                      (s) => DropdownMenuItem(value: s, child: Text(s)),
                    ),
                  ],
                  onChanged: (value) {
                    controller.selectedStore.value = value;
                    controller.selectedFromWarehouse.value = null;
                    controller.fetchWarehouses(
                      controller.storeMap[value],
                      true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// From Warehouse
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedFromWarehouse.value,
                  decoration: _dropdownDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select From Warehouse"),
                    ),
                    ...controller.fromWarehouseMap.keys.map(
                      (w) => DropdownMenuItem(value: w, child: Text(w)),
                    ),
                  ],
                  onChanged: (value) {
                    controller.selectedFromWarehouse.value = value;
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// To Store
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedToStore.value,
                  decoration: _dropdownDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select To Store"),
                    ),
                    ...controller.toStoreMap.keys.map(
                      (s) => DropdownMenuItem(value: s, child: Text(s)),
                    ),
                  ],
                  onChanged: (value) {
                    controller.selectedToStore.value = value;
                    controller.selectedToWarehouse.value = null;
                    controller.fetchWarehouses(
                      controller.toStoreMap[value],
                      false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              /// To Warehouse
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedToWarehouse.value,
                  decoration: _dropdownDecoration(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Select To Warehouse"),
                    ),
                    ...controller.toWarehouseMap.keys.map(
                      (w) => DropdownMenuItem(value: w, child: Text(w)),
                    ),
                  ],
                  onChanged: (value) {
                    controller.selectedToWarehouse.value = value;
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

              /// Transfer Quantity
              TextField(
                controller: controller.transferQtyController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Transfer Quantity"),
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

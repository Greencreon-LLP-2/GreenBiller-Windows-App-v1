import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Purchase Page Top Section - Enhanced UI matching sales page design
class PurchasePageTopSectionwidget extends HookConsumerWidget {
  final ValueNotifier<Map<String, String>> supplierMap;
  final ValueNotifier<Map<String, String>> warehouseMap;
  final ValueNotifier<Map<String, String>> storeMap;
  final Function(String?) onSupplierSelected;
  final Function(String?) onWarehouseSelected;
  final Function(String?) onStoreSelected;
  final TextEditingController billNoController;
  final TextEditingController billDateController;
  final ValueNotifier<bool> isLoadingStores; // Add this
  final ValueNotifier<bool> isLoadingWarehouses; // Add this
  final ValueNotifier<bool> isLoadingSuppliers; // Add this

  const PurchasePageTopSectionwidget({
    super.key,
    required this.supplierMap,
    required this.onSupplierSelected,
    required this.warehouseMap,
    required this.onWarehouseSelected,
    required this.storeMap,
    required this.onStoreSelected,
    required this.billNoController,
    required this.billDateController,
    required this.isLoadingStores, // Add this
    required this.isLoadingWarehouses, // Add this
    required this.isLoadingSuppliers, // Add this
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: Colors.green.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Purchase Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // First Row - Store, Warehouse, Bill Number
          Row(
            children: [
              // Store Selection
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Store"),
                    const SizedBox(height: 6),
                    isLoadingStores.value
                        ? _buildLoadingDropdown("Loading stores...")
                        : _buildStoreDropdown(),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Warehouse Selection
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Warehouse"),
                    const SizedBox(height: 6),
                    isLoadingWarehouses.value || warehouseMap.value.isEmpty
                        ? _buildLoadingDropdown(warehouseMap.value.isEmpty
                            ? "Select store first"
                            : "Loading warehouses...")
                        : _buildWarehouseDropdown(),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Bill Number
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bill Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                        color: Colors.green.shade50,
                      ),
                      child: TextField(
                        controller: billNoController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Enter bill no.",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.receipt,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Second Row - Supplier and Bill Date
          Row(
            children: [
              // Supplier Selection
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Suppliers"),
                    const SizedBox(height: 6),
                    isLoadingSuppliers.value || supplierMap.value.isEmpty
                        ? _buildLoadingDropdown(supplierMap.value.isEmpty
                            ? "Select store first"
                            : "Loading Suppliers...")
                        : _buildSupplierDropdown(),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Spacer
              const Expanded(flex: 2, child: SizedBox()),

              // Bill Date
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bill Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                        color: Colors.green.shade50,
                      ),
                      child: TextField(
                        controller: billDateController,
                        readOnly: true,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Select date",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.green.shade600,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDropdown(String message) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.hourglass_empty, size: 20),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: DropdownButtonFormField<String>(
        items: storeMap.value.keys.map((String store) {
          return DropdownMenuItem<String>(
            value: store,
            child: Text(store),
          );
        }).toList(),
        onChanged: onStoreSelected,
        decoration: InputDecoration(
          hintText: "Select Store",
          prefixIcon: Icon(Icons.store, color: Colors.green.shade600),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildWarehouseDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: DropdownButtonFormField<String>(
        items: warehouseMap.value.keys.map((String warehouse) {
          return DropdownMenuItem<String>(
            value: warehouse,
            child: Text(warehouse),
          );
        }).toList(),
        onChanged: onWarehouseSelected,
        decoration: InputDecoration(
          hintText: "Select Warehouse",
          prefixIcon: Icon(Icons.warehouse, color: Colors.green.shade600),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSupplierDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: DropdownButtonFormField<String>(
        items: supplierMap.value.keys.map((String supplier) {
          return DropdownMenuItem<String>(
            value: supplier,
            child: Text(supplier),
          );
        }).toList(),
        onChanged: onSupplierSelected,
        decoration: InputDecoration(
            hintText: "Select Supplier",
            prefixIcon:
                Icon(Icons.water_drop_outlined, color: Colors.green.shade600),
            border: InputBorder.none),
      ),
    );
  }
}

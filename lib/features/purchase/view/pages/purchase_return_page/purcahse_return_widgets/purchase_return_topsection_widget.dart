import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Purchase Page Top Section - Enhanced UI matching sales page design
class PurchaseReturnTopsectionWidget extends HookConsumerWidget {
  final String? billNo;

  final String? supplier;
  final String? store;
  final String? warehouse;
  final TextEditingController returnBillController;
  final TextEditingController returnDateController;
  final ValueNotifier<bool> isLoadingStores; // Add this
  final ValueNotifier<bool> isLoadingWarehouses; // Add this
  final ValueNotifier<bool> isLoadingSuppliers; // Add this

  const PurchaseReturnTopsectionWidget({
    super.key,
    required this.supplier,
    required this.returnDateController,
    required this.billNo,
    required this.store,
    required this.warehouse,
    required this.returnBillController,
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
                "Purchased Information",
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
              // Bill Number
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Retrun Bill Number",
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
                        controller: returnBillController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Return Bill Number",
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
              const SizedBox(
                width: 12,
              ),
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
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: billNo,
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

              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Return Date",
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
                        enabled: false,
                        controller: returnDateController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
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

          const SizedBox(height: 20),

          Row(
            children: [
              // Bill Number
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Supplier",
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
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: supplier,
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
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Store Name",
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
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: supplier,
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

              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "WareHouse",
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
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: warehouse,
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
        ],
      ),
    );
  }
}

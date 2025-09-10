import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/purchase/controller/purchase_manage_controller.dart';

class PurchaseReturnTopsectionWidget extends GetView<PurchaseManageController> {
  final String? billNo;
  final String? supplier;
  final String? store;
  final String? warehouse;

  const PurchaseReturnTopsectionWidget({
    super.key,
    required this.supplier,
    required this.billNo,
    required this.store,
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.green.shade700, size: 24),
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
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Return Bill Number",
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.returnNoController,
                              style: const TextStyle(fontSize: 14),
                              readOnly: true, // prevent manual edits
                              decoration: InputDecoration(
                                hintText: "Return Bill Number",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.receipt,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.green,
                            ),
                            tooltip: "Generate New Number",
                            onPressed: () {
                              controller.generateReturnNo();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),
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
                            horizontal: 16,
                            vertical: 14,
                          ),
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
              const SizedBox(width: 12),
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
                        controller: controller.returnDateController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                        color: controller.isLoadingSuppliers.value
                            ? Colors.grey.shade200
                            : Colors.green.shade50,
                      ),
                      child: TextField(
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: controller.isLoadingSuppliers.value
                              ? 'Loading...'
                              : supplier,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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
                        color: controller.isLoadingStores.value
                            ? Colors.grey.shade200
                            : Colors.green.shade50,
                      ),
                      child: TextField(
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: controller.isLoadingStores.value
                              ? 'Loading...'
                              : store,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.store,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Warehouse",
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
                        color: controller.isLoadingWarehouses.value
                            ? Colors.grey.shade200
                            : Colors.green.shade50,
                      ),
                      child: TextField(
                        enabled: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: controller.isLoadingWarehouses.value
                              ? 'Loading...'
                              : warehouse,
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.warehouse,
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

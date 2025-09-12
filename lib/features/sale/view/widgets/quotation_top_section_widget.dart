import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/sale/controller/quatation_controller.dart';

class QuotationTopSectionWidget extends StatelessWidget {
  final QuotationController controller;
  final VoidCallback onCustomerAddSuccess;

  const QuotationTopSectionWidget({
    super.key,
    required this.controller,
    required this.onCustomerAddSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Selection
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value:
                    controller.storeId.value != null &&
                        controller.storeId.value!.isNotEmpty
                    ? controller.storeId.value
                    : null,
                decoration: InputDecoration(
                  labelText: 'Select Store',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: controller.storeMap.keys.map((String storeName) {
                  return DropdownMenuItem<String>(
                    value: storeName,
                    child: Text(storeName),
                  );
                }).toList(),
                onChanged: (value) => controller.onStoreSelected(value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Customer Selection
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value:
                    controller.customerId.value != null &&
                        controller.customerId.value!.isNotEmpty &&
                        controller.customerMap.keys.contains(
                          controller.customerId.value,
                        )
                    ? controller.customerId.value
                    : null,
                decoration: InputDecoration(
                  labelText: 'Select Customer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: controller.customerMap.keys.map((String customerName) {
                  return DropdownMenuItem<String>(
                    value: customerName,
                    child: Text(customerName),
                  );
                }).toList(),
                onChanged: (value) => controller.onCustomerSelected(value),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add customer functionality if needed
                Get.snackbar(
                  'Info',
                  'Add customer functionality not implemented',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
              child: const Text('Add Customer'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Quote Number
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: controller.quotationNumber.value,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          readOnly: true,
        ),
      ],
    );
  }
}

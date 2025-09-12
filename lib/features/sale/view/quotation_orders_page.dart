import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/sale/controller/quatation_controller.dart';
import 'package:greenbiller/features/sale/model/quotation_model.dart';
import 'package:greenbiller/features/sale/view/quotation_view_page.dart';
import 'package:intl/intl.dart';

import 'package:greenbiller/routes/app_routes.dart';

class QuotationOrdersPage extends GetView<QuotationController> {
  const QuotationOrdersPage({super.key});

  String _getCustomerInitials(String? customerName) {
    if (customerName == null || customerName.isEmpty) return 'NA';
    final parts = customerName.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : parts[0][0].toUpperCase();
  }

  String _getItemSummary(List<QuotationItem> items) {
    if (items.isEmpty) return 'No items';
    if (items.length == 1) return '1 item: ${items.first.itemName}';
    return '${items.length} items';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        title: const Text(
          "Quotations",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.fetchQuotations();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: () {
              Get.toNamed(AppRoutes.createQuotation);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingQuotations.value) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () => controller.fetchQuotations(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // 🔍 Search + Filter row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) =>
                          controller.quotationSearchText.value = v,
                      decoration: InputDecoration(
                        hintText: "Search by Quote No, Customer, or Item",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: accentColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text("All"),
                    selected: controller.selectedQuotationFilter.value == "All",
                    onSelected: (_) =>
                        controller.selectedQuotationFilter.value = "All",
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Pending"),
                    selected:
                        controller.selectedQuotationFilter.value == "Pending",
                    onSelected: (_) =>
                        controller.selectedQuotationFilter.value = "Pending",
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Accepted"),
                    selected:
                        controller.selectedQuotationFilter.value == "Accepted",
                    onSelected: (_) =>
                        controller.selectedQuotationFilter.value = "Accepted",
                  ),
                ],
              ),
            ),
            // 📋 Quotations Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  final quotations = controller.filteredQuotations;
                  return DataTable(
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Quote Date')),
                      DataColumn(label: Text('Quote No')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Items')),
                      DataColumn(label: Text('Total Amount')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: quotations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final quotation = entry.value;
                      final dateFormat = DateFormat('dd MMM yyyy');
                      final customerName = quotation.customerId != null
                          ? controller.customerMap[quotation.customerId] ??
                                'Walk-in Customer'
                          : 'Walk-in Customer';
                      final statusText = quotation.status == 1
                          ? 'completed'
                          : 'pending';
                      final statusColor = quotation.status == 0
                          ? Colors.orange
                          : Colors.green;

                      return DataRow(
                        onSelectChanged: (_) {
                          Get.to(
                            () => QuotationViewPage(
                              index: index,
                              quotation: quotation,
                            ),
                            binding: BindingsBuilder(() {
                              Get.put(QuotationController());
                            }),
                          );
                        },
                        cells: [
                          DataCell(Text((index + 1).toString())),
                          DataCell(
                            Text(
                              dateFormat.format(
                                quotation.quoteDate ?? DateTime.now(),
                              ),
                            ),
                          ),
                          DataCell(Text(quotation.quoteNumber)),
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: accentColor.withOpacity(0.1),
                                  child: Text(
                                    _getCustomerInitials(customerName),
                                    style: const TextStyle(color: accentColor),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(customerName),
                              ],
                            ),
                          ),
                          DataCell(Text(_getItemSummary(quotation.items))),
                          DataCell(
                            Text("₹${quotation.totalAmount.toString()}"),
                          ),
                          DataCell(
                            Text(
                              statusText,
                              style: TextStyle(color: statusColor),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}

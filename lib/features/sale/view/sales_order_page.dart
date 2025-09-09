import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/sale/controller/sales_manage_controller.dart';
import 'package:greenbiller/features/sale/model/sales_order_model.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:intl/intl.dart';

class SalesOrderPage extends GetView<SalesManageController> {
  const SalesOrderPage({super.key});

  String _getCustomerInitials(String? customerName) {
    if (customerName == null || customerName.isEmpty) return 'NA';
    final parts = customerName.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : parts[0][0].toUpperCase();
  }

  String _getItemSummary(List<OrderItem> items) {
    if (items.isEmpty) return 'No items';
    if (items.length == 1) return '1 item: ${items.first.itemId}';
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
          "Sales Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              controller.fetchSalesOrderData(); // inject token
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            onPressed: () {
              Get.toNamed(AppRoutes.createsaleOrder);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
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
                  onPressed: () => controller.fetchSalesOrderData(),
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
                          controller.salesOrderSerchText.value = v,
                      decoration: InputDecoration(
                        hintText: "Search by Order ID, Customer, or Item",
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
                    selected: controller.selectedOrderFilter.value == "All",
                    onSelected: (_) =>
                        controller.selectedOrderFilter.value = "All",
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Open Orders"),
                    selected:
                        controller.selectedOrderFilter.value == "Open Orders",
                    onSelected: (_) =>
                        controller.selectedOrderFilter.value = "Open Orders",
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text("Closed Orders"),
                    selected:
                        controller.selectedOrderFilter.value == "Closed Orders",
                    onSelected: (_) =>
                        controller.selectedOrderFilter.value = "Closed Orders",
                  ),
                ],
              ),
            ),
            // 📋 Orders Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  final orders = controller.filteredOrders;
                  return DataTable(
                    columns: const [
                       DataColumn(label: Text('#')),
                      DataColumn(label: Text('Order Date')),
                      DataColumn(label: Text('Order No')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Items')),
                      DataColumn(label: Text('Total Amount')),
                      DataColumn(label: Text('Payment Mode')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: orders.map((order) {
                      final dateFormat = DateFormat('dd MMM yyyy');
                      final customerName =
                          order.orderAddress ?? 'Walk-in Customer';
                      final statusText = order.orderstatusId == '1'
                          ? 'OPEN'
                          : 'CLOSED';
                      final statusColor = order.orderstatusId == '1'
                          ? warningColor
                          : successColor;

                      return DataRow(
                        cells: [
                              DataCell(Text(order.id.toString())),
                          DataCell(Text(dateFormat.format(order.createdAt))),
                          DataCell(Text(order.uniqueOrderId)),
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: secondaryColor.withOpacity(
                                    0.1,
                                  ),
                                  child: Text(
                                    _getCustomerInitials(customerName),
                                    style: const TextStyle(
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(customerName),
                              ],
                            ),
                          ),
                          DataCell(Text(_getItemSummary(order.items))),
                          DataCell(Text("₹${order.orderTotalamt}")),
                          DataCell(Text(order.paymentMode)),
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

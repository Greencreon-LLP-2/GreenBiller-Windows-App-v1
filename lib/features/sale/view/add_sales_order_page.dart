// views/add_sales_order_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/sale/controller/sales_order_controller.dart';
import 'package:greenbiller/features/sale/model/sale_order_model.dart';
import 'package:greenbiller/features/sale/view/add_sale_order_item_page.dart';
import 'package:intl/intl.dart';

class AddSalesOrderPage extends GetView<SalesOrderController> {
  AddSalesOrderPage({super.key});

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  final dateFormatter = DateFormat('dd MMM yyyy');

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return CardContainer(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
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
              'Add Sales Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildActionButton(
                  'Save',
                  Icons.save,
                  accentColor,
                  () => controller.saveSalesOrder(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              // Summary
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Total Amount',
                        currencyFormatter.format(controller.calculateTotal()),
                        const Color(0xFF3B82F6),
                        Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Items',
                        controller.selectedItems.length.toString(),
                        const Color(0xFF10B981),
                        Icons.inventory_2_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              CardContainer(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sales Order Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Store dropdown
                    _buildStoreDropdown(),
                    const SizedBox(height: 16),

                    // Customer dropdown
                    _buildCustomerDropdown(),
                    const SizedBox(height: 16),

                    // Phone & Paid Amount
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            "Phone Number",
                            controller.phoneController,
                            TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(
                            "Paid Amount",
                            controller.totalAmountController,
                            TextInputType.number,
                            suffix: const Text("₹"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Items
                    if (controller.selectedItems.isNotEmpty) ...[
                      const Text(
                        'Order Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...controller.selectedItems.map(
                        (item) => _buildModernItemCard(item),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildAddItemsButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController ctrl,
    TextInputType type, {
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          keyboardType: type,
          decoration: InputDecoration(
            suffixIcon: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedStoreName.value.isEmpty
            ? null
            : controller.selectedStoreName.value,
        hint: const Text("Select Store"),
        isExpanded: true,
        items: controller.storeMap.keys
            .map((name) => DropdownMenuItem(value: name, child: Text(name)))
            .toList(),
        onChanged: controller.isLoadingStores.value
            ? null
            : controller.onStoreSelected,
        decoration: const InputDecoration(labelText: "Store"),
      ),
    );
  }

  Widget _buildCustomerDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCustomerName.value.isEmpty
            ? null
            : controller.selectedCustomerName.value,
        hint: const Text("Select Customer"),
        isExpanded: true,
        items: controller.customerMap.keys
            .map((name) => DropdownMenuItem(value: name, child: Text(name)))
            .toList(),
        onChanged: controller.isLoadingCustomers.value
            ? null
            : controller.onCustomerSelected,
        decoration: const InputDecoration(labelText: "Customer"),
      ),
    );
  }

  Widget _buildModernItemCard(SaleOrderModelItem item) {
    return CardContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.item.itemName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          Text(
            currencyFormatter.format(item.subtotal),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.selectedStoreId.value.isEmpty) {
          Get.snackbar('Error', 'Please select a store before adding items.');
          return;
        }
        Get.to(() => AddSaleOrderItemsPage());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accentColor.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: accentColor, size: 20),
            SizedBox(width: 8),
            Text(
              "Add Items",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/purchase/controller/new_purchase_controller.dart';

class NewPurchasePage extends StatelessWidget {
  const NewPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewPurchaseController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Purchase"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.savePurchase,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: controller.clearForm, // Removed the () here
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            /// Purchase Info Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green[100]!, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header with green icon
                    Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.green[100]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green[300]!,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.inventory_2,
                              color: Colors.green[700]!,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Purchase Information",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // First row of fields
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabeledField(
                            "Store",
                            controller.storeController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLabeledField(
                            "Warehouse",
                            controller.warehouseController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLabeledFieldWithButton(
                            "Bill Number",
                            controller.billNumberController,
                            onPressed: controller.generateBillNumber,
                            buttonText: "Generate",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Second row of fields
                    Row(
                      children: [
                        Expanded(
                          child: _buildLabeledField(
                            "Supplier",
                            controller.supplierController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLabeledFieldWithButton(
                            "Bill Date",
                            controller.billDateController,
                            onPressed: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 365),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (date != null) {
                                controller.setBillDate(date);
                              }
                            },
                            buttonText: "Pick Date",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Purchase Items Table
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.green[800],
                                  size: 18,
                                ),
                              ),
                              TextSpan(
                                text: " Purchase Items",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: controller.addItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add Item"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Scrollable Table
                    Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 400,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                  ),
                                  columnSpacing: 20,
                                  headingRowHeight: 50,
                                  dataRowHeight: 60,
                                  headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  columns: const [
                                    DataColumn(
                                      label: Center(child: Text("Sl No")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Item")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Serial No")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Qty")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Unit")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Price/Unit")),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text("Purchase Price"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("SKU")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Discount %")),
                                    ),
                                    DataColumn(
                                      label: Center(
                                        child: Text("Discount Amt"),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Tax %")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Tax Amt")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Total")),
                                    ),
                                    DataColumn(
                                      label: Center(child: Text("Actions")),
                                    ),
                                  ],
                                  rows: List.generate(
                                    controller.items.length < 5
                                        ? 5
                                        : controller.items.length,
                                    (index) {
                                      // Use empty item if index is beyond controller items
                                      final item =
                                          index < controller.items.length
                                          ? controller.items[index]
                                          : PurchaseItem();

                                      return DataRow(
                                        color:
                                            MaterialStateProperty.resolveWith<
                                              Color?
                                            >(
                                              (states) => index.isEven
                                                  ? Colors.green[50]
                                                  : null,
                                            ),
                                        cells: [
                                          DataCell(
                                            Center(child: Text("${index + 1}")),
                                          ),
                                          DataCell(_buildTextField(item.item)),
                                          DataCell(
                                            _buildTextField(item.serialNo),
                                          ),
                                          DataCell(_buildTextField(item.qty)),
                                          DataCell(_buildTextField(item.unit)),
                                          DataCell(
                                            _buildTextField(item.pricePerUnit),
                                          ),
                                          DataCell(
                                            _buildTextField(item.purchasePrice),
                                          ),
                                          DataCell(_buildTextField(item.sku)),
                                          DataCell(
                                            _buildTextField(
                                              item.discountPercent,
                                            ),
                                          ),
                                          DataCell(
                                            _buildTextField(
                                              item.discountAmount,
                                            ),
                                          ),
                                          DataCell(
                                            _buildTextField(item.taxPercent),
                                          ),
                                          DataCell(
                                            _buildTextField(item.taxAmount),
                                          ),
                                          DataCell(
                                            _buildTextField(item.totalAmount),
                                          ),
                                          DataCell(
                                            Center(
                                              child:
                                                  index <
                                                      controller.items.length
                                                  ? IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () =>
                                                          controller.removeItem(
                                                            index,
                                                          ),
                                                    )
                                                  : const SizedBox(), // Empty space for empty rows
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Purchase Details and Summary Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purchase Details Card
                Expanded(
                  flex: 2,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.green, width: 1.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Purchase Details & Summary",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Payment Type",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Obx(
                            () => DropdownButtonFormField<String>(
                              value: controller.paymentType.value.isEmpty
                                  ? null
                                  : controller.paymentType.value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.green.shade50,
                              ),
                              items: ["Cash", "Card", "UPI", "Credit"]
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                controller.paymentType.value = val ?? "";
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Purchase Note",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: controller.noteController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Add purchase note...",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              filled: true,
                              fillColor: Colors.green.shade50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Purchase Summary Card
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.green, width: 1.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Purchase Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green[800],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _summaryRow("Subtotal", controller.subtotal.value),
                            const SizedBox(height: 8),
                            _summaryRow(
                              "Total Discount",
                              controller.totalDiscount.value,
                              textColor: Colors.red,
                            ),
                            const SizedBox(height: 8),
                            _summaryRow("Total Tax", controller.totalTax.value),
                            const SizedBox(height: 10),
                            TextField(
                              controller: controller.otherChargesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Other Charges",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.add,
                                  color: Colors.green[700],
                                ),
                                filled: true,
                                fillColor: Colors.green.shade50,
                              ),
                            ),
                            const Divider(),
                            _summaryRow(
                              "Grand Total",
                              controller.grandTotal.value,
                              isBold: true,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: controller.paidAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Paid Amount",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.currency_rupee,
                                  color: Colors.green[700],
                                ),
                                filled: true,
                                fillColor: Colors.green.shade50,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: controller.balanceAmount.value <= 0
                                    ? Colors.green.shade100
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            controller.balanceAmount.value <= 0
                                                ? Icons.check_circle
                                                : Icons.pending,
                                            color:
                                                controller
                                                        .balanceAmount
                                                        .value <=
                                                    0
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            controller.balanceAmount.value <= 0
                                                ? "Fully Paid"
                                                : "Pending",
                                            style: TextStyle(
                                              color:
                                                  controller
                                                          .balanceAmount
                                                          .value <=
                                                      0
                                                  ? Colors.green
                                                  : Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹${controller.balanceAmount.value.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color:
                                              controller.balanceAmount.value <=
                                                  0
                                              ? Colors.green
                                              : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 80), // Space for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: controller.clearForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text("Clear Form"),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: controller.savePurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text("Save Purchase"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----- Helper Methods -----
  static Widget _buildLabeledField(
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }

  static Widget _buildLabeledFieldWithButton(
    String label,
    TextEditingController controller, {
    required VoidCallback onPressed,
    required String buttonText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 42,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(buttonText, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildTextField(TextEditingController controller) {
    return Container(
      width: 120,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double value, {
    Color? textColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/sale/controller/sales_create_controller.dart';

class SalesPageBottomSectionWidget extends StatelessWidget {
  final SalesController controller;

  const SalesPageBottomSectionWidget({super.key, required this.controller});

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
          // Header Section
          Row(
            children: [
              Icon(Icons.payment, color: Colors.green.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                "Payment & Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Main Content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Payment Type, Sales Bill ID, Sales Note
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Type
                    Text(
                      "Payment Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                        color: Colors.green.shade50,
                      ),
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.salesType.value.isEmpty
                              ? null
                              : controller.salesType.value,
                          items: const [
                            DropdownMenuItem(
                              value: "Cash",
                              child: Text('Cash'),
                            ),
                            DropdownMenuItem(value: "Upi", child: Text('UPI')),
                            DropdownMenuItem(
                              value: "Cheque",
                              child: Text('Cheque'),
                            ),
                            DropdownMenuItem(
                              value: "Bank Transfer",
                              child: Text('Bank Transfer'),
                            ),
                          ],
                          onChanged: controller.onSalesTypeChanged,
                          decoration: InputDecoration(
                            hintText: "Select Payment Type",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.green.shade300,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.payment,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                          ),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sales Bill ID
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reference No",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
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
                            controller: controller.referenceNocontroller,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                           
                            decoration: InputDecoration(
                              hintText: "Reference No",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Icon(
                                  Icons.note_add,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Sales Note
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sales Note",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
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
                            controller: controller.salesNoteController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Add sales note...",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Icon(
                                  Icons.note_add,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right Column - Financial Summary
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Header
                      Row(
                        children: [
                          Icon(
                            Icons.calculate,
                            color: Colors.green.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Bill Summary",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Subtotal
                      Obx(
                        () => _buildSummaryRow(
                          "Subtotal",
                          "₹${controller.tempSubTotal.value.toStringAsFixed(2)}",
                          isReadOnly: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Total Tax
                      Obx(
                        () => _buildSummaryRow(
                          "Total Tax",
                          "₹${controller.tempTotalTax.value.toStringAsFixed(2)}",
                          isReadOnly: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Other Charges
                      _buildSummaryRowWithInput(
                        "Other Charges",
                        controller.otherChargesController,
                        Icons.add_circle_outline,
                        () {
                          controller.recalculateGrandTotal();
                          controller.grandTotal.refresh();
                        },
                      ),
                      const SizedBox(height: 12),
                      // Total Discount
                      Obx(
                        () => _buildSummaryRow(
                          "Total Discount",
                          "₹${controller.tempTotalDiscount.value.toStringAsFixed(2)}",
                          isReadOnly: true,
                          color: Colors.red.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      Divider(color: Colors.green.shade300, thickness: 1),
                      const SizedBox(height: 8),
                      // Grand Total
                      Obx(
                        () => _buildSummaryRow(
                          "Grand Total",
                          "₹${controller.grandTotal.value.toStringAsFixed(2)}",
                          isReadOnly: true,
                          isBold: true,
                          fontSize: 18,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Paid Amount
                      _buildSummaryRowWithInput(
                        "Paid Amount",
                        controller.paidAmountController,
                        Icons.account_balance_wallet,
                        () {
                          controller.updateBalance();
                          controller.balance.refresh();
                        },
                      ),
                      const SizedBox(height: 16),
                      // Balance
                      Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: controller.balance.value < 0
                                ? Colors.red.shade50
                                : controller.balance.value > 0
                                ? Colors.orange.shade50
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller.balance.value < 0
                                  ? Colors.red.shade300
                                  : controller.balance.value > 0
                                  ? Colors.orange.shade300
                                  : Colors.green.shade400,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    controller.balance.value < 0
                                        ? Icons.arrow_downward
                                        : controller.balance.value > 0
                                        ? Icons.arrow_upward
                                        : Icons.check_circle,
                                    color: controller.balance.value < 0
                                        ? Colors.red.shade600
                                        : controller.balance.value > 0
                                        ? Colors.orange.shade600
                                        : Colors.green.shade700,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.balance.value < 0
                                        ? "Credit Balance"
                                        : controller.balance.value > 0
                                        ? "Balance Due"
                                        : "Balanced",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: controller.balance.value < 0
                                          ? Colors.red.shade700
                                          : controller.balance.value > 0
                                          ? Colors.orange.shade700
                                          : Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "₹${controller.balance.value.abs().toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: controller.balance.value < 0
                                      ? Colors.red.shade700
                                      : controller.balance.value > 0
                                      ? Colors.orange.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isReadOnly = true,
    bool isBold = false,
    double fontSize = 14,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRowWithInput(
    String label,
    TextEditingController controller,
    IconData icon,
    VoidCallback? onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade300),
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: Colors.green.shade600, size: 18),
                suffixText: "₹",
                suffixStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                onChanged?.call();
              },
            ),
          ),
        ),
      ],
    );
  }
}

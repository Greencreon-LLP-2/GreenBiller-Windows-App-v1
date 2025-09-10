import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/purchase/controller/purchase_manage_controller.dart';
import 'package:intl/intl.dart';

class PurchaseReturnBottomSection extends StatelessWidget {
  final double subTotal;
  final double totalDiscount;
  final TextEditingController otherChargesController;
  final TextEditingController purchaseNoteController;

  const PurchaseReturnBottomSection({
    required this.subTotal,
    required this.totalDiscount,
    required this.otherChargesController,
    required this.purchaseNoteController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PurchaseManageController>();
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return Obx(() {
      final grandTotal =
          subTotal + controller.otherCharges.value - totalDiscount;
      final balance = grandTotal - controller.paidAmount.value;

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
                Icon(
                  Icons.shopping_cart,
                  color: Colors.green.shade700,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Return Details & Summary",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Return Note",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 265,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300),
                              color: Colors.green.shade50,
                            ),
                            child: TextField(
                              controller: purchaseNoteController,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Add return note...",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
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
                        Row(
                          children: [
                            Icon(
                              Icons.calculate,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Return Summary",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          "Subtotal",
                          currencyFormatter.format(subTotal),
                          isReadOnly: true,
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRowWithInput(
                          "Other Charges",
                          otherChargesController,
                          Icons.add_circle_outline,
                          currencyFormatter,
                        ),
                        const SizedBox(height: 12),
                        _buildSummaryRow(
                          "Total Discount",
                          currencyFormatter.format(totalDiscount),
                          isReadOnly: true,
                          color: Colors.red.shade600,
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.green.shade300, thickness: 1),
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          "Grand Total",
                          currencyFormatter.format(grandTotal),
                          isReadOnly: true,
                          isBold: true,
                          fontSize: 18,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: balance < 0
                                ? Colors.red.shade50
                                : balance > 0
                                    ? Colors.orange.shade50
                                    : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: balance < 0
                                  ? Colors.red.shade300
                                  : balance > 0
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
                                    balance < 0
                                        ? Icons.arrow_downward
                                        : balance > 0
                                            ? Icons.arrow_upward
                                            : Icons.check_circle,
                                    color: balance < 0
                                        ? Colors.red.shade600
                                        : balance > 0
                                            ? Colors.orange.shade600
                                            : Colors.green.shade600,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    balance < 0
                                        ? "Overpaid"
                                        : balance > 0
                                            ? "Pending"
                                            : "Balanced",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: balance < 0
                                          ? Colors.red.shade700
                                          : balance > 0
                                              ? Colors.orange.shade700
                                              : Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                currencyFormatter.format(balance.abs()),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: balance < 0
                                      ? Colors.red.shade700
                                      : balance > 0
                                          ? Colors.orange.shade700
                                          : Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
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
    NumberFormat currencyFormatter,
  ) {
    final manageController = Get.find<PurchaseManageController>();
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
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: Colors.green.shade600, size: 18),
                suffixText: "₹",
                suffixStyle:
                    TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              onChanged: (value) {
                manageController.otherCharges.value =
                    double.tryParse(value) ?? 0.0;
                manageController.recalculateGrandTotal();
              },
            ),
          ),
        ),
      ],
    );
  }
}
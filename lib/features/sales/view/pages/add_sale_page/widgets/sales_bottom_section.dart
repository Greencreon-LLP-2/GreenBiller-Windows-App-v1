import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SalesPageBottomSectionWidget extends HookConsumerWidget {
  final double subTotal;
  final double totalDiscount;
  final TextEditingController paidAmountController;
  final TextEditingController otherChargesController;
  final TextEditingController purchaseNoteController;
  final String? purchaseType;
  final void Function(String?)? onPurchaseTypeChanged;

  const SalesPageBottomSectionWidget({
    required this.subTotal,
    required this.totalDiscount,
    required this.paidAmountController,
    required this.otherChargesController,
    required this.purchaseNoteController,
    this.purchaseType,
    this.onPurchaseTypeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherCharges = useState(0.0);
    final paidAmount = useState(0.0);

    useEffect(() {
      void listener() {
        final value = double.tryParse(otherChargesController.text) ?? 0.0;
        otherCharges.value = value;
      }

      otherChargesController.addListener(listener);
      return () => otherChargesController.removeListener(listener);
    }, [otherChargesController]);

    useEffect(() {
      void listener() {
        final value = double.tryParse(paidAmountController.text) ?? 0.0;
        paidAmount.value = value;
      }

      paidAmountController.addListener(listener);
      return () => paidAmountController.removeListener(listener);
    }, [paidAmountController]);

    final grandTotal = subTotal + otherCharges.value - totalDiscount;
    final balance = grandTotal - paidAmount.value;

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
                Icons.payment,
                color: Colors.green.shade700,
                size: 24,
              ),
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
              // Left Column - Payment Type and Sales Note
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Type
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          child: DropdownButtonFormField<String>(
                            value: purchaseType,
                            items: const [
                              DropdownMenuItem(
                                  value: "Cash", child: Text('Cash')),
                              DropdownMenuItem(
                                  value: "Upi", child: Text('UPI')),
                              DropdownMenuItem(
                                  value: "Cheque", child: Text('Cheque')),
                              DropdownMenuItem(
                                  value: "Bank Transfer",
                                  child: Text('Bank Transfer')),
                            ],
                            onChanged: (value) =>
                                onPurchaseTypeChanged?.call(value),
                            decoration: InputDecoration(
                              hintText: "Select Payment Type",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.payment,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.green.shade600,
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
                          height: 250,
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
                            onChanged: (value) {
                              // Save value to a variable or state for API usage
                              // Example: ref.read(purchaseNoteProvider.notifier).state = value;
                            },
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
                      _buildSummaryRow(
                        "Subtotal",
                        "₹${subTotal.toStringAsFixed(2)}",
                        isReadOnly: true,
                      ),
                      const SizedBox(height: 12),

                      // Other Charges
                      _buildSummaryRowWithInput(
                        "Other Charges",
                        otherChargesController,
                        Icons.add_circle_outline,
                      ),
                      const SizedBox(height: 12),

                      // Total Discount
                      _buildSummaryRow(
                        "Total Discount",
                        "₹${totalDiscount.toStringAsFixed(2)}",
                        isReadOnly: true,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Divider(color: Colors.green.shade300, thickness: 1),
                      const SizedBox(height: 8),

                      // Grand Total
                      _buildSummaryRow(
                        "Grand Total",
                        "₹${grandTotal.toStringAsFixed(2)}",
                        isReadOnly: true,
                        isBold: true,
                        fontSize: 18,
                      ),
                      const SizedBox(height: 16),

                      // Paid Amount
                      _buildSummaryRowWithInput(
                        "Paid Amount",
                        paidAmountController,
                        Icons.account_balance_wallet,
                      ),
                      const SizedBox(height: 16),

                      // Balance
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
                                const SizedBox(width: 8),
                                Text(
                                  balance < 0
                                      ? "Credit Balance"
                                      : balance > 0
                                          ? "Balance Due"
                                          : "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: balance < 0
                                        ? Colors.red.shade700
                                        : balance > 0
                                            ? Colors.orange.shade700
                                            : accentColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "₹${balance.abs().toStringAsFixed(2)}",
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
              decoration: InputDecoration(
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                prefixIcon: Icon(
                  icon,
                  color: Colors.green.shade600,
                  size: 18,
                ),
                suffixText: "₹",
                suffixStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

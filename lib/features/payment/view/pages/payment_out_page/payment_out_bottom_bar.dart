import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/payment/services/payment_in_out_service.dart';

class PaymentOutBottomBar extends StatefulWidget {
  final String accessToken;
  final String? supplierId;
  final String? supplierDue;

  const PaymentOutBottomBar({
    super.key,
    required this.accessToken,
    this.supplierId,
    this.supplierDue,
  });

  @override
  State<PaymentOutBottomBar> createState() => _PaymentOutBottomBarState();
}

class _PaymentOutBottomBarState extends State<PaymentOutBottomBar> {
  final _paymentController = TextEditingController();
  final _purchaseIdController = TextEditingController();
  final _referenceController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;
  String _paymentType = 'Cash';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _purchaseIdController.dispose();
    _referenceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _savePayment() async {
    if (widget.supplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a supplier first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final payment = double.tryParse(_paymentController.text);
    if (payment == null || payment <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid payment amount"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if payment exceeds supplier due
    final supplierDue = double.tryParse(widget.supplierDue ?? '0') ?? 0;
    if (supplierDue > 0 && payment > supplierDue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment exceeds supplier due of ₹ $supplierDue"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      "supplier_id": widget.supplierId,
      "payment": payment.toString(),
      "payment_date": _selectedDate?.toIso8601String().split('T')[0],
      "payment_type": _paymentType,
      "payment_note": _noteController.text,
      "purchase_id": _purchaseIdController.text.isNotEmpty
          ? _purchaseIdController.text
          : null,
      "reference_no": _referenceController.text.isNotEmpty
          ? _referenceController.text
          : null,
    };

    try {
      final service = PaymentInOutService(widget.accessToken);
      final response = await service.savePaymentOut(data);

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment Out recorded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Error: ${response['message'] ?? response['errors']?.toString() ?? 'Unknown error'}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving payment: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.payment,
                  color: accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Payment Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _purchaseIdController,
                          label: "Purchase ID",
                          hint: "Optional",
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.receipt_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _paymentController,
                          label: "Payment Amount",
                          hint: "Enter amount",
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          prefixIcon: Icons.currency_rupee,
                          isRequired: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDatePicker(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPaymentTypeDropdown(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _referenceController,
                    label: "Reference Number",
                    hint: "Optional",
                    prefixIcon: Icons.tag,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _noteController,
                    label: "Payment Note",
                    hint: "Add any additional notes",
                    prefixIcon: Icons.note_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side:
                                BorderSide(color: errorColor.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: errorColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _savePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.save_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Save Payment",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isRequired)
              const Text(
                " *",
                style: TextStyle(
                  color: errorColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey.shade600, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: accentColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              "Payment Date",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              " *",
              style: TextStyle(
                color: errorColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "Select date"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate == null
                          ? Colors.grey.shade600
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Type",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: DropdownButton<String>(
            value: _paymentType,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text(' Cash')),
              DropdownMenuItem(value: 'Card', child: Text(' Card')),
              DropdownMenuItem(value: 'Cheque', child: Text(' Cheque')),
              DropdownMenuItem(value: 'UPI', child: Text(' UPI')),
              DropdownMenuItem(
                  value: 'Bank Transfer', child: Text('🏛️ Bank Transfer')),
            ],
            onChanged: (value) {
              setState(() {
                _paymentType = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

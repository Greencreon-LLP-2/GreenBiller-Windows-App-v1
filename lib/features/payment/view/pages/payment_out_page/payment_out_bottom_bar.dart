
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
      "purchase_id": _purchaseIdController.text.isNotEmpty ? _purchaseIdController.text : null,
      "reference_no": _referenceController.text.isNotEmpty ? _referenceController.text : null,
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
            content: Text("Error: ${response['message'] ?? response['errors']?.toString() ?? 'Unknown error'}"),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _purchaseIdController,
            decoration: const InputDecoration(
              labelText: "Purchase ID (Optional)",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _paymentController,
            decoration: const InputDecoration(
              labelText: "Payment Amount *",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickDate,
                  child: Text(
                    _selectedDate == null
                        ? "Select Payment Date *"
                        : "Date: ${_selectedDate!.toLocal().toString().split(" ")[0]}",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _referenceController,
            decoration: const InputDecoration(
              labelText: "Reference No (Optional)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: textLightColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _paymentType,
              isExpanded: true,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'Card', child: Text('Card')),
                DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
                DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
              ],
              onChanged: (value) {
                setState(() {
                  _paymentType = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: "Payment Note (Optional)",
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: errorColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _savePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Save Payment Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
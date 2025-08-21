import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/payment/services/payment_in_out_service.dart';

class PaymentInBottomBar extends StatefulWidget {
  final String accessToken;
  final String? customerId;

  const PaymentInBottomBar({
    super.key,
    required this.accessToken,
    this.customerId,
  });

  @override
  State<PaymentInBottomBar> createState() => _PaymentInBottomBarState();
}

class _PaymentInBottomBarState extends State<PaymentInBottomBar> {
  final _paymentController = TextEditingController();
  final _saleidController = TextEditingController();
  final _referenceController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _paymentController.dispose();
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
    if (widget.customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a customer first or add one"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ensure sale_id is numeric
    int? saleId = int.tryParse(_saleidController.text);
    if (saleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sale ID must be a valid number"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      "customer_id": widget.customerId,
      "sale_id": saleId,
      "payment": _paymentController.text,
      "payment_date": _selectedDate?.toIso8601String(),
      "reference_no": _referenceController.text,
      "payment_note": _noteController.text,
    };

    try {
      final service = PaymentInOutService(widget.accessToken);
      final response = await service.savePaymentIn(data);

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Payment saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show backend validation errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${response['errors'] ?? 'Unknown error'}"),
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
            controller: _saleidController,
            decoration: const InputDecoration(
              labelText: "sale ID",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _paymentController,
            decoration: const InputDecoration(
              labelText: "Payment Amount",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickDate,
                  child: Text(
                    _selectedDate == null
                        ? "Select Payment Date"
                        : _selectedDate!.toLocal().toString().split(" ")[0],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _referenceController,
            decoration: const InputDecoration(
              labelText: "Reference No",
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
              value: 'Cash',
              isExpanded: true,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'Card', child: Text('Card')),
                DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
                DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                DropdownMenuItem(value: 'Credit', child: Text('Credit')),
              ],
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: "Payment Note",
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
                    "Save Payment",
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

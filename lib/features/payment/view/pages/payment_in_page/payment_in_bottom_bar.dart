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
  String _paymentType = 'Cash';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _saleidController.dispose();
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textPrimaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: accentColor),
            ),
          ),
          child: child!,
        );
      },
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
        SnackBar(
          content: const Text("Please select a customer first or add one"),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    int? saleId = int.tryParse(_saleidController.text);
    if (saleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Sale ID must be a valid number"),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    final payment = double.tryParse(_paymentController.text);
    if (payment == null || payment <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter a valid payment amount"),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final data = {
      "customer_id": widget.customerId,
      "sale_id": saleId,
      "payment": payment.toString(),
      "payment_date": _selectedDate?.toIso8601String().split('T')[0],
      "payment_type": _paymentType,
      "reference_no": _referenceController.text.isNotEmpty
          ? _referenceController.text
          : null,
      "payment_note":
          _noteController.text.isNotEmpty ? _noteController.text : null,
    };

    try {
      final service = PaymentInOutService(widget.accessToken);
      final response = await service.savePaymentIn(data);

      if (response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Payment saved successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${response['errors'] ?? 'Unknown error'}"),
            backgroundColor: errorColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving payment: $e"),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.payments_outlined,
                  color: accentColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Payment In",
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
                          controller: _saleidController,
                          label: "Sale ID",
                          hint: "Enter sale ID",
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.receipt_long_outlined,
                          isRequired: true,
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
                          onPressed: _isSaving ? null : _savePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isSaving
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Saving...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
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
              DropdownMenuItem(value: 'Credit', child: Text(' Credit')),
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

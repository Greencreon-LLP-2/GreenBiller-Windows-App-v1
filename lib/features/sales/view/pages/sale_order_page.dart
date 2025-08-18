import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:intl/intl.dart';

class AddSaleOrderPage extends HookWidget {
  const AddSaleOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderNumberController = useTextEditingController(text: "2");
    final selectedDate = useState(DateTime.now());
    final selectedDueDate = useState(DateTime.now());
    final customerNameController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    final totalAmountController = useTextEditingController();

    final dateFormat = DateFormat('dd/MM/yyyy');

    Future<void> selectDate(
        BuildContext context, ValueNotifier<DateTime> dateNotifier) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateNotifier.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: accentColor,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        dateNotifier.value = picked;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sale Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          "Order No.",
                          orderNumberController,
                          readOnly: true,
                          suffix: const Icon(Icons.arrow_drop_down,
                              color: textSecondaryColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => selectDate(context, selectedDate),
                          child: _buildInputField(
                            "Date",
                            TextEditingController(
                              text: dateFormat.format(selectedDate.value),
                            ),
                            readOnly: true,
                            suffix: const Icon(Icons.calendar_today,
                                size: 18, color: textSecondaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    "Customer Name *",
                    customerNameController,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    "Phone Number",
                    phoneNumberController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => selectDate(context, selectedDueDate),
                    child: _buildInputField(
                      "Due Date",
                      TextEditingController(
                        text: dateFormat.format(selectedDueDate.value),
                      ),
                      readOnly: true,
                      suffix: const Icon(Icons.calendar_today,
                          size: 18, color: textSecondaryColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAddItemsButton(),
                  const SizedBox(height: 12),
                  _buildInputField(
                    "Total Amount",
                    totalAmountController,
                    prefix: const Text(
                      "₹",
                      style: TextStyle(
                        fontSize: 16,
                        color: textPrimaryColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String hint,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType? keyboardType,
    Widget? prefix,
    Widget? suffix,
  }) {
    return CardContainer(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: const TextStyle(
              color: textSecondaryColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (prefix != null) ...[
                prefix,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    color: textPrimaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
              if (suffix != null) suffix,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemsButton() {
    return const CardContainer(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.add_circle, color: accentColor, size: 20),
          SizedBox(width: 8),
          Text(
            "Add Items",
            style: TextStyle(
              color: accentColor,
              fontSize: 14,
            ),
          ),
          Text(
            " (Optional)",
            style: TextStyle(
              color: textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Save & New",
                style: TextStyle(color: textSecondaryColor),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

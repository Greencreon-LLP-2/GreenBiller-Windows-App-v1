import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/sale/controller/sales_manage_controller.dart';
import 'package:intl/intl.dart';

class AddCreditNoteItemsPage extends GetView<SalesManageController> {
  AddCreditNoteItemsPage({super.key});

  // Formatter for currency
  final currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  Widget _buildInputField(
    String label, {
    bool isRequired = false,
    required RxString rxValue,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              const Text(" *", style: TextStyle(color: accentColor)),
          ],
        ),
        const SizedBox(height: 8),

        Obx(
          () => TextField(
            controller: TextEditingController(text: rxValue.value)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: rxValue.value.length),
              ),
            keyboardType: keyboardType,
            readOnly: onTap != null,
            onTap: onTap,
            onChanged: (val) {
              rxValue.value = val;
              controller.filterItems(val);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: textLightColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: textLightColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: accentColor),
              ),
              fillColor: cardColor,
              filled: true,

              suffixIcon: rxValue.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                      onPressed: () => rxValue.value = '',
                    )
                  : const Icon(Icons.search, color: Color(0xFF64748B)),
            ),
            style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    ValueChanged<String?>? onChanged,
  ) {
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
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: textLightColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: textLightColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor),
            ),
            fillColor: cardColor,
            filled: true,
          ),
          style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
        ),
      ],
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch items on initialization
    if (controller.selectedStoreId.value.isNotEmpty) {
      controller.fetchItems(controller.selectedStoreId.value);
    }

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Add Items to Credit Note',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: CardContainer(
          margin: const EdgeInsets.all(20),
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
                'Item Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField('Search Items', rxValue: controller.searchText),

              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoadingItems.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: accentColor),
                  );
                } else if (controller.searchText.value.isNotEmpty &&
                    controller.filteredItems.isNotEmpty) {
                  return Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        return ListTile(
                          title: Text(
                            item['item_name'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          subtitle: Text(
                            'Price: ${currencyFormatter.format(double.tryParse(item['Purchase_price'] as String? ?? '0') ?? 0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          onTap: () => controller.selectItem(item),
                        );
                      },
                    ),
                  );
                } else if (controller.searchText.value.isNotEmpty &&
                    controller.filteredItems.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No items found',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Obx(() {
                if (controller.selectedItem.value == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Selected Item Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Quantity',
                      rxValue: controller.quantityText,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            'Tax',
                            controller.selectedTaxType.value,
                            const [
                              DropdownMenuItem(
                                value: 'Without Tax',
                                child: Text('Without Tax'),
                              ),
                              DropdownMenuItem(
                                value: 'GST',
                                child: Text('GST'),
                              ),
                              DropdownMenuItem(
                                value: 'VAT',
                                child: Text('VAT'),
                              ),
                            ],
                            (value) {
                              if (value != null) {
                                controller.selectedTaxType.value = value;
                                controller.selectedTaxRate.value =
                                    value == 'GST'
                                    ? 18.0
                                    : value == 'VAT'
                                    ? 12.5
                                    : 0.0;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: const Center(
                          child: Text(
                            'Discard',
                            style: TextStyle(
                              color: Color(0xFF1E293B),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: controller.selectedItem.value != null
                            ? controller.saveItem
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: controller.selectedItem.value != null
                                ? accentColor
                                : accentColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: controller.selectedItem.value != null
                                  ? accentColor
                                  : accentColor.withOpacity(0.5),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Save Item',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
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
      ),
    );
  }
}

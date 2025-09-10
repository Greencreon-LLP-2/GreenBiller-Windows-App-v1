import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/sale/controller/sales_manage_controller.dart';
import 'package:greenbiller/features/sale/model/credit_note_model.dart';
import 'package:greenbiller/features/sale/view/add_credit_note_items_page.dart';

import 'package:intl/intl.dart';

class CreditNotePage extends GetView<SalesManageController> {
  CreditNotePage({super.key});

  // Formatter for currency
  final currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  // Formatter for date
  final dateFormatter = DateFormat('dd MMM yyyy');

  void _showSuccessSnackBar(
    BuildContext context,
    String message,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
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

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
    bool isLoading,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return CardContainer(
      margin: EdgeInsets.zero,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
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
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label, {
    bool isRequired = false,
    Widget? suffix,
    TextEditingController? controller,
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: onTap != null,
          onTap: onTap,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor),
            ),
            fillColor: Colors.white,
            filled: true,
            suffixIcon: suffix,
          ),
          style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown({
    required RxString selectedStoreName,
    required RxMap<String, String> storeList,
    required RxBool isLoading,
    required Function(String? storeName) onStoreSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Store",
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => isLoading.value
              ? _buildLoadingDropdown("Loading stores...")
              : DropdownButtonFormField<String>(
                  value: selectedStoreName.value.isEmpty
                      ? null
                      : selectedStoreName.value,
                  hint: const Text(
                    "Select Store (Required)",
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                  isExpanded: true,
                  items: storeList.value.keys.map((name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(
                        name,
                        style: const TextStyle(color: Color(0xFF1E293B)),
                      ),
                    );
                  }).toList(),
                  onChanged: isLoading.value ? null : onStoreSelected,
                  menuMaxHeight: 400,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: accentColor),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: const Icon(
                      Icons.store_outlined,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF1E293B)),
                ),
        ),
      ],
    );
  }

  Widget _buildAddItemsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.selectedStoreId.value.isEmpty) {
          _showErrorSnackBar(
            context,
            'Please select a store before adding items.',
          );
          return;
        }
        Get.to(() => AddCreditNoteItemsPage());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accentColor.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: accentColor, size: 20),
            SizedBox(width: 8),
            Text(
              "Add Items",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernItemCard(CreditNoteItem item) {
    return CardContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.item.itemName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Qty: ${item.quantity} ${item.unit}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              Text(
                'Rate: ${currencyFormatter.format(item.rate)}/${item.unit}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              if (item.taxRate > 0)
                Text(
                  'Tax: ${item.taxRate}% (${item.taxType})',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
            ],
          ),
          Text(
            currencyFormatter.format(item.subtotal),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch stores on initialization
    if (controller.storeMap.isEmpty) {
      controller.fetchStores();
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
            centerTitle: false,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Sales Return',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Obx(
                  () => _buildActionButton(
                    'Save',
                    Icons.save,
                    accentColor,
                    () => controller.saveCreditNote(context),
                    controller.isLoadingCreateSalesReturn.value ||
                        controller.isLoadingCreateSalesItemReturn.value ||
                        controller.isLoadingCreateSalesPaymentReturn.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Summary Card
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Total Amount',
                        currencyFormatter.format(controller.calculateTotal()),
                        const Color(0xFF3B82F6),
                        Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Items',
                        controller.selectedItems.length.toString(),
                        const Color(0xFF10B981),
                        Icons.inventory_2_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Form Fields
            CardContainer(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                    'Credit Note Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => _buildDropdownField(
                            "Return No.",
                            controller.returnNumber.value,
                            onTap: () {
                              controller.returnNumber.value = controller
                                  .generateReturnNumber();
                              _showSuccessSnackBar(
                                context,
                                'Return number refreshed!',
                                Icons.refresh,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(
                          () => _buildDropdownField(
                            "Date",
                            dateFormatter.format(controller.selectedDate.value),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: controller.selectedDate.value,
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
                                controller.selectedDate.value = picked;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStoreDropdown(
                    selectedStoreName: controller.selectedStoreName,
                    storeList: controller.storeMap,
                    isLoading: controller.isLoadingStores,
                    onStoreSelected: (name) async {
                      controller.selectedStoreName.value = name ?? '';
                      controller.selectedStoreId.value = name != null
                          ? controller.storeMap.value[name] ?? ''
                          : '';

                      // Clear previously selected customer
                      controller.selectedCustomerName.value = '';
                      controller.customerNameController.clear();

                      // Fetch customers for the selected store
                      await controller.fetchCustomers(
                        controller.selectedStoreId.value,
                      );

                      // Optionally auto-select the first customer (if any)
                      if (controller.customerMap.isNotEmpty) {
                        final firstCustomer = controller.customerMap.keys.first;
                        controller.selectedCustomerName.value = firstCustomer;
                        controller.customerNameController.text = firstCustomer;
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          controller.customerMap.containsKey(
                            controller.selectedCustomerName.value,
                          )
                          ? controller.selectedCustomerName.value
                          : null,
                      isExpanded: true,
                      items: controller.customerMap.value.keys
                          .map(
                            (name) => DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            ),
                          )
                          .toList(),
                      onChanged: controller.isLoadingCustomers.value
                          ? null
                          : (name) {
                              if (name == null) return;
                              controller.selectedCustomerName.value = name;

                              if (name != 'Walk-in Customer') {
                                controller.customerNameController.text = name;
                              } else {
                                controller.customerNameController.clear();
                              }
                            },
                      menuMaxHeight: 400,
                      decoration: InputDecoration(
                        labelText: "Customer",
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
                        suffixIcon: controller.isLoadingCustomers.value
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Icon(Icons.person_outline),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  _buildInputField(
                    "Phone Number",
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.invoiceDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Invoice Date",
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: accentColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: textLightColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: accentColor),
                            ),
                            fillColor: cardColor,
                            filled: true,
                          ),
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
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
                              controller.invoiceDateController.text =
                                  dateFormatter.format(picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          "Sales Invoice No.",
                          controller: controller.invoiceNumberController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (controller.selectedItems.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...controller.selectedItems.map(
                          (item) => _buildModernItemCard(item),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildAddItemsButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

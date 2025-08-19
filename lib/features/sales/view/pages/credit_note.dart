import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/model/credit_note/credit_note_model.dart';
import 'package:green_biller/features/sales/view/pages/add_credit_note_items_page.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final selectedItemsProvider = StateProvider<List<CreditNoteItem>>((ref) => []);

class CreditNotePage extends HookConsumerWidget {
  CreditNotePage({super.key});

  // Formatter for currency
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  // Formatter for date
  final dateFormatter = DateFormat('dd MMM yyyy');

  void _showSuccessSnackBar(
      BuildContext context, String message, IconData icon) {
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
      String label, IconData icon, Color color, VoidCallback onPressed) {
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
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    final dateFormat = DateFormat('dd/MM/yyyy');
    final customerNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final invoiceDateController = useTextEditingController();
    final invoiceNumberController = useTextEditingController();
    final selectedItems = ref.watch(selectedItemsProvider);
    final returnNumber = useState(_generateReturnNumber());
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final selectedStoreName = useState<String?>(null);
    final selectedStoreId = useState<String?>(null);
    final selectedCustomerName = useState<String>('Walk-in Customer');
    final customerList =
        useState<Map<String, String>>({'Walk-in Customer': ''});
    final storeList = useState<Map<String, String>>({});
    final isLoadingCustomers = useState(false);

    double calculateTotal() {
      return selectedItems.fold(0, (sum, item) => sum + item.subtotal);
    }

    Future<Map<String, String>> fetchStores(String accessToken) async {
      try {
        final map =
            await ViewStoreController(accessToken: accessToken, storeId: 0)
                .getStoreList();
        storeList.value = map;
        return map;
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to fetch stores: $e');
        return {};
      }
    }

    useEffect(() {
      if (accessToken == null) return null;
      invoiceDateController.text =
          DateFormat('dd/MM/yyyy').format(DateTime.now());
      fetchStores(accessToken);
      return null;
    }, [accessToken]);

    Future<void> fetchCustomers(String? storeId) async {
      if (storeId == null) return;
      isLoadingCustomers.value = true;
      try {
        final user = ref.read(userProvider);
        final accessToken = user?.accessToken;
        if (accessToken != null) {
          final customers =
              await ViewPartiesController().customerList(accessToken, storeId);
          customerList.value = {'Walk-in Customer': '', ...customers};
        } else {
          customerList.value = {'Walk-in Customer': ''};
        }
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to fetch customers: $e');
        customerList.value = {'Walk-in Customer': ''};
      } finally {
        selectedCustomerName.value = 'Walk-in Customer';
        isLoadingCustomers.value = false;
      }
    }

    void saveCreditNote() {
      final creditNote = CreditNote(
        returnNumber: returnNumber.value,
        returnDate: selectedDate.value,
        customerName: selectedCustomerName.value == 'Walk-in Customer'
            ? 'Walk-in Customer'
            : customerNameController.text,
        phoneNumber: phoneController.text,
        invoiceDate: invoiceDateController.text.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(invoiceDateController.text)
            : null,
        invoiceNumber: invoiceNumberController.text,
        items: selectedItems,
        totalAmount: calculateTotal(),
        storeId: selectedStoreId.value ?? '',
        customerId: selectedCustomerName.value != 'Walk-in Customer'
            ? customerList.value[selectedCustomerName.value] ?? ''
            : null,
      );
      _printCreditNoteDetails(creditNote);
      _showSuccessSnackBar(
          context, 'Credit note saved successfully!', Icons.check_circle);
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Credit Note',
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
                child: _buildActionButton(
                  'Save',
                  Icons.save,
                  accentColor,
                  saveCreditNote,
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
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildModernSummaryCard(
                      'Total Amount',
                      currencyFormatter.format(calculateTotal()),
                      const Color(0xFF3B82F6),
                      Icons.payments_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernSummaryCard(
                      'Items',
                      selectedItems.length.toString(),
                      const Color(0xFF10B981),
                      Icons.inventory_2_outlined,
                    ),
                  ),
                ],
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
                        child: _buildDropdownField(
                          "Return No.",
                          returnNumber.value,
                          onTap: () {
                            returnNumber.value = _generateReturnNumber();
                            _showSuccessSnackBar(context,
                                'Return number refreshed!', Icons.refresh);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          "Date",
                          dateFormatter.format(selectedDate.value),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate.value,
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
                              selectedDate.value = picked;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStoreDropdown(
                    selectedStoreName: selectedStoreName,
                    storeList: storeList,
                    isLoading: isLoadingCustomers.value,
                    onStoreSelected: (name) async {
                      selectedStoreName.value = name;
                      selectedStoreId.value =
                          name != null ? storeList.value[name] : null;
                      selectedCustomerName.value = 'Walk-in Customer';
                      customerNameController.clear();
                      await fetchCustomers(selectedStoreId.value);
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCustomerName.value,
                    isExpanded: true,
                    items: customerList.value.keys
                        .map((name) => DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            ))
                        .toList(),
                    onChanged: isLoadingCustomers.value
                        ? null
                        : (name) {
                            if (name == null) return;
                            selectedCustomerName.value = name;
                            if (name != 'Walk-in Customer') {
                              customerNameController.text = name;
                            } else {
                              customerNameController.clear();
                            }
                          },
                    menuMaxHeight: 400,
                    decoration: InputDecoration(
                      labelText: "Customer",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
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
                      suffixIcon: isLoadingCustomers.value
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            )
                          : const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    "Phone Number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: invoiceDateController,
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
                              borderSide:
                                  const BorderSide(color: textLightColor),
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
                              invoiceDateController.text =
                                  dateFormatter.format(picked);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          "Invoice No.",
                          controller: invoiceNumberController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (selectedItems.isNotEmpty) ...[
                    const Text(
                      'Selected Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...selectedItems.map((item) => _buildModernItemCard(item)),
                  ],
                  const SizedBox(height: 16),
                  _buildAddItemsButton(context, selectedStoreId.value),
                ],
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
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                'Rate: ${currencyFormatter.format(item.rate)}/${item.unit}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
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

  static String _generateReturnNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final randomString =
        List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
    return 'RT_ITEM_$randomString';
  }

  void _printCreditNoteDetails(CreditNote creditNote) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    print('--- Credit Note Details ---');
    print('Return Number: ${creditNote.returnNumber}');
    print('Date: ${dateFormat.format(creditNote.returnDate)}');
    print('Store ID: ${creditNote.storeId}');
    print('Customer: ${creditNote.customerName}');
    print('Customer ID: ${creditNote.customerId ?? "Walk-in Customer"}');
    if (creditNote.phoneNumber != null) {
      print('Phone: ${creditNote.phoneNumber}');
    }
    if (creditNote.invoiceDate != null) {
      print('Invoice Date: ${dateFormat.format(creditNote.invoiceDate!)}');
    }
    if (creditNote.invoiceNumber != null) {
      print('Invoice No: ${creditNote.invoiceNumber}');
    }
    print('\nItems:');
    for (final item in creditNote.items) {
      print(
          '- ${item.item.itemName}: ${item.quantity} ${item.unit} @ ₹${item.rate}');
    }
    print('\nTotal Amount: ₹${creditNote.totalAmount.toStringAsFixed(2)}');
    print('--------------------------');
  }

  Widget _buildDropdownField(String label, String value,
      {VoidCallback? onTap}) {
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
              const Text(
                " *",
                style: TextStyle(color: accentColor),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: onTap != null,
          onTap: onTap,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStoreDropdown({
    required ValueNotifier<String?> selectedStoreName,
    required ValueNotifier<Map<String, String>> storeList,
    required bool isLoading,
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
        DropdownButtonFormField<String>(
          value: selectedStoreName.value,
          hint: const Text(
            "Select Store (Optional)",
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
          isExpanded: true,
          items: storeList.value.keys
              .map((name) => DropdownMenuItem<String>(
                    value: name,
                    child: Text(
                      name,
                      style: const TextStyle(color: Color(0xFF1E293B)),
                    ),
                  ))
              .toList(),
          onChanged: isLoading ? null : onStoreSelected,
          menuMaxHeight: 400,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accentColor,
                      ),
                    ),
                  )
                : const Icon(Icons.store_outlined, color: Color(0xFF64748B)),
          ),
          style: const TextStyle(color: Color(0xFF1E293B)),
        ),
      ],
    );
  }

  Widget _buildAddItemsButton(BuildContext context, String? selectedStore) {
    return GestureDetector(
      onTap: () {
           
         context.go('/add-credit-note-items/${selectedStore}');
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
}

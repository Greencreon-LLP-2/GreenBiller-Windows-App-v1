import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/model/credit_note_model.dart';
import 'package:green_biller/features/item/view/pages/add_credit_note_items_page.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final selectedItemsProvider = StateProvider<List<CreditNoteItem>>((ref) => []);

class CreditNotePage extends HookConsumerWidget {
  const CreditNotePage({super.key});

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
    // Store & customer state
    final selectedStoreName = useState<String?>(null);
    final selectedStoreId = useState<String?>(null);

    final selectedCustomerName = useState<String>('Walk-in Customer');
    final customerList =
        useState<Map<String, String>>({'Walk-in Customer': ''});
    final storeList = useState<Map<String, String>>({});
    final isLoadingCustomers = useState(false);
    final showCustomerDropdown = useState(false);

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
        debugPrint('Error fetching stores: $e');
        return {};
      }
    }

    useEffect(() {
      if (accessToken == null) return;
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
          // Ensure Walk-in first and unique
          customerList.value = {'Walk-in Customer': '', ...customers};
        } else {
          customerList.value = {'Walk-in Customer': ''};
        }
      } catch (e) {
        debugPrint('Error fetching customers: $e');
        customerList.value = {'Walk-in Customer': ''};
      } finally {
        // Always reset selection to Walk-in after fetch
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
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          "Credit Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Return No and Date Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    "Return No.",
                    returnNumber.value,
                    onTap: () {
                      returnNumber.value = _generateReturnNumber();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    "Date",
                    dateFormat.format(selectedDate.value),
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
            const SizedBox(height: 24),

            // Store Dropdown
            _buildStoreDropdown(
              selectedStoreName: selectedStoreName,
              storeList: storeList,
              isLoading: isLoadingCustomers.value,
              onStoreSelected: (name) async {
                selectedStoreName.value = name;
                selectedStoreId.value =
                    name != null ? storeList.value[name] : null;

                // Reset customer fields and fetch
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
                  .map((name) =>
                      DropdownMenuItem<String>(value: name, child: Text(name)))
                  .toList(),
              onChanged: isLoadingCustomers.value
                  ? null
                  : (name) {
                      if (name == null) return;
                      selectedCustomerName.value = name;
                      // Mirror to the text controller if needed for display/printing
                      if (name != 'Walk-in Customer') {
                        customerNameController.text = name;
                      } else {
                        customerNameController.clear();
                      }
                    },
              menuMaxHeight: 400,
              decoration: InputDecoration(
                labelText: "Customer",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                            child: CircularProgressIndicator(strokeWidth: 2)),
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

            // Invoice Details Row
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
                    ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        invoiceDateController.text =
                            DateFormat('dd/MM/yyyy').format(picked);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    "Inv No.",
                    controller: invoiceNumberController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selected Items List
            if (selectedItems.isNotEmpty) ...[
              const Text(
                "Selected Items:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...selectedItems.map((item) => _buildItemCard(item)),
              const SizedBox(height: 16),
            ],

            // Add Items Button
            _buildAddItemsButton(context, selectedStoreId.value),
            const SizedBox(height: 24),

            // Total Amount
            Row(
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "₹",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textPrimaryColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: textLightColor,
                  ),
                ),
                Text(
                  "₹${calculateTotal().toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(saveCreditNote),
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
        const Text("Store",
            style: TextStyle(color: textSecondaryColor, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedStoreName.value,
          hint: const Text("Select Store (Optional)"),
          isExpanded: true,
          items: storeList.value.keys
              .map((name) =>
                  DropdownMenuItem<String>(value: name, child: Text(name)))
              .toList(),
          onChanged: isLoading ? null : onStoreSelected,
          menuMaxHeight: 400,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : const Icon(Icons.store_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDropdown({
    required ValueNotifier<String?> selectedCustomer,
    required ValueNotifier<Map<String, String>> customerList,
    required bool isLoading,
    required TextEditingController customerNameController,
    required Function(String?) onCustomerSelected,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCustomer.value ?? 'Walk-in Customer',
                items: [
                  const DropdownMenuItem(
                    value: "Walk-in Customer",
                    child: Text("Walk-in Customer"),
                  ),
                  ...customerList.value.keys
                      .where((key) => key != 'Walk-in Customer')
                      .map((customer) => DropdownMenuItem(
                            value: customer,
                            child: Text(customer),
                          ))
                ],
                onChanged: isLoading
                    ? null
                    : (value) {
                        onCustomerSelected(value);
                        if (value != null && value != 'Walk-in Customer') {
                          customerNameController.text = value;
                        } else {
                          customerNameController.clear();
                        }
                      },
                decoration: InputDecoration(
                  labelText: "Customer",
                  border: const OutlineInputBorder(),
                  suffixIcon:
                      isLoading ? const CircularProgressIndicator() : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isLoading) const LinearProgressIndicator(),
      ],
    );
  }

  Widget _buildItemCard(CreditNoteItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.item.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹${item.subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text("Qty: ${item.quantity} ${item.unit}"),
            Text("Rate: ₹${item.rate.toStringAsFixed(2)} per ${item.unit}"),
            if (item.taxRate > 0)
              Text("Tax: ${item.taxRate}% (${item.taxType})"),
          ],
        ),
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
            color: textSecondaryColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: textLightColor),
              borderRadius: BorderRadius.circular(8),
              color: cardColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(color: textPrimaryColor),
                ),
                const Icon(Icons.arrow_drop_down, color: textSecondaryColor),
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
                color: textSecondaryColor,
                fontSize: 14,
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
        InkWell(
          onTap: onTap,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: onTap != null,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddItemsButton(BuildContext context, String? selectedStore) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: textLightColor),
        borderRadius: BorderRadius.circular(8),
        color: cardColor,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCreditNoteItemsPage(
                storeId: selectedStore,
              ),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: accentColor),
            SizedBox(width: 8),
            Text(
              "Add Items",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Text(
              "(Optional)",
              style: TextStyle(
                color: textSecondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(VoidCallback onSave) {
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
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Save & New",
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

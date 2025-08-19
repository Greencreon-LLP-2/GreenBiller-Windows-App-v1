import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/model/credit_note/credit_note_model.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/sales/view/pages/credit_note.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddCreditNoteItemsPage extends HookConsumerWidget {
  final String? storeId;
  AddCreditNoteItemsPage({
    super.key,
    required this.storeId,
  });

  // Formatter for currency
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  Widget _buildInputField(
    String label, {
    bool isRequired = false,
    Widget? suffix,
    TextEditingController? controller,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
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
          onChanged: onChanged,
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
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 14,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final searchController = useTextEditingController();
    final quantityController = useTextEditingController(text: '1');
    final rateController = useTextEditingController();
    final selectedItem = useState<Item?>(null);
    final selectedUnit = useState<String>('');
    final selectedTaxType = useState<String>('Without Tax');
    final selectedTaxRate = useState<double>(0);
    final itemsList = useState<List<Item>>([]);
    final filteredItems = useState<List<Item>>([]);
    final isLoading = useState<bool>(false);

    useEffect(() {
      if (accessToken != null && storeId != null) {
        isLoading.value = true;
        ViewAllItemsController(accessToken: accessToken)
            .getAllItems(storeId)
            .then((result) {
          itemsList.value = result.data;
          filteredItems.value = result.data;
          isLoading.value = false;
        }).catchError((e) {
          isLoading.value = false;
          _showErrorSnackBar(context, 'Failed to fetch items: $e');
        });
      }
      return null;
    }, [accessToken, storeId]);

    void filterItems(String query) {
      if (query.isEmpty) {
        filteredItems.value = itemsList.value;
      } else {
        filteredItems.value = itemsList.value
            .where((item) =>
                item.itemName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }

    void selectItem(Item item) {
      selectedItem.value = item;
      selectedUnit.value = item.unit.isNotEmpty ? item.unit : 'Piece';
      rateController.text = item.salesPrice.isNotEmpty
          ? double.parse(item.salesPrice).toStringAsFixed(2)
          : '0.00';
      searchController.text = item.itemName;
      filteredItems.value = itemsList.value;
    }

    void saveItem() {
      if (selectedItem.value == null) {
        _showErrorSnackBar(context, 'Please select an item.');
        return;
      }
      if (quantityController.text.isEmpty) {
        _showErrorSnackBar(context, 'Please enter a quantity.');
        return;
      }

      final quantity = int.tryParse(quantityController.text) ?? 1;
      final rate = double.tryParse(rateController.text) ?? 0;

      final creditNoteItem = CreditNoteItem(
        item: selectedItem.value!,
        rate: rate,
        quantity: quantity,
        unit: selectedUnit.value,
        taxRate: selectedTaxRate.value,
        taxType: selectedTaxType.value,
      );

      ref
          .read(selectedItemsProvider.notifier)
          .update((state) => [...state, creditNoteItem]);
      context.pop();
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
              onPressed: () => context.pop(),
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
              _buildInputField(
                'Search Items',
                controller: searchController,
                onChanged: filterItems,
                suffix: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                        onPressed: () {
                          searchController.clear();
                          filterItems('');
                        },
                      )
                    : const Icon(Icons.search, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              if (isLoading.value)
                const Center(
                  child: CircularProgressIndicator(color: accentColor),
                )
              else if (searchController.text.isNotEmpty &&
                  filteredItems.value.isNotEmpty)
                Container(
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
                    itemCount: filteredItems.value.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems.value[index];
                      return ListTile(
                        title: Text(
                          item.itemName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        subtitle: Text(
                          'Price: ${currencyFormatter.format(double.tryParse(item.salesPrice) ?? 0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        onTap: () => selectItem(item),
                      );
                    },
                  ),
                )
              else if (searchController.text.isNotEmpty &&
                  filteredItems.value.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No items found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              if (selectedItem.value != null) ...[
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
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'Quantity',
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        'Unit',
                        selectedUnit.value,
                        [
                          DropdownMenuItem(
                            value: selectedItem.value?.unit.isNotEmpty == true
                                ? selectedItem.value!.unit
                                : 'Piece',
                            child: Text(
                              selectedItem.value?.unit.isNotEmpty == true
                                  ? selectedItem.value!.unit
                                  : 'Piece',
                            ),
                          ),
                        ],
                        (value) {
                          if (value != null) {
                            selectedUnit.value = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        'Rate (Price/Unit)',
                        controller: rateController,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        'Tax',
                        selectedTaxType.value,
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
                            selectedTaxType.value = value;
                            selectedTaxRate.value = value == 'GST'
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.pop(),
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
                    child: GestureDetector(
                      onTap: selectedItem.value != null ? saveItem : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedItem.value != null
                              ? accentColor
                              : accentColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: selectedItem.value != null
                                  ? accentColor
                                  : accentColor.withOpacity(0.5)),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

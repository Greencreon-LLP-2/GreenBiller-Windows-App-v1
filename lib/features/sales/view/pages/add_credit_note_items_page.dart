import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/model/credit_note/credit_note_model.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/sales/view/pages/credit_note.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddCreditNoteItemsPage extends HookConsumerWidget {
  final String? storeId;
  const AddCreditNoteItemsPage({
    super.key,
    required this.storeId,
  });

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

    useEffect(() {
      print(storeId);
      if (accessToken != null) {
        ViewAllItemsController(accessToken: accessToken)
            .getAllItems(storeId)
            .then((result) {
          itemsList.value = result.data;
          filteredItems.value = itemsList.value;
        });
      }
      return null;
    }, [accessToken]);

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
    }

    void saveItem() {
      if (selectedItem.value == null) return;
      if (quantityController.text.isEmpty) return;

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
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Add Items to Credit Note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Search
            const Text(
              "Item Name",
              style: TextStyle(color: Colors.blue),
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search items...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          filterItems('');
                        },
                      )
                    : null,
              ),
              onChanged: filterItems,
            ),

            // Search Results
            if (searchController.text.isNotEmpty &&
                filteredItems.value.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.value.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems.value[index];
                    return ListTile(
                      title: Text(item.itemName),
                      subtitle: Text("Price: ₹${item.salesPrice}"),
                      onTap: () => selectItem(item),
                    );
                  },
                ),
              ),

            // Item Details (shown when item is selected)
            if (selectedItem.value != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Quantity"),
                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Unit"),
                        DropdownButtonFormField<String>(
                          value: selectedUnit.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: selectedItem.value?.unit.isNotEmpty == true
                                  ? selectedItem.value!.unit
                                  : 'Piece',
                              child: Text(
                                  selectedItem.value?.unit.isNotEmpty == true
                                      ? selectedItem.value!.unit
                                      : 'Piece'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              selectedUnit.value = value;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Rate (Price/Unit)"),
                        TextField(
                          controller: rateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tax"),
                        DropdownButtonFormField<String>(
                          value: selectedTaxType.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Without Tax",
                              child: Text("Without Tax"),
                            ),
                            DropdownMenuItem(
                              value: "GST",
                              child: Text("GST"),
                            ),
                            DropdownMenuItem(
                              value: "VAT",
                              child: Text("VAT"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              selectedTaxType.value = value;
                              selectedTaxRate.value = value == "GST"
                                  ? 18.0
                                  : value == "VAT"
                                      ? 12.5
                                      : 0.0;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
                child: const Text(
                  "Discard",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: selectedItem.value != null ? saveItem : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

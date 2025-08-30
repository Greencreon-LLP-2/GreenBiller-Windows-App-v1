import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart'; // Assuming accentColor is defined here

class SkuEditDialog extends HookWidget {
  final List<String> initialSkus;
  final TextEditingController? batchNoController;
  final TextEditingController? quantityController;
  final TextEditingController?
  salesPriceController; // Added for salesPrice updates
  final Map<int, Map<String, String>> rowFields;
  final int index;
  final VoidCallback onSave;

  const SkuEditDialog({
    super.key,
    required this.initialSkus,
    required this.batchNoController,
    required this.quantityController,
    required this.salesPriceController, // Added parameter
    required this.rowFields,
    required this.index,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final skuList = useState<List<String>>(initialSkus);
    final skuInputController = useTextEditingController();
    final focusNode = useFocusNode();

    // Request focus on TextField when dialog opens
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
      return null;
    }, []);

    // Helper function to update rowFields and controllers
    void updateRowFields() {
      final quantity = skuList.value.length.toDouble();
      final price = double.tryParse(rowFields[index]?['price'] ?? '0') ?? 0;
      final salesPrice = quantity * price;
      final taxRate = double.tryParse(rowFields[index]?['taxRate'] ?? '0') ?? 0;
      final taxAmount = salesPrice * taxRate / 100;
      final discountPercent =
          double.tryParse(rowFields[index]?['discountPercent'] ?? '0') ?? 0;
      final discountAmount = (salesPrice * discountPercent) / 100;

      batchNoController?.text = skuList.value.join(',');
      quantityController?.text = quantity.toString();
      salesPriceController?.text = salesPrice.toStringAsFixed(2);
      rowFields[index] = {
        ...?rowFields[index],
        'batchNo': skuList.value.join(','),
        'quantity': quantity.toString(),
        'salesPrice': salesPrice.toStringAsFixed(2),
        'taxAmount': taxAmount.toStringAsFixed(2),
        'discountAmount': discountAmount.toStringAsFixed(2),
      };
    }

    // Handle editing an existing SKU
    void editSku(int skuIndex) {
      final currentSku = skuList.value[skuIndex];
      skuInputController.text = currentSku;
      focusNode.requestFocus();
      skuList.value = [...skuList.value..removeAt(skuIndex)];
      updateRowFields();
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 1200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF8FFF9)],
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor, accentColor],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit SKUs',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Add or manage SKU numbers',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          padding: const EdgeInsets.all(6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: skuInputController,
                              focusNode: focusNode,
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                labelText: 'SKU',
                                labelStyle: TextStyle(fontSize: 12),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              maxLength: 20,
                              onChanged: (value) {
                                if (value.endsWith('\n')) {
                                  final newSku = value.trim().replaceAll(
                                    '\n',
                                    '',
                                  );
                                  if (newSku.isNotEmpty) {
                                    skuList.value = [...skuList.value, newSku];
                                    skuInputController.clear();
                                    updateRowFields();
                                    focusNode.requestFocus();
                                  }
                                }
                              },
                              onSubmitted: (value) {
                                final newSku = value.trim();
                                if (newSku.isNotEmpty) {
                                  skuList.value = [...skuList.value, newSku];
                                  skuInputController.clear();
                                  updateRowFields();
                                  focusNode.requestFocus();
                                }
                              },
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: skuList.value.length,
                                itemBuilder: (context, skuIndex) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    minVerticalPadding: 0,
                                    dense: true,
                                    title: Text(
                                      skuList.value[skuIndex],
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 16,
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          constraints: const BoxConstraints(),
                                          onPressed: () => editSku(skuIndex),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 16,
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            skuList.value = [
                                              ...skuList.value
                                                ..removeAt(skuIndex),
                                            ];
                                            updateRowFields();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FFF9),
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 16),
                        label: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          updateRowFields();
                          onSave();
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.save_rounded, size: 16),
                        label: const Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

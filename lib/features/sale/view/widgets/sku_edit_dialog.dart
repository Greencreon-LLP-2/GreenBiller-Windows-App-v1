import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';

class SkuEditDialog extends StatelessWidget {
  final TempPurchaseItem item;
  final VoidCallback onSave;

  SkuEditDialog({super.key, required this.item, required this.onSave});

  final TextEditingController serialController = TextEditingController();
  final RxList<String> serials = RxList<String>();

  @override
  Widget build(BuildContext context) {
    serials.value = item.serialNumbers
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --------- HEADER ----------
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Icon(Icons.qr_code, color: Colors.green.shade700),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Serial Number Manager',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --------- INPUT ----------
              TextField(
                controller: serialController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Scan or enter serial number',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.green.shade600,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      final value = serialController.text.trim();
                      if (value.isNotEmpty && !serials.contains(value)) {
                        serials.add(value);
                        serialController.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty && !serials.contains(value.trim())) {
                    serials.add(value.trim());
                    serialController.clear();
                  }
                },
              ),
              const SizedBox(height: 16),

              // --------- ITEM DETAILS ----------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.itemName}  •  ₹${item.pricePerUnit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --------- SERIAL LIST ----------
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() {
                  if (serials.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No serial numbers added yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: serials.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.grey.shade300, height: 1),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text(
                          serials[index],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () => serials.removeAt(index),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),

              // --------- FOOTER ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${serials.length} items',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          item.purchaseQty = serials.length.toString();
                          item.batchNo = serials.join(',');
                          item.serialNumbers = serials.join(',');
                          double price =
                              double.tryParse(item.pricePerUnit) ?? 0;
                          item.totalCost = (serials.length * price)
                              .toStringAsFixed(2);
                          onSave();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                    ],
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

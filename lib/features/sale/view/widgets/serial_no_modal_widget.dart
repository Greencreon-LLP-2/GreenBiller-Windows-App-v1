import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:greenbiller/features/purchase/controller/new_purchase_controller.dart';

class SerialNumberModal extends StatelessWidget {
  final PurchaseItem item;
  final VoidCallback onSave;

  SerialNumberModal({required this.item, required this.onSave});

  final TextEditingController serialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.qr_code, color: Colors.green.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Add Serial Numbers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: serialController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Scan or Enter Serial Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.green.shade600,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty && !item.serials.contains(value)) {
                  item.serials.add(value);
                  serialController.clear();
                }
              },
            ),
            const SizedBox(height: 16),
            Obx(
              () => Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: item.serials.isEmpty
                        ? [const Text('No serial numbers added')]
                        : item.serials.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String serial = entry.value;
                            return ListTile(
                              title: Text(serial),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  item.serials.removeAt(idx);
                                },
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onSave();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

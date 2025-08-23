import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/sales/view/widgets/textfield_widget.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/model/store_model/store_model.dart'
    as store_model;
import 'package:green_biller/features/store/services/add_warehouse_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddWarehouseDialog extends HookConsumerWidget {
  final String? accessToken;
  final String? userId;
  final VoidCallback? onSuccess;
  final BuildContext parentContext; // Add parent context for ScaffoldMessenger

  const AddWarehouseDialog({
    super.key,
    required this.accessToken,
    required this.userId,
    this.onSuccess,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouseNameController = useTextEditingController();
    final warehouseAddressController = useTextEditingController();
    final warehouseTypeController = useTextEditingController();
    final warehouseEmailController = useTextEditingController();
    final warehousePhoneController = useTextEditingController();

    final selectedStore = useState<store_model.StoreData?>(null);
    final storesAsync = ref.watch(storesProvider);
    final token = accessToken;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.warehouse,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Add New Warehouse',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Store dropdown
              const Text(
                'Select Store',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              storesAsync.when(
                loading: () => const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(
                  'Failed to load stores: $e',
                  style: const TextStyle(color: Colors.red),
                ),
                data: (storeModel) {
                  final stores = storeModel.data ?? [];
                  if (stores.isEmpty) {
                    return const Text(
                      'No stores available',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return DropdownButtonFormField<store_model.StoreData>(
                    value: selectedStore.value,
                    items: stores
                        .map(
                          (s) => DropdownMenuItem<store_model.StoreData>(
                            value: s,
                            child: Text(s.storeName ?? 'Unnamed Store'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => selectedStore.value = v,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    hint: const Text('Choose store'),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextfieldWidget(
                controller: warehouseNameController,
                label: 'Warehouse Name',
                hint: 'Enter warehouse name',
                icon: Icons.warehouse_outlined,
              ),
              const SizedBox(height: 16),
              TextfieldWidget(
                controller: warehouseAddressController,
                label: 'Address',
                hint: 'Enter Warehouse Location',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 24),
              TextfieldWidget(
                label: 'Email',
                hint: 'Enter Warehouse Email',
                icon: Icons.web,
                controller: warehouseEmailController,
              ),
              const SizedBox(height: 16),
              TextfieldWidget(
                label: 'Phone',
                hint: 'Enter WareHouse Phone Number',
                icon: Icons.call,
                controller: warehousePhoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextfieldWidget(
                label: 'WareHouse Type',
                hint: 'Enter WareHouse Type',
                icon: Icons.category_outlined,
                controller: warehouseTypeController,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: textSecondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      // Validation
                      if (selectedStore.value == null) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a store'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (warehouseNameController.text.isEmpty) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text('Warehouse name is required'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (token == null || token.isEmpty) {
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                            content: Text('Missing access token'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        final response = await addWarehouseService(
                          warehouseNameController.text,
                          warehouseAddressController.text,
                          warehouseTypeController.text,
                          warehouseEmailController.text, // Fixed: Use email controller
                          warehousePhoneController.text,
                          token,
                          selectedStore.value!.id.toString(),
                          userId,
                        );
                        if (response == 'Warehouse created successfully') {
                          Navigator.pop(context); // Pop dialog first
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            const SnackBar(
                              content: Text('Warehouse added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          onSuccess?.call();
                        } else {
                          ScaffoldMessenger.of(parentContext).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Failed to add warehouse: $response'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        log('Add warehouse error: $e');
                        ScaffoldMessenger.of(parentContext).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add Warehouse'),
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
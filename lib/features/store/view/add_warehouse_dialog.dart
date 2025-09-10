import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/core/gloabl_widgets/text_fields/text_field_widget.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';

class AddWarehouseDialog extends GetView<StoreController> {
  final VoidCallback? onSuccess;
  const AddWarehouseDialog({super.key, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: controller.warehouseFormKey,
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
                const Text(
                  'Select Store',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppDropdown(
                        label: "Store",
                        placeHolderText: 'Select Store',
                        selectedValue:
                            controller.storeDropdownController.selectedStoreId,
                        options: controller.storeDropdownController.storeMap,
                        isLoading:
                            controller.storeDropdownController.isLoadingStores,
                        onChanged: (val) async {
                          if (val != null) {}
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  controller: controller.warehouseNameController,
                  label: 'Warehouse Name',
                  hint: 'Enter warehouse name',
                  icon: Icons.warehouse_outlined,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  controller: controller.warehouseAddressController,
                  label: 'Address',
                  hint: 'Enter Warehouse Location',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 24),
                TextfieldWidget(
                  label: 'Email',
                  hint: 'Enter Warehouse Email',
                  icon: Icons.web,
                  controller: controller.warehouseEmailController,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  label: 'Phone',
                  hint: 'Enter Warehouse Phone Number',
                  icon: Icons.call,
                  controller: controller.warehousePhoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  label: 'Warehouse Type',
                  hint: 'Enter Warehouse Type',
                  icon: Icons.category_outlined,
                  controller: controller.warehouseTypeController,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: textSecondaryColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => controller.addWarehouse(),
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
      ),
    );
  }
}

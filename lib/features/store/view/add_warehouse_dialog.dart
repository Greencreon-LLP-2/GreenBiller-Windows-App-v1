import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/text_fields/text_field_widget.dart';

class AddWarehouseDialog extends GetView<AddWarehouseController> {

  final VoidCallback? onSuccess;
  final BuildContext parentContext;

  const AddWarehouseDialog({
    super.key,
  
    this.onSuccess,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    child: const Icon(Icons.warehouse, color: Colors.blue, size: 24),
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
              // Obx(() => controller.isLoading.value
              //     ? const SizedBox(
              //         height: 48,
              //         child: Center(child: CircularProgressIndicator()),
              //       )
              //     : controller.stores.isEmpty
              //         ? const Text(
              //             'No stores available',
              //             style: TextStyle(color: Colors.red),
              //           )
              //         : DropdownButtonFormField<StoreData>(
              //             value: controller.selectedStore.value,
              //             items: controller.stores
              //                 .map((s) => DropdownMenuItem<StoreData>(
              //                       value: s,
              //                       child: Text(s.storeName ?? 'Unnamed Store'),
              //                     ))
              //                 .toList(),
              //             onChanged: (v) => controller.selectedStore.value = v,
              //             decoration: const InputDecoration(
              //               border: OutlineInputBorder(),
              //               isDense: true,
              //               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              //             ),
              //             hint: const Text('Choose store'),
              //           )),
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
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: textSecondaryColor)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => controller.addWarehouse(parentContext, onSuccess),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

class AddWarehouseController extends GetxController {
  final warehouseNameController = TextEditingController();
  final warehouseAddressController = TextEditingController();
  final warehouseTypeController = TextEditingController();
  final warehouseEmailController = TextEditingController();
  final warehousePhoneController = TextEditingController();
  // final selectedStore = Rxn<StoreData>();
  // final stores = <StoreData>[].obs;
  final isLoading = false.obs;
  final String? accessToken;
  final String? userId;

  AddWarehouseController({this.accessToken, this.userId});

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  void fetchStores() async {
    // isLoading.value = true;
    // try {
    //   final storeController = Get.find<ViewStoreController>();
    //   final storeModel = await storeController.fetchStores();
    //   stores.assignAll(storeModel.data ?? []);
    // } catch (e) {
    //   Get.snackbar('Error', 'Failed to load stores: $e', backgroundColor: Colors.red, colorText: Colors.white);
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void addWarehouse(BuildContext parentContext, VoidCallback? onSuccess) async {
    // if (selectedStore.value == null) {
    //   ScaffoldMessenger.of(parentContext).showSnackBar(
    //     const SnackBar(content: Text('Please select a store'), backgroundColor: Colors.red),
    //   );
    //   return;
    // }
    if (warehouseNameController.text.isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Warehouse name is required'), backgroundColor: Colors.red),
      );
      return;
    }
    if (accessToken == null || accessToken!.isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Missing access token'), backgroundColor: Colors.red),
      );
      return;
    }

    // try {
    //   final response = await addWarehouseService(
    //     warehouseNameController.text,
    //     warehouseAddressController.text,
    //     warehouseTypeController.text,
    //     warehouseEmailController.text,
    //     warehousePhoneController.text,
    //     accessToken!,
    //     selectedStore.value!.id.toString(),
    //     userId,
    //   );
    //   if (response == 'Warehouse created successfully') {
    //     Get.back();
    //     ScaffoldMessenger.of(parentContext).showSnackBar(
    //       const SnackBar(content: Text('Warehouse added successfully'), backgroundColor: Colors.green),
    //     );
    //     onSuccess?.call();
    //   } else {
    //     ScaffoldMessenger.of(parentContext).showSnackBar(
    //       SnackBar(content: Text('Failed to add warehouse: $response'), backgroundColor: Colors.red),
    //     );
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(parentContext).showSnackBar(
    //     SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
    //   );
    // }
  }

  @override
  void onClose() {
    warehouseNameController.dispose();
    warehouseAddressController.dispose();
    warehouseTypeController.dispose();
    warehouseEmailController.dispose();
    warehousePhoneController.dispose();
    super.onClose();
  }
}
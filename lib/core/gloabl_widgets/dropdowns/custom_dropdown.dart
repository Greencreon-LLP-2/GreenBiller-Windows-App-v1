import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/app_handler/store_drtopdown_controller.dart';
import 'package:greenbiller/core/colors.dart';

import 'package:greenbiller/features/items/controller/add_items_controller.dart';

class StoreDropdown extends GetView<StoreDropdownController> {
  final ValueChanged<int?>? onStoreChanged;

  const StoreDropdown({super.key, this.onStoreChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textLightColor, width: 1),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedStoreName,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  )
                : const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(color: textPrimaryColor, fontSize: 14),
            items: [
              const DropdownMenuItem(
                value: 'Select Store',
                child: Text('Select Store'),
              ),
              ...controller.storeMap.entries.map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              ),
            ],
            onChanged: (newValue) {
              if (newValue == null || newValue == 'Select Store') {
                controller.selectedStoreId.value = null;
                onStoreChanged?.call(null);
              } else {
                final id = controller.storeMap[newValue];
                controller.selectedStoreId.value = id;
                onStoreChanged?.call(id);
              }
            },
          ),
        ),
      ),
    );
  }
}

class StoreDropdownUltimate extends StatelessWidget {
  final AddItemController controller;

  const StoreDropdownUltimate({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DropdownButtonFormField<String>(
          value: controller.selectedStore.value,
          decoration: InputDecoration(
            labelText: 'Select Store',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.store,
                color: accentColor.withOpacity(0.85),
                size: 22,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select a Store',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...controller.storeDropdownController.storeMap.entries.map(
              (entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            controller.selectedStore.value = value;
            controller.selectedStoreId.value = value != null
                ? controller.storeDropdownController.storeMap[value]
                : null;
            controller.selectedCategory.value = null;
            controller.selectedBrand.value = null;

            if (controller.selectedStoreId.value != null) {
              controller.loadCategories();
              controller.loadBrands();
            }
          },
          icon: controller.storeDropdownController.isLoading.value
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                )
              : Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 26,
                  color: accentColor.withOpacity(0.85),
                ),
          iconEnabledColor: accentColor.withOpacity(0.7),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          isExpanded: true,
          menuMaxHeight: 300,
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final AddItemController controller;
  final ValueChanged<String?>? onChanged;

  const CategoryDropdown({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: controller.selectedStoreId.value == null
            ? Colors.grey.shade100
            : backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textLightColor, width: 1),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedCategory.value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            icon: controller.isLoadingCategories.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  )
                : const Icon(Icons.keyboard_arrow_down),
            style: TextStyle(
              color: controller.selectedStoreId.value == null
                  ? Colors.grey.shade400
                  : textPrimaryColor,
              fontSize: 14,
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Select Category'),
              ),
              ...controller.categoryMap.entries.map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              ),
            ],
            onChanged: controller.selectedStoreId.value == null
                ? null
                : (newValue) {
                    controller.selectedCategory.value = newValue;
                    onChanged?.call(newValue);
                  },
          ),
        ),
      ),
    );
  }
}

class BrandDropdown extends StatelessWidget {
  final AddItemController controller;
  final ValueChanged<String?>? onChanged;

  const BrandDropdown({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: controller.selectedStoreId.value == null
            ? Colors.grey.shade100
            : backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textLightColor, width: 1),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedBrand.value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            icon: controller.isLoadingBrands.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  )
                : const Icon(Icons.keyboard_arrow_down),
            style: TextStyle(
              color: controller.selectedStoreId.value == null
                  ? Colors.grey.shade400
                  : textPrimaryColor,
              fontSize: 14,
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Select Brand')),
              ...controller.brandMap.entries.map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              ),
            ],
            onChanged: controller.selectedStoreId.value == null
                ? null
                : (newValue) {
                    controller.selectedBrand.value = newValue;
                    onChanged?.call(newValue);
                  },
          ),
        ),
      ),
    );
  }
}

class UnitDropdown extends StatelessWidget {
  final AddItemController controller;
  final ValueChanged<String?>? onChanged;

  const UnitDropdown({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textLightColor, width: 1),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.unitController.text.isEmpty
                ? null
                : controller.unitController.text,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            icon: controller.isLoadingUnits.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  )
                : const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(color: textPrimaryColor, fontSize: 14),
            items: [
              const DropdownMenuItem(value: null, child: Text('Select Unit')),
              ...controller.unitMap.entries.map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              ),
            ],
            onChanged: (newValue) {
              controller.unitController.text = newValue ?? '';
              controller.subUnitController.clear();
              onChanged?.call(newValue);
            },
          ),
        ),
      ),
    );
  }
}

class WarehouseDropdown extends StatelessWidget {
  final AddItemController controller;
  final ValueChanged<String?>? onChanged;

  const WarehouseDropdown({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textLightColor, width: 1),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedWarehouse.value,
            isExpanded: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            icon: controller.isLoadingWarehouses.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  )
                : const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(color: textPrimaryColor, fontSize: 14),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Select Warehouse'),
              ),
              ...controller.warehouseMap.entries.map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.key),
                ),
              ),
            ],
            onChanged: (newValue) {
              controller.selectedWarehouse.value = newValue;
              onChanged?.call(newValue);
            },
          ),
        ),
      ),
    );
  }
}

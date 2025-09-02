import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/parties/controller/store_drtopdown_controller.dart';

class StoreDropdown extends GetView<StoreDropdownController> {
  final ValueChanged<int?>? onStoreChanged;

  const StoreDropdown({super.key, this.onStoreChanged});

  @override
  Widget build(BuildContext context) {
    print(controller.storeMap.values);
    return Container(
      width: 200,
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

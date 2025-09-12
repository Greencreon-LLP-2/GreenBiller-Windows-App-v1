import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/items/controller/add_items_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';

class UnitDropdownWithValue extends StatelessWidget {
  final AddItemController controller;

  const UnitDropdownWithValue({super.key, required this.controller});

  void _openDropDown({
    required BuildContext context,
    required String title,
    required List<UnitItem> items,
    required Function(UnitItem) onSelected,
  }) {
    final data = items
        .map((unit) => SelectedListItem<UnitItem>(data: unit))
        .toList();

    // NOTE: pass `dropDown:` as named parameter
    DropDownState<UnitItem>(
      dropDown: DropDown<UnitItem>(
        data: data,
        onSelected: (List<SelectedListItem<UnitItem>> selectedList) {
          if (selectedList.isNotEmpty) {
            final selected = selectedList.first.data;
            onSelected(selected);
          }
        },
        // UI / Behaviour options
        isSearchVisible: true,
        enableMultipleSelection: false,
        bottomSheetTitle: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        submitButtonChild: const Text("Select"),
        searchHintText: "Search here...",
        listViewPadding: const EdgeInsets.symmetric(vertical: 8),
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedUnit = controller.selectedUnit.value;
      final selectedSubUnit = controller.selectedSubUnit.value;

      return Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primary Unit Dropdown (Searchable)
              InkWell(
                onTap: () => _openDropDown(
                  context: context,
                  title: "Select Unit",
                  items: controller.unitList,
                  onSelected: (unit) {
                    controller.selectedUnit.value = unit;
                    controller.unitValueController.text = unit.unitValue ?? "";

                    // Reset subunit state
                    controller.selectedSubUnit.value = null;
                    controller.subUnitController.clear();
                    controller.subUnitValueText.value = "";
                    controller.isShowSubUnit.value = false;
                  },
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedUnit?.unitName ?? "Select Unit",
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedUnit == null
                              ? Colors.grey.shade500
                              : Colors.black,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (selectedUnit != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Enable Subunit Conversion",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      activeColor: Colors.green,
                      value: controller.isShowSubUnit.value,
                      onChanged: (val) => controller.isShowSubUnit.value = val,
                    ),
                  ],
                ),

              if (controller.isShowSubUnit.value && selectedUnit != null) ...[
                const SizedBox(height: 16),

                // Subunit Dropdown (Searchable)
                InkWell(
                  onTap: () => _openDropDown(
                    context: context,
                    title: "Select Subunit",
                    items: controller.unitList,
                    onSelected: (unit) =>
                        controller.selectedSubUnit.value = unit,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedSubUnit?.unitName ?? "Select Subunit",
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedSubUnit == null
                                ? Colors.grey.shade500
                                : Colors.black,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Conversion Input
                TextFormField(
                  controller: controller.subUnitController,
                  enabled: selectedSubUnit != null,
                  decoration: InputDecoration(
                    labelText: "Conversion Value",
                    hintText: "e.g. 1000 (grams in 1 kg)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => controller.subUnitValueText.value =
                      controller.subUnitController.text,
                ),

                const SizedBox(height: 16),

                if (selectedUnit != null && selectedSubUnit != null)
                  Card(
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Obx(() {
                        final value = controller.subUnitValueText.value;
                        return Text(
                          "1 ${selectedUnit.unitName} = ${value.isEmpty ? "___" : value} ${selectedSubUnit.unitName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

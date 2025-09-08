import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/items/controller/add_items_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';

class UnitDropdownWithValue extends StatelessWidget {
  final AddItemController controller;

  const UnitDropdownWithValue({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedUnit = controller.selectedUnit.value;
      final selectedSubUnit = controller.selectedSubUnit.value;

      return Card(
        elevation: 2,
        color: Colors.white,
        // shadowColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Primary Unit Dropdown
              DropdownButtonFormField<UnitItem>(
                value: selectedUnit,
                decoration: InputDecoration(
                  labelText: "Unit",
                  hintText: "Select main unit",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                isExpanded: true,
                items: [
                  DropdownMenuItem<UnitItem>(
                    value: null,
                    child: Text("Select Unit"),
                  ),
                  ...controller.unitList.map((unit) {
                    return DropdownMenuItem<UnitItem>(
                      value: unit,
                      child: Text(unit.unitName ?? "Unnamed"),
                    );
                  }),
                ],
                onChanged: (unit) {
                  controller.selectedUnit.value = unit;
                  controller.unitValueController.text = unit?.unitValue ?? "";

                  // Reset subunit stuff when main unit changes
                  controller.selectedSubUnit.value = null;
                  controller.subUnitController.clear();
                  controller.subUnitValueText.value = "";
                  controller.isShowSubUnit.value = false;
                },
              ),

              const SizedBox(height: 16),

              // 🔹 Toggle Subunit (only if unit selected)
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
                      onChanged: (val) {
                        controller.isShowSubUnit.value = val;
                      },
                    ),
                  ],
                ),

              if (controller.isShowSubUnit.value && selectedUnit != null) ...[
                const SizedBox(height: 16),

                // 🔹 Subunit Dropdown (disabled until unit selected)
                DropdownButtonFormField<UnitItem>(
                  value: selectedSubUnit,
                  decoration: InputDecoration(
                    labelText: "Subunit",
                    hintText: "Select subunit",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<UnitItem>(
                      value: null,
                      child: Text("Select Subunit"),
                    ),
                    ...controller.unitList.map((unit) {
                      return DropdownMenuItem<UnitItem>(
                        value: unit,
                        child: Text(unit.unitName ?? "Unnamed"),
                      );
                    }),
                  ],
                  onChanged: (unit) {
                    controller.selectedSubUnit.value = unit;
                  },
                ),

                const SizedBox(height: 16),

                // 🔹 Conversion Input (disabled until subunit selected)
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
                  onChanged: (_) {
                    controller.subUnitValueText.value =
                        controller.subUnitController.text;
                  },
                ),

                const SizedBox(height: 16),

                // 🔹 Conversion Preview
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
                          "1 ${selectedUnit.unitName} = "
                          "${value.isEmpty ? "___" : value} ${selectedSubUnit.unitName}",
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

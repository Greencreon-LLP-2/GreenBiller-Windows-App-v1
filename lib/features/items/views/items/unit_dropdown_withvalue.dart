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

      return Row(
        children: [
          // Dropdown for Unit Names
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<UnitItem>(
              value: selectedUnit,
              decoration: InputDecoration(
                labelText: "Units",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
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
                }).toList(),
              ],
              onChanged: (unit) {
                controller.selectedUnit.value = unit;
                controller.unitValueController.text =
                    unit?.unitValue ?? ""; // auto-fill
              },
            ),
          ),

          const SizedBox(width: 12),
          if (controller.isShowSubUnit.value)
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: controller.unitValueController,
                decoration: InputDecoration(
                  labelText: "Value",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
        ],
      );
    });
  }
}

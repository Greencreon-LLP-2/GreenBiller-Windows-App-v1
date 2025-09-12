import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String? placeHolderText;
  final Rxn<int> selectedValue; // holds the selected id
  final RxMap<String, int> options; // name -> id
  final RxBool isLoading;
  final ValueChanged<int?>? onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    this.placeHolderText,
    required this.selectedValue,
    required this.options,
    required this.isLoading,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int? currentValue = selectedValue.value;

      // Reset invalid selection if not in options
      if (currentValue != null && !options.values.contains(currentValue)) {
        currentValue = null;
        selectedValue.value = null;
      }

      late final List<DropdownMenuItem<int>> items;

      if (options.isEmpty) {
        // Show "No data found" when empty
        items = const [
          DropdownMenuItem<int>(
            value: -1, // 👈 unique dummy value
            enabled: false,
            child: Text(
              "No data found",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ];
        currentValue = -1; // 👈 force match so text is visible
      } else {
        items = [
          DropdownMenuItem<int>(
            value: null,
            child: Text(placeHolderText ?? 'Select Store'),
          ),
          ...options.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.value,
              child: Text(entry.key),
            );
          }),
        ];
      }

      return DropdownButtonFormField<int>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        isExpanded: true,
        items: items,
        onChanged: (options.isEmpty || isLoading.value)
            ? null // disable when loading or no data
            : (val) {
                selectedValue.value = val;
                onChanged?.call(val);
              },
        icon: isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.keyboard_arrow_down),
      );
    });
  }
}

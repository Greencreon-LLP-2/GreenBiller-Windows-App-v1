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
      print(
        "🔽 Building $label dropdown -> options: ${options.length}, selected: ${selectedValue.value}",
      );
      return DropdownButtonFormField<int>(
        value: selectedValue.value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        isExpanded: true,
        items: [
          DropdownMenuItem<int>(
            value: null,
            child: Text(placeHolderText ?? 'Select Store'),
          ),
          ...options.entries.map((entry) {
            print("  ➕ Option: ${entry.key} => ${entry.value}");
            return DropdownMenuItem<int>(
              value: entry.value,
              child: Text(entry.key),
            );
          }),
        ],
        onChanged: isLoading.value
            ? null
            : (val) {
                print("🟢 Changed $label -> $val");
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

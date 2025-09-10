import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenbiller/core/colors.dart';

class TextfieldWidget extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData? icon;
  final bool isRequired;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const TextfieldWidget({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.isRequired = false,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        style: const TextStyle(color: textPrimaryColor),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator ??
            (isRequired
                ? (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null
                : null),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: textPrimaryColor) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: textSecondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: accentColor),
          ),
        ),
      ),
    );
  }
}

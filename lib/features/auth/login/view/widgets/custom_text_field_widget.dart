import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';

class CustomTextFieldWidget extends HookWidget {
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final bool passwordVisible;
  final Function()? onToggleVisibility;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String selectedCountryCode; 
   final bool showCountryPicker;
  final String hintText;
  final ValueChanged<String>? onCountryCodeChanged;
  final String? Function(String?)? validator;

  const CustomTextFieldWidget({
    super.key,
    required this.label,
    required this.prefixIcon,
    required this.hintText,
    this.isPassword = false,
    this.passwordVisible = false,
    this.onToggleVisibility,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.readOnly = false,
    this.validator,
    this.showCountryPicker = true,
    this.selectedCountryCode = '+91',
    this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = useState(false);
    final focusNode = useFocusNode();

    // Listen for focus changes
    useEffect(() {
      void onFocusChange() {
        isFocused.value = focusNode.hasFocus;
      }

      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    }, [focusNode]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        // Changed from TextField to TextFormField
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: isPassword && !passwordVisible,
        onChanged: onChanged,
        readOnly: readOnly,
        validator: validator, // Added validator parameter
        decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            color: isFocused.value ? accentColor : textSecondaryColor,
          ),
          prefixIcon: Icon(prefixIcon,
              color: isFocused.value
                  ? accentColor
                  : textSecondaryColor.withOpacity(0.7)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: textSecondaryColor,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}

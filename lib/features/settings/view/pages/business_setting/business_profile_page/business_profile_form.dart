import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_biller/core/constants/colors.dart';

class BusinessProfileForm {
  static Widget buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          onChanged: (_) => onChanged?.call(),
        ),
      ],
    );
  }

  static DecorationImage? imageProvider(
    File? file,
    String? url, {
    BoxFit fit = BoxFit.cover,
  }) {
    if (file != null) return DecorationImage(image: FileImage(file), fit: fit);
    if (url != null) return DecorationImage(image: NetworkImage(url), fit: fit);
    return null;
  }

  static Widget buildDropdown({
    required String? value,
    required String label,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ],
    );
  }

  // Logo Section
  static Widget buildLogoSection({
    required double completionPercent,
    required File? logoImage,
    required String? logoUrl,
    required VoidCallback onEdit,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Business Logo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: completionPercent,
                strokeWidth: 6,
                backgroundColor: const Color(0xFFD1D5DB),
                valueColor: const AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
                image: imageProvider(logoImage, logoUrl, fit: BoxFit.cover),
              ),
              child: (logoImage == null && logoUrl == null)
                  ? const Icon(
                      Icons.camera_alt,
                      size: 32,
                      color: Color(0xFF9CA3AF),
                    )
                  : null,
            ),
            Positioned(
              bottom: 5,
              right: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 12, color: Colors.white),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Signature Section
  static Widget buildSignatureSection({
    required File? signatureImage,
    required String? signatureUrl,
    required VoidCallback onEdit,
  }) {
    return Container(
      width: double.infinity,
      height: 128,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
        image: imageProvider(signatureImage, signatureUrl, fit: BoxFit.contain),
      ),
      child: Stack(
        children: [
          if (signatureImage == null && signatureUrl == null)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload, size: 32, color: Color(0xFF9CA3AF)),
                  SizedBox(height: 4),
                  Text(
                    'Upload Signature',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: const BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                isVisible ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

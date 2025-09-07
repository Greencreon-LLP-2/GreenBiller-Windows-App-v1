import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';

class EditWarehousePage extends StatelessWidget {
  final String warehouseId;
  final String? currentName;
  final String? currentLocation;
  final String? warehouseType;
  final String? warehouseEmail;
  final String? warehousePhone;

  const EditWarehousePage({
    super.key,
    required this.warehouseId,
    this.currentName,
    this.currentLocation,
    this.warehouseType,
    this.warehouseEmail,
    this.warehousePhone,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();

    // Initialize controllers with existing warehouse data
    controller.warehouseNameController.text = currentName ?? '';
    controller.warehouseAddressController.text = currentLocation ?? '';
    controller.warehouseTypeController.text = warehouseType ?? '';
    controller.warehouseEmailController.text = warehouseEmail ?? '';
    controller.warehousePhoneController.text = warehousePhone ?? '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height *
              0.8, // Limit dialog height to 80% of screen
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16), // Reduced padding to save space
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warehouse, color: accentColor, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Edit Warehouse',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Update warehouse details',
                  style: TextStyle(fontSize: 14, color: textSecondaryColor),
                ),
                const SizedBox(height: 12),
                const Divider(color: accentLightColor, thickness: 1.5),
                const SizedBox(height: 16),
                _buildField(
                  'Warehouse Name',
                  controller.warehouseNameController,
                  icon: Icons.warehouse_outlined,
                ),
                const SizedBox(height: 16),
                _buildField(
                  'Warehouse Type',
                  controller.warehouseTypeController,
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 16),
                _buildField(
                  'Address',
                  controller.warehouseAddressController,
                  maxLines: 2,
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),
                _buildField(
                  'Email',
                  controller.warehouseEmailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _buildField(
                  'Phone',
                  controller.warehousePhoneController,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        foregroundColor: accentColor,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => controller.editWarehouse(
                        int.parse(warehouseId),
                        oldName: currentName,
                        oldAddress: currentLocation,
                        oldType: warehouseType,
                        oldEmail: warehouseEmail,
                        oldPhone: warehousePhone,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: accentColor, size: 20)
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: accentLightColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: accentColor, width: 1.5),
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}

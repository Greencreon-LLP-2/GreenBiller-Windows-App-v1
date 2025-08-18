// --- EditWarehouseWidget (updated with custom dialog) ---
import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/services/edit_warehouse_service.dart';
import 'package:green_biller/utils/dialog.dart'
    show DialogField, showCustomEditDialog, DialogSection;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditWarehouseWidget extends ConsumerStatefulWidget {
  final String accessToken;
  final String warehouseId;
  final String? currentName;
  final String? currentLocation;
  final String warehouseType;
  final String? warehouseEmail;
  final String? warehousephone;
  final WidgetRef ref;

  const EditWarehouseWidget({
    super.key,
    required this.accessToken,
    required this.warehouseId,
    this.currentName,
    this.currentLocation,
    this.warehouseEmail,
    this.warehousephone,
    required this.warehouseType,
    required this.ref,
  });

  @override
  ConsumerState<EditWarehouseWidget> createState() =>
      _EditWarehouseWidgetState();
}

class _EditWarehouseWidgetState extends ConsumerState<EditWarehouseWidget> {
  late TextEditingController warehouseNameController;
  late TextEditingController warehouseTypeController;
  late TextEditingController warehouseAddressController;
  late TextEditingController warehouseEmailController;
  late TextEditingController warehousePhoneController;

  @override
  void initState() {
    super.initState();
    warehouseNameController = TextEditingController(text: widget.currentName);
    warehouseAddressController =
        TextEditingController(text: widget.currentLocation);
    warehouseTypeController = TextEditingController(text: widget.warehouseType);
    warehouseEmailController =
        TextEditingController(text: widget.warehouseEmail);
    warehousePhoneController =
        TextEditingController(text: widget.warehousephone);
  }

  @override
  void dispose() {
    warehouseNameController.dispose();
    warehouseAddressController.dispose();
    warehouseTypeController.dispose();
    warehouseEmailController.dispose();
    warehousePhoneController.dispose();
    super.dispose();
  }

  Future<void> _updateWarehouse(BuildContext context) async {
    try {
      final response = await editWarehouseService(
        warehouseId: widget.warehouseId,
        name: warehouseNameController.text.isNotEmpty
            ? warehouseNameController.text
            : null,
        address: warehouseAddressController.text.isNotEmpty
            ? warehouseAddressController.text
            : null,
        warehouseType: warehouseTypeController.text.isNotEmpty
            ? warehouseTypeController.text
            : null,
        mobile: warehousePhoneController.text.isNotEmpty
            ? warehousePhoneController.text
            : null,
        email: warehouseEmailController.text.isNotEmpty
            ? warehouseEmailController.text
            : null,
        accessToken: widget.accessToken,
      );

      if (response == 'success') {
        ref.refresh(warehouseListProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Warehouse updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else if (response == 'no_changes') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No changes to update'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update warehouse'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomEditDialog(
        context: context,
        title: 'Edit Warehouse',
        subtitle: 'Update warehouse details',
        sections: [
          DialogSection(
            title: 'Warehouse Information',
            icon: Icons.warehouse,
            fields: [
              DialogField(
                label: 'Warehouse Name',
                icon: Icons.warehouse_outlined,
                controller: warehouseNameController,
              ),
              DialogField(
                label: 'Warehouse Type',
                icon: Icons.category_outlined,
                controller: warehouseTypeController,
              ),
              DialogField(
                label: 'Address',
                icon: Icons.location_on_outlined,
                controller: warehouseAddressController,
                maxLines: 2,
              ),
              DialogField(
                label: 'Email',
                icon: Icons.email_outlined,
                controller: warehouseEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
              DialogField(
                label: 'Phone',
                icon: Icons.phone_outlined,
                controller: warehousePhoneController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ],
        onSave: () => _updateWarehouse(context),
        onCancel: () => Navigator.pop(context),
        saveButtonText: 'Update Warehouse',
        primaryColor: secondaryColor,
        secondaryColor: secondaryColor,
      );
    });

    return const SizedBox.shrink();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/add_supplier_controller.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/store_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddSupplierDialog extends HookConsumerWidget {
  final VoidCallback? onSuccess;
  const AddSupplierDialog({super.key, this.onSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessToken = ref.watch(userProvider)!.accessToken;
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final addressController = useTextEditingController();
    final gstController = useTextEditingController();
    final selectedStore = useState('Select Store');

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Add New Supplier',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: nameController,
              label: 'Supplier Name',
              hint: 'Enter supplier name',
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: phoneController,
              label: 'Phone',
              hint: 'Enter phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: addressController,
              label: 'Address',
              hint: 'Enter address',
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: gstController,
              label: 'GST Number',
              hint: 'Enter GST number',
              icon: Icons.numbers_outlined,
            ),
            const SizedBox(height: 16),
            StoreDropdown(
              value: selectedStore.value,
              onChanged: (value) {
                if (value != null) {
                  selectedStore.value = value;
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: textSecondaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    // &-----==================================================Add supplier logic here= api call

                    final addSupplierController = AddSupplierController(
                      accessToken: accessToken!,
                      storeId: int.parse(selectedStore.value),
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      address: addressController.text,
                      gstin: gstController.text,
                    );
                    await addSupplierController.addSupplierController(
                        context, onSuccess);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Supplier'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: textPrimaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: textLightColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: textPrimaryColor,
          ),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}

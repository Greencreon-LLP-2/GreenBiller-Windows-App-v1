import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/add_customer_controller.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/store_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddCustomerDialog extends HookConsumerWidget {
  final VoidCallback? onSuccess;
  const AddCustomerDialog({super.key, this.onSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final addressController = useTextEditingController();
    final gstinController = useTextEditingController();
    final selectedStore = useState('Select Store');

    final accessToken = ref.watch(userProvider)!.accessToken;
    final userId = ref.watch(userProvider)!.user!.id;
    final userName = ref.watch(userProvider)!.user!.name;

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
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Add New Customer',
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
              label: 'Customer Name',
              hint: 'Enter customer name',
              icon: Icons.person_outline,
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
              controller: gstinController,
              label: 'GSTIN',
              hint: 'Enter GSTIN',
              icon: Icons.account_balance_rounded,
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
                  onPressed: () => Navigator.pop(context),
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
                    //&===================================================== Add customer logic here- api call
                    final result = AddCustomerController(
                        accessToken: accessToken!,
                        storeId: int.parse(selectedStore.value),
                        userId: userId.toString(),
                        name: nameController.text,
                        phone: phoneController.text,
                        email: emailController.text,
                        address: addressController.text,
                        gstin: gstinController.text,
                        userName: userName!,
                        onSuccess: onSuccess);
                    await result.addCustomerController(context);
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
                  child: const Text('Add Customer'),
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

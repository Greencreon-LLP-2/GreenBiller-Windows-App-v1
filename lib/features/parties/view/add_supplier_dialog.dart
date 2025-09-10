import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/validator/validator.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';

class AddSupplierDialog extends StatelessWidget {
  final VoidCallback onSuccess;

  const AddSupplierDialog({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartiesController>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final gstController = TextEditingController();
    final taxController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
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
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (controller.supplierError.value != null) {
                return Text(
                  controller.supplierError.value!,
                  style: const TextStyle(color: Colors.red),
                );
              }
              if (controller.supplierSuccess.value != null) {
                return Text(
                  controller.supplierSuccess.value!,
                  style: const TextStyle(color: Colors.green),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 24),
            _buildTextField(
              controller: nameController,
              label: 'Supplier Name',
              hint: 'Enter supplier name',
              icon: Icons.business_outlined,
              validator: NameValidator.validate,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                LengthLimitingTextInputFormatter(100),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: phoneController,
              label: 'Phone',
              hint: 'Enter phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: PhoneValidator.validate,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: EmailValidator.validate,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: addressController,
              label: 'Address',
              hint: 'Enter address',
              icon: Icons.location_on_outlined,
              maxLines: 2,
              validator: AddressValidator.validate,
              
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: gstController,
              label: 'GST Number',
              hint: 'Enter GST number',
              icon: Icons.numbers_outlined,
              validator: GSTValidator.validate,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
               LengthLimitingTextInputFormatter(40),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: taxController,
              label: 'Tax Number',
              hint: 'Enter Tax number',
              icon: Icons.branding_watermark_outlined,
              validator: TaxValidator.validate,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\s-]')),
                LengthLimitingTextInputFormatter(40),
              ],
            ),
            const SizedBox(height: 16),
            AppDropdown(
              label: "Store",
              selectedValue: controller.storeDropdownController.selectedStoreId,
              options: controller.storeDropdownController.storeMap,
              isLoading: controller.storeDropdownController.isLoadingStores,
              onChanged: (val) {
                controller.selectedCustomerStoreId.value = val;
              },
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: textSecondaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (controller.storeDropdownController.selectedStoreId.value == null) {
                       
                        return;
                      }
                      controller
                        .addSupplier(
                          context,
                          nameController.text.trim(),
                          phoneController.text.trim(),
                          emailController.text.trim(),
                          addressController.text.trim(),
                          gstController.text.trim().toUpperCase(),
                          taxController.text.trim(),
                          controller.storeDropdownController.selectedStoreId.value,
                        )
                        .then((_) {
                          Get.back();
                          onSuccess();
                        });
                    } 
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
    )
    )
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: textPrimaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textLightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textPrimaryColor),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
}

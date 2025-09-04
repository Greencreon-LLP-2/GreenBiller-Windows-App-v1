import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/validator/validator.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';

class AddCustomerDialog extends StatelessWidget {
  final VoidCallback onSuccess;

  const AddCustomerDialog({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartiesController>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final gstinController = TextEditingController();
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
                 Obx(() {
                  if (controller.customerError.value != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.customerError.value!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (controller.customerSuccess.value != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.customerSuccess.value!,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: nameController,
                  label: 'Customer Name',
                  hint: 'Enter customer name',
                  icon: Icons.person_outline,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                  validator : NameValidator.validate
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: phoneController,
                  label: 'Phone',
                  hint: 'Enter phone number',
                  icon: Icons.phone_outlined,
                 inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                 LengthLimitingTextInputFormatter(10),
                 ],
                  keyboardType: TextInputType.phone,
                  validator: PhoneValidator.validate,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: EmailValidator.validate,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]'))]
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
                  controller: gstinController,
                  label: 'GSTIN',
                  hint: 'Enter GSTIN',
                  icon: Icons.account_balance_rounded,
                  validator: GSTINValidator.validate,
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
                          if (controller.selectedCustomerStoreId.value == null) {
                            Get.snackbar(
                              'Validation Error',
                              'Please select a store',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              colorText: Colors.red,
                              icon: const Icon(Icons.error_outline, color: Colors.red),
                            );
                            return;
                          }
                        controller
                           .addCustomer(
                                context,
                                nameController.text.trim(),
                                phoneController.text.trim(),
                                emailController.text.trim(),
                                addressController.text.trim(),
                                gstinController.text.trim().toUpperCase(), 
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
                      child: const Text('Add Customer'),
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
      validator: validator,
      inputFormatters: inputFormatters,
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
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dialog_field.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/features/parties/models/customer_model.dart';

class CustomerCard extends StatelessWidget {
  final CustomerData customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartiesController>();
    final name = customer.customerName ?? "Unknown";
    final status = customer.status == '1' ? 'Active' : 'Inactive';
    final statusColor = customer.status == '1' ? Colors.green : Colors.red;
    final mobile = customer.mobile ?? '';
    final email = customer.email ?? '';
    final address = customer.address ?? '';

    final customerNameController = TextEditingController(text: name);
    final phoneController = TextEditingController(text: mobile);
    final emailController = TextEditingController(text: email);
    final addressController = TextEditingController(text: address);
    final gstController = TextEditingController(text: customer.gstin);

    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(width: 18),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (mobile.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(mobile),
                      ],
                    ),
                  if (email.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.email, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(email),
                      ],
                    ),
                  if (address.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(address, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (customer.gstin?.isNotEmpty ?? false)
                        Row(
                          children: [
                            const Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(customer.gstin!),
                          ],
                        ),
                      if ((customer.gstin?.isNotEmpty ?? false) &&
                          (customer.storeId?.isNotEmpty ?? false))
                        const SizedBox(width: 12),
                      if (customer.storeId?.isNotEmpty ?? false)
                        Row(
                          children: [
                            const Icon(
                              Icons.store,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text('Store: ${customer.storeName}'),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  color: Colors.blue,
                  tooltip: 'Edit',
                  onTap: () => _showEditDialog(
                    context,
                    customerNameController,
                    phoneController,
                    emailController,
                    addressController,
                    gstController,
                  ),
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  color: errorColor,
                  tooltip: 'Delete',
                  onTap: () =>
                      _showDeleteConfirmation(context, customer.id.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: 20, color: color),
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    TextEditingController customerNameController,
    TextEditingController phoneController,
    TextEditingController emailController,
    TextEditingController addressController,
    TextEditingController gstController,
  ) {
    final controller = Get.find<PartiesController>();
    showCustomEditDialog(
      context: context,
      title: 'Edit Customer',
      subtitle: 'Update customer information',
      barrierDismissible: false,
      sections: [
        DialogSection(
          title: 'Basic Information',
          icon: Icons.info_outline_rounded,
          fields: [
            DialogField(
              label: 'Customer name',
              icon: Icons.person_outline_rounded,
              controller: customerNameController,
            ),
            DialogField(
              label: 'Phone',
              icon: Icons.phone_outlined,
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            DialogField(
              label: 'Email',
              icon: Icons.email_outlined,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            DialogField(
              label: 'Address',
              icon: Icons.location_on_outlined,
              controller: addressController,
              maxLines: 2,
            ),
            DialogField(
              label: 'GST Number',
              icon: Icons.business_outlined,
              controller: gstController,
            ),
          ],
        ),
      ],
      onSave: () => controller.handleSaveCustomerChanges(
        context,
        customer.id.toString(),
        customerNameController.text,
        phoneController.text,
        emailController.text,
        addressController.text,
        gstController.text,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String customerId) {
    final controller = Get.find<PartiesController>();
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.handleDeleteCustomer(context, customerId);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }
}

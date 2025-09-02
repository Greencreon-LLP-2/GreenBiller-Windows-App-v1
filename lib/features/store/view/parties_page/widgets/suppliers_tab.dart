import 'dart:developer' as dev;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/edit_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/model/supplier_model/supplier_model.dart';
import 'package:green_biller/features/store/services/view_parties_servies.dart';
import 'package:green_biller/features/store/view/parties_page/parties_page_providers.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/filter_chip.dart'
    as custom;
import 'package:green_biller/features/store/view/parties_page/widgets/store_dropdown.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/summary_card.dart';
import 'package:green_biller/utils/dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SuppliersTab extends HookConsumerWidget {
  const SuppliersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useMemoized(() => ValueNotifier(''), const []);
    final selectedFilter =
        useMemoized(() => ValueNotifier('All Suppliers'), const []);
    final selectedStore = useState<String?>(null);
    final selectedStoreId = useState<int?>(null);
    final isLoading = useState(false);
    final suppliers = useState<List<SupplierData>>([]);
    final error = useState<String?>(null);
    final accessToken = ref.watch(userProvider)?.accessToken!;
    final user = ref.watch(userProvider)?.user;
    final supplierModel = useState<SupplierModel?>(null);
    final refresh = ref.watch(supplierRefreshProvider);
    // Dispose ValueNotifiers
    useEffect(() {
      return () {
        searchQuery.dispose();
        selectedFilter.dispose();
      };
    }, const []);

    // Fetch suppliers from backend when store changes
    useEffect(() {
      Future<void> loadSuppliers() async {
        if (accessToken == null || user?.id == null) return;

        // Better null/undefined handling
        String? storeId = selectedStoreId.value?.toString();
        if (storeId == 'null' || storeId == 'undefined') {
          storeId = null;
        }
        isLoading.value = true;
        error.value = null;
        try {
          final response = await ViewPartiesController().viewSupplier(
            accessToken,
            storeId,
          );
          supplierModel.value = response;
          if (response.data != null) {
            suppliers.value = response.data!;
          }
        } catch (e) {
          final errorString = e.toString();
          error.value = errorString.replaceAll('Exception:', '').trim();
          if (error.value!.startsWith('Exception')) {
            error.value = error.value!.substring('Exception'.length).trim();
          }
          dev.log('Error loading suppliers: $e');
        } finally {
          isLoading.value = false;
        }
      }

      loadSuppliers();
      return null;
    }, [selectedStoreId.value, accessToken, user?.id, refresh]);

    return Column(
      children: [
        // Summary Cards
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              SummaryCard(
                title: 'Total Suppliers',
                value:
                    supplierModel.value?.insights?.totalSuppliers?.toString() ??
                        '0',
                icon: Icons.business,
                color: Colors.blue,
              ),
              const SizedBox(width: 16),
              SummaryCard(
                title: 'Active Suppliers',
                value:
                    supplierModel.value?.insights?.totalSuppliers?.toString() ??
                        '0',
                icon: Icons.check_circle,
                color: successColor,
              ),
              const SizedBox(width: 16),
              SummaryCard(
                title: 'New Suppliers (30 days)',
                value: supplierModel.value?.insights?.newSuppliersLast30Days
                        ?.toString() ??
                    '0',
                icon: Icons.person_add,
                color: Colors.green,
              ),
            ],
          ),
        ),
        // Search, Filter and Store Selection Section
        Container(
          padding: const EdgeInsets.all(16),
          color: cardColor,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: textLightColor,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: textPrimaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search suppliers...',
                      hintStyle: TextStyle(
                        color: textSecondaryColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: textSecondaryColor.withOpacity(0.6),
                      ),
                      suffixIcon: searchQuery.value.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 20,
                                color: textSecondaryColor.withOpacity(0.6),
                              ),
                              onPressed: () {
                                searchQuery.value = '';
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      searchQuery.value = value.toLowerCase();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              StoreDropdown(
                value: selectedStore.value ?? 'Select Store',
                onChanged: (value) {
                  if (value != null) {
                    selectedStore.value = value;
                  }
                },
                onStoreIdChanged: (storeId) {
                  selectedStoreId.value = storeId;
                },
              ),
              const SizedBox(width: 12),
              custom.CustomFilterChip(
                icon: Icons.filter_list,
                label: selectedFilter.value,
                onTap: () {
                  _showFilterDialog(context, selectedFilter, accessToken!);
                },
              ),
            ],
          ),
        ),
        // Suppliers List
        Expanded(
          child: isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : error.value != null
                  ? Center(
                      child: Text(
                        'Error: ${error.value}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : suppliers.value.isEmpty
                      ? const Center(
                          child: Text('No suppliers found'),
                        )
                      : ListView.builder(
                          itemCount: suppliers.value.length,
                          itemBuilder: (context, index) {
                            final supplier = suppliers.value[index];
                            return SupplierCard(
                              supplier: supplier,
                              accessToken: accessToken!,
                              ref: ref,
                            );
                          },
                        ),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context,
      ValueNotifier<String> selectedFilter, String accessToken) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Suppliers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(
                context, 'All Suppliers', selectedFilter, accessToken),
            _buildFilterOption(
                context, 'Active Suppliers', selectedFilter, accessToken),
            _buildFilterOption(
                context, 'Inactive Suppliers', selectedFilter, accessToken),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String option,
      ValueNotifier<String> selectedFilter, String accessToken) {
    final isSelected = selectedFilter.value == option;
    return ListTile(
      title: Text(option),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: accentColor,
            )
          : null,
      onTap: () {
        selectedFilter.value = option;
        Navigator.of(context).pop();
      },
    );
  }
}

class SupplierCard extends HookWidget {
  final SupplierData supplier;
  final String accessToken;
  final WidgetRef ref;

  const SupplierCard({
    super.key,
    required this.supplier,
    required this.accessToken,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final name = supplier.supplierName ?? "Unknown";
    final status = supplier.status == '1' ? 'Active' : 'Inactive';
    final statusColor = supplier.status == '1' ? Colors.green : Colors.red;
    final mobile = supplier.mobile ?? '';
    final email = supplier.email ?? '';
    final address = supplier.address ?? '';

    // Create controllers for the edit dialog using hooks
    final supplierNameController = useTextEditingController(text: name);
    final phoneController = useTextEditingController(text: mobile);
    final emailController = useTextEditingController(text: email);
    final addressController = useTextEditingController(text: address);
    final gstController = useTextEditingController(text: supplier.gstin);

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
                    color: accentColor),
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
                              fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
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
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                            child:
                                Text(address, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (supplier.gstin?.isNotEmpty ?? false)
                        Row(
                          children: [
                            const Icon(Icons.business,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(supplier.gstin!),
                          ],
                        ),
                      if ((supplier.gstin?.isNotEmpty ?? false) &&
                          (supplier.storeId?.isNotEmpty ?? false))
                        const SizedBox(width: 12),
                      if (supplier.storeId?.isNotEmpty ?? false)
                        Row(
                          children: [
                            const Icon(Icons.store,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text('Store: ${supplier.storeName}'),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions with new design
            Column(
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  color: Colors.blue,
                  tooltip: 'Edit',
                  onTap: () {
                    showSupplierEditDialog(
                      context: context,
                      supplierNameController: supplierNameController,
                      phoneController: phoneController,
                      emailController: emailController,
                      addressController: addressController,
                      gstController: gstController,
                      onSave: () => _handleSaveChanges(
                        context,
                        supplierNameController,
                        phoneController,
                        emailController,
                        addressController,
                        gstController,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  color: errorColor,
                  tooltip: 'Delete',
                  onTap: () => _showDeleteConfirmation(context),
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

  void showSupplierEditDialog({
    required BuildContext context,
    required TextEditingController supplierNameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required TextEditingController addressController,
    required TextEditingController gstController,
    required VoidCallback onSave,
  }) {
    showCustomEditDialog(
      context: context,
      title: 'Edit Supplier',
      subtitle: 'Update supplier information',
      sections: [
        DialogSection(
          title: 'Basic Information',
          icon: Icons.info_outline_rounded,
          fields: [
            DialogField(
              label: 'Supplier name',
              icon: Icons.person_outline_rounded,
              controller: supplierNameController,
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
      onSave: onSave,
    );
  }

  void _showDeleteConfirmation(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: const Text('Are you sure you want to delete this supplier?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      await _handleDelete(context);
    }
  }

  Future<void> _handleSaveChanges(
    BuildContext context,
    TextEditingController supplierNameController,
    TextEditingController phoneController,
    TextEditingController emailController,
    TextEditingController addressController,
    TextEditingController gstController,
  ) async {
    try {
      log(supplier.id.toString());
      log(supplier.supplierName.toString());
      log(supplier.mobile.toString());
      log(supplier.email.toString());
      log(supplier.address.toString());
      log(supplier.gstin.toString());
      log(supplier.storeId.toString());

      final response = await EditPartiesController(
        name: supplierNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        address: addressController.text,
        gstin: gstController.text,
        accestoken: accessToken,
      ).editSupplierController(supplier.id.toString());

      if (response == "Supplier updated successfully") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supplier updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(supplierRefreshProvider.notifier).state++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update supplier"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    Navigator.pop(context);
  }

  Future<void> _handleDelete(BuildContext context) async {
    try {
      final response = await ViewPartiesServies()
          .deleteSupplierSerivce(accessToken, supplier.id.toString());

      if (response == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Supplier deleted successfully')),
          );
          ref.read(supplierRefreshProvider.notifier).state++;
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Failed to delete supplier')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Widget _buildSection(BuildContext context, String title, IconData icon,
      List<Widget> children) {
    return Card(
      elevation: 0,
      color: secondaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

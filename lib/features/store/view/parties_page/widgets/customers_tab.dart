import 'dart:async';
import 'dart:developer' as dev;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/edit_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/model/customer_model/customer_model.dart';
import 'package:green_biller/features/store/services/view_parties_servies.dart';
import 'package:green_biller/features/store/view/parties_page/parties_page_providers.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/filter_chip.dart'
    as custom;
import 'package:green_biller/features/store/view/parties_page/widgets/store_dropdown.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/summary_card.dart';
import 'package:green_biller/utils/dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomersTab extends HookConsumerWidget {
  const CustomersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    // Use useMemoized to create ValueNotifiers that persist across rebuilds
    final searchQuery = useMemoized(() => ValueNotifier(''), const []);
    final selectedFilter =
        useMemoized(() => ValueNotifier('All Customers'), const []);
    final selectedStore = useState<String?>(null);
    final selectedStoreId = useState<int?>(null);
    final accessToken = ref.watch(userProvider)?.accessToken!;
    final user = ref.watch(userProvider)?.user;
    final isLoading = useState(false);
    final customers = useState<List<CustomerData>>([]);
    final error = useState<String?>(null);
    final customerModel = useState<CustomerModel?>(null);
    final refresh = ref.watch(customerRefreshProvider);
    // Use useEffect to dispose of the ValueNotifiers when the widget is disposed
   final cancelCompleter = useMemoized(() => Completer<void>(), const []);
    useEffect(() {
      return () {
        searchQuery.dispose();
        selectedFilter.dispose();
         cancelCompleter.complete();
      };
    }, const []);

    // Load customers when store is selected
    useEffect(() {
      bool active = true;
      Future<void> loadCustomers() async {
        if (accessToken == null || user?.id == null) return;

        // Better null/undefined handling
        String? storeId = selectedStoreId.value?.toString();
        if (storeId == 'null' || storeId == 'undefined') {
          storeId = null;
        }

        isLoading.value = true;
        error.value = null;

        try {
          final response = await ViewPartiesController().viewCustomer(
            accessToken,
            storeId, // Now properly null or valid ID
          );
          if (cancelCompleter.isCompleted) return;
          customerModel.value = response;
          if (response.data != null) {
            customers.value = response.data!;
          }
        } catch (e) {
           if (cancelCompleter.isCompleted) return;
          final errorString = e.toString();
          error.value = errorString.replaceAll('Exception:', '').trim();
          if (error.value!.startsWith('Exception')) {
            error.value = error.value!.substring('Exception'.length).trim();
          }
          dev.log('Error loading customers: $e', error: e);
        } finally {
          if (!cancelCompleter.isCompleted) {
            isLoading.value = false;
          }
        }
      }

      loadCustomers();
      return null;
    }, [accessToken, selectedStoreId.value, user?.id, refresh]);

    return Column(
      children: [
        // Summary Cards
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              SummaryCard(
                title: 'Total Customers',
                value:
                    customerModel.value?.insights?.totalCustomers?.toString() ??
                        '0',
                icon: Icons.people,
                color: accentColor,
              ),
              const SizedBox(width: 16),
              SummaryCard(
                title: 'Active Customers',
                value:
                    customerModel.value?.insights?.totalCustomers?.toString() ??
                        '0',
                icon: Icons.check_circle,
                color: successColor,
              ),
              const SizedBox(width: 16),
              SummaryCard(
                title: 'New Customers (30 days)',
                value: customerModel.value?.insights?.newCustomersLast30Days
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
                      hintText: 'Search customers...',
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
                onChanged: (newValue) {
                  if (newValue != null) {
                    selectedStore.value = newValue;
                  }
                },
                onStoreIdChanged: (storeId) {
                  selectedStoreId.value = storeId;
                  dev.log('Selected store ID: ${storeId.toString()}');
                },
              ),
              const SizedBox(width: 12),
              custom.CustomFilterChip(
                icon: Icons.filter_list,
                label: selectedFilter.value,
                onTap: () {
                  _showFilterDialog(context, selectedFilter);
                },
              ),
            ],
          ),
        ),

        // Customers List
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
                  : customers.value.isEmpty
                      ? const Center(
                          child: Text('No customers found'),
                        )
                      : ListView.builder(
                          itemCount: customers.value.length,
                          itemBuilder: (context, index) {
                            final customer = customers.value[index];
                            return CustomerCard(
                              customer: customer,
                              accessToken: accessToken!,
                              ref: ref,
                            );
                          },
                        ),
        ),
      ],
    );
  }

  void _showFilterDialog(
      BuildContext context, ValueNotifier<String> selectedFilter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Customers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(context, 'All Customers', selectedFilter),
            _buildFilterOption(context, 'Active Customers', selectedFilter),
            _buildFilterOption(context, 'Inactive Customers', selectedFilter),
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
      ValueNotifier<String> selectedFilter) {
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
        if (!selectedFilter.hasListeners) return;
        selectedFilter.value = option;
        Navigator.of(context).pop();
      },
    );
  }

// Add this custom hook to check if component is mounted
  bool useIsMounted() {
    final isMounted = useRef(true);

    useEffect(() {
      return () {
        isMounted.value = false;
      };
    }, []);

    return isMounted.value;
  }
}

class CustomerCard extends HookWidget {
  final String accessToken;
  final CustomerData customer;
  final WidgetRef ref;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.accessToken,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final name = customer.customerName ?? "Unknown";
    final status = customer.status == '1' ? 'Active' : 'Inactive';
    final statusColor = customer.status == '1' ? Colors.green : Colors.red;
    final mobile = customer.mobile ?? '';
    final email = customer.email ?? '';
    final address = customer.address ?? '';

    final customerNameController = useTextEditingController(text: name);
    final phoneController = useTextEditingController(text: mobile);
    final emailController = useTextEditingController(text: email);
    final addressController = useTextEditingController(text: address);
    final gstController = useTextEditingController(text: customer.gstin);

    // Get accessToken from Provider
    final accessToken = ProviderScope.containerOf(context, listen: false)
        .read(userProvider)
        ?.accessToken;
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
                      if (customer.gstin?.isNotEmpty ?? false)
                        Row(
                          children: [
                            const Icon(Icons.business,
                                size: 16, color: Colors.grey),
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
                            const Icon(Icons.store,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text('Store : ${customer.storeName}'),
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
                    _showEditDialog(
                      context,
                      customerNameController,
                      phoneController,
                      emailController,
                      addressController,
                      gstController,
                      accessToken,
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.delete_outline_rounded,
                  color: errorColor,
                  tooltip: 'Delete',
                  onTap: () => _showDeleteConfirmation(context, accessToken),
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
    String? accessToken,
  ) {
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
      onSave: () => _handleSaveChanges(
        context,
        customerNameController,
        phoneController,
        emailController,
        addressController,
        gstController,
        accessToken,
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String? accessToken) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: const Text('Are you sure you want to delete this customer?'),
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
      await _handleDelete(context, accessToken);
    }
  }

  Future<void> _handleSaveChanges(
    BuildContext context,
    TextEditingController customerNameController,
    TextEditingController phoneController,
    TextEditingController emailController,
    TextEditingController addressController,
    TextEditingController gstController,
    String? accessToken,
  ) async {
    try {
      log(customer.id.toString());
      log(customer.customerName.toString());
      log(customer.mobile.toString());
      log(customer.email.toString());
      log(customer.address.toString());
      log(customer.gstin.toString());
      log(customer.storeId.toString());

      final response = await EditPartiesController(
        name: customerNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        address: addressController.text,
        gstin: gstController.text,
        accestoken: accessToken!,
      ).editCustomerController(customer.id.toString());

      if (response == "Customer updated successfully") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(customerRefreshProvider.notifier).state++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update customer"),
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

  Future<void> _handleDelete(BuildContext context, String? accessToken) async {
    try {
      final response = await ViewPartiesServies()
          .deleteCustomerSerivce(accessToken!, customer.id.toString());

      if (response == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Customer deleted successfully')),
          );
          ref.read(customerRefreshProvider.notifier).state++;
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Failed to delete customer')),
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
}

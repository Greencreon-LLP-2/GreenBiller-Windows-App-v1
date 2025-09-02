// lib/features/store/view/admin/admin_warehouses_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/services/delete_warehouse_service.dart';
import 'package:green_biller/features/store/view/store_page/shared/single_warehouse_details.dart';
import 'package:green_biller/features/store/view/store_page/widgets/edit_warehouse_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminWarehousesTab extends HookConsumerWidget {
  const AdminWarehousesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final isLoading = useState<bool>(false);
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('User not found. Please login again.')),
      );
    }

    // Watch the warehouse list provider
    final warehouseAsync = ref.watch(warehouseListProvider);

    return Stack(
      children: [
        if (isLoading.value)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Processing...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Column(
          children: [
            // Enhanced Search and filter section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: textLightColor.withOpacity(0.3)),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search warehouses...',
                          hintStyle: TextStyle(
                              color: textSecondaryColor.withOpacity(0.7)),
                          prefixIcon: const Icon(Icons.search,
                              color: textSecondaryColor),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        onChanged: (value) {
                          searchQuery.value = value.toLowerCase();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list, color: accentColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'all',
                          child: Row(
                            children: [
                              Icon(Icons.list_alt, size: 18),
                              SizedBox(width: 8),
                              Text('All Warehouses'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'active',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  size: 18, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Active'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'inactive',
                          child: Row(
                            children: [
                              Icon(Icons.cancel, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Inactive'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Manual refresh
                        ref.refresh(warehouseListProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced Table Content with pull-to-refresh
            Expanded(
              child: warehouseAsync.when(
                loading: () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading warehouses...'),
                    ],
                  ),
                ),
                error: (err, st) => Center(
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text('Error: $err',
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
                data: (warehouseModel) {
                  if (warehouseModel?.data == null ||
                      warehouseModel!.data!.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.refresh(warehouseListProvider);
                        // wait for refetch
                        await ref.read(warehouseListProvider.future);
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 100),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: textSecondaryColor.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No warehouses found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: textSecondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pull down to refresh',
                                  style: TextStyle(
                                    color: textSecondaryColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Filtered list
                  final filtered = warehouseModel.data!.where((warehouse) {
                    if (searchQuery.value.isEmpty) return true;
                    final searchableText = [
                      warehouse.warehouseName,
                      warehouse.address,
                      warehouse.warehouseType,
                    ].join(' ').toLowerCase();
                    return searchableText.contains(searchQuery.value);
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(warehouseListProvider);
                      await ref.read(warehouseListProvider.future);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final warehouse = filtered[index];
                        final isActive = warehouse.status == 'active';

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                if (warehouse.storeId != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WarehouseDetailScreen(
                                                accessToken: accessToken,
                                                storeId: warehouse.storeId!,
                                              )));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'please connect with support, something wrong with this warehouse')),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    // Enhanced warehouse icon
                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        color: accentColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.warehouse,
                                        color: accentColor,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 20),

                                    // Warehouse details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Name
                                          Text(
                                            warehouse.warehouseName ??
                                                'Unnamed Warehouse',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: textPrimaryColor,
                                              letterSpacing: -0.5,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),

                                          // Address
                                          if (warehouse.address != null &&
                                              warehouse.address!.isNotEmpty)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on_outlined,
                                                  size: 16,
                                                  color: textSecondaryColor,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    warehouse.address!,
                                                    style: const TextStyle(
                                                      color: textSecondaryColor,
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 6),

                                          // Type
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.category_outlined,
                                                size: 16,
                                                color: textSecondaryColor,
                                              ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  warehouse.warehouseType ??
                                                      'Unknown type',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue.shade700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Type
                                          Row(
                                            children: [
                                              const Text("Items Count :"),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  warehouse.itemsCount
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue.shade700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Status and action buttons in column
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Status container
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 6,
                                                width: 6,
                                                decoration: BoxDecoration(
                                                  color: isActive
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                isActive
                                                    ? 'Active'
                                                    : 'Inactive',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: isActive
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),

                                        // Action buttons
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Edit button
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: IconButton(
                                                tooltip: 'Edit',
                                                icon: const Icon(
                                                    Icons.edit_outlined,
                                                    size: 20,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        EditWarehouseWidget(
                                                      accessToken: accessToken,
                                                      warehouseId: warehouse.id
                                                          .toString(),
                                                      currentName: warehouse
                                                              .warehouseName ??
                                                          '',
                                                      warehouseEmail:
                                                          warehouse.email,
                                                      warehousephone:
                                                          warehouse.mobile,
                                                      currentLocation:
                                                          warehouse.address ??
                                                              '',
                                                      warehouseType: warehouse
                                                              .warehouseType ??
                                                          "",
                                                      ref: ref,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            // View button
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: IconButton(
                                                tooltip: 'View Details',
                                                icon: const Icon(
                                                    Icons.visibility_outlined,
                                                    size: 20,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  // Navigate to view details
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            // Delete button
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: IconButton(
                                                tooltip: 'Delete',
                                                icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 20,
                                                    color: Colors.red),
                                                onPressed: () async {
                                                  // Show confirmation dialog
                                                  final shouldDelete =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16)),
                                                      title: const Text(
                                                          'Delete Warehouse'),
                                                      content: Text(
                                                          'Are you sure you want to delete "${warehouse.warehouseName}"?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        FilledButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          style: FilledButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red),
                                                          child: const Text(
                                                              'Delete'),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                  if (shouldDelete == true) {
                                                    isLoading.value = true;
                                                    final response =
                                                        await deleteWareHouseSerivce(
                                                      accessToken,
                                                      warehouse.id.toString(),
                                                    );

                                                    if (response == 200) {
                                                      isLoading.value = false;
                                                      ref.refresh(
                                                          warehouseListProvider);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                              "Warehouse deleted successfully"),
                                                          backgroundColor:
                                                              Colors.green,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                      );
                                                    } else {
                                                      isLoading.value = false;
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                              "Failed to delete warehouse"),
                                                          backgroundColor:
                                                              Colors.red,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

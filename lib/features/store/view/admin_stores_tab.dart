import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/store/view/store_detail_page.dart';

class AdminStoresTab extends GetView<AdminStoresController> {
  const AdminStoresTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Column(
            children: [
              // Enhanced Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cardColor, cardColor.withOpacity(0.9)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: textLightColor.withOpacity(0.15),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search stores, locations, contacts...',
                          hintStyle: TextStyle(
                            color: textSecondaryColor.withOpacity(0.6),
                            fontSize: 15,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: accentColor,
                              size: 20,
                            ),
                          ),
                          suffixIcon: controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.searchQuery.value = '';
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        onChanged: (value) {
                          controller.searchQuery.value = value.toLowerCase();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Filter Dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedFilter.value,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                ),
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(
                                    value: 'all',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.store_rounded,
                                          size: 18,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('All Stores'),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'active',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 18,
                                          color: Colors.green.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Active Only'),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'inactive',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.cancel_rounded,
                                          size: 18,
                                          color: Colors.red.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Inactive Only'),
                                      ],
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedFilter.value = value;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Refresh Button
                        Container(
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Get.find<ViewStoreController>().fetchStores();
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: accentColor,
                            ),
                            tooltip: 'Refresh Stores',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.isLoading.value
                    ? _buildLoadingState()
                    : controller.stores.isEmpty
                    ? _buildEmptyState()
                    : controller.filteredStores.isEmpty
                    ? _buildNoResultsState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          // await Get.find<ViewStoreController>().fetchStores();
                        },
                        child: _buildListView(
                          context,
                          controller.filteredStores,
                          controller.isLoading,
                        ),
                      ),
              ),
            ],
          ),
          if (controller.isLoading.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<dynamic> stores,
    RxBool isLoading,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        return _buildStoreListCard(context, stores[index], isLoading);
      },
    );
  }

  Widget _buildStoreListCard(
    BuildContext context,
    dynamic store,
    RxBool isLoading,
  ) {
    final storeName = store.storeName ?? 'Unnamed Store';
    final customersCount = store.customersCount ?? 0;
    final suppliersCount = store.suppliersCount ?? 0;
    final storeId = store.id?.toString() ?? '';
    final location = store.storeAddress ?? 'No address';
    final phone = store.storePhone ?? '';
    final email = store.storeEmail ?? '';
    final city = store.storeCity ?? '';
    final country = store.storeCountry ?? '';
    final status = store.status;
    final logo = "$publicUrl/${store.storeLogo}";
    final isActive = status == 'active';

    final controller = Get.find<AdminStoresController>();
    final warehouseCount = controller.warehouseCounts[storeId] ?? 0;
    final categories = controller.categories[storeId] ?? [];
    final salesCount = controller.salesCounts[storeId] ?? 0;
    final salesReturnCount = controller.salesReturnCounts[storeId] ?? 0;
    final purchaseCount = controller.purchaseCounts[storeId] ?? 0;
    final purchaseReturnCount = controller.purchaseReturnCounts[storeId] ?? 0;

    if (storeId.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'Invalid store ID',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Get.to(
            //   () => StoreDetailScreen(
            //     accessToken: controller.user.value?.accessToken ?? '',
            //     storeId: int.parse(storeId),
            //   ),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.store_rounded,
                        color: accentColor,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              storeName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(isActive),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (location.isNotEmpty && location != 'No address')
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          text: location,
                          maxLines: 1,
                        ),
                      if (phone.isNotEmpty && phone != 'No phone') ...[
                        const SizedBox(height: 4),
                        _buildInfoRow(icon: Icons.phone_outlined, text: phone),
                      ],
                      if (email.isNotEmpty && email != 'No email') ...[
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          text: email,
                          maxLines: 1,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildStatChip(
                            '$warehouseCount Warehouses',
                            Icons.warehouse_outlined,
                          ),
                          _buildStatChip(
                            '${categories.length} Categories',
                            Icons.category_outlined,
                          ),
                          if (salesCount >= 0)
                            _buildStatChip(
                              '$salesCount Sales',
                              Icons.point_of_sale_outlined,
                            ),
                          if (salesReturnCount >= 0)
                            _buildStatChip(
                              '$salesReturnCount Sales Returns',
                              Icons.assignment_return_outlined,
                            ),
                          if (purchaseCount >= 0)
                            _buildStatChip(
                              '$purchaseCount Purchases',
                              Icons.shopping_cart_outlined,
                            ),
                          if (purchaseReturnCount >= 0)
                            _buildStatChip(
                              '$purchaseReturnCount Purchase Returns',
                              Icons.keyboard_return_outlined,
                            ),
                          if (customersCount > 0)
                            _buildStatChip(
                              '$customersCount Customers',
                              Icons.people_outline,
                            ),
                          if (suppliersCount > 0)
                            _buildStatChip(
                              '$suppliersCount Suppliers',
                              Icons.local_shipping_outlined,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      color: Colors.blue,
                      tooltip: 'Edit Store',
                      onTap: () {
                        // Get.to(
                        //   () => EditStorePage(
                        //     accessToken:
                        //         controller.user.value?.accessToken ?? '',
                        //     storeId: storeId,
                        //   ),
                        // );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      color: Colors.grey,
                      tooltip: 'View Details',
                      onTap: () {
                        // Get.to(
                        //   () => StoreDetailScreen(
                        //     accessToken:
                        //         controller.user.value?.accessToken ?? '',
                        //     storeId: int.parse(storeId),
                        //   ),
                        // );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red,
                      tooltip: 'Delete Store',
                      onTap: () =>
                          controller.deleteStore(context, storeName, storeId),
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

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: accentColor),
          const SizedBox(width: 2),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
        ],
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

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(height: 20),
          Text(
            'Loading stores...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        // await Get.find<ViewStoreController>().fetchStores();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.store_mall_directory_outlined,
                    size: 64,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No stores found',
                  style: TextStyle(
                    fontSize: 20,
                    color: textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first store to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Get.find<ViewStoreController>().fetchStores();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No matching stores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: textSecondaryColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 14,
            color: textSecondaryColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: textSecondaryColor,
              fontSize: 13,
              height: 1.3,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class AdminStoresController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'all'.obs;
  final isLoading = false.obs;

  final stores = <dynamic>[].obs;
  final filteredStores = <dynamic>[].obs;
  final warehouseCounts = <String, int>{}.obs;
  final categories = <String, List<dynamic>>{}.obs;
  final salesCounts = <String, int>{}.obs;
  final salesReturnCounts = <String, int>{}.obs;
  final purchaseCounts = <String, int>{}.obs;
  final purchaseReturnCounts = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();

    fetchStores();
    ever(searchQuery, (_) => _filterStores());
    ever(selectedFilter, (_) => _filterStores());
  }

  void fetchStores() async {
    isLoading.value = true;
    try {
      // final storeController = Get.find<ViewStoreController>();
      // final storeModel = await storeController.fetchStores();
      // stores.assignAll(storeModel.data ?? []);
      // for (var store in stores) {
      //   final storeId = store.id.toString();
      //   warehouseCounts[storeId] = await Get.find<ViewWarehouseController>()
      //       .getWarehouseCount(storeId);
      //   categories[storeId] = await Get.find<ViewStoreController>()
      //       .getCategories(storeId);
      //   salesCounts[storeId] = await Get.find<ViewStoreController>()
      //       .getSalesCount(storeId);
      //   salesReturnCounts[storeId] = await Get.find<ViewStoreController>()
      //       .getSalesReturnCount(storeId);
      //   purchaseCounts[storeId] = await Get.find<ViewStoreController>()
      //       .getPurchaseCount(storeId);
      //   purchaseReturnCounts[storeId] = await Get.find<ViewStoreController>()
      //       .getPurchaseReturnCount(storeId);
      // }
      // _filterStores();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _filterStores() {
    final query = searchQuery.value;
    final filter = selectedFilter.value;
    filteredStores.assignAll(
      stores.where((store) {
        if (query.isNotEmpty) {
          final searchableFields = [
            store.storeName ?? '',
            store.address ?? '',
            store.phone ?? '',
            store.email ?? '',
            store.city ?? '',
            store.country ?? '',
          ].join(' ').toLowerCase();
          if (!searchableFields.contains(query)) return false;
        }
        if (filter != 'all') {
          final isActive = store.status == 'active';
          if (filter == 'active' && !isActive) return false;
          if (filter == 'inactive' && isActive) return false;
        }
        return true;
      }).toList(),
    );
  }

  void deleteStore(
    BuildContext context,
    String storeName,
    String storeId,
  ) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade600,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Delete Store'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "$storeName"?'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'This action cannot be undone.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      isLoading.value = true;
      // try {
      //   final response = await deleteStoreSerivce(
      //     user.value?.accessToken ?? '',
      //     storeId,
      //   );
      //   if (response == 200) {
      //     fetchStores();
      //     Get.snackbar(
      //       'Success',
      //       'Store deleted successfully',
      //       backgroundColor: Colors.green.shade600,
      //       colorText: Colors.white,
      //       snackPosition: SnackPosition.BOTTOM,
      //       margin: const EdgeInsets.all(16),
      //       borderRadius: 12,
      //     );
      //   } else {
      //     Get.snackbar(
      //       'Error',
      //       'Failed to delete store',
      //       backgroundColor: Colors.red.shade600,
      //       colorText: Colors.white,
      //       snackPosition: SnackPosition.BOTTOM,
      //       margin: const EdgeInsets.all(16),
      //       borderRadius: 12,
      //     );
      //   }
      // } catch (e) {
      //   Get.snackbar(
      //     'Error',
      //     'Error: $e',
      //     backgroundColor: Colors.red.shade600,
      //     colorText: Colors.white,
      //     snackPosition: SnackPosition.BOTTOM,
      //     margin: const EdgeInsets.all(16),
      //     borderRadius: 12,
      //   );
      // } finally {
      //   isLoading.value = false;
      // }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';

import 'package:greenbiller/routes/app_routes.dart';

class AdminStoresTab extends GetView<StoreController> {
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
                        controller: controller.storeSearchController,
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
                          suffixIcon:
                              controller.storeSearchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    controller.storeSearchController.clear();
                                    controller.storeSearchQuery.value = '';
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
                          controller.storeSearchQuery.value = value
                              .toLowerCase();
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
                                value: controller.storeSelectedFilter.value,
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
                                    controller.storeSelectedFilter.value =
                                        value;
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
                              controller.getStoreList();
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
                child: controller.isStoreLoading.value
                    ? _buildLoadingState()
                    : controller.stores.isEmpty
                    ? _buildEmptyState()
                    : controller.filteredStores.isEmpty
                    ? _buildNoResultsState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          controller.getStoreList();
                        },
                        child: _buildListView(
                          context,
                          controller.filteredStores,
                          controller.isStoreLoading,
                        ),
                      ),
              ),
            ],
          ),
          if (controller.isStoreLoading.value)
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: accentColor,
                            ),
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
    final status = store.status;
    final logo = "$publicUrl/${store.storeLogo}";
    final isActive = status == 'active';

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
            Get.toNamed(
              AppRoutes.singleStoreView,
              parameters: {'storeId': storeId.toString()},
            );
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
                        Get.toNamed(
                          AppRoutes.editStoreView,
                          parameters: {'storeEditId': storeId.toString()},
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      color: Colors.grey,
                      tooltip: 'View Details',
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.singleStoreView,
                          parameters: {'storeId': storeId.toString()},
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red,
                      tooltip: 'Delete Store',
                      onTap: () => controller.deleteStore(store.id),
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
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: accentColor,
            ),
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
        controller.getStoreList();
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
                    controller.getStoreList();
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

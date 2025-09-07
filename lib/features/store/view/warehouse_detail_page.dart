import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/store/controller/store_warehouse_details_controller.dart';
import 'package:greenbiller/routes/app_routes.dart';

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? background;
  final Color? iconColor;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.background,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor ?? textSecondaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: textSecondaryColor),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color ?? accentColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class WarehouseDetailScreen extends GetView<StoreWarehouseDetailsController> {
  const WarehouseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.warehouseId.value = int.parse(
      Get.parameters['warehouseId'] ?? '0',
    );
    controller.storeId.value = int.parse(Get.parameters['storeId'] ?? '0');
    controller.fetchSingleWarehouse();
    controller.fetchWarehouseItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Details'),
        backgroundColor: cardColor,
        foregroundColor: textPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchSingleWarehouse();
              controller.fetchWarehouseItems();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isWarehouseLoading.value ||
            controller.isLoadingItems.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator(color: accentColor)),
              ],
            ),
          );
        }

        if (controller.warehouseError.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${controller.warehouseError.value}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchSingleWarehouse();
                    controller.fetchWarehouseItems();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final warehouse = controller.singleWarehouse.value;
        if (warehouse == null) {
          return const Center(
            child: Text(
              'Warehouse not found',
              style: TextStyle(fontSize: 18, color: textSecondaryColor),
            ),
          );
        }

        final name = warehouse.warehouseName ?? 'Unnamed Warehouse';
        final type = warehouse.warehouseType ?? '—';
        final address = warehouse.address ?? 'No address';
        final mobile = warehouse.mobile ?? 'N/A';
        final email = warehouse.email ?? 'N/A';
        final status = (warehouse.status ?? 'unknown').toLowerCase();
        final storeId = warehouse.storeId;

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.fetchSingleWarehouse(),
              controller.fetchWarehouseItems(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warehouse Info
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    InfoChip(icon: Icons.category, label: type),
                    InfoChip(icon: Icons.location_on, label: address),
                    InfoChip(icon: Icons.phone, label: mobile),
                    InfoChip(icon: Icons.email, label: email),
                    InfoChip(
                      icon: status == 'active'
                          ? Icons.check_circle
                          : Icons.error_outline,
                      label: status.toUpperCase(),
                      background: status == 'active'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      iconColor: status == 'active'
                          ? Colors.green[800]
                          : Colors.orange[800],
                    ),
                    if (storeId != null)
                      TextButton.icon(
                        onPressed: () {
                          // Clear all existing controller data
                          controller.store.value = null;
                          controller.warehouses.clear();
                          controller.storeId.value = 0;
                          controller.singleWarehouse.value = null;
                          controller.warehouseId.value = 0;
                          controller.items.clear();
                          controller.searchQuery.value = '';

                          // Navigate
                          Get.toNamed(
                            AppRoutes.singleStoreView,
                            parameters: {'storeId': storeId.toString()},
                          );
                        },
                        icon: const Icon(Icons.store),
                        label: const Text('View Parent Store'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Total Items',
                        value: controller.totalItems.toString(),
                        icon: Icons.inventory_2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Active',
                        value: controller.activeItems.toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Inactive',
                        value: controller.inactiveItems.toString(),
                        icon: Icons.pause_circle_outline,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: 'Total Quantity',
                        value: controller.totalQuantity.toString(),
                        icon: Icons.scale,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),

                // Items List
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textLightColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.isLoadingItems.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                      ),
                    );
                  }
                  if (controller.errorItems.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${controller.errorItems.value}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.fetchWarehouseItems,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  final filteredItems = controller.filteredItems;
                  if (filteredItems.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No items found')),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final itemName = item.itemName ?? 'Unnamed';
                      final sku = item.sku ?? '';
                      final qty = item.quantity?.toString() ?? '0';
                      final status = item.status == 1 ? 'active' : 'inactive';
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.inventory),
                          title: Text(itemName),
                          subtitle: Text('SKU: $sku'),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Qty: $qty'),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: status == 'active'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    color: status == 'active'
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}

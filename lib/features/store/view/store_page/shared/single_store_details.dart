// lib/features/store/view/store_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CardContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: child,
    );
  }
}

class StoreDetailScreen extends HookConsumerWidget {
  final String accessToken;
  final int storeId;

  const StoreDetailScreen({
    super.key,
    required this.accessToken,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You might want to provide a scoped provider for storeId/accessToken if needed.
    final storeAsync =
        ref.watch(storesProvider); // expects StoreModel with .data
    final warehousesAsync = ref.watch(warehouseListProvider); // WareHouseModel?
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Store Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: cardColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              onPressed: () {
                ref.refresh(storesProvider);
                ref.refresh(warehouseListProvider);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(storesProvider);
          ref.refresh(warehouseListProvider);
          await Future.wait([
            ref.read(storesProvider.future).catchError((_) {}),
            ref.read(warehouseListProvider.future).catchError((_) {}),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STORE INFO SECTION
              storeAsync.when(
                loading: () => const CardContainer(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (e, _) => CardContainer(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Colors.red[50],
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red[700], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Error loading store: $e',
                          style:
                              TextStyle(color: Colors.red[700], fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                data: (storeModel) {
                  final store =
                      (storeModel.data != null && storeModel.data!.isNotEmpty)
                          ? storeModel.data!.first
                          : null;
                  if (store == null) {
                    return const CardContainer(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Icon(Icons.store_outlined,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Store not found',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  final storeName = store.storeName ?? 'Unnamed Store';
                  final location = store.storeAddress ?? 'No address';
                  final phone = store.storePhone ?? 'N/A';
                  final email = store.storeEmail ?? 'N/A';
                  final website = store.website ?? store.website ?? '';
                  final city = store.storeCity ?? '';
                  final country = store.storeCountry ?? '';
                  final status = store.status ?? 'unknown';

                  return CardContainer(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.store_rounded,
                                color: accentColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    storeName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: status == 'active'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: status == 'active'
                                            ? Colors.green.withOpacity(0.3)
                                            : Colors.orange.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: status == 'active'
                                                ? Colors.green[600]
                                                : Colors.orange[600],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          status.toUpperCase(),
                                          style: TextStyle(
                                            color: status == 'active'
                                                ? Colors.green[700]
                                                : Colors.orange[700],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            InfoChip(
                              icon: Icons.location_on_rounded,
                              label: [location, city, country]
                                  .where((s) => s.isNotEmpty)
                                  .join(', '),
                            ),
                            InfoChip(
                              icon: Icons.phone_rounded,
                              label: phone,
                            ),
                            InfoChip(
                              icon: Icons.email_rounded,
                              label: email,
                            ),
                            if (website.isNotEmpty)
                              InfoChip(
                                icon: Icons.public_rounded,
                                label: 'Website',
                                isClickable: true,
                                onTap: () {
                                  // launch URL
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              // SUMMARY CARDS
              warehousesAsync.when(
                loading: () => const CardContainer(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (e, _) => CardContainer(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Colors.red[50],
                  child: Text(
                    'Failed to load warehouses: $e',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
                data: (warehouseModel) {
                  final warehouses = warehouseModel?.data ?? [];
                  final totalWarehouses = warehouses.length;
                  final activeWarehouses = warehouses
                      .where((w) => (w.status ?? '').toLowerCase() == 'active')
                      .length;
                  final inactiveWarehouses = totalWarehouses - activeWarehouses;

                  // Placeholder for total items; adapt to your actual data
                  final totalItems = warehouses.fold<int>(0, (prev, w) {
                    // suppose warehouse has itemCount field; otherwise adjust
                    // return prev + (w.itemCount ?? 0);
                    return 20;
                  });

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Total Warehouses',
                            value: totalWarehouses.toString(),
                            icon: Icons.warehouse_rounded,
                            IconColor: accentColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SummaryCard(
                            title: 'Active',
                            value: activeWarehouses.toString(),
                            icon: Icons.check_circle_rounded,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SummaryCard(
                            title: 'Inactive',
                            value: inactiveWarehouses.toString(),
                            icon: Icons.pause_circle_outline_rounded,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SummaryCard(
                            title: 'Total Items',
                            value: totalItems.toString(),
                            icon: Icons.inventory_2_rounded,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // WAREHOUSE LIST SECTION
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.warehouse_rounded,
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Warehouses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search bar for warehouses
              CardContainer(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(4),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search warehouses...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (v) => searchQuery.value = v.toLowerCase(),
                ),
              ),
              const SizedBox(height: 8),

              // Warehouse listing
              warehousesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (e, _) => CardContainer(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  backgroundColor: Colors.red[50],
                  child: Center(
                    child: Text(
                      'Error: $e',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ),
                data: (warehouseModel) {
                  final list = warehouseModel?.data ?? [];
                  final filtered = list.where((w) {
                    if (searchQuery.value.isEmpty) return true;
                    final name = w.warehouseName ?? '';
                    final type = w.warehouseType ?? '';
                    final address = w.address ?? '';
                    final searchable =
                        [name, type, address].join(' ').toLowerCase();
                    return searchable.contains(searchQuery.value);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const CardContainer(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warehouse_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No warehouses found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final warehouse = filtered[idx];
                      return WarehouseTile(
                        warehouse: warehouse,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? background;
  final Color? iconColor;
  final bool isClickable;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.background,
    this.iconColor,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isClickable
              ? Colors.blue.withOpacity(0.1)
              : background ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: isClickable
              ? Border.all(color: Colors.blue.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isClickable
                  ? Colors.blue[600]
                  : iconColor ?? Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isClickable ? Colors.blue[700] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final Color? IconColor;

  const SummaryCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      this.color,
      this.IconColor});

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Colors.blue;
    return CardContainer(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(12),
      backgroundColor: cardColor.withOpacity(0.1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: cardColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class WarehouseTile extends StatelessWidget {
  final dynamic warehouse; // replace with your typed model

  const WarehouseTile({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    final name = warehouse.warehouseName ?? 'Unnamed';
    final type = warehouse.warehouseType ?? '';
    final address = warehouse.address ?? '';
    final status = warehouse.status ?? '';

    return CardContainer(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle warehouse tap - navigate to warehouse details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.warehouse_rounded,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [type, address].where((s) => s.isNotEmpty).join(' • '),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: status.toLowerCase() == 'active'
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: status.toLowerCase() == 'active'
                          ? Colors.green[200]!
                          : Colors.orange[200]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: status.toLowerCase() == 'active'
                              ? Colors.green[600]
                              : Colors.orange[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: status.toLowerCase() == 'active'
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/features/store/view/warehouse_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/store/services/view_warehouse_service.dart';
import 'package:green_biller/features/store/view/store_page/shared/single_store_details.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WarehouseDetailScreen extends HookConsumerWidget {
  final String accessToken;
  final String storeId;

  const WarehouseDetailScreen({
    super.key,
    required this.accessToken,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouseAsync = ref.watch(warehouseByIdProvider(storeId));
    // final itemsAsync =
    //     ref.watch(warehouseItemsProvider(storeId)); // list of items
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Details'),
        backgroundColor: cardColor,
        foregroundColor: textPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(warehouseByIdProvider(storeId));
              // ref.refresh(warehouseItemsProvider(warehouseId));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(warehouseByIdProvider(storeId));
          // ref.refresh(warehouseItemsProvider(warehouseId));
          // await Future.wait([
          //   ref
          //       .read(warehouseByIdProvider(warehouseId).future)
          //       .catchError((_) {}),
          //   ref
          //       .read(warehouseItemsProvider(warehouseId).future)
          //       .catchError((_) {}),
          // ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // WAREHOUSE INFO + SUMMARY
            warehouseAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Error loading warehouse: $e')),
              data: (warehouseModel) {
                final warehouse = (warehouseModel.data != null &&
                        warehouseModel.data!.isNotEmpty)
                    ? warehouseModel.data!.first
                    : null;
                if (warehouse == null) {
                  return const Center(child: Text('Warehouse not found'));
                }

                final name = warehouse.warehouseName ?? 'Unnamed Warehouse';
                final type = warehouse.warehouseType ?? '—';
                final address = warehouse.address ?? 'No address';
                final mobile = warehouse.mobile ?? 'N/A';
                final email = warehouse.email ?? 'N/A';
                final status = (warehouse.status ?? 'unknown').toLowerCase();
                final storeId = warehouse.storeId;
                final storeLink = storeId != null
                    ? TextButton.icon(
                        onPressed: () {
                          if (storeId is int) {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => singleWarehouseProvider(
                            //       accessToken: accessToken,
                            //       storeId: storeId,
                            //     ),
                            //   ),
                            // );
                          }
                        },
                        icon: const Icon(Icons.store),
                        label: const Text('View Parent Store'),
                      )
                    : const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 12, runSpacing: 6, children: [
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
                      storeLink,
                    ]),
                    const SizedBox(height: 16),
                    // SUMMARY CARDS for items
                    // itemsAsync.when(
                    //   loading: () => const SizedBox(
                    //     height: 120,
                    //     child: Center(child: CircularProgressIndicator()),
                    //   ),
                    //   error: (e, _) => Text('Failed to load items: $e'),
                    //   data: (itemModel) {
                    //     final items = itemModel?.data ?? [];
                    //     final totalItems = items.length;
                    //     final activeItems = items
                    //         .where((i) =>
                    //             ((i.status ?? '').toLowerCase() == 'active'))
                    //         .length;
                    //     final inactiveItems = totalItems - activeItems;
                    //     final totalQuantity = items.fold<int>(0, (prev, i) {
                    //       final qty = i.quantity;
                    //       if (qty is int) return prev + qty;
                    //       if (qty is String)
                    //         return prev + (int.tryParse(qty) ?? 0);
                    //       return prev;
                    //     });

                    //     return Row(
                    //       children: [
                    //         Expanded(
                    //           child: SummaryCard(
                    //             title: 'Total Items',
                    //             value: totalItems.toString(),
                    //             icon: Icons.inventory_2,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 12),
                    //         Expanded(
                    //           child: SummaryCard(
                    //             title: 'Active',
                    //             value: activeItems.toString(),
                    //             icon: Icons.check_circle,
                    //             color: Colors.green,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 12),
                    //         Expanded(
                    //           child: SummaryCard(
                    //             title: 'Inactive',
                    //             value: inactiveItems.toString(),
                    //             icon: Icons.pause_circle_outline,
                    //             color: Colors.orange,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 12),
                    //         Expanded(
                    //           child: SummaryCard(
                    //             title: 'Total Quantity',
                    //             value: totalQuantity.toString(),
                    //             icon: Icons.scale,
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 24),
                    const Divider(),
                  ],
                );
              },
            ),

            // ITEMS LIST
            const Text(
              'Items',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: textLightColor),
                ),
              ),
              onChanged: (v) => searchQuery.value = v.toLowerCase(),
            ),
            const SizedBox(height: 12),
            // itemsAsync.when(
            //   loading: () => const Center(child: CircularProgressIndicator()),
            //   error: (e, _) => Center(child: Text('Error: $e')),
            //   data: (itemModel) {
            //     final list = itemModel?.data ?? [];
            //     final filtered = list.where((i) {
            //       if (searchQuery.value.isEmpty) return true;
            //       final name = (i.itemName ?? '').toString().toLowerCase();
            //       final sku = (i.sku ?? '').toString().toLowerCase();
            //       return [name, sku].join(' ').contains(searchQuery.value);
            //     }).toList();

            //     if (filtered.isEmpty) {
            //       return const Padding(
            //         padding: EdgeInsets.symmetric(vertical: 40),
            //         child: Center(child: Text('No items found')),
            //       );
            //     }

            //     return ListView.separated(
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemCount: filtered.length,
            //       separatorBuilder: (_, __) => const SizedBox(height: 8),
            //       itemBuilder: (context, index) {
            //         final item = filtered[index];
            //         final itemName = item.itemName ?? 'Unnamed';
            //         final sku = item.sku ?? '';
            //         final qty = item.quantity?.toString() ?? '0';
            //         final status = item.status ?? '';
            //         return Card(
            //           elevation: 1,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(12)),
            //           child: ListTile(
            //             leading: const Icon(Icons.inventory),
            //             title: Text(itemName),
            //             subtitle: Text('SKU: $sku'),
            //             trailing: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 Text('Qty: $qty'),
            //                 const SizedBox(height: 4),
            //                 Container(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 8, vertical: 4),
            //                   decoration: BoxDecoration(
            //                     color: status.toLowerCase() == 'active'
            //                         ? Colors.green.withOpacity(0.1)
            //                         : Colors.orange.withOpacity(0.1),
            //                     borderRadius: BorderRadius.circular(6),
            //                   ),
            //                   child: Text(
            //                     status.toUpperCase(),
            //                     style: TextStyle(
            //                       color: status.toLowerCase() == 'active'
            //                           ? Colors.green[800]
            //                           : Colors.orange[800],
            //                       fontSize: 10,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 )
            //               ],
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
          ]),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:greenbiller/core/colors.dart';
// import 'package:greenbiller/features/store/controller/store_warehouse_details_controller.dart';

// class WarehouseDetailScreen extends GetView<StoreWarehouseDetailsController> {
//   const WarehouseDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final searchController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Warehouse Details'),
//         backgroundColor: cardColor,
//         foregroundColor: textPrimaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               // controller.fetchWarehouseDetails();
//               // controller.fetchWarehouseItems();
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await Future.wait([
//             // controller.fetchWarehouseDetails(),
//             // controller.fetchWarehouseItems(),
//           ]);
//         },
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // WAREHOUSE INFO + SUMMARY
//               Obx(() {
//                 // if (controller.isLoadingWarehouse.value) {
//                 //   return const Center(child: CircularProgressIndicator());
//                 // }
//                 // if (controller.errorWarehouse.value.isNotEmpty) {
//                 //   return Center(child: Text('Error loading warehouse: ${controller.errorWarehouse.value}'));
//                 // }
//                 // final warehouseModel = controller.warehouseModel.value;
//                 // final warehouse = (warehouseModel?.data != null && warehouseModel!.data!.isNotEmpty)
//                 //     ? warehouseModel.data!.first
//                 //     : null;
//                 // if (warehouse == null) {
//                 //   return const Center(child: Text('Warehouse not found'));
//                 // }

//                 // final name = warehouse.warehouseName ?? 'Unnamed Warehouse';
//                 // final type = warehouse.warehouseType ?? '—';
//                 // final address = warehouse.address ?? 'No address';
//                 // final mobile = warehouse.mobile ?? 'N/A';
//                 // final email = warehouse.email ?? 'N/A';
//                 // final status = (warehouse.status ?? 'unknown').toLowerCase();
//                 // final storeId = warehouse.storeId;
//                 // final storeLink = storeId != null
//                 //     ? TextButton.icon(
//                 //         onPressed: () {
//                 //           if (storeId is int) {
//                 //             Get.to(() => const StorePage(), arguments: {
//                 //               'accessToken': controller.accessToken.value,
//                 //               'storeId': storeId.toString(),
//                 //             });
//                 //           }
//                 //         },
//                 //         icon: const Icon(Icons.store),
//                 //         label: const Text('View Parent Store'),
//                 //       )
//                 //     : const SizedBox.shrink();

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Wrap(
//                       spacing: 12,
//                       runSpacing: 6,
//                       children: [
//                         InfoChip(icon: Icons.category, label: type),
//                         InfoChip(icon: Icons.location_on, label: address),
//                         InfoChip(icon: Icons.phone, label: mobile),
//                         InfoChip(icon: Icons.email, label: email),
//                         InfoChip(
//                           icon: status == 'active' ? Icons.check_circle : Icons.error_outline,
//                           label: status.toUpperCase(),
//                           background: status == 'active' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
//                           iconColor: status == 'active' ? Colors.green[800] : Colors.orange[800],
//                         ),
//                         storeLink,
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     // SUMMARY CARDS for items
//                     Obx(() {
//                       if (controller.isLoadingItems.value) {
//                         return const SizedBox(
//                           height: 120,
//                           child: Center(child: CircularProgressIndicator()),
//                         );
//                       }
//                       if (controller.errorItems.value.isNotEmpty) {
//                         return Text('Failed to load items: ${controller.errorItems.value}');
//                       }
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: SummaryCard(
//                               title: 'Total Items',
//                               value: controller.totalItems.toString(),
//                               icon: Icons.inventory_2,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: SummaryCard(
//                               title: 'Active',
//                               value: controller.activeItems.toString(),
//                               icon: Icons.check_circle,
//                               color: Colors.green,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: SummaryCard(
//                               title: 'Inactive',
//                               value: controller.inactiveItems.toString(),
//                               icon: Icons.pause_circle_outline,
//                               color: Colors.orange,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: SummaryCard(
//                               title: 'Total Quantity',
//                               value: controller.totalQuantity.toString(),
//                               icon: Icons.scale,
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//                     const SizedBox(height: 24),
//                     const Divider(),
//                   ],
//                 );
//               }),

//               // ITEMS LIST
//               const Text(
//                 'Items',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search items...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(color: textLightColor),
//                   ),
//                 ),
//                 onChanged: controller.setSearchQuery,
//               ),
//               const SizedBox(height: 12),
//               Obx(() {
//                 if (controller.isLoadingItems.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (controller.errorItems.value.isNotEmpty) {
//                   return Center(child: Text('Error: ${controller.errorItems.value}'));
//                 }
//                 final filteredItems = controller.filteredItems;
//                 if (filteredItems.isEmpty) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 40),
//                     child: Center(child: Text('No items found')),
//                   );
//                 }

//                 return ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: filteredItems.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 8),
//                   itemBuilder: (context, index) {
//                     final item = filteredItems[index];
//                     final itemName = item.itemName ?? 'Unnamed';
//                     final sku = item.sku ?? '';
//                     final qty = item.quantity?.toString() ?? '0';
//                     final status = item.status ?? '';
//                     return Card(
//                       elevation: 1,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: ListTile(
//                         leading: const Icon(Icons.inventory),
//                         title: Text(itemName),
//                         subtitle: Text('SKU: $sku'),
//                         trailing: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text('Qty: $qty'),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: status.toLowerCase() == 'active'
//                                     ? Colors.green.withOpacity(0.1)
//                                     : Colors.orange.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 status.toUpperCase(),
//                                 style: TextStyle(
//                                   color: status.toLowerCase() == 'active' ? Colors.green[800] : Colors.orange[800],
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
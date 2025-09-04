import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/store/controller/store_details_controller.dart';

class StoreDetailScreen extends GetView<StoreDetailController> {
  final String accessToken;
  final int storeId;

  const StoreDetailScreen({
    super.key,
    required this.accessToken,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    controller.fetchStoreDetails(storeId);
    controller.fetchWarehouses();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Store Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
                controller.fetchStoreDetails(storeId);
                controller.fetchWarehouses();
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchStoreDetails(storeId);
          await controller.fetchWarehouses();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // STORE INFO SECTION
                  if (controller.isLoading.value)
                    const CardContainer(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    )
                  else if (controller.error.value.isNotEmpty)
                    CardContainer(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.red[50],
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Error loading store: ${controller.error.value}',
                              style: TextStyle(color: Colors.red[700], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (controller.store.value == null)
                    const CardContainer(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Icon(Icons.store_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Store not found', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  else
                    CardContainer(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  image: controller.store.value!.storeLogo != null
                                      ? DecorationImage(
                                          image: NetworkImage("$publicUrl/${controller.store.value!.storeLogo}"),
                                          fit: BoxFit.cover,
                                          onError: (exception, stackTrace) => const Icon(
                                            Icons.store_rounded,
                                            color: accentColor,
                                            size: 24,
                                          ),
                                        )
                                      : null,
                                ),
                                child: controller.store.value!.storeLogo == null
                                    ? const Icon(
                                        Icons.store_rounded,
                                        color: accentColor,
                                        size: 24,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.store.value!.storeName ?? 'Unnamed Store',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: controller.store.value!.status == 'active'
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: controller.store.value!.status == 'active'
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
                                              color: controller.store.value!.status == 'active'
                                                  ? Colors.green[600]
                                                  : Colors.orange[600],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            controller.store.value!.status!.toUpperCase(),
                                            style: TextStyle(
                                              color: controller.store.value!.status == 'active'
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
                              // InfoChip(
                              //   icon: Icons.location_on_rounded,
                              //   label: [
                              //     controller.store.value!.storeAddress ?? 'No address',
                              //     controller.store.value!.storeCity ?? '',
                              //     controller.store.value!.storeCountry ?? ''
                              //   ].where((s) => s.isNotEmpty).join(', '),
                              // ),
                              InfoChip(
                                icon: Icons.phone_rounded,
                                label: controller.store.value!.storePhone ?? 'N/A',
                              ),
                              InfoChip(
                                icon: Icons.email_rounded,
                                label: controller.store.value!.storeEmail ?? 'N/A',
                              ),
                              if (controller.store.value!.website != null &&
                                  controller.store.value!.website!.isNotEmpty)
                                InfoChip(
                                  icon: Icons.public_rounded,
                                  label: 'Website',
                                  isClickable: true,
                                  onTap: () {
                                    // Implement URL launch logic here
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  // SUMMARY CARDS
                  if (controller.isWarehouseLoading.value)
                    const CardContainer(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    )
                  else if (controller.warehouseError.value.isNotEmpty)
                    CardContainer(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.red[50],
                      child: Text(
                        'Failed to load warehouses: ${controller.warehouseError.value}',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'Total Warehouses',
                              value: controller.warehouses.length.toString(),
                              icon: Icons.warehouse_rounded,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SummaryCard(
                              title: 'Active',
                              value: controller.warehouses
                                  .where((w) => (w.status ?? '').toLowerCase() == 'active')
                                  .length
                                  .toString(),
                              icon: Icons.check_circle_rounded,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SummaryCard(
                              title: 'Inactive',
                              value: (controller.warehouses.length -
                                      controller.warehouses
                                          .where((w) => (w.status ?? '').toLowerCase() == 'active')
                                          .length)
                                  .toString(),
                              icon: Icons.pause_circle_outline_rounded,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SummaryCard(
                              title: 'Total Items',
                              // value: controller.warehouses
                              //     .fold<int>(0, (prev, w) => prev + (w.itemsCount ?? 0))
                              //     .toString(),
                              value:'sdfdsf',
                              icon: Icons.inventory_2_rounded,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // WAREHOUSES SECTION
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (controller.warehouses.isEmpty)
                    const CardContainer(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Icon(Icons.warehouse_outlined, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('No warehouses found', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.warehouses.length,
                      itemBuilder: (context, index) {
                        final warehouse = controller.warehouses[index];
                        return CardContainer(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.warehouse_rounded, color: accentColor),
                            ),
                            title: Text(
                              warehouse.warehouseName ?? 'Unnamed Warehouse',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (warehouse.address != null && warehouse.address!.isNotEmpty)
                                  Text(
                                    warehouse.address!,
                                    style: const TextStyle(color: textSecondaryColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  'Items: ${warehouse.itemsCount ?? 0}',
                                  style: const TextStyle(color: textSecondaryColor, fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: warehouse.status == 'active'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                warehouse.status.toUpperCase(),
                                style: TextStyle(
                                  color: warehouse.status == 'active' ? Colors.green[700] : Colors.red[700],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onTap: () {
                              // Get.to(() => WarehouseDetailScreen(
                              //       accessToken: accessToken,
                              //       storeId: warehouse.storeId!,
                              //     ));
                            },
                          ),
                        );
                      },
                    ),
                ],
              )),
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? backgroundColor;

  const CardContainer({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isClickable;
  final VoidCallback? onTap;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.isClickable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: textSecondaryColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: textSecondaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: textSecondaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

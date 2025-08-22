import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/item/services/item/recent_items_provider.dart';
import 'package:green_biller/features/item/view/pages/add_items_page/add_items_page.dart';
import 'package:green_biller/features/item/view/pages/all_items_page/all_items.dart';
import 'package:green_biller/features/item/view/pages/all_items_page/widgets/items_details_dialog.dart';
import 'package:green_biller/features/item/view/pages/brand/brand_page.dart';
import 'package:green_biller/features/item/view/pages/categories/categories_page.dart';
import 'package:green_biller/features/item/view/pages/units/units_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/controller/view_brand_controller.dart';

final viewAllItemsControllerProvider =
    Provider.family<ViewAllItemsController, String?>((ref, accessToken) {
  return ViewAllItemsController(accessToken: accessToken ?? '');
});

final viewBrandControllerProvider =
    Provider.family<ViewBrandController, String?>((ref, accessToken) {
  return ViewBrandController(accessToken: accessToken ?? '');
});

final dashboardDataProvider =
    FutureProvider.family<Map<String, dynamic>, String?>(
        (ref, accessToken) async {
  if (accessToken == null) throw Exception('No access token');

  final itemsController = ref.read(viewAllItemsControllerProvider(accessToken));
  final brandController = ref.read(viewBrandControllerProvider(accessToken));

  try {
    final results = await Future.wait([
      itemsController.getAllItems(null),
      brandController.viewBrandByIdController(0),
    ]);

    return {
      'items': results[0] as ItemModel,
      'brands': results[1] as List<Map<String?, String?>>,
    };
  } catch (e) {
    throw Exception('Failed to load dashboard data: $e');
  }
});

class ItemsPage extends HookConsumerWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessToken = ref.watch(userProvider)?.accessToken;
    final recentItemsAsync = ref.watch(recentItemsProvider);
    final dashboardAsync = ref.watch(dashboardDataProvider(accessToken));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "Items",
              style: AppTextStyles.h3,
            ),
            backgroundColor: Colors.white,
            foregroundColor: textPrimaryColor,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 16 : 24,
              horizontal: isSmallScreen ? 16 : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Cards with real data
                dashboardAsync.when(
                  loading: () => GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isSmallScreen
                        ? 2
                        : isMediumScreen
                            ? 3
                            : 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isSmallScreen ? 1.5 : 1.8,
                    children:
                        List.generate(4, (index) => _buildStatCardSkeleton()),
                  ),
                  error: (error, stack) => _buildErrorWidget(error.toString()),
                  data: (dashboardData) {
                    final items = dashboardData['items'] as ItemModel;
                    final brands =
                        dashboardData['brands'] as List<Map<String?, String?>>;
                    // Fix: Handle the warehouse data properly - it might be dynamic
                    final warehouses =
                        (dashboardData['warehouses'] as List<dynamic>?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            [];

                    final totalItems = items.data?.length ?? 0;
                    final lowStockItems = items.data?.where((item) {
                          final stock =
                              int.tryParse(item.openingStock ?? '0') ?? 0;
                          final alertQty =
                              int.tryParse(item.alertQuantity ?? '0') ?? 0;
                          return stock <= alertQty && stock > 0;
                        }).length ??
                        0;

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isSmallScreen
                          ? 2
                          : isMediumScreen
                              ? 3
                              : 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: isSmallScreen ? 1.5 : 1.8,
                      children: [
                        _buildStatCard(
                          "Total Items",
                          totalItems.toString(),
                          Icons.inventory,
                          accentColor,
                        ),
                        _buildStatCard(
                          "Low Stock",
                          lowStockItems.toString(),
                          Icons.warning_rounded,
                          warningColor,
                        ),
                        if (!isSmallScreen) ...[
                          _buildStatCard(
                            "Categories",
                            warehouses.length.toString(),
                            Icons.category_outlined,
                            successColor,
                          ),
                          _buildStatCard(
                            "Brands",
                            brands.length.toString(),
                            Icons.branding_watermark_outlined,
                            Colors.purple,
                          ),
                        ],
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),
                Text(
                  "Quick Actions",
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isSmallScreen
                      ? 2
                      : isMediumScreen
                          ? 3
                          : 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: isSmallScreen ? 1.2 : 1.5,
                  children: [
                    _buildActionCard(
                      context,
                      "Add Item",
                      Icons.add_circle_outline,
                      () {},
                      const AddItemsPage(),
                      LinearGradient(
                        colors: [accentColor, accentColor.withOpacity(0.8)],
                      ),
                    ),
                    _buildActionCard(
                      context,
                      "All Items",
                      Icons.miscellaneous_services,
                      () {},
                      const AllItemsPage(),
                      LinearGradient(
                        colors: [
                          secondaryColor,
                          secondaryColor.withOpacity(0.8)
                        ],
                      ),
                    ),
                    _buildActionCard(
                      context,
                      "Categories",
                      Icons.category_outlined,
                      () {},
                      const CategoriesPage(),
                      LinearGradient(
                        colors: [successColor, successColor.withOpacity(0.8)],
                      ),
                    ),
                    _buildActionCard(
                      context,
                      "Brands",
                      Icons.branding_watermark_outlined,
                      () {},
                      const BrandPage(),
                      LinearGradient(
                        colors: [warningColor, warningColor.withOpacity(0.8)],
                      ),
                    ),
                    _buildActionCard(
                      context,
                      "Units",
                      Icons.ad_units_sharp,
                      () {},
                      const UnitsPage(),
                      LinearGradient(
                        colors: [
                          const Color.fromARGB(207, 148, 1, 136),
                          const Color.fromARGB(86, 248, 82, 198)
                              .withOpacity(0.8),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recent Items",
                        style: AppTextStyles.h3.copyWith(fontSize: 18)),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AllItemsPage()),
                      ),
                      child: Text("View All",
                          style: AppTextStyles.labelLarge
                              .copyWith(color: accentColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                recentItemsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => _buildErrorWidget(err.toString()),
                  data: (items) {
                    if (items.isEmpty) {
                      return _buildEmptyState();
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isSmallScreen
                            ? 1
                            : isMediumScreen
                                ? 2
                                : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isSmallScreen ? 3 : 4,
                        mainAxisExtent: 100,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          _buildItemCard(context, items[index]),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemsPage()),
              );
            },
            backgroundColor: accentColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildStatCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 24,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            "Failed to load data",
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
          ),
          Text(
            error,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "No data found",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatCard(String label, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.statNumber.copyWith(color: color),
        ),
      ],
    ),
  );
}

Widget _buildActionCard(
  BuildContext context,
  String label,
  IconData icon,
  Function function,
  Widget? route,
  LinearGradient gradient,
) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: route != null
          ? () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => route))
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildItemCard(BuildContext context, Item item) {
  return InkWell(
    onTap: () {
      showItemDetailsDialog(
        context: context,
        itemId: item.id.toString(),
        itemName: item.itemName,
        itemCode: item.itemCode,
        barcode: item.barcode,
        categoryName: item.categoryName,
        brandName: item.brandName,
        storeName: item.storeName,
        stock: int.tryParse(item.openingStock ?? '0') ?? 0,
        price: double.tryParse(item.salesPrice ?? '0') ?? 0.0,
        mrp: item.mrp,
        unit: item.unit,
        sku: item.sku,
        profitMargin: double.tryParse(item.profitMargin ?? '0') ?? 0.0,
        taxRate: double.tryParse(item.taxRate ?? '0') ?? 0.0,
        taxType: item.taxType,
        discountType: item.discountType,
        discount: item.discount,
        alertQuantity: item.alertQuantity,
        imageUrl: item.itemImage,
      );
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5)
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: accentColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.itemName ?? 'Unnamed Item',
                  style: AppTextStyles.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "In Stock: ${item.openingStock ?? '0'}",
                        style: AppTextStyles.bodySmall
                            .copyWith(color: successColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "SKU: ${item.sku ?? 'N/A'}",
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${item.salesPrice ?? '0'}",
                style: AppTextStyles.bodyLarge
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "GST: ${item.taxRate ?? '0'}%",
                style:
                    AppTextStyles.bodySmall.copyWith(color: textSecondaryColor),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

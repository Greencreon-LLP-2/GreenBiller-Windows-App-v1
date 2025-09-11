import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/view/login_page.dart';
import 'package:greenbiller/features/items/controller/items_dashboard_controller.dart';
import 'package:greenbiller/features/items/model/items_insights_model.dart';

import 'package:greenbiller/features/items/views/brands/brand_page.dart';
import 'package:greenbiller/features/items/views/category/categories_page.dart';
import 'package:greenbiller/features/items/views/items/add_items_page.dart';
import 'package:greenbiller/features/items/views/items/all_items_page.dart';
import 'package:greenbiller/features/items/views/units/units_page.dart';
import 'package:greenbiller/routes/app_routes.dart';

class ItemsDashboardPage extends StatelessWidget {
  const ItemsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemsDashboardController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Items Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: textPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 18),
            onPressed: controller.fetchDashboardData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Overview Section
            Text(
              "Overview",
              style: AppTextStyles.h1.copyWith(
                fontSize: 22,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildStatCard(
                  "Total Items",
                  controller.totalItems.toString(),
                  Icons.inventory,
                  accentColor,
                ),
                _buildStatCard(
                  "Total Categories",
                  controller.totalCategories.toString(),
                  Icons.category,
                  accentColor,
                ),
                _buildStatCard(
                  "Total Brands",
                  controller.totalBrands.toString(),
                  Icons.branding_watermark,
                  accentColor,
                ),
                _buildStatCard(
                  "Total Units",
                  controller.totalUnits.toString(),
                  Icons.ad_units,
                  accentColor,
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Quick Actions Section
            Text(
              "Quick Actions",
              style: AppTextStyles.h1.copyWith(
                fontSize: 22,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 5,
              childAspectRatio: 2.5,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              children: [
                _buildActionCard(
                  "Add Item",
                  Icons.add_circle_outline,
                  AppRoutes.addItems,
                ),
                _buildActionCard("All Items", Icons.list, AppRoutes.viewItems),
                _buildActionCard(
                  "Categories",
                  Icons.category_outlined,
                  AppRoutes.categories,
                ),
                _buildActionCard(
                  "Brands",
                  Icons.branding_watermark_outlined,
                  AppRoutes.brands,
                ),
                _buildActionCard("Units", Icons.ad_units, AppRoutes.units),
              ],
            ),
            const SizedBox(height: 14),
            // Recent Brands Section
            Text(
              "Recent Brands",
              style: AppTextStyles.h2.copyWith(
                fontSize: 22,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            controller.brands.isEmpty
                ? _buildEmptyState("No brands found")
                : Column(
                    children: controller.brands
                        .take(3)
                        .map((brand) => _buildBrandCard(brand))
                        .toList(),
                  ),
            const SizedBox(height: 14),
            // Recent Categories Section
            Text(
              "Recent Categories",
              style: AppTextStyles.h2.copyWith(
                fontSize: 22,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            controller.categories.isEmpty
                ? _buildEmptyState("No categories found")
                : Column(
                    children: controller.categories
                        .take(3)
                        .map((category) => _buildCategoryCard(category))
                        .toList(),
                  ),
            const SizedBox(height: 14),
            // Recent Units Section
            Text(
              "Recent Units",
              style: AppTextStyles.h2.copyWith(
                fontSize: 22,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),
            controller.units.isEmpty
                ? _buildEmptyState("No units found")
                : Column(
                    children: controller.units
                        .take(3)
                        .map((unit) => _buildUnitCard(unit))
                        .toList(),
                  ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(String message) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline, size: 24, color: Colors.grey),
        const SizedBox(height: 4),
        Text(message, style: AppTextStyles.bodyMedium.copyWith(fontSize: 13)),
      ],
    ),
  );

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            offset: const Offset(2, 2),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(-2, -2),
            blurRadius: 5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String label, IconData icon, String route) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accentColor, accentColor.withOpacity(0.5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandCard(InsightsBrand brand) {
    return InkWell(
      onTap: () => Get.to(() => const BrandPage()), // Navigate to brand details
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              spreadRadius: 0.5,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.branding_watermark_outlined,
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.brandName ?? 'Unnamed Brand',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Code: ${brand.brandCode ?? 'N/A'}",
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              brand.status == 1 ? 'Active' : 'Inactive',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: brand.status == 1 ? accentColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(InsightsCategory category) {
    return InkWell(
      onTap: () =>
          Get.to(() => const CategoriesPage()), // Navigate to category details
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              spreadRadius: 0.5,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.category_outlined,
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.categoryName ?? 'Unnamed Category',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Code: ${category.categoryCode ?? 'N/A'}",
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              category.status == 1 ? 'Active' : 'Inactive',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: category.status == 1 ? accentColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard(InsightsUnits unit) {
    return InkWell(
      onTap: () => Get.to(() => const UnitsPage()), // Navigate to unit details
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              spreadRadius: 0.5,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.ad_units, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.unitName ?? 'Unnamed Unit',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Value: ${unit.unitValue ?? 'N/A'}",
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              unit.status ?? 'N/A',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: unit.status == '1' ? accentColor : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

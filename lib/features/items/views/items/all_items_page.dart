import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/items/controller/all_items_controller.dart';
import 'package:greenbiller/features/items/views/items/add_items_page.dart';
import 'package:greenbiller/features/items/views/items/item_gridview_card_widget.dart';

class AllItemsPage extends GetView<AllItemsController> {
  const AllItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Items',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(
            () => Tooltip(
              message: controller.importedFile.value != null
                  ? 'Open ${controller.importedFile.value!['name']}'
                  : 'No file selected',
              child: TextButton(
                onPressed: controller.openFile,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  minimumSize: WidgetStateProperty.all(const Size(0, 0)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.white.withOpacity(0.2);
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.white.withOpacity(0.3);
                    }
                    return null;
                  }),
                  backgroundColor: WidgetStateProperty.all(
                    controller.importedFile.value != null
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.1),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.importedFile.value != null) ...[
                      const Icon(
                        Icons.insert_drive_file,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        controller.importedFile.value != null
                            ? controller.importedFile.value!['name']
                            : 'No File',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: controller.importedFile.value != null
                              ? Colors.white
                              : Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: controller.pickFile,
            tooltip: 'Import Items',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const AddItemsPage()),
            tooltip: 'Add New Item',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Obx(
                  () => controller.importedFile.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ElevatedButton.icon(
                            onPressed: controller.isProcessing.value
                                ? null
                                : controller.processImportedFile,
                            icon: controller.isProcessing.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.upload_file),
                            label: const Text('Process Imported File'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: controller.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: textSecondaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: textSecondaryColor,
                        ),
                        onPressed: () {
                          searchController.clear();
                          controller.clearSearchQuery();
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AppDropdown(
                          label: "Store",
                          placeHolderText: 'Select Store',
                          selectedValue: controller
                              .storeDropdownController
                              .selectedStoreId,
                          options: controller.storeDropdownController.storeMap,
                          isLoading: controller
                              .storeDropdownController
                              .isLoadingStores,
                          onChanged: (val) async {
                            if (val != null) {
                              await controller.fetchItems();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedCategory.value,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: textSecondaryColor,
                              ),
                              style: const TextStyle(color: textPrimaryColor),
                              items: controller.categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  controller.setSelectedCategory(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedSort.value,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: textSecondaryColor,
                            ),
                            style: const TextStyle(color: textPrimaryColor),
                            items: controller.sortOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                controller.setSelectedSort(newValue);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: Obx(() => _buildGridView(context))),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              controller.error.value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Failed to load items. Please try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    if (controller.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No items found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'No items available for the selected store.\nPlease add some items to get started.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        const double minCardWidth = 300;
        int crossAxisCount = (screenWidth / minCardWidth).floor().clamp(1, 4);

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ItemGridViewCardWidget(
              itemId: item.id.toString(),
              stock: item.openingStock,
              itemName: item.itemName,
              itemCode: item.itemCode,
              barcode: item.barcode,
              category: item.categoryId ?? 0,
              brand: item.brandId ?? 0,
              price: double.tryParse(item.salesPrice) ?? 0.0,
              mrp: item.mrp,
              unit: item.unit,
              sku: item.sku,
              profitMargin: double.tryParse(item.profitMargin) ?? 0.0,
              taxRate: double.tryParse(item.taxRate) ?? 0.0,
              taxType: item.taxType,
              discountType: item.discountType,
              discount: item.discount,
              alertQuantity: item.alertQuantity,
              onRefresh: controller.fetchItems,
              brandName: item.brandName,
              storeName: item.storeName,
              categoryName: item.categoryName,
              imageUrl: item.itemImage,
            );
          },
        );
      },
    );
  }
}

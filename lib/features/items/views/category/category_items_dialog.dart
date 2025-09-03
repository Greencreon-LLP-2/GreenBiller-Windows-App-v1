import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/items/controller/category_controller.dart';
import 'package:greenbiller/features/items/controller/category_items_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';

class CategoryItemsDialog extends GetView<CategoryItemsController> {
  final String categoryName;
  final int categoryId;

  const CategoryItemsDialog({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(CategoryItemsController());
    controller.loadItems(categoryId.toString());

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Get.find<CategoryController>().getCategoryIcon(categoryName),
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
                        categoryName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      Obx(() => Text(
                            '${controller.filteredItems.length} items',
                            style: TextStyle(fontSize: 14, color: textSecondaryColor.withOpacity(0.8)),
                          )),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search items...',
                        hintStyle: TextStyle(color: textLightColor),
                        prefixIcon: Icon(Icons.search, color: textSecondaryColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Obx(() => DropdownButton<String>(
                        value: controller.selectedFilter.value,
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All Items')),
                          DropdownMenuItem(value: 'Active', child: Text('Active')),
                          DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                          DropdownMenuItem(value: 'In Stock', child: Text('In Stock')),
                          DropdownMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
                        ],
                        onChanged: (value) => controller.selectedFilter.value = value!,
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down, color: textSecondaryColor),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: accentColor));
                }
                if (controller.filteredItems.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  itemCount: controller.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredItems[index];
                    return _buildItemCard(item);
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close', style: TextStyle(color: textSecondaryColor)),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    // Navigate to add item page with category pre-selected
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Item item) {
    final isActive = item.status == 1;
    final stock = int.tryParse(item.openingStock) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.itemImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.itemImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory, color: accentColor),
                    ),
                  )
                : const Icon(Icons.inventory, color: accentColor, size: 24),
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
                        item.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: textPrimaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.sku,
                  style: TextStyle(fontSize: 12, color: textSecondaryColor.withOpacity(0.8)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.salesPrice}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: accentColor),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stock > 0 ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: $stock',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: stock > 0 ? Colors.blue : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textSecondaryColor.withOpacity(0.6)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(children: [
                  Icon(Icons.visibility, size: 18, color: accentColor),
                  SizedBox(width: 8),
                  Text('View Details'),
                ]),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Icons.edit, size: 18, color: accentColor),
                  SizedBox(width: 8),
                  Text('Edit'),
                ]),
              ),
              PopupMenuItem(
                value: isActive ? 'deactivate' : 'activate',
                child: Row(children: [
                  Icon(
                    isActive ? Icons.block : Icons.check_circle,
                    size: 18,
                    color: isActive ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(isActive ? 'Deactivate' : 'Activate'),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete'),
                ]),
              ),
            ],
            onSelected: (value) => controller.handleItemAction(value, item),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: textSecondaryColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textSecondaryColor.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchController.text.isNotEmpty ? 'Try adjusting your search terms' : 'Add items to this category to see them here',
            style: TextStyle(fontSize: 14, color: textSecondaryColor.withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              // Navigate to add item page
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add First Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
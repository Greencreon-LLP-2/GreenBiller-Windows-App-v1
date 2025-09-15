import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';

import 'package:greenbiller/features/items/controller/category_controller.dart';
import 'package:greenbiller/features/items/views/category/category_items_dialog.dart';

class CategoriesPage extends GetView<CategoryController> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.category, color: accentColor, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: controller.pickFile,
            tooltip: 'Upload File',
          ),

          // Download Template Button
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: controller.downloadTemplate, // add method below
            tooltip: 'Download Template',
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(
            () => controller.importedFile.value != null
                ? Padding(
                    padding: EdgeInsets.all(isDesktop ? 24 : 16),
                    child: Column(
                      children: [
                        Obx(() {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected File:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.importedFile.value?['name'],
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 32,
                                      color: Colors.red,
                                      onPressed: () {
                                        controller.importedFile.value = null;
                                        controller
                                                .selectedStoreIdForFileUpload
                                                .value =
                                            null;
                                      },
                                      icon: Icon(Icons.clear),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                        Row(
                          children: [
                            Expanded(
                              child: AppDropdown(
                                label: "Store to upload",
                                placeHolderText: 'Choose Store to upload',
                                selectedValue: controller
                                    .storeDropdownController
                                    .selectedStoreId,
                                options:
                                    controller.storeDropdownController.storeMap,
                                isLoading: controller
                                    .storeDropdownController
                                    .isLoadingStores,
                                onChanged: (val) async {
                                  if (val != null) {
                                    controller
                                            .selectedStoreIdForFileUpload
                                            .value =
                                        val;
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: controller.isProcessing.value
                                    ? null
                                    : controller.processImportedFile,
                                icon: controller.isProcessing.value
                                    ? const SizedBox(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Icon(Icons.upload_file),
                                label: const Text('Process Imported File'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(double.infinity, 55),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: MediaQuery.of(context).size.width < 600
                ? Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.showAddCategoryDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Category'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildFilterDropdown(),
                    ],
                  )
                : Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.showAddCategoryDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Category'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSearchBar()),
                      const SizedBox(width: 16),
                      _buildFilterDropdown(),
                    ],
                  ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.filteredCategories.length} Categories',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimaryColor,
                    ),
                  ),
                  if (controller.searchController.text.isNotEmpty)
                    Text(
                      'Filtered results',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondaryColor.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: accentColor),
                      SizedBox(height: 16),
                      Text('Loading categories...'),
                    ],
                  ),
                );
              }
              if (controller.categories.value?.status != 1 ||
                  controller.filteredCategories.isEmpty) {
                return const Center(child: Text('No categories found'));
              }
              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 6 : (isTablet ? 4 : 2),
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.filteredCategories[index];
                  final colors = controller.getCategoryColors(
                    category.name ?? 'Unknown',
                  );
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors['border']!.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (category.id != null) {
                            Get.dialog(
                              CategoryItemsDialog(
                                categoryName: category.name ?? 'Unknown',
                                categoryId: category.id!,
                              ),
                            );
                          }
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: colors['background'],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        controller.getCategoryIcon(
                                          category.name ?? 'Unknown',
                                        ),
                                        color: colors['primary'],
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      category.name ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: textPrimaryColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category.id.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 20, 20, 20),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors['background'],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${category.itemCount} items',
                                        style: TextStyle(
                                          color: colors['primary'],
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.more_vert,
                                  color: textSecondaryColor.withOpacity(0.6),
                                  size: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: accentColor,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    // Implement edit functionality if needed
                                  } else if (value == 'delete') {
                                    controller.deleteCategory(
                                      category.id.toString(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: const TextStyle(color: textLightColor),
          prefixIcon: const Icon(Icons.search, color: textSecondaryColor),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: textSecondaryColor),
            onPressed: () => controller.searchController.clear(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return SizedBox(
      width: 200, // ✅ fixes unbounded width
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Obx(
          () => DropdownButton<String>(
            value: controller.selectedFilter.value,
            isExpanded: true, // ✅ fine now, inside SizedBox
            items: const [
              DropdownMenuItem(value: 'All', child: Text('All Categories')),
              DropdownMenuItem(value: 'Active', child: Text('Active')),
              DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
            ],
            onChanged: (value) => controller.selectedFilter.value = value!,
            style: const TextStyle(color: textPrimaryColor),
            underline: SizedBox.shrink(),
            icon: const Icon(Icons.arrow_drop_down, color: textSecondaryColor),
          ),
        ),
      ),
    );
  }
}

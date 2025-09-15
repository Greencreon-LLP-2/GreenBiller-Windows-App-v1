import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/items/controller/brand_controller.dart';

class BrandPage extends GetView<BrandController> {
  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Brands',
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
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: controller.showAddBrandDialog,
            tooltip: 'Add Brand',
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop)
            Container(
              width: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Brands',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Total Brands',
                    style: TextStyle(fontSize: 14, color: textSecondaryColor),
                  ),
                  Obx(
                    () => Text(
                      controller.brands.length.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: controller.showAddBrandDialog,
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add New Brand'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Column(
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
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              controller
                                                  .importedFile
                                                  .value?['name'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            iconSize: 32,
                                            color: Colors.red,
                                            onPressed: () {
                                              controller.importedFile.value =
                                                  null;
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
                                      options: controller
                                          .storeDropdownController
                                          .storeMap,
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
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Icon(Icons.upload_file),
                                      label: const Text(
                                        'Process Imported File',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: accentColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          double.infinity,
                                          55,
                                        ),
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
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: accentLightColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search brands...',
                              hintStyle: const TextStyle(color: textLightColor),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: textSecondaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: textSecondaryColor,
                                ),
                                onPressed: () =>
                                    controller.searchController.clear(),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isDesktop) ...[
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: 'All',
                          items: const [
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All Brands'),
                            ),
                            DropdownMenuItem(
                              value: 'Active',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: 'Inactive',
                              child: Text('Inactive'),
                            ),
                          ],
                          onChanged: (value) {},
                          style: const TextStyle(color: textPrimaryColor),
                          underline: Container(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.brands.isEmpty) {
                      return const Center(child: Text('No brands found'));
                    }
                    return isDesktop ? _buildDesktopView() : _buildMobileView();
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView() {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Brand Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Store ID',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: controller.brands.length,
            itemBuilder: (context, index) {
              final brand = controller.brands[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          brand.brandName ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            color: textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Text(
                          brand.storeId ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: textSecondaryColor.withOpacity(0.7),
                          size: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18, color: accentColor),
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
                            controller.deleteBrand(brand.id.toString());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.brands.length,
      itemBuilder: (context, index) {
        final brand = controller.brands[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Text(
                    brand.brandName ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 14,
                  ),
                  child: Text(
                    'Store: ${brand.storeId}',
                    style: const TextStyle(
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: textSecondaryColor.withOpacity(0.7),
                    size: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: accentColor),
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
                      controller.deleteBrand(brand.id.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

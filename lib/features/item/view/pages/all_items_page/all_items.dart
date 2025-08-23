import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/add_item_controller.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/view/pages/add_items_page/add_items_page.dart';
import 'package:green_biller/features/item/view/pages/all_items_page/widgets/item_gridview_card_widget.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/store_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';

final refreshItemsProvider = StateProvider<int>((ref) => 0);

class AllItemsPage extends HookConsumerWidget {
  const AllItemsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final accessToken = ref.watch(userProvider)?.accessToken!;
    final isGridView = useState(false);
    final selectedCategory = useState('All');
    final selectedSort = useState('Name (A-Z)');
    final selectedStore = useState<String?>(null);
    final userId = ref.watch(userProvider)?.user?.id!;
    final refreshKey = ref.watch(refreshItemsProvider);
    final _logger = useMemoized(() => Logger(), []);
    final _importedFile = useState<Map<String, dynamic>?>(null);
    final _isProcessing = useState(false);

    final categories = [
      'All',
      'Electronics',
      'Clothing',
      'Food',
      'Office Supplies',
    ];

    final sortOptions = [
      'Name (A-Z)',
      'Name (Z-A)',
      'Price (Low to High)',
      'Price (High to Low)',
      'Stock (Low to High)',
      'Stock (High to Low)',
    ];

    Future<void> _pickFile() async {
      try {
        _logger.d('Opening file picker for Excel/CSV');
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls', 'csv'],
        );

        if (result != null &&
            result.files.single.name != null &&
            result.files.single.path != null) {
          final filePath = result.files.single.path!;
          final file = File(filePath);
          if (await file.exists()) {
            _importedFile.value = {
              'name': result.files.single.name,
              'file': file,
            };
            _logger.i(
                'File selected: ${_importedFile.value!['name']} at path: $filePath');
          } else {
            _logger.w('File does not exist at path: $filePath');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selected file does not exist'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          _logger.w('No file selected');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file selected'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        _logger.e('Error picking file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    Future<void> _openFile() async {
      if (_importedFile.value != null && _importedFile.value!['file'] != null) {
        try {
          final file = _importedFile.value!['file'] as File;
          final filePath = file.path;
          _logger.d(
              'Attempting to open file: ${_importedFile.value!['name']} at path: $filePath');

          if (await file.exists()) {
            final result = await OpenFile.open(filePath);
            if (result.type != ResultType.done) {
              _logger.w('Failed to open file: ${result.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to open file: ${result.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              _logger.i(
                  'File opened successfully: ${_importedFile.value!['name']}');
            }
          } else {
            _logger.w('File does not exist at path: $filePath');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File does not exist'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          _logger.e('Error opening file: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error opening file: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        _logger.w('No file to open');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected to open'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    Future<void> _processImportedFile() async {
      if (_importedFile.value == null || _isProcessing.value) return;

      _isProcessing.value = true;
      try {
        final file = _importedFile.value!['file'] as File;
        final storeId = selectedStore.value; // Use the selected store

        if (storeId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a store before importing'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }



        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Items imported successfully'),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(refreshItemsProvider.notifier).state++; // Trigger refresh
      } catch (e) {
        _logger.e('Error processing imported file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing items: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        _isProcessing.value = false;
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Items',
          
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20,color: Colors.white),
        ),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Tooltip(
            message: _importedFile.value != null &&
                    _importedFile.value!['name'] != null
                ? 'Open ${_importedFile.value!['name']}'
                : 'No file selected',
            child: TextButton(
              onPressed: _openFile,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.white.withOpacity(0.2);
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.white.withOpacity(0.3);
                    }
                    return null;
                  },
                ),
                backgroundColor: MaterialStateProperty.all(
                  _importedFile.value != null &&
                          _importedFile.value!['name'] != null
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.1),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_importedFile.value != null &&
                      _importedFile.value!['name'] != null) ...[
                    const Icon(
                      Icons.insert_drive_file,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      _importedFile.value != null &&
                              _importedFile.value!['name'] != null
                          ? _importedFile.value!['name']
                          : 'No File',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _importedFile.value != null &&
                                _importedFile.value!['name'] != null
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
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: _pickFile,
            tooltip: 'Import Items',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddItemsPage(),
                ),
              );
            },
            tooltip: 'Add New Item',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
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
                // Import Button
                // if (_importedFile.value != null)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 16),
                //     child: ElevatedButton.icon(
                //       onPressed:
                //           _isProcessing.value ? null : _processImportedFile,
                //       icon: _isProcessing.value
                //           ? const SizedBox(
                //               width: 20,
                //               height: 20,
                //               child: CircularProgressIndicator(
                //                 strokeWidth: 2,
                //                 valueColor:
                //                     AlwaysStoppedAnimation<Color>(Colors.white),
                //               ),
                //             )
                //           : const Icon(Icons.upload_file),
                //       label: const Text('Process Imported File'),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: accentColor,
                //         foregroundColor: Colors.white,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         minimumSize: const Size(double.infinity, 48),
                //       ),
                //     ),
                //   ),
                // Search Bar
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
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon:
                          const Icon(Icons.search, color: textSecondaryColor),
                      suffixIcon: IconButton(
                        icon:
                            const Icon(Icons.clear, color: textSecondaryColor),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter and Sort Row
                Row(
                  children: [
                    // Store Dropdown
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
                        child: StoreDropdown(
                          value: selectedStore.value ?? 'Select Store',
                          onChanged: (newValue) {
                            if (newValue != null &&
                                newValue != 'Select Store') {
                              selectedStore.value = newValue;
                            } else {
                              selectedStore.value = null;
                            }
                          },
                          onStoreIdChanged: (storeId) {
                            if (storeId != null) {
                              print('Selected store ID: $storeId');
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Category Filter
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory.value,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: textSecondaryColor),
                            style: const TextStyle(color: textPrimaryColor),
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                selectedCategory.value = newValue;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort Dropdown
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort.value,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: textSecondaryColor),
                          style: const TextStyle(color: textPrimaryColor),
                          items: sortOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedSort.value = newValue;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Items List/Grid
          Expanded(
            child: _buildGridView(context, accessToken!, selectedStore.value,
                userId.toString(), refreshKey, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, String accessToken,
      String? storeId, String userId, int refreshKey, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        const double minCardWidth = 200;
        int crossAxisCount = (screenWidth / minCardWidth).floor().clamp(1, 5);

        return FutureBuilder(
          future: ViewAllItemsController(accessToken: accessToken)
              .getAllItems(storeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null &&
                snapshot.data!.status == 0) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No items found",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No items available for the selected store.\nPlease add some items to get started.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: snapshot.data?.data.length ?? 5,
              itemBuilder: (context, index) {
                final itemId = snapshot.data?.data[index].id.toString() ?? '';
                final itemName = snapshot.data?.data[index].itemName ?? '';
                final category = snapshot.data?.data[index].categoryId ?? 0;
                final stock = snapshot.data?.data[index].openingStock ?? 0;
                final price = snapshot.data?.data[index].salesPrice ?? 0;
                final mrp = snapshot.data?.data[index].mrp ?? '00000';
                final profitMargin =
                    snapshot.data?.data[index].profitMargin ?? 0;
                final taxRate = snapshot.data?.data[index].taxRate ?? 0;
                final unit = snapshot.data?.data[index].unit ?? '11100';
                final sku = snapshot.data?.data[index].sku ?? '11111';
                final brand = snapshot.data?.data[index].brandId ?? 0;
                final itemCode =
                    snapshot.data?.data[index].itemCode ?? '000000';
                final barcode = snapshot.data?.data[index].barcode ?? '000000';
                final taxType = snapshot.data?.data[index].taxType ?? 'none';
                final imageUrl = snapshot.data?.data[index].itemImage;
                final categoryName =
                    snapshot.data?.data[index].categoryName ?? '';
                final brandName = snapshot.data?.data[index].brandName ?? '';
                final storeName = snapshot.data?.data[index].storeName ?? '';
                final storeId = snapshot.data?.data[index].storeId;
                final discountType =
                    snapshot.data?.data[index].discountType ?? '';
                final discount = snapshot.data?.data[index].discount ?? '0';
                final alertQuantity =
                    snapshot.data?.data[index].alertQuantity ?? '0';
                return ItemGridViewCardWidget(
                  accessToken: accessToken,
                  storeId: storeId.toString(),
                  userId: userId,
                  itemId: itemId,
                  stock: stock,
                  itemName: itemName,
                  itemCode: itemCode,
                  barcode: barcode,
                  category: category,
                  brand: brand,
                  price: price,
                  mrp: mrp,
                  unit: unit,
                  sku: sku,
                  profitMargin: profitMargin,
                  taxRate: taxRate,
                  taxType: taxType,
                  discountType: discountType,
                  discount: discount,
                  alertQuantity: alertQuantity,
                  onRefresh: () {
                    ref.read(refreshItemsProvider.notifier).state++;
                  },
                  brandName: brandName,
                  storeName: storeName,
                  categoryName: categoryName,
                  imageUrl: imageUrl,
                );
              },
            );
          },
        );
      },
    );
  }
}

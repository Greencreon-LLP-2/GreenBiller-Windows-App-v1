import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/view/pages/add_items_page/add_items_page.dart';
import 'package:green_biller/features/item/view/pages/all_items_page/widgets/item_gridview_card_widget.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/store_dropdown.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Items',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
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

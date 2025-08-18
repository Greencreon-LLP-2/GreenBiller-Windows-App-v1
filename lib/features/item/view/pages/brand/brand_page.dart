import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/add_brand_controller.dart';
import 'package:green_biller/features/item/model/brand/brand_item.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/model/store_model/store_model.dart'
    as store_model;
import 'package:green_biller/features/store/services/view_store_service.dart';
import 'package:green_biller/utils/dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BrandPage extends HookConsumerWidget {
  const BrandPage({super.key});

  Future<List<String>> getStoreList(storeService) async {
    try {
      final storeModel = await storeService;

      List<String> storeList = [];
      if (storeModel.data != null) {
        for (var store in storeModel.data!) {
          if (store.storeName != null) {
            storeList.add(store.storeName!);
          }
        }
      }
      ('Store list created: $storeList');
      return storeList;
    } catch (e) {
      print('Error in getStoreList: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final user = ref.watch(userProvider);
    final storesAsync = ref.watch(storesProvider);
    final accessToken = user?.accessToken;
    final userId = user?.user?.id.toString();
    final storeService = viewStoreService(accessToken!);

    final isLoading = useState(true);
    final refreshKey = useState(0);
    useEffect(() {
      print('Access token available, fetching stores...');
      isLoading.value = true;
      getStoreList(storeService).then((stores) {
        print('Stores fetched successfully: $stores');

        isLoading.value = false;
      }).catchError((error) {
        print('Error loading stores: $error');
        isLoading.value = false;
      });
      return null;
    }, [accessToken]);

    final brands = useState<List<String>>([
      // 'Nike',
      // 'Adidas',
      // 'Apple',
      // 'Samsung',
      // 'Sony',
      // 'LG',
      // 'Dell',
      // 'HP',
      // 'Lenovo',
      // 'Asus',
    ]);

    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final isTablet = MediaQuery.of(context).size.width > 600;

    // Function to refresh brand data
    void refreshBrands() {
      refreshKey.value++;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Brands',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textPrimaryColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder(
                  future: getStoreList(storeService),
                  builder: (context, snapshot) {
                    return ElevatedButton.icon(
                      onPressed: () => _showAddBrandDialog(
                          context,
                          isLoading, // ValueNotifier<bool>
                          accessToken, // String
                          userId!, // String
                          refreshBrands, // VoidCallback
                          storeService // dynamic
                          ,
                          ref),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Add Brand'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    );
                  }),
            )
          else
            Builder(builder: (context) {
              return FutureBuilder(
                  future: getStoreList(storeService),
                  builder: (context, snapshot) {
                    return IconButton(
                      icon: const Icon(Icons.add, color: textPrimaryColor),
                      onPressed: () => _showAddBrandDialog(
                          context,
                          isLoading,
                          accessToken,
                          userId!,
                          refreshBrands,
                          storeService,
                          ref),
                      tooltip: 'Add Brand',
                    );
                  });
            })
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
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondaryColor,
                    ),
                  ),
                  FutureBuilder<List<BrandItem>>(
                    key: ValueKey(refreshKey.value),
                    future: ViewBrandController(accessToken: accessToken)
                        .viewBrandController(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          '...',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        );
                      }
                      return Text(
                        (snapshot.data?.length ?? 0).toString(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  FutureBuilder(
                      future: getStoreList(storeService),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ElevatedButton.icon(
                            onPressed: () => _showAddBrandDialog(
                                context,
                                isLoading,
                                accessToken,
                                userId!,
                                refreshBrands,
                                storeService,
                                ref),
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
                          );
                        }
                      }),
                ],
              ),
            ),
          Expanded(
            child: Column(
              children: [
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
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search brands...',
                              hintStyle: const TextStyle(color: textLightColor),
                              prefixIcon: const Icon(Icons.search,
                                  color: textSecondaryColor),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear,
                                    color: textSecondaryColor),
                                onPressed: () {
                                  searchController.clear();
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
                      ),
                      if (isDesktop) ...[
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: 'All',
                          items: const [
                            DropdownMenuItem(
                                value: 'All', child: Text('All Brands')),
                            DropdownMenuItem(
                                value: 'Active', child: Text('Active')),
                            DropdownMenuItem(
                                value: 'Inactive', child: Text('Inactive')),
                          ],
                          onChanged: (value) {},
                          style: const TextStyle(color: textPrimaryColor),
                          underline: Container(),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: textSecondaryColor),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<BrandItem>>(
                    key: ValueKey(
                        refreshKey.value), // Use refreshKey to trigger rebuild
                    future: ViewBrandController(accessToken: accessToken)
                        .viewBrandController(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final brandList = snapshot.data;
                        if (brandList == null || brandList.isEmpty) {
                          return const Center(child: Text('No brands found'));
                        }

                        return isDesktop
                            ? _buildDesktopView(brandList, refreshBrands,
                                accessToken, storeService)
                            : _buildMobileView(brandList, refreshBrands,
                                accessToken, storeService);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopView(List<BrandItem> brandList,
      VoidCallback refreshBrands, String accessToken, storeService) {
    return Column(
      children: [
        // Table header
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('Brand Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ),
              Expanded(
                flex: 2,
                child: Text('Store ID',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ),
              SizedBox(width: 40), // For popup menu
            ],
          ),
        ),
        const Divider(height: 1),
        // Brand rows
        Expanded(
          child: ListView.builder(
            itemCount: brandList.length,
            itemBuilder: (context, index) {
              final brand = brandList[index];
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
                            horizontal: 16, vertical: 12),
                        child: Text(
                          brand.brandName,
                          style: const TextStyle(
                              fontSize: 15, color: textPrimaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Text(
                          brand.storeId,
                          style: const TextStyle(
                              fontSize: 14,
                              color: accentColor,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            color: textSecondaryColor.withOpacity(0.7),
                            size: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
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
                                Icon(Icons.delete_outline,
                                    size: 18, color: errorColor),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditBrandDialog(context, brand, refreshBrands,
                                accessToken, storeService);
                          } else if (value == 'delete') {
                            _showDeleteConfirmationDialog(
                                context, brand, refreshBrands, accessToken);
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

  Widget _buildMobileView(List<BrandItem> brandList, VoidCallback refreshBrands,
      String accessToken, storeService) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: brandList.length,
      itemBuilder: (context, index) {
        final brand = brandList[index];
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text(
                    brand.brandName,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
                  icon: Icon(Icons.more_vert,
                      color: textSecondaryColor.withOpacity(0.7), size: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
                          Icon(Icons.delete_outline,
                              size: 18, color: errorColor),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditBrandDialog(context, brand, refreshBrands,
                          accessToken, storeService);
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog(
                          context, brand, refreshBrands, accessToken);
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

  void _showAddBrandDialog(
      BuildContext context,
      ValueNotifier<bool> isLoading, // Correct type
      String accessToken, // Correct type
      String userId, // Correct type
      VoidCallback refreshBrands,
      dynamic storeService,
      WidgetRef ref) {
    // Add storeService parameter
    final controller = TextEditingController();
    final storeId = ValueNotifier<int?>(null);
    final storesAsync = ref.watch(storesProvider);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Add New Brand',
              style: TextStyle(color: textPrimaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Brand Name',
                    labelStyle: const TextStyle(color: textSecondaryColor),
                    hintText: 'Enter brand name',
                    hintStyle: const TextStyle(color: textLightColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                // ADD THIS FUTURE BUILDER (same as edit dialog)
                DropdownButtonFormField<int?>(
                  value: storeId.value,
                  decoration: InputDecoration(
                    labelText: 'Select Store',
                    labelStyle: const TextStyle(color: textSecondaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text('Choose store'),
                  items: storesAsync.when(
                    loading: () => [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: SizedBox(
                            height: 24,
                            child: Center(child: CircularProgressIndicator())),
                      )
                    ],
                    error: (e, _) => [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Failed to load stores'),
                      )
                    ],
                    data: (storeModel) {
                      // First access the data List<StoreData> from StoreModel
                      final List<store_model.StoreData>? stores =
                          storeModel.data;

                      if (stores == null || stores.isEmpty) {
                        return [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('No stores available'),
                          )
                        ];
                      }

                      return stores
                          .map((store) => DropdownMenuItem<int?>(
                                value: store.id,
                                child: Text(store.storeName ?? 'Unnamed Store'),
                              ))
                          .toList();
                    },
                  ),
                  onChanged: (val) {
                    storeId.value = val;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: textSecondaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // print(storeId.value);
                  if (controller.text.isNotEmpty && storeId.value != null) {
                    isLoading.value = true; // Show loading state
                    final response = await addBrandController(accessToken,
                        controller.text, storeId.value.toString(), userId);
                    isLoading.value = false;

                    if (response) {
                      refreshBrands();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Brand added successfully'),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Brand not added'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  void _showEditBrandDialog(
    BuildContext context,
    BrandItem brand,
    VoidCallback refreshBrands,
    String accessToken,
    dynamic storeService,
  ) async {
    final controller = TextEditingController(text: brand.brandName);
    String? selectedStore = brand.storeId;

    try {
      // Fetch store list asynchronously
      final storeList = await getStoreList(storeService);

      showCustomEditDialog(
        context: context,
        title: 'Edit Brand',
        subtitle: 'Update brand details',
        sections: [
          DialogSection(
            title: 'Brand Information',
            icon: Icons.business,
            fields: [
              DialogField(
                label: 'Brand Name',
                icon: Icons.label,
                controller: controller,
                fieldType: FieldType.text,
              ),
              DialogField(
                label: 'Select Store',
                icon: Icons.store,
                fieldType: FieldType.dropdown,
                dropdownItems: storeList.map((String store) {
                  return DropdownMenuItem<String>(
                    value: store,
                    child: Text(store),
                  );
                }).toList(),
                dropdownValue: selectedStore,
                onDropdownChanged: (value) {
                  selectedStore = value;
                },
              ),
            ],
          ),
        ],
        onSave: () async {
          if (controller.text.isNotEmpty && selectedStore != null) {
            final response = await editBrandController(
              accessToken,
              brand.id,
              controller.text,
              selectedStore!,
            );

            if (response) {
              refreshBrands();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Brand updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update brand'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill all fields'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        saveButtonText: 'Save',
      );
    } catch (e) {
      // Handle store list loading error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading stores: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, BrandItem brand,
      VoidCallback refreshBrands, String accessToken) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Brand',
          style: TextStyle(color: textPrimaryColor),
        ),
        content: Text(
          'Are you sure you want to delete "${brand.brandName}"?',
          style: const TextStyle(color: textSecondaryColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final deleted =
                  await deleteBrandController(accessToken, brand.id);
              Navigator.pop(context);
              if (deleted) {
                refreshBrands(); // Refresh the brand list
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Brand deleted successfully'),
                  backgroundColor: Colors.green,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to delete brand'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/add_category_controller.dart';
import 'package:green_biller/features/item/services/category/view_categories_service.dart';
import 'package:green_biller/features/item/view/pages/categories/categories_item_dialog.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/model/store_model/store_model.dart'
    as store_model;
import 'package:green_biller/utils/dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CategoriesPage extends HookConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final categories = useState<List<String>>([]);
    final categoryMap = useState<Map<String, int>>({});
    final storeId = useState<int?>(null);
    final isFirstLoad = useState(true);

    final user = ref.watch(userProvider);
    final storesAsync = ref.watch(storesProvider);
    final accessToken = user?.accessToken;
    final userId = user?.user?.id.toString();

    final categoryAsync = ref.watch(categoriesProvider);
    useEffect(() {
      if (isFirstLoad.value && accessToken != null) {
        _loadCategories(accessToken, categoryMap, categories);
        isFirstLoad.value = false;
      }
      return null;
    }, [accessToken]);

    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Filter categories based on search
    final filteredCategories = useMemoized(() {
      if (searchController.text.isEmpty) {
        return categories.value;
      }
      return categories.value
          .where((category) => category
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }, [categories.value, searchController.text]);

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
              child: const Icon(
                Icons.category,
                color: accentColor,
                size: 24,
              ),
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
      ),
      body: Column(
        children: [
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
            child: isSmallScreen
                ? Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showAddCategoryDialog(context, ref,
                            categories, categoryMap, storeId, null),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: 'Search categories...',
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
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: 'All',
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                                value: 'All', child: Text('All Categories')),
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
                      ),
                    ],
                  )
                : Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showAddCategoryDialog(context, ref,
                            categories, categoryMap, storeId, null),
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
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Search categories...',
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
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        constraints: const BoxConstraints(minWidth: 160),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: 'All',
                          items: const [
                            DropdownMenuItem(
                                value: 'All', child: Text('All Categories')),
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
                      ),
                    ],
                  ),
          ),
          // Categories count header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredCategories.length} Categories',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                ),
                if (searchController.text.isNotEmpty)
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
          Expanded(
            child: categoryAsync.when(
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading categories...'),
                  ],
                ),
              ),
              error: (err, st) {
                return Center(
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 8),
                          Text('Error: $err',
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                );
              },
              data: (categoryModel) {
                if (categoryModel.status != 1 ||
                    categoryModel.categories == null) {
                  return const Center(child: Text('No categories found'));
                }
                final allCategories = categoryModel.categories ?? [];

                // You probably want to filter by a search query; replace '' with your actual query:
                final filteredCategories = allCategories.where((cat) {
                  final name = (cat.name ?? '').toLowerCase();
                  return name
                      .contains(''); // replace '' with searchText.toLowerCase()
                }).toList();

                if (filteredCategories.isEmpty) {
                  return const Center(child: Text('No categories found'));
                }

                return GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 6 : (isTablet ? 4 : 2),
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];

                    final colors =
                        _getCategoryColors(category.name ?? 'Unknow Name');

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
                              showCategoryItemsDialog(
                                context,
                                categoryName: category.name ?? 'Unknow Name',
                                accessToken: accessToken,
                                categoryId: category.id!,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: colors['background'],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          _getCategoryIcon(
                                              category.name ?? 'Unknow Name'),
                                          color: colors['primary'],
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        category.name ?? 'Unknow Name',
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
                                          color:
                                              Color.fromARGB(255, 20, 20, 20),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: colors['background'],
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                          Icon(Icons.edit,
                                              size: 18, color: accentColor),
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
                                      _showEditCategoryDialog(
                                          context,
                                          category.name ?? 'Unknow Name',
                                          categories);
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmationDialog(
                                        context,
                                        category.name ?? 'Unknow Name',
                                        categories,
                                        accessToken,
                                        category.id.toString(),
                                        ref,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get category-specific colors
  Map<String, Color> _getCategoryColors(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return {
          'primary': const Color(0xFF2196F3),
          'background': const Color(0xFF2196F3).withOpacity(0.1),
          'border': const Color(0xFF2196F3),
        };
      case 'clothing':
        return {
          'primary': const Color(0xFFE91E63),
          'background': const Color(0xFFE91E63).withOpacity(0.1),
          'border': const Color(0xFFE91E63),
        };
      case 'food & beverages':
        return {
          'primary': const Color(0xFFFF9800),
          'background': const Color(0xFFFF9800).withOpacity(0.1),
          'border': const Color(0xFFFF9800),
        };
      case 'office supplies':
        return {
          'primary': const Color(0xFF607D8B),
          'background': const Color(0xFF607D8B).withOpacity(0.1),
          'border': const Color(0xFF607D8B),
        };
      case 'home & kitchen':
        return {
          'primary': const Color(0xFF795548),
          'background': const Color(0xFF795548).withOpacity(0.1),
          'border': const Color(0xFF795548),
        };
      case 'beauty & personal care':
        return {
          'primary': const Color(0xFFE91E63),
          'background': const Color(0xFFE91E63).withOpacity(0.1),
          'border': const Color(0xFFE91E63),
        };
      case 'sports & outdoors':
        return {
          'primary': const Color(0xFF4CAF50),
          'background': const Color(0xFF4CAF50).withOpacity(0.1),
          'border': const Color(0xFF4CAF50),
        };
      case 'books & stationery':
        return {
          'primary': const Color(0xFF9C27B0),
          'background': const Color(0xFF9C27B0).withOpacity(0.1),
          'border': const Color(0xFF9C27B0),
        };
      case 'automotive':
        return {
          'primary': const Color(0xFF212121),
          'background': const Color(0xFF212121).withOpacity(0.1),
          'border': const Color(0xFF212121),
        };
      case 'health & wellness':
        return {
          'primary': const Color(0xFF00BCD4),
          'background': const Color(0xFF00BCD4).withOpacity(0.1),
          'border': const Color(0xFF00BCD4),
        };
      case 'toys & games':
        return {
          'primary': const Color(0xFFFF5722),
          'background': const Color(0xFFFF5722).withOpacity(0.1),
          'border': const Color(0xFFFF5722),
        };
      case 'jewelry':
        return {
          'primary': const Color(0xFFFFC107),
          'background': const Color(0xFFFFC107).withOpacity(0.1),
          'border': const Color(0xFFFFC107),
        };
      case 'pet supplies':
        return {
          'primary': const Color(0xFF8BC34A),
          'background': const Color(0xFF8BC34A).withOpacity(0.1),
          'border': const Color(0xFF8BC34A),
        };
      case 'garden & outdoor':
        return {
          'primary': const Color(0xFF4CAF50),
          'background': const Color(0xFF4CAF50).withOpacity(0.1),
          'border': const Color(0xFF4CAF50),
        };
      case 'music & instruments':
        return {
          'primary': const Color(0xFF673AB7),
          'background': const Color(0xFF673AB7).withOpacity(0.1),
          'border': const Color(0xFF673AB7),
        };
      default:
        return {
          'primary': accentColor,
          'background': accentColor.withOpacity(0.1),
          'border': accentColor,
        };
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.electrical_services;
      case 'clothing':
        return Icons.checkroom;
      case 'food & beverages':
        return Icons.restaurant;
      case 'office supplies':
        return Icons.work;
      case 'home & kitchen':
        return Icons.home;
      case 'beauty & personal care':
        return Icons.spa;
      case 'sports & outdoors':
        return Icons.sports_soccer;
      case 'books & stationery':
        return Icons.menu_book;
      case 'automotive':
        return Icons.directions_car;
      case 'health & wellness':
        return Icons.medical_services;
      case 'toys & games':
        return Icons.toys;
      case 'jewelry':
        return Icons.diamond;
      case 'pet supplies':
        return Icons.pets;
      case 'garden & outdoor':
        return Icons.yard;
      case 'music & instruments':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }

  void _showAddCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<String>> categories,
    ValueNotifier<Map<String, int>> categoryMap, // if still needed elsewhere
    ValueNotifier<int?> storeId,
    File? imageFile,
  ) {
    final controller = TextEditingController();
    File? selectedImage;
    final picker = ImagePicker();

    final storesAsync =
        ref.watch(storesProvider); // assume AsyncValue<store_model.StoreModel>
    showDialog(
      context: context,
      builder: (context) {
        int? selectedStoreId = storeId.value;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Add New Category',
                style: TextStyle(color: textPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category name
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      labelStyle: const TextStyle(color: textSecondaryColor),
                      hintText: 'Enter category name',
                      hintStyle: const TextStyle(color: textLightColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  // Store dropdown from provider
                  DropdownButtonFormField<int?>(
                    value: selectedStoreId,
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
                              child:
                                  Center(child: CircularProgressIndicator())),
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
                                  child:
                                      Text(store.storeName ?? 'Unnamed Store'),
                                ))
                            .toList();
                      },
                    ),
                    onChanged: (val) {
                      setState(() {
                        selectedStoreId = val;
                      });
                      storeId.value = val;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Image picker
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              selectedImage = File(pickedFile.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.photo),
                        label: const Text('Pick Photo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      selectedImage != null
                          ? SizedBox(
                              width: 48,
                              height: 48,
                              child:
                                  Image.file(selectedImage!, fit: BoxFit.cover),
                            )
                          : const Text('No image selected'),
                    ],
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
                    if (controller.text.isEmpty) return;
                    if (selectedImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please upload category image"),
                          backgroundColor: Colors.blueAccent,
                        ),
                      );
                      context.pop();
                      return;
                    }
                    final accessToken = ref.read(userProvider)?.accessToken;
                    final userId = ref.read(userProvider)?.user?.id.toString();

                    if (accessToken != null && userId != null) {
                      try {
                        final response =
                            await AddCategoryController().addCategoryController(
                          accessToken,
                          controller.text,
                          userId,
                          storeId.value,
                          imageFile: selectedImage,
                        );
                        if (response == "Category created successfully") {
                          ref.refresh(categoriesProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response!),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(response ?? "Failed to create category"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        log("Add category failed: $e");
                      }
                    } else {
                      // fallback local add
                      final newCategories = List<String>.from(categories.value);
                      newCategories.add(controller.text);
                      categories.value = newCategories;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category added locally'),
                          backgroundColor: Colors.green,
                        ),
                      );
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
          },
        );
      },
    );
  }

  void _showEditCategoryDialog(
    BuildContext context,
    String category,
    ValueNotifier<List<String>> categories,
  ) {
    final TextEditingController controller =
        TextEditingController(text: category);
    File? selectedImage;
    String? selectedIcon;
    final picker = ImagePicker();

    const dropdownItems = [
      DropdownMenuItem(value: 'electronics', child: Text('Electronics')),
      DropdownMenuItem(value: 'clothing', child: Text('Clothing')),
      DropdownMenuItem(value: 'food', child: Text('Food & Beverages')),
      DropdownMenuItem(value: 'office', child: Text('Office Supplies')),
      DropdownMenuItem(value: 'home', child: Text('Home & Kitchen')),
      DropdownMenuItem(value: 'beauty', child: Text('Beauty & Personal Care')),
      DropdownMenuItem(value: 'sports', child: Text('Sports & Outdoors')),
      DropdownMenuItem(value: 'books', child: Text('Books & Stationery')),
      DropdownMenuItem(value: 'automotive', child: Text('Automotive')),
      DropdownMenuItem(value: 'health', child: Text('Health & Wellness')),
    ];

    showCustomEditDialog(
      context: context,
      title: 'Edit Category',
      subtitle: 'Update category details',
      sections: [
        DialogSection(
          title: 'Category Information',
          icon: Icons.category,
          fields: [
            DialogField(
              label: 'Category Name',
              icon: Icons.label,
              controller: controller,
              fieldType: FieldType.text,
            ),
            DialogField(
              label: 'Category Icon',
              icon: Icons.tag,
              fieldType: FieldType.dropdown,
              dropdownItems: dropdownItems,
              dropdownValue: selectedIcon,
              onDropdownChanged: (value) => selectedIcon = value,
            ),
            DialogField(
              label: 'Category Image',
              icon: Icons.image,
              fieldType: FieldType.imagePicker,
              imagePreview: selectedImage != null
                  ? SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.file(selectedImage, fit: BoxFit.cover),
                    )
                  : null,
              onImagePressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  selectedImage = File(pickedFile.path);
                  // Rebuild the dialog to update the preview
                  showCustomEditDialog(
                    context: context,
                    title: 'Edit Category',
                    subtitle: 'Update category details',
                    sections: [
                      DialogSection(
                        title: 'Category Information',
                        icon: Icons.category,
                        fields: [
                          DialogField(
                            label: 'Category Name',
                            icon: Icons.label,
                            controller: controller,
                            fieldType: FieldType.text,
                          ),
                          DialogField(
                            label: 'Category Icon',
                            icon: Icons.tag,
                            fieldType: FieldType.dropdown,
                            dropdownItems: dropdownItems,
                            dropdownValue: selectedIcon,
                            onDropdownChanged: (value) => selectedIcon = value,
                          ),
                          DialogField(
                            label: 'Category Image',
                            icon: Icons.image,
                            fieldType: FieldType.imagePicker,
                            imagePreview: SizedBox(
                              width: 48,
                              height: 48,
                              child:
                                  Image.file(selectedImage!, fit: BoxFit.cover),
                            ),
                            onImagePressed: () async {
                              final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (pickedFile != null) {
                                selectedImage = File(pickedFile.path);
                                // Close and reopen to refresh
                                Navigator.pop(context);
                                _showEditCategoryDialog(
                                    context, category, categories);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                    onSave: () {
                      if (controller.text.isNotEmpty) {
                        final index = categories.value.indexOf(category);
                        if (index != -1) {
                          final newCategories =
                              List<String>.from(categories.value);
                          newCategories[index] = controller.text;
                          categories.value = newCategories;
                        }
                        // Use selectedImage and selectedIcon as needed
                        Navigator.pop(context);
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ],
      onSave: () {
        if (controller.text.isNotEmpty) {
          final index = categories.value.indexOf(category);
          if (index != -1) {
            final newCategories = List<String>.from(categories.value);
            newCategories[index] = controller.text;
            categories.value = newCategories;
          }
          // Use selectedImage and selectedIcon as needed
          Navigator.pop(context);
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context,
      String category,
      ValueNotifier<List<String>> categories,
      String? accessToken,
      String? categoryId,
      WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Category',
          style: TextStyle(color: textPrimaryColor),
        ),
        content: Text(
          'Are you sure you want to delete "$category"?',
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
              final response = await deleteCatgoryById(accessToken, categoryId);
              if (response == 200) {
                ref.refresh(categoriesProvider);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Selected Cateogry deleted sucessfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete the category'),
                    backgroundColor: Colors.red,
                  ),
                );
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

  Future<void> _loadCategories(
    String accessToken,
    ValueNotifier<Map<String, int>> categoryMap,
    ValueNotifier<List<String>> categories,
  ) async {
    try {
      final categoryList =
          await AddCategoryController().getCategoryList(accessToken, null);

      final newMap = <String, int>{};
      final newCategories = <String>[];

      for (var category in categoryList) {
        category.forEach((id, name) {
          newMap[name] = id;
          newCategories.add(name);
        });
      }

      categoryMap.value = newMap;
      // Only update categories if we got data from server
      if (newCategories.isNotEmpty) {
        categories.value = newCategories;
      }
    } catch (e) {
      log('Error loading categories: $e');
    }
  }
}

class DiagonalLinesPainter extends CustomPainter {
  final Color color;

  DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (var i = -size.width; i < size.width * 2; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DotsPatternPainter extends CustomPainter {
  final Color color;

  DotsPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < size.width; i += 15) {
      for (var j = 0; j < size.height; j += 15) {
        canvas.drawCircle(
          Offset(i.toDouble(), j.toDouble()),
          0.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

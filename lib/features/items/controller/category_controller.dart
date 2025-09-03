import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/store_drtopdown_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/store_dropdown.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/category_list_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class CategoryController extends GetxController {
  final DioClient dioClient = DioClient();
  final AuthController authController = Get.find<AuthController>();
  final StoreDropdownController storeDropdownController =
      Get.find<StoreDropdownController>();
  final Logger logger = Logger();
  final ImagePicker picker = ImagePicker();

  // Reactive states
  final categories = Rxn<CategoryListModel>();
  final filteredCategories = <CategoryModel>[].obs;
  final searchController = TextEditingController();
  final isLoading = true.obs;
  final selectedFilter = 'All'.obs;
  final selectedStoreId = Rxn<int>();

  // Dialog controllers
  final categoryNameController = TextEditingController();
  final editCategoryNameController = TextEditingController();
  final selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    searchController.addListener(_filterCategories);
  }

  Future<void> fetchCategories([String? storeId]) async {
    try {
      isLoading.value = true;
      
      final url = storeId != null
          ? '$viewCategoriesUrl/$storeId'
          : viewCategoriesUrl;
      final response = await dioClient.dio.get(url);
      if (response.statusCode == 200) {
        final categoryModel = CategoryListModel.fromJson(response.data);
        categories.value = categoryModel;
        _filterCategories();
      } else {
        categories.value = CategoryListModel();
        filteredCategories.clear();
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching categories: $e', stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(
    String categoryName,
    int? storeId,
    File? imageFile,
  ) async {
    if (storeId == null || categoryName.isEmpty || imageFile == null) {
      Get.snackbar(
        'Error',
        'Please fill in all fields and upload an image',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;
      final userId = authController.user.value?.userId ?? 0;
      final categoryCode =
          "CnCd-$userId${DateTime.now().millisecondsSinceEpoch}";
      final formData = FormData.fromMap({
        'category_name': categoryName,
        'category_code': categoryCode,
        'store_id': storeId.toString(),
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await dioClient.dio.post(
        addCategoriesUrl,
        data: formData,
      );
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Category added successfully',
          backgroundColor: Colors.green,
        );
        await fetchCategories();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to add category',
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error adding category: $e', stackTrace);
      Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Category'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        isLoading.value = true;
        final response = await dioClient.dio.delete(
          '$deleteCategoriesUrl/$categoryId',
        );
        if (response.statusCode == 200) {
          Get.snackbar(
            'Success',
            'Category deleted successfully',
            backgroundColor: Colors.green,
          );
          await fetchCategories();
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete category',
            backgroundColor: Colors.red,
          );
        }
      } catch (e, stackTrace) {
        logger.e('Error deleting category: $e', stackTrace);
        Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void _filterCategories() {
    if (categories.value?.categories == null) {
      filteredCategories.clear();
      return;
    }
    final query = searchController.text.toLowerCase();
    filteredCategories.value = categories.value!.categories!.where((cat) {
      final name = (cat.name ?? '').toLowerCase();
      if (selectedFilter.value == 'All') return name.contains(query);
      if (selectedFilter.value == 'Active') {
        return name.contains(query) && cat.status == '1';
      }
      if (selectedFilter.value == 'Inactive') {
        return name.contains(query) && cat.status != '1';
      }
      return true;
    }).toList();
  }

  Future<void> showAddCategoryDialog() async {
    categoryNameController.clear();
    selectedStoreId.value = null;
    selectedImage.value = null;

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add New Category',
          style: TextStyle(color: Colors.black),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryNameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'Enter category name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              StoreDropdown(
                onStoreChanged: (storeId) {
                  storeDropdownController.selectedStoreId.value = storeId;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        selectedImage.value = File(pickedFile.path);
                      }
                    },
                    icon: const Icon(Icons.photo),
                    label: const Text('Pick Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => selectedImage.value != null
                        ? SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.file(
                              selectedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Text('No image selected'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: isLoading.value
                  ? null
                  : () async {
                      if (categoryNameController.text.isEmpty ||
                          selectedImage.value == null) {
                        Get.snackbar(
                          'Error',
                          'Please enter a category name and select an image',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      await addCategory(
                        categoryNameController.text,
                        selectedStoreId.value,
                        selectedImage.value,
                      );
                      Get.back();
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> getCategoryColors(String category) {
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
          'primary': Colors.blue,
          'background': Colors.blue.withOpacity(0.1),
          'border': Colors.blue,
        };
    }
  }

  IconData getCategoryIcon(String category) {
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

  @override
  void onClose() {
    searchController.dispose();
    categoryNameController.dispose();
    editCategoryNameController.dispose();
    super.onClose();
  }
}

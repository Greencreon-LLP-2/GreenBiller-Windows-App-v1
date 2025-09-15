import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';

import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/category_list_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CategoryController extends GetxController {
  // Services
  late DioClient dioClient;
  late AuthController authController;
  late DropdownController storeDropdownController;
  late Logger logger;
  late ImagePicker picker;

  // Reactive states
  Rxn<CategoryListModel> categories = Rxn<CategoryListModel>();
  RxList<CategoryModel> filteredCategories = <CategoryModel>[].obs;
  late TextEditingController searchController;
  RxBool isLoading = true.obs;
  RxString selectedFilter = 'All'.obs;

  // Dialog controllers
  late TextEditingController categoryNameController;
  late TextEditingController editCategoryNameController;
  Rxn<File> selectedImage = Rxn<File>();

  final Rxn<Map<String, dynamic>> importedFile = Rxn<Map<String, dynamic>>();
  final selectedStoreIdForFileUpload = Rxn<int>();
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize services
    dioClient = DioClient();
    authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();
    storeDropdownController.loadStores();
    logger = Logger();
    picker = ImagePicker();

    // Initialize controllers
    searchController = TextEditingController();
    categoryNameController = TextEditingController();
    editCategoryNameController = TextEditingController();

    // Attach listeners
    searchController.addListener(_filterCategories);

    // Initial data load
    fetchCategories();
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
              AppDropdown(
                label: "Store",
                selectedValue: storeDropdownController.selectedStoreId,
                options: storeDropdownController.storeMap,
                isLoading: storeDropdownController.isLoadingStores,
                onChanged: (val) {},
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
                        storeDropdownController.selectedStoreId.value,
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

  Future<void> pickFile() async {
    selectedStoreIdForFileUpload.value = null;
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Excel/CSV files',
        extensions: ['csv', 'xls', 'xlsx'], // desktop
        mimeTypes: [
          'text/csv',
          'application/vnd.ms-excel',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ], // mobile/web
        uniformTypeIdentifiers: ['public.comma-separated-values-text'], // Apple
        webWildCards: ['.csv', '.xls', '.xlsx'], // Web
      );
      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
        confirmButtonText: "Select upload file",
      );
      // #enddocregion SingleOpen
      if (result == null) {
        // Operation was canceled by the user.
        return;
      }
      if (result.path.isNotEmpty) {
        final filePath = result.path;
        final file = File(filePath);
        if (await file.exists()) {
          importedFile.value = {'name': result.path, 'file': file};
        } else {
          Get.snackbar(
            'Error',
            'Selected file does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'No file selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error selecting file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadSelctedFile() async {
    if (importedFile.value != null && importedFile.value!['file'] != null) {
      try {
        final file = importedFile.value!['file'] as File;
        final filePath = file.path;

        if (await file.exists()) {
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            Get.snackbar(
              'Error',
              'Failed to open file: ${result.message}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {}
        } else {
          Get.snackbar(
            'Error',
            'File does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error opening file: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'No file selected to open',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> processImportedFile() async {
    if (importedFile.value == null || isProcessing.value) return;
    print(selectedStoreIdForFileUpload.value);
    isProcessing.value = true;
    try {
      if (selectedStoreIdForFileUpload.value == null) {
        Get.snackbar(
          'Error',
          'Please select a store before importing',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final file = importedFile.value!['file'] as File;
      final formData = dio.FormData.fromMap({
        'store_id': selectedStoreIdForFileUpload.value,
        'file': await dio.MultipartFile.fromFile(
          file.path,
          filename: importedFile.value!['name'],
        ),
      });

      final response = await dioClient.dio.post(
        bulkItemUpdate, // ✅ correct API
        data: formData,
      );

      if (response.statusCode == 201 && response.data['status'] == true) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Items imported successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        importedFile.value = null;
        fetchCategories();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to import items');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error importing items: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> downloadTemplate() async {
    try {
      final response = await dioClient.dio.get(
        sampleBrandsExcellTemplateUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/brand_bulk_template.xlsx');
        await file.writeAsBytes(response.data);
        Get.snackbar(
          'Success',
          'Template downloaded: ${file.path}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await OpenFile.open(file.path);
      } else {
        throw Exception('Failed to download template');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download template: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    // Clean up controllers
    searchController.dispose();
    categoryNameController.dispose();
    editCategoryNameController.dispose();
    super.onClose();
  }
}

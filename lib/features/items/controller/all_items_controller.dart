import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_selector/file_selector.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';

import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AllItemsController extends GetxController {
  final DioClient dioClient = DioClient();
  final Logger _logger = Logger();
  late CommonApiFunctionsController commonApi;
  late AuthController authController;
  late DropdownController storeDropdownController;

  final Rxn<Map<String, dynamic>> importedFile = Rxn<Map<String, dynamic>>();
  final selectedStoreIdForFileUpload = Rxn<int>();

  final RxBool isGridView = false.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSort = 'Name (A-Z)'.obs;

  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  final RxString error = ''.obs;
  final RxList<Item> items = <Item>[].obs;
  final RxString searchQuery = ''.obs;

  // Categories and sort options
  final List<String> categories = [
    'All',
    'Electronics',
    'Clothing',
    'Food',
    'Office Supplies',
  ];
  final List<String> sortOptions = [
    'Name (A-Z)',
    'Name (Z-A)',
    'Price (Low to High)',
    'Price (High to Low)',
    'Stock (Low to High)',
    'Stock (High to Low)',
  ];

  @override
  void onInit() {
    super.onInit();
    commonApi = CommonApiFunctionsController();
    authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();

    fetchItems();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    fetchItems();
  }

  void clearSearchQuery() {
    searchQuery.value = '';
    fetchItems();
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
    fetchItems();
  }

  void setSelectedSort(String sort) {
    selectedSort.value = sort;
    fetchItems();
  }

  void toggleGridView() {
    isGridView.value = !isGridView.value;
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    error.value = '';
    try {
      final url = storeDropdownController.selectedStoreId.value != null
          ? '$viewAllItemUrl/${storeDropdownController.selectedStoreId.value}'
          : viewAllItemUrl;
      final response = await dioClient.dio.get(url);

      if (response.statusCode == 200) {
        final itemModel = ItemModel.fromJson(response.data);
        items.assignAll(itemModel.data);
      } else {
        error.value = response.data['message'] ?? 'Failed to fetch items';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Error fetching items: $e');
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch items: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFile() async {
    selectedStoreIdForFileUpload.value = null;
    try {
      _logger.d('Opening file picker for Excel/CSV');
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
          _logger.i(
            'File selected: ${importedFile.value!['name']} at path: $filePath',
          );
        } else {
          _logger.w('File does not exist at path: $filePath');
          Get.snackbar(
            'Error',
            'Selected file does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        _logger.w('No file selected');
        Get.snackbar(
          'Error',
          'No file selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      _logger.e('Error picking file: $e');
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
        _logger.d(
          'Attempting to open file: ${importedFile.value!['name']} at path: $filePath',
        );

        if (await file.exists()) {
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            _logger.w('Failed to open file: ${result.message}');
            Get.snackbar(
              'Error',
              'Failed to open file: ${result.message}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            _logger.i(
              'File opened successfully: ${importedFile.value!['name']}',
            );
          }
        } else {
          _logger.w('File does not exist at path: $filePath');
          Get.snackbar(
            'Error',
            'File does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        _logger.e('Error opening file: $e');
        Get.snackbar(
          'Error',
          'Error opening file: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      _logger.w('No file to open');
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
        fetchItems();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to import items');
      }
    } catch (e) {
      _logger.e('Error processing imported file: $e');
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
        sampleItemsExcellTemplateUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/item_bulk_template.xlsx');
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
      _logger.e('Error downloading template: $e');
      Get.snackbar(
        'Error',
        'Failed to download template: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> deleteItem(int itemId) async {
    try {
      final response = await dioClient.dio.delete('$deleteItemUrl/$itemId');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Item deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchItems(); // Refresh items after deletion
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete item');
      }
    } catch (e) {
      _logger.e('Error deleting item: $e');
      Get.snackbar(
        'Error',
        'Failed to delete item: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}

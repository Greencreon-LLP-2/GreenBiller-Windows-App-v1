import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

import 'package:greenbiller/features/items/model/brand_model.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class BrandController extends GetxController {
  // Services
  late DioClient dioClient;
  late AuthController authController;
  late Logger logger;
  late DropdownController storeDropdownController;

  // Reactive states
  RxList<BrandItemData> brands = <BrandItemData>[].obs;
  RxBool isLoading = true.obs;

  final Rxn<Map<String, dynamic>> importedFile = Rxn<Map<String, dynamic>>();
  final selectedStoreIdForFileUpload = Rxn<int>();
  final RxBool isProcessing = false.obs;

  // Dialog controllers
  late TextEditingController searchController;
  late TextEditingController brandNameController;
  late TextEditingController editBrandNameController;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    authController = Get.find<AuthController>();
    logger = Logger();
    storeDropdownController = Get.find<DropdownController>();
    storeDropdownController.loadStores();
    searchController = TextEditingController();
    brandNameController = TextEditingController();
    editBrandNameController = TextEditingController();

    searchController.addListener(() => update());
    fetchBrands();
  }

  Future<void> fetchBrands([int? storeId]) async {
    try {
      isLoading.value = true;

      final response = await dioClient.dio.get(
        viewBrandUrl,
        queryParameters: storeId != null ? {'store_id': storeId} : null,
      );
      if (response.statusCode == 200) {
        final brandModel = BrandModel.fromJson(response.data);
        brands.value = brandModel.data ?? [];
      } else {
        brands.clear();
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching brands: $e', stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load brands: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBrand(String brandName, String storeId, String userId) async {
    try {
      isLoading.value = true;

      final response = await dioClient.dio.post(
        addBrandUrl,
        data: {
          'store_id': storeId,
          'slug': '',
          'count_id': '1',
          'brand_code': 'br-1',
          'brand_name': brandName,
          'brand_image': '',
          'description': 'test',
          'status': '1',
          'inapp_view': '1',
          'user_id': userId,
        },
      );
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Brand added successfully',
          backgroundColor: Colors.green,
        );
        await fetchBrands();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to add brand',
          backgroundColor: Colors.red,
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error adding brand: $e', stackTrace);
      Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBrand(String brandId) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Brand'),
        content: const Text('Are you sure you want to delete this brand?'),
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
          '$baseUrl/brand-delete/$brandId',
        );
        if (response.statusCode == 200) {
          Get.snackbar(
            'Success',
            'Brand deleted successfully',
            backgroundColor: Colors.green,
          );
          await fetchBrands();
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete brand',
            backgroundColor: Colors.red,
          );
        }
      } catch (e, stackTrace) {
        logger.e('Error deleting brand: $e', stackTrace);
        Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> showAddBrandDialog() async {
    brandNameController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add New Brand',
          style: TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: brandNameController,
              decoration: InputDecoration(
                labelText: 'Brand Name',
                hintText: 'Enter brand name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              label: "Store",
              selectedValue: storeDropdownController.selectedStoreId,
              options: storeDropdownController.storeMap,
              isLoading: storeDropdownController.isLoadingStores,
              onChanged: (val) {},
            ),
          ],
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
                      if (brandNameController.text.isEmpty ||
                          storeDropdownController.selectedStoreId.value ==
                              null) {
                        Get.snackbar(
                          'Error',
                          'Please fill in all fields',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      await addBrand(
                        brandNameController.text,
                        storeDropdownController.selectedStoreId.value
                            .toString(),
                        authController.user.value?.userId.toString() ?? '',
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
        fetchBrands();
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
        sampleCategoryExcellTemplateUrl,
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
    searchController.dispose();
    brandNameController.dispose();
    editBrandNameController.dispose();
    super.onClose();
  }
}

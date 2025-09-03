import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/store_drtopdown_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

import 'package:greenbiller/features/items/model/brand_model.dart';
import 'package:logger/logger.dart';

class BrandController extends GetxController {
  // Services
  late DioClient dioClient;
  late AuthController authController;
  late Logger logger;
  late StoreDropdownController storeDropdownController;

  // Reactive states
  RxList<BrandItemData> brands = <BrandItemData>[].obs;
  RxBool isLoading = true.obs;
  Rxn<int> selectedStoreId = Rxn<int>();

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
    storeDropdownController = Get.find<StoreDropdownController>();

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
    selectedStoreId.value = null;

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
            StoreDropdown(
              onStoreChanged: (storeId) {
                storeDropdownController.selectedStoreId.value = storeId;
              },
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
                          selectedStoreId.value == null) {
                        Get.snackbar(
                          'Error',
                          'Please fill in all fields',
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      await addBrand(
                        brandNameController.text,
                        selectedStoreId.value.toString(),
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

  @override
  void onClose() {
    searchController.dispose();
    brandNameController.dispose();
    editBrandNameController.dispose();
    super.onClose();
  }
}

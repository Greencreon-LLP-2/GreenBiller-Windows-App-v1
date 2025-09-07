import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:greenbiller/features/store/model/warehouse_model.dart';

class StoreController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late CommonApiFunctionsController commonApi;
  late AuthController authController;
  late DropdownController storeDropdownController;
  late DioClient dioClient;
  late ImagePicker picker;

  late TabController tabController;
  final currentTabIndex = 0.obs;

  final RxList<StoreData> stores = <StoreData>[].obs;
  final RxList<WarehouseData> warehouses = <WarehouseData>[].obs;
  final isStoreLoading = false.obs;
  final isWarehouseLoading = false.obs;

  final RxInt userId = 0.obs;
  final RxInt editStoreId = 0.obs;
  final RxInt editwarehouseId = 0.obs;

  /// Add store form
  final storeNameController = TextEditingController();
  final storeWebsiteController = TextEditingController();
  final storeAddressController = TextEditingController();
  final storePhoneController = TextEditingController();
  final storeEmailController = TextEditingController();
  final storeImage = Rxn<String>();
  final storeFormKey = GlobalKey<FormState>();
  final storeSearchController = TextEditingController();
  final storeSearchQuery = ''.obs;
  final storeSelectedFilter = 'all'.obs;
  final filteredStores = <dynamic>[].obs;
  final warehouseCounts = <String, int>{}.obs;

  final categories = <String, List<dynamic>>{}.obs;
  final salesCounts = <String, int>{}.obs;
  final salesReturnCounts = <String, int>{}.obs;
  final purchaseCounts = <String, int>{}.obs;
  final purchaseReturnCounts = <String, int>{}.obs;

  /// Add warehouse form
  final warehouseNameController = TextEditingController();
  final warehouseTypeController = TextEditingController();
  final warehouseAddressController = TextEditingController();
  final warehouseEmailController = TextEditingController();
  final warehousePhoneController = TextEditingController();
  final warehouseFormKey = GlobalKey<FormState>();
  final filteredWarehouses = <dynamic>[].obs;
  final warehouseSearchController = TextEditingController();
  final warehouseSearchQuery = ''.obs;
  final warehouseSelectedFilter = 'all'.obs;

  /// Edit store form controllers
  final storeCodeController = TextEditingController();
  final storeCityController = TextEditingController();
  final storeStateController = TextEditingController();
  final storePostcodeController = TextEditingController();
  final storeCountryController = TextEditingController();
  final storeTimezoneController = TextEditingController();
  final storeCurrencyController = TextEditingController();
  final storeLanguageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    commonApi = CommonApiFunctionsController();
    authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();
    picker = ImagePicker();
    userId.value = authController.user.value?.userId ?? 0;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      currentTabIndex.value = tabController.index;
    });
    ever(storeSearchQuery, (_) => _filterStores());
    ever(storeSelectedFilter, (_) => _filterStores());
    ever(warehouseSearchQuery, (_) => _filterWarehouses());
    ever(warehouseSelectedFilter, (_) => _filterWarehouses());
    getStoreList();
    getWarehouseList();
  }

  @override
  void onClose() {
    tabController.dispose();
    storeNameController.dispose();
    storeWebsiteController.dispose();
    storeAddressController.dispose();
    storePhoneController.dispose();
    storeEmailController.dispose();
    warehouseNameController.dispose();
    warehouseTypeController.dispose();
    warehouseAddressController.dispose();
    warehouseEmailController.dispose();
    warehousePhoneController.dispose();
    storeCodeController.dispose();
    storeCityController.dispose();
    storeStateController.dispose();
    storePostcodeController.dispose();
    storeCountryController.dispose();
    storeTimezoneController.dispose();
    storeCurrencyController.dispose();
    storeLanguageController.dispose();
    super.onClose();
  }

  void _filterWarehouses() {
    final query = warehouseSearchQuery.value;
    final filter = warehouseSelectedFilter.value;
    filteredWarehouses.assignAll(
      warehouses.where((warehouse) {
        if (query.isNotEmpty) {
          final searchableText = [
            warehouse.warehouseName,
            warehouse.address,
            warehouse.warehouseType,
          ].join(' ').toLowerCase();
          if (!searchableText.contains(query)) return false;
        }
        if (filter != 'all') {
          final isActive = warehouse.status == 'active';
          if (filter == 'active' && !isActive) return false;
          if (filter == 'inactive' && isActive) return false;
        }
        return true;
      }).toList(),
    );
  }

  void _filterStores() {
    final query = storeSearchQuery.value;
    final filter = storeSelectedFilter.value;
    filteredStores.assignAll(
      stores.where((store) {
        if (query.isNotEmpty) {
          final searchableFields = [
            store.storeName ?? '',
            store.storeAddress ?? '',
            store.storePhone ?? '',
            store.storeEmail ?? '',
            store.storeCity ?? '',
            store.storeCountry ?? '',
          ].join(' ').toLowerCase();
          if (!searchableFields.contains(query)) return false;
        }
        if (filter != 'all') {
          final isActive = store.status == 'active';
          if (filter == 'active' && !isActive) return false;
          if (filter == 'inactive' && isActive) return false;
        }
        return true;
      }).toList(),
    );
  }

  Future<void> getStoreList() async {
    try {
      isStoreLoading.value = true;
      final result = await commonApi.fetchStore();
      stores.assignAll(result.data ?? []);
      filteredStores.assignAll(result.data ?? []);
    } catch (e) {
      print("Failed to fetch stores: $e");
    } finally {
      isStoreLoading.value = false;
      storeDropdownController.loadStores();
    }
  }

  Future<void> getWarehouseList() async {
    try {
      isWarehouseLoading.value = true;
      final result = await commonApi.fetchWarehouse();
      warehouses.assignAll(result.data ?? []);
      filteredWarehouses.assignAll(result.data ?? []);
    } catch (e) {
      print("Failed to fetch warehouses: $e");
    } finally {
      isWarehouseLoading.value = false;
    }
  }

  Future<void> addStore() async {
    if (!storeFormKey.currentState!.validate()) return;

    try {
      final formData = dio.FormData.fromMap({
        "user_id": userId.value.toString(),
        "store_code": "store-${DateTime.now().millisecondsSinceEpoch}",
        "store_name": storeNameController.text,
        "website": storeWebsiteController.text,
        "store_email": storeEmailController.text,
        "store_phone": storePhoneController.text,
        "store_address": storeAddressController.text,
        if (storeImage.value != null)
          "store_logo": await dio.MultipartFile.fromFile(
            storeImage.value!,
            filename: "logo.png",
          ),
      });

      final response = await dioClient.dio.post(addStoreUrl, data: formData);
      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Store added successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await getStoreList();
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add store: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addWarehouse() async {
    if (!warehouseFormKey.currentState!.validate()) return;
    if (storeDropdownController.selectedStoreId.value == null) {
      Get.snackbar(
        "Missing Store Id",
        "Please Select a Store first",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      final response = await dioClient.dio.post(
        addWarehouseUrl,
        data: {
          "warehouse_name": warehouseNameController.text,
          "address": warehouseAddressController.text,
          "warehouse_type": warehouseTypeController.text,
          "mobile": warehousePhoneController.text,
          "email": warehouseEmailController.text,
          "store_id": stores.isNotEmpty ? stores.first.id.toString() : null,
          "user_id": userId.value.toString(),
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Warehouse added successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await getWarehouseList();
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add warehouse: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickStoreImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        storeImage.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Image picker failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteStore(int storeId) async {
    try {
      final response = await dioClient.dio.delete("$deleteStoreUrl$storeId");

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Store deleted successfully',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await getStoreList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete store',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> deleteWarehouse(int warehouseId) async {
    try {
      final response = await dioClient.dio.delete(
        "$deleteWarehouseUrl$warehouseId",
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Warehouse deleted successfully',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await getWarehouseList();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete warehouse',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> editStore(int storeId) async {
    try {
      final store = stores.firstWhereOrNull((s) => s.id == storeId);
      if (store == null) {
        Get.snackbar(
          'Error',
          'Store not found',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      final Map<String, dynamic> payload = {'user_id': userId.value.toString()};

      // Only attach changed values, using correct Laravel field names
      if (storeCodeController.text != (store.storeCode ?? '')) {
        payload['store_code'] = storeCodeController.text;
      }
      if (storeNameController.text != (store.storeName ?? '')) {
        payload['store_name'] = storeNameController.text;
      }
      if (storeWebsiteController.text != (store.website ?? '')) {
        payload['store_website'] = storeWebsiteController.text;
      }
      if (storeEmailController.text != (store.storeEmail ?? '')) {
        payload['email'] = storeEmailController.text;
      }
      if (storePhoneController.text != (store.storePhone ?? '')) {
        payload['phone'] = storePhoneController.text;
      }
      if (storeAddressController.text != (store.storeAddress ?? '')) {
        payload['address'] = storeAddressController.text;
      }
      if (storeCityController.text != (store.storeCity ?? '')) {
        payload['city'] = storeCityController.text;
      }
      if (storeStateController.text != (store.storeState ?? '')) {
        payload['state'] = storeStateController.text;
      }
      if (storePostcodeController.text != (store.storePostalCode ?? '')) {
        payload['postcode'] = storePostcodeController.text;
      }
      if (storeCountryController.text != (store.storeCountry ?? '')) {
        payload['country'] = storeCountryController.text;
      }
      if (storeTimezoneController.text != (store.timezone ?? '')) {
        payload['timezone'] = storeTimezoneController.text;
      }
      if (storeCurrencyController.text != (store.currency ?? '')) {
        payload['currency_id'] = storeCurrencyController.text;
      }
      if (storeLanguageController.text != (store.language ?? '')) {
        payload['language_id'] = storeLanguageController.text;
      }

      // For logo → check if a new file was picked
      if (storeImage.value != null && storeImage.value != store.storeLogo) {
        payload['store_logo'] = await dio.MultipartFile.fromFile(
          storeImage.value!,
          filename: "logo.png",
        );
      }

      if (payload.length <= 1) {
        // Only has user_id, no actual changes
        Get.snackbar(
          'No Changes',
          'No fields were modified',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      final formData = dio.FormData.fromMap(payload);

      final response = await dioClient.dio.put(
        "$editStoreUrl/$storeId",
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization':
                'Bearer ${authController.user.value?.accessToken ?? ''}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Store updated successfully',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await getStoreList();
        Get.back();
      } else {
        _showError(response.data);
      }
    } on dio.DioException catch (e) {
      _showError(e.response?.data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> editWarehouse(
    int warehouseId, {
    String? oldName,
    String? oldAddress,
    String? oldType,
    String? oldEmail,
    String? oldPhone,
  }) async {
    try {
      final payload = <String, dynamic>{};

      final newName = warehouseNameController.text.trim();
      final newAddress = warehouseAddressController.text.trim();
      final newType = warehouseTypeController.text.trim();
      final newEmail = warehouseEmailController.text.trim();
      final newPhone = warehousePhoneController.text.trim();

      if (newName.isNotEmpty && newName != oldName) {
        payload['warehouse_name'] = newName;
      }
      if (newAddress.isNotEmpty && newAddress != oldAddress) {
        payload['address'] = newAddress;
      }
      if (newType.isNotEmpty && newType != oldType) {
        payload['warehouse_type'] = newType;
      }
      if (newEmail.isNotEmpty && newEmail != oldEmail) {
        payload['email'] = newEmail;
      }
      if (newPhone.isNotEmpty && newPhone != oldPhone) {
        payload['mobile'] = newPhone;
      }

      if (payload.isEmpty) {
        Get.snackbar(
          'No Changes',
          'No changes to update',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      final response = await dioClient.dio.put(
        "$editWarehouseUrl/$warehouseId",
        data: payload,
        options: dio.Options(
          headers: {
            'Authorization':
                'Bearer ${authController.user.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Warehouse updated successfully',
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        await getWarehouseList();
        Get.back();
      } else {
        _showError(response.data);
      }
    } on dio.DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 422) {
        _showError(e.response?.data);
      } else {
        Get.snackbar(
          'Error',
          'Failed to update warehouse: ${e.message}',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  /// Helper to show validation errors clearly
  void _showError(dynamic data) {
    String message = 'Failed to update warehouse';

    if (data is Map && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      final errorMessages = errors.entries
          .map((e) => "${e.key}: ${(e.value as List).join(', ')}")
          .join("\n");

      message = errorMessages;
    } else if (data is Map && data.containsKey('message')) {
      message = data['message'];
    }

    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}

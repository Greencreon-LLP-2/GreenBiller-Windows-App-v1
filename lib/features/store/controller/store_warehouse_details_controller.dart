import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';

import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:greenbiller/features/store/model/warehouse_model.dart';

class StoreWarehouseDetailsController extends GetxController {
  late CommonApiFunctionsController commonApi;
  late DioClient dioClient;

  // Store
  final store = Rxn<StoreData>();
  final storeId = 0.obs;

  // Warehouses
  final warehouses = <WarehouseData>[].obs;
  final singleWarehouse = Rxn<WarehouseData>();
  final warehouseId = 0.obs;

  // Items
  final items = <Item>[].obs;
  final searchQuery = ''.obs;

  // Loading states
  final isLoading = false.obs;
  final isWarehouseLoading = false.obs;
  final isLoadingItems = false.obs;

  // Error messages
  final error = ''.obs;
  final warehouseError = ''.obs;
  final errorItems = ''.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    commonApi = CommonApiFunctionsController();
  }

  void updateStore(int newId) {
    if (storeId.value != newId) {
      storeId.value = newId;
      fetchStoreDetails();
      fetchWarehouseDetails();
    }
  }

  void updateWarehouse(int newStoreId, int newWarehouseId) {
    if (storeId.value != newStoreId) {
      storeId.value = newStoreId;
    }
    if (warehouseId.value != newWarehouseId) {
      warehouseId.value = newWarehouseId;
      fetchSingleWarehouse();
      fetchWarehouseItems();
    }
  }

  /// Fetch store details
  Future<void> fetchStoreDetails() async {
    if (storeId.value == 0) return;
    isLoading.value = true;
    error.value = '';
    try {
      final storeModel = await commonApi.fetchStore(storeId: storeId.value);

      final matchedStore = storeModel.data?.firstWhereOrNull(
        (s) => s.id == storeId.value,
      );

      if (matchedStore != null) {
        store.value = matchedStore;
      } else {
        error.value = 'Store not found';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load store details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all warehouses for store
  Future<void> fetchWarehouseDetails() async {
    if (storeId.value == 0) return;
    isWarehouseLoading.value = true;
    warehouseError.value = '';
    try {
      final response = await commonApi.fetchWarehousesByStoreID(storeId.value);
      warehouses.value = response
          .map((e) => WarehouseData.fromJson(e))
          .toList();
    } catch (e) {
      warehouseError.value = 'Failed to fetch warehouse details: $e';
      Get.snackbar(
        'Error',
        warehouseError.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isWarehouseLoading.value = false;
    }
  }

  /// Fetch single warehouse by warehouseId
  Future<void> fetchSingleWarehouse() async {
    if (storeId.value == 0 || warehouseId.value == 0) return;

    isWarehouseLoading.value = true;
    warehouseError.value = '';

    try {
      final response = await commonApi.fetchSingleWareHouseById(storeId.value);

      if (response is Map<String, dynamic> && response['data'] is List) {
        final warehouseList = (response['data'] as List)
            .map((e) => WarehouseData.fromJson(e as Map<String, dynamic>))
            .toList();

        final matchedWarehouse = warehouseList.firstWhereOrNull(
          (w) => w.id == warehouseId.value,
        );

        if (matchedWarehouse != null) {
          singleWarehouse.value = matchedWarehouse;
          warehouses.value = [matchedWarehouse];
        } else {
          warehouseError.value =
              'Warehouse with id ${warehouseId.value} not found';
        }
      } else {
        warehouseError.value = 'Invalid response format';
      }
    } catch (e) {
      warehouseError.value = 'Failed to fetch warehouse details: $e';
      print(warehouseError.value);
      Get.snackbar(
        'Error',
        warehouseError.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isWarehouseLoading.value = false;
    }
  }

  /// Fetch items of warehouse
  Future<void> fetchWarehouseItems() async {
    if (storeId.value == 0) return;
    isLoadingItems.value = true;
    errorItems.value = '';
    try {
      final response = await dioClient.dio.get(
        '$viewAllItemUrl/${storeId.value}',
      );

      if (response.statusCode == 200) {
        final itemModel = ItemModel.fromJson(response.data);
        items.assignAll(itemModel.data ?? []);
      } else {
        errorItems.value = response.data['message'] ?? 'Failed to fetch items';

        Get.snackbar(
          'Error',
          errorItems.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorItems.value = 'Failed to fetch items: $e';
      print(errorItems.value);
      Get.snackbar(
        'Error',
        errorItems.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingItems.value = false;
    }
  }

  /// Search + Stats
  List<Item> get filteredItems {
    if (searchQuery.value.isEmpty) return items;

    final query = searchQuery.value.toLowerCase();
    return items.where((item) {
      final name = item.itemName.toLowerCase();
      final sku = item.sku.toLowerCase();
      final category = item.categoryName.toLowerCase();
      final brand = item.brandName.toLowerCase();

      return [name, sku, category, brand].join(' ').contains(query);
    }).toList();
  }

  int get totalItems => filteredItems.length;

  int get activeItems => filteredItems.where((item) => item.status == 1).length;

  int get inactiveItems =>
      filteredItems.where((item) => item.status != 1).length;

  int get totalQuantity => filteredItems.fold<int>(0, (prev, item) {
    if (item.quantity == null) return prev;
    return prev + (int.tryParse(item.quantity!) ?? 0);
  });

  double get totalStockValue => filteredItems.fold<double>(0.0, (prev, item) {
    final qty = int.tryParse(item.quantity ?? '0') ?? 0;
    final price = double.tryParse(item.purchasePrice) ?? 0.0;
    return prev + (qty * price);
  });

  double get potentialSalesValue =>
      filteredItems.fold<double>(0.0, (prev, item) {
        final qty = int.tryParse(item.quantity ?? '0') ?? 0;
        final price = double.tryParse(item.salesPrice) ?? 0.0;
        return prev + (qty * price);
      });
}

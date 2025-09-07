import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';

import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:greenbiller/features/store/model/warehouse_model.dart';

class StoreWarehouseDetailsController extends GetxController {
  late CommonApiFunctionsController commonApi;
  final store = Rxn<StoreData>();
  final warehouses = <WarehouseData>[].obs;
  final isLoading = true.obs;
  final isWarehouseLoading = true.obs;
  final error = ''.obs;
  final warehouseError = ''.obs;
  final storeId = 0.obs;
  final warehouseId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    commonApi = CommonApiFunctionsController();
  }

  Future<void> fetchStoreDetails() async {
    if (storeId.value == 0) return; // don't run if storeId not set
    isLoading.value = true;
    error.value = '';
    try {
      final storeModel = await commonApi.fetchStore(storeId: storeId.value);

      // pick the one store that matches the given ID
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

  Future<void> fetchSingleWarehouse() async {
    if (storeId.value == 0) return;
    isWarehouseLoading.value = true;
    warehouseError.value = '';
    try {
      final response = await commonApi.fetchSingleWareHouseById(storeId.value);
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
}

// class WarehouseDetailController extends GetxController {
//   final DioClient dioClient = DioClient();
//   final Logger _logger = Logger();

//   // Reactive state
//   final Rxn<WarehouseModel> warehouseModel = Rxn<WarehouseModel>();
//   final RxList<Item> items = <Item>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with arguments or AuthController
//     fetchWarehouseDetails();
//     fetchWarehouseItems();
//   }

//   Future<void> fetchWarehouseDetails() async {
//     isLoadingWarehouse.value = true;
//     errorWarehouse.value = '';
//     try {
//       final response = await dioClient.dio.get(
//         '$viewWarehouseUrl/$storeId',
//         options: dio.Options(headers: {'Authorization': 'Bearer ${accessToken.value}'}),
//       );

//       if (response.statusCode == 200) {
//         warehouseModel.value = WarehouseModel.fromJson(response.data);
//       } else {
//         errorWarehouse.value = response.data['message'] ?? 'Failed to fetch warehouse details';
//         Get.snackbar('Error', errorWarehouse.value, backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       _logger.e('Error fetching warehouse details: $e');
//       errorWarehouse.value = 'Failed to fetch warehouse details: $e';
//       Get.snackbar('Error', errorWarehouse.value, backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoadingWarehouse.value = false;
//     }
//   }

//   Future<void> fetchWarehouseItems() async {
//     isLoadingItems.value = true;
//     errorItems.value = '';
//     try {
//       final response = await dioClient.dio.get(
//         '$viewAllItemUrl/$storeId',
//         options: dio.Options(headers: {'Authorization': 'Bearer ${accessToken.value}'}),
//       );

//       if (response.statusCode == 200) {
//         final itemModel = ItemModel.fromJson(response.data);
//         items.assignAll(itemModel.data);
//       } else {
//         errorItems.value = response.data['message'] ?? 'Failed to fetch items';
//         Get.snackbar('Error', errorItems.value, backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       _logger.e('Error fetching warehouse items: $e');
//       errorItems.value = 'Failed to fetch items: $e';
//       Get.snackbar('Error', errorItems.value, backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoadingItems.value = false;
//     }
//   }

//   List<Item> get filteredItems {
//     if (searchQuery.value.isEmpty) return items;
//     return items.where((item) {
//       final name = (item.itemName ?? '').toLowerCase();
//       final sku = (item.sku ?? '').toLowerCase();
//       return [name, sku].join(' ').contains(searchQuery.value);
//     }).toList();
//   }

//   int get totalItems => filteredItems.length;

//   int get activeItems => filteredItems.where((item) => (item.status ?? '').toLowerCase() == 'active').length;

//   int get inactiveItems => totalItems - activeItems;

//   int get totalQuantity => filteredItems.fold<int>(0, (prev, item) {
//         final qty = item.quantity;
//         if (qty is int) return prev + qty;
//         if (qty is String) return prev + (int.tryParse(qty) ?? 0);
//         return prev;
//       });
// }

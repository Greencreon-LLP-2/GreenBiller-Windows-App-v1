import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:greenbiller/features/store/model/warehouse_model.dart';
import 'package:logger/logger.dart';

class StoreWarehouseDetailsController extends GetxController {
  late CommonApiFunctionsController commonApi;
  final store = Rxn<StoreData>();
  final warehouses = <dynamic>[].obs;
  final isLoading = true.obs;
  final isWarehouseLoading = true.obs;
  final error = ''.obs;
  final warehouseError = ''.obs;
  late final int storeId;
  @override
  void onInit() {
    super.onInit();
    commonApi = CommonApiFunctionsController();
    storeId = int.parse(Get.parameters['storeId']!);
    fetchStoreDetails(storeId);
  }

  Future<void> fetchStoreDetails(int storeId) async {
    isLoading.value = true;
    error.value = '';
    try {
      final storeModel = await commonApi.fetchStore(storeId: storeId);
      store.value = storeModel.data?.firstWhereOrNull((s) => s.id == storeId);
      if (store.value == null) {
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

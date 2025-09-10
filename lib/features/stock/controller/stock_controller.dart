import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:greenbiller/features/store/model/warehouse_model.dart';

class StockController extends GetxController {
  final DioClient dioClient = DioClient();

  // Stores & Warehouses
  var storeMap = <String, String>{}.obs;
  var toStoreMap = <String, String>{}.obs;
  var warehouseMap = <String, String>{}.obs;
  var fromWarehouseMap = <String, String>{}.obs;
  var toWarehouseMap = <String, String>{}.obs;

  var selectedStore = Rxn<String>();
  var selectedToStore = Rxn<String>();
  var selectedWarehouse = Rxn<String>();
  var selectedFromWarehouse = Rxn<String>();
  var selectedToWarehouse = Rxn<String>();

  // Controllers for input fields
  final itemIdController = TextEditingController();
  final adjustmentQtyController = TextEditingController();
  final transferQtyController = TextEditingController();
  final descriptionController = TextEditingController();

  var isLoading = false.obs;

  // ------------------------- Fetch Stores -------------------------
  Future<void> fetchStores() async {
    try {
      isLoading.value = true;
      final response = await dioClient.dio.get(viewStoreUrl);

      if (response.statusCode == 200) {
        final model = StoreModel.fromJson(response.data);
        if (model.data != null) {
          storeMap.value = {
            for (var e in model.data!) e.storeName ?? '': e.id.toString(),
          };
          toStoreMap.value = Map.from(storeMap);
        }
      } else {
        throw Exception('Failed to fetch stores: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------- Fetch Warehouses -------------------------
  // ------------------------- Fetch Warehouses -------------------------
  Future<void> fetchWarehouses(String? storeId, bool isFrom) async {
    try {
      isLoading.value = true;
      final url = storeId != null
          ? "$viewWarehouseUrl/$storeId"
          : viewWarehouseUrl;
      final response = await dioClient.dio.get(url);

      if (response.statusCode == 200) {
        final model = WarehouseModel.fromJson(response.data);
        final Map<String, String> map = {
          for (var e in model.data ?? [])
            (e.warehouseName ?? ''): (e.id?.toString() ?? ''),
        };

        if (isFrom) {
          fromWarehouseMap.value = map;
        } else {
          toWarehouseMap.value = map;
        }
      } else {
        throw Exception('Failed to fetch warehouses: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch warehouses: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------- Stock Adjustment -------------------------
  Future<void> createStockAdjustment() async {
    if (selectedStore.value == null || selectedWarehouse.value == null) {
      Get.snackbar(
        'Error',
        'Select store and warehouse first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final payload = {
      'store_id': storeMap[selectedStore.value] ?? '',
      'warehouse_id': warehouseMap[selectedWarehouse.value] ?? '',
      'item_id': itemIdController.text,
      'adjustment_qty': adjustmentQtyController.text,
      'status': '1',
      'description': descriptionController.text,
    };

    try {
      final response = await dioClient.dio.post(
        '/stockadjustmentitem-create',
        data: payload,
      );
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Stock Adjusted Successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearFields();
      } else {
        throw Exception('Failed to adjust stock: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ------------------------- Stock Transfer -------------------------
  Future<void> createStockTransfer() async {
    if (selectedStore.value == null ||
        selectedToStore.value == null ||
        selectedFromWarehouse.value == null ||
        selectedToWarehouse.value == null) {
      Get.snackbar(
        'Error',
        'Fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final payload = {
      'store_id': storeMap[selectedStore.value] ?? '',
      'to_store_id': toStoreMap[selectedToStore.value] ?? '',
      'warehouse_from': fromWarehouseMap[selectedFromWarehouse.value] ?? '',
      'warehouse_to': toWarehouseMap[selectedToWarehouse.value] ?? '',
      'item_id': itemIdController.text,
      'transfer_qty': transferQtyController.text,
      'status': '1',
    };

    try {
      final response = await dioClient.dio.post(
        '/stocktransferitem-create',
        data: payload,
      );
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Stock Transferred Successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearFields();
      } else {
        throw Exception('Failed to transfer stock: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ------------------------- Clear Fields -------------------------
  void clearFields() {
    itemIdController.clear();
    adjustmentQtyController.clear();
    transferQtyController.clear();
    descriptionController.clear();
    selectedStore.value = null;
    selectedToStore.value = null;
    selectedWarehouse.value = null;
    selectedFromWarehouse.value = null;
    selectedToWarehouse.value = null;
  }
}

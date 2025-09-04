
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/store/model/store_model.dart';

class StoreDetailController extends GetxController {
  final store = Rxn<StoreData>();
  final warehouses = <dynamic>[].obs;
  final isLoading = true.obs;
  final isWarehouseLoading = true.obs;
  final error = ''.obs;
  final warehouseError = ''.obs;

  Future<void> fetchStoreDetails(int storeId) async {
    isLoading.value = true;
    error.value = '';
    try {
      // final storeController = Get.find<ViewStoreController>();
      // final storeModel = await storeController.fetchStoreById(storeId.toString());
      // store.value = storeModel.data?.firstWhereOrNull((s) => s.id == storeId);
      // if (store.value == null) {
      //   error.value = 'Store not found';
      // }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load store details: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWarehouses() async {
    isWarehouseLoading.value = true;
    warehouseError.value = '';
    try {
      // final warehouseController = Get.find<ViewWarehouseController>();
      // final warehouseModel = await warehouseController.fetchWarehouses();
      // warehouses.assignAll(warehouseModel?.data ?? []);
    } catch (e) {
      warehouseError.value = e.toString();
      Get.snackbar('Error', 'Failed to load warehouses: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isWarehouseLoading.value = false;
    }
  }
}
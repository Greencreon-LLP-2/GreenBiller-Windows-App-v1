import 'package:get/get.dart';
import 'dart:developer';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';

class StoreDropdownController extends GetxController {
  final CommonApiFunctionsController commonApi =
      Get.find<CommonApiFunctionsController>();

  final storeMap = <String, int>{}.obs; // store_name → id
  final selectedStoreId = RxnInt(); // ✅ track selected store id

  final isLoading = false.obs;
  final error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadStores();
  }

  Future<void> loadStores() async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await commonApi.fetchStores();
      storeMap.value = response;
    } catch (e) {
      error.value = e.toString().replaceAll('Exception:', '').trim();
      log('Error loading stores: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get selectedStoreName {
    final id = selectedStoreId.value;
    if (id == null) return 'Select Store';
    final entry = storeMap.entries.firstWhere(
      (entry) => entry.value == id,
      orElse: () => const MapEntry('Select Store', -1),
    );
    return entry.key;
  }
}

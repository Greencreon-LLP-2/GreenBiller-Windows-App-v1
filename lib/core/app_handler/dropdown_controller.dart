import 'package:get/get.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';

class DropdownController extends GetxController {
  final CommonApiFunctionsController commonApi = Get.find();

  // Store
  final storeMap = <String, int>{}.obs;
  final selectedStoreId = Rxn<int>();
  final isLoadingStores = false.obs;

  // Category
  final categoryMap = <String, int>{}.obs;
  final selectedCategoryId = Rxn<int>();
  final isLoadingCategories = false.obs;

  // Brand
  final brandMap = <String, int>{}.obs;
  final selectedBrandId = Rxn<int>();
  final isLoadingBrands = false.obs;

  // Unit
  final unitMap = <String, int>{}.obs;
  final selectedUnitId = Rxn<int>();
  final isLoadingUnits = false.obs;

  // Warehouse
  final warehouseMap = <String, int>{}.obs;
  final selectedWarehouseId = Rxn<int>();
  final isLoadingWarehouses = false.obs;

  final error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // Load stores automatically on init
    _loadInitialData();
  }

  /// Loads initial data for dropdowns
  Future<void> _loadInitialData() async {
    await loadStores();
    if (storeMap.isNotEmpty) {
      selectedStoreId.value = storeMap.values.first;
      // Load dependent dropdowns
      await loadCategories(selectedStoreId.value!);
      await loadBrands(selectedStoreId.value!);
    }
  }

  // STORE API
  Future<void> loadStores() async {
    await _fetchData(
      fetchFn: () => commonApi.fetchStores(),
      targetMap: storeMap,
      isLoading: isLoadingStores,
    );
  }

  // CATEGORY API
  Future<void> loadCategories(int storeId) async {
    await _fetchData(
      fetchFn: () => commonApi.fetchCategories(storeId),
      targetMap: categoryMap,
      isLoading: isLoadingCategories,
    );
  }

  // BRAND API
  Future<void> loadBrands(int storeId) async {
    await _fetchData(
      fetchFn: () => commonApi.fetchBrands(storeId),
      targetMap: brandMap,
      isLoading: isLoadingBrands,
    );
  }

  // UNIT API
  Future<void> loadUnits() async {
    await _fetchData(
      fetchFn: () => commonApi.fetchUnits(),
      targetMap: unitMap,
      isLoading: isLoadingUnits,
    );
  }

  // WAREHOUSE API
  Future<void> loadWarehouses(int? storeId) async {
    await _fetchData(
      fetchFn: () => commonApi.fetchWarehouses(storeId),
      targetMap: warehouseMap,
      isLoading: isLoadingWarehouses,
    );
  }

  /// Generic fetch function for dropdowns
  Future<void> _fetchData({
    required Future<Map<String, int>> Function() fetchFn,
    required RxMap<String, int> targetMap,
    required RxBool isLoading,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;
    error.value = null;

    try {
      final response = await fetchFn();
      targetMap.clear();
      targetMap.addAll(response);
    } catch (e) {
      error.value = e.toString().replaceAll('Exception:', '').trim();
    } finally {
      isLoading.value = false;
    }
  }
}

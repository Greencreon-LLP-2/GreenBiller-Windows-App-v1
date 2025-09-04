import 'dart:convert';

import 'package:get/get.dart';
import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:greenbiller/features/store/model/warehouse_model.dart';
import 'package:logger/logger.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';

class CommonApiFunctionsController extends GetxController {
  final dioClient = DioClient();
  final authController = Get.find<AuthController>();
  final logger = Logger();

  Future<Map<String, int>> fetchDropdownValues({
    required String url,
    required String keyName,
    required String valueName,
    bool isListResponse = true,
    String? listKey,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dioClient.dio.get(
        url,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        List<dynamic> items = [];

        if (isListResponse) {
          items = listKey != null
              ? List<dynamic>.from(response.data[listKey] ?? [])
              : List<dynamic>.from(response.data ?? []);
        } else {
          throw Exception("Unsupported response type for $url");
        }

        final newMap = <String, int>{};
        for (var item in items) {
          final name = item[valueName]?.toString();
          final id = item[keyName];
          if (name != null && id != null) {
            final idInt = id is int ? id : int.tryParse(id.toString());
            if (idInt != null) {
              newMap[name] = idInt;
            } else {
              print("⚠️ Skipping item due to invalid id: $item");
            }
          } else {
            print("⚠️ Skipping item due to missing key/value: $item");
          }
        }

        print("✅ Fetch success: ${newMap.length} items -> $newMap");
        return newMap;
      } else {
        throw Exception("Failed to fetch $url : ${response.data}");
      }
    } catch (e, stack) {
      logger.e("Error fetching dropdown values ($url): $e", e, stack);
      return {};
    }
  }

  /// STORES
  Future<Map<String, int>> fetchStores() async {
    return fetchDropdownValues(
      url: viewStoreUrl,
      keyName: "id",
      valueName: "store_name",
      isListResponse: true,
      listKey: "data",
    );
  }

  /// CATEGORIES
  Future<Map<String, int>> fetchCategories(int storeId) async {
    return fetchDropdownValues(
      url: "$viewCategoriesUrl/$storeId",
      keyName: "id",
      valueName: "name",
      isListResponse: true,
      listKey: "data",
    );
  }

  /// BRANDS
  Future<Map<String, int>> fetchBrands(int storeId) async {
    return fetchDropdownValues(
      url: viewBrandUrl,
      keyName: "id",
      valueName: "brand_name",
      isListResponse: true,
      queryParams: {'store_id': storeId},
      listKey: "data",
    );
  }

  /// UNITS
  Future<Map<String, int>> fetchUnits() async {
    return fetchDropdownValues(
      url: viewUnitUrl,
      keyName: "id",
      valueName: "unit_name",
      isListResponse: true,
      listKey: "data",
    );
  }

  /// WAREHOUSES
  Future<Map<String, int>> fetchWarehouses(int? storeId) async {
    return fetchDropdownValues(
      url: storeId != null ? "$viewWarehouseUrl/$storeId" : viewWarehouseUrl,
      keyName: "id",
      valueName: "warehouse_name",
      isListResponse: true,
      listKey: "data",
    );
  }

  /// Extra: retain list-returning versions if needed
  Future<List<dynamic>> fetchStoreList() async {
    try {
      final response = await dioClient.dio.get(viewStoreUrl);
      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else {
        throw response;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stores: $e');
      throw e;
    }
  }

  Future<List<dynamic>> fetchTaxList() async {
    try {
      final response = await dioClient.dio.get(viewTaxUrl);
      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else {
        throw response;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stores: $e');
      throw e;
    }
  }

  Future<List<dynamic>> fetchWarehousesByStoreID(String? storeId) async {
    try {
      String url = storeId != null
          ? "$viewWarehouseUrl/$storeId"
          : viewWarehouseUrl;
      final response = await dioClient.dio.get(url);
      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else {
        throw response;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch warehouses: $e');
      throw e;
    }
  }

  Future<List<dynamic>> fetchSuppliers(String? storeId) async {
    try {
      String url = storeId != null
          ? "$viewSupplierUrl/$storeId"
          : viewSupplierUrl;
      final response = await dioClient.dio.get(url);
      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else {
        throw response;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch suppliers: $e');
      throw e;
    }
  }

  Future<List<dynamic>> fetchAllItems(String? storeId) async {
    try {
      final url = storeId != null ? "$viewAllItemUrl/$storeId" : viewAllItemUrl;
      final response = await dioClient.dio.get(url);
      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else {
        throw response;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch items: $e');
      throw e;
    }
  }

  Future<UnitModel> viewUnit() async {
    try {
      final response = await dioClient.dio.get(viewUnitUrl);
      if (response.statusCode == 200) {
        return UnitModel.fromJson(response.data);
      } else {
        return UnitModel(message: response.data.toString());
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching units: $e', stackTrace);
      throw Exception(e);
    }
  }

  Future<StoreModel> fetchStore({int? storeId}) async {
    try {
      final url = storeId != null ? "$viewStoreUrl/$storeId" : viewStoreUrl;
      final response = await dioClient.dio.get(url);

      if (response.statusCode == 200) {
        return StoreModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.data}');
      }
    } catch (e, st) {
      logger.e('Error fetching stores: $e', st);
      rethrow;
    }
  }

  Future<WarehouseModel> fetchWarehouse({int? warehouseId}) async {
    try {
      final url = warehouseId != null
          ? "$viewWarehouseUrl/$warehouseId"
          : viewWarehouseUrl;
      final response = await dioClient.dio.get(url);

      if (response.statusCode == 200) {
        return WarehouseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.data}');
      }
    } catch (e, st) {
      logger.e('Error fetching warehouses: $e', st);
      rethrow;
    }
  }
}

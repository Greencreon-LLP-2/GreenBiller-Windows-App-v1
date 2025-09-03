import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';

class CommonApiFunctionsController {
  final DioClient dioClient = DioClient();
  final AuthController authController = Get.find<AuthController>();
  final Logger logger = Logger();

  Future<Map<String, int>> fetchStores({
    bool excludeWalkingCustomer = true,
  }) async {
    try {
      final response = await dioClient.dio.get(viewStoreUrl);

      if (response.statusCode == 200) {
        final stores = response.data['data'];

        if (stores is List) {
          final mappedStores = <String, int>{};
          for (var store in stores) {
            final name = store['store_name'] ?? 'Unnamed Store';
            final id = store['id'] as int;
            mappedStores[name] = id;
          }

          return mappedStores;
        } else {
          logger.w("Unexpected store response format: ${response.data}");
          return {};
        }
      } else {
        logger.w("Failed to fetch stores: ${response.data}");
        return {};
      }
    } catch (e, stack) {
      logger.e("Error fetching stores: $e", e, stack);
      return {};
    }
  }

  Future<List<dynamic>> fetchStoreList() async {
    try {
      final response = await dioClient.dio.get(viewStoreUrl);
      if (response.statusCode == 200) {
        return response.data['data'] as List; // Safe cast
      } else {
        throw response; // Re-throwing non-200 response
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stores: $e');
      throw e; // Re-throwing error for caller to handle
    }
  }

  Future<Map<String, int>> fetchCategories(int storeId) async {
    try {
      final response = await dioClient.dio.get('$viewCategoriesUrl/$storeId');
      if (response.statusCode == 200) {
        final categories = response.data['categories'] as List<dynamic>;
        final newMap = <String, int>{};
        for (var category in categories) {
          if (category['id'] != null && category['name'] != null) {
            newMap[category['name']] = category['id'];
          }
        }
        return newMap;
      } else {
        throw Exception(
          'Failed to load categories: ${response.data['message']}',
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching categories: $e', stackTrace);
      throw Exception(e);
    }
  }

  Future<Map<String, int>> fetchBrands(int storeId) async {
    try {
      final response = await dioClient.dio.get('$viewBrandUrl/$storeId');
      if (response.statusCode == 200) {
        final brandList = response.data as List<dynamic>;
        final newMap = <String, int>{};
        for (var brand in brandList) {
          if (brand['name'] != null && brand['id'] != null) {
            newMap[brand['name']] = int.parse(brand['id'].toString());
          }
        }
        return newMap;
      } else {
        throw Exception('Failed to load brands: ${response.data['message']}');
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching brands: $e', stackTrace);
      throw Exception(e);
    }
  }

  Future<Map<String, int>> fetchUnits() async {
    try {
      final response = await dioClient.dio.get(viewUnitUrl);
      if (response.statusCode == 200) {
        final unitList = response.data['data'] as List<dynamic>;
        final newMap = <String, int>{};
        for (var unit in unitList) {
          if (unit['id'] != null && unit['unit_name'] != null) {
            newMap[unit['unit_name']] = unit['id'];
          }
        }
        return newMap;
      } else {
        throw Exception('Failed to load units: ${response.data['message']}');
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching units: $e', stackTrace);
      throw Exception(e);
    }
  }

  Future<List<dynamic>> fetchWarehousesByStoreID(String storeId) async {
    try {
      final response = await dioClient.dio.get("$viewWarehouseUrl/$storeId");
      if (response.statusCode == 200) {
        return response.data['data'] as List; // Safe cast
      } else {
        throw response; // Re-throwing non-200 response
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stores: $e');
      throw e; // Re-throwing error for caller to handle
    }
  }

  Future<Map<String, String>> fetchWarehouses() async {
    try {
      final response = await dioClient.dio.get(viewWarehouseUrl);
      if (response.statusCode == 200) {
        final warehouseList = response.data as Map<String, dynamic>;
        final newMap = <String, String>{};
        warehouseList.forEach((key, value) {
          newMap[key] = value.toString();
        });
        return newMap;
      } else {
        throw Exception(
          'Failed to load warehouses: ${response.data['message']}',
        );
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching warehouses: $e', stackTrace);
      throw Exception(e);
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
}

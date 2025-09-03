import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';
import 'package:logger/logger.dart';

class CommonApiFunctionsController extends GetxController {
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

  Future<List<dynamic>> fetchWarehouses() async {
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

  Future<List<dynamic>> fetchSuppliers(String? storeId) async {
    try {
      String url = storeId != null
          ? "$viewSupplierUrl/$storeId"
          : viewSupplierUrl;
      final response = await dioClient.dio.get(url);
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

  Future<List<dynamic>> fetchAllItems(String? storeId) async {
    try {
      final url = storeId != null ? "$viewAllItemUrl/$storeId" : viewAllItemUrl;
      final response = await dioClient.dio.get(url);
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

  Future<UnitModel> viewUnit() async {
    try {
      final response = await dioClient.dio.get(viewUnitUrl);
      if (response.statusCode == 200) {
        return UnitModel.fromJson(response.data);
      } else {
        return UnitModel(message: response.data.toString());
      }
    } catch (e, stackTrace) {
      logger.e('Error fetching units: $e', e, stackTrace);
      throw Exception(e);
    }
  }
}

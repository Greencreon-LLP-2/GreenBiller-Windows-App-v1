import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:logger/logger.dart';

class CommonApiFunctionsController extends GetxController {
  final DioClient dioClient = Get.find<DioClient>();
  final AuthController authController = Get.find<AuthController>();
  final Logger logger = Logger();

  
  Future<Map<String, int>> fetchStores({bool excludeWalkingCustomer = true}) async {
    try {
      final response = await dioClient.dio.get(viewStoreUrl);

      if (response.statusCode == 200) {
        final stores = response.data['data'];

        if (stores is List) {
          final storeList = excludeWalkingCustomer
              ? stores.where((store) => store['store_name'] != 'Walking Customer').toList()
              : stores;

          final mappedStores = <String, int>{};
          for (var store in storeList) {
            final name = store['store_name'] ?? 'Unnamed Store';
            final id = store['id'] as int;
            mappedStores[name] = id;
          }

          logger.i("Fetched stores: ${mappedStores.keys.toList()}");
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
}

import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/model/store_model/store_model.dart';
import 'package:green_biller/features/store/services/view_store_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewStoreController {
  final String accessToken;
  final int storeId;

  ViewStoreController({required this.accessToken, required this.storeId});

  Future<String> viewStoreControllerByStoreId() async {
    final response = await viewStoreServiceByStoreId(accessToken, storeId);
    return response.data![0].storeName!;
  }

  Future<Map<String, String>> getSupplierMap() async {
    final response = await viewStoreServiceByStoreId(accessToken, storeId);
    final Map<String, String> supplierMap = {};

    if (response.data != null) {
      for (var store in response.data!) {
        if (store.storeName != null && store.storeCode != null) {
          supplierMap[store.storeName!] = store.storeCode!;
        }
      }
    }

    return supplierMap;
  }

  Future<Map<String, String>> getStoreList() async {
    final response = await viewStoreService(accessToken);
    final Map<String, String> storeMap = {};

    if (response.data != null) {
      for (var store in response.data!) {
        if (store.storeName != null && store.id != null) {
          storeMap[store.storeName!] = store.id.toString();
        }
      }
    }
    return storeMap;
  }
}

final storesProvider = FutureProvider<StoreModel>((ref) {
  final user = ref.watch(userProvider);
  final accessToken = user?.accessToken ?? '';
  if (accessToken.isEmpty) {
    throw Exception('Missing access token');
  }
  return viewStoreService(accessToken); // returns StoreModel with .data list
});

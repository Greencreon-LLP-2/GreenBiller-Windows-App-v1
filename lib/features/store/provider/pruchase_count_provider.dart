import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green_biller/features/purchase/models/purchase_view_model/purchase_view_model.dart';
import 'package:green_biller/features/purchase/services/purchase_view_service.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';


final purchaseCountProvider =
    FutureProvider.family<int, String>((ref, storeId) async {
  final userModel = ref.watch(userProvider);
  final accessToken = userModel?.accessToken;
  if (accessToken == null) throw Exception('No access token available');

  final purchaseService = PurchaseViewService();
  final purchaseView =
      await purchaseService.getPurchaseViewService(accessToken);

  final purchaseCount = purchaseView.data
          ?.where((purchase) => purchase.storeId == storeId)
          .length ??
      0;
  return purchaseCount;
});

final purchaseReturnCountProvider =
    FutureProvider.family<int, String>((ref, storeId) async {
  final userModel = ref.watch(userProvider);
  final accessToken = userModel?.accessToken;
  if (accessToken == null) throw Exception('No access token available');

  final purchaseService = PurchaseViewService();
  final purchaseReturnView =
      await purchaseService.getPurchaseReturnViewService(accessToken);

  final purchaseReturnCount = purchaseReturnView.data
          ?.where((returnItem) => returnItem.storeId == storeId)
          .length ??
      0;
  return purchaseReturnCount;
});

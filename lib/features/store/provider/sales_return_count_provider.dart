import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/service/sales_view_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final salesReturnCountProvider =
    FutureProvider.family<int, String>((ref, storeId) async {
  final userModel = ref.watch(userProvider);
  final accessToken = userModel?.accessToken;
  if (accessToken == null) throw Exception('No access token available');

  final salesService = SalesViewService(accessToken);
  final salesReturnView =
      await salesService.getSalesReturnViewService(accessToken);

  final salesReturnCount = salesReturnView.records
      .where((returnItem) => returnItem.storeId == storeId)
      .length;
  return salesReturnCount;
});

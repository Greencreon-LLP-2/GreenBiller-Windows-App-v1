import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/service/sales_view_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final salesCountProvider =
    FutureProvider.family<int, String>((ref, storeId) async {
  final userModel = ref.watch(userProvider);
  final accessToken = userModel?.accessToken;
  if (accessToken == null) throw Exception('No access token available');

  final salesService = SalesViewService(accessToken);
  final salesView = await salesService.getSalesViewService(accessToken);

  final salesCount =
      salesView.data?.where((sale) => sale.storeId == storeId).length ?? 0;
  return salesCount;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/features/sales/models/sales_return_model.dart';

import 'package:green_biller/features/sales/service/sales_view_service.dart';


final salesReturnProvider =
    FutureProvider.family<SalesReturnModel, String>((ref, accessToken) async {
  return  SalesViewService(accessToken).getSalesReturnViewService(accessToken);
});

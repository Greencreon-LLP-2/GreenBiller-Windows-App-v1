import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/features/sales/models/sales_order_model.dart';

import 'package:green_biller/features/sales/service/sales_view_service.dart';

final salesOrderProvider =
    FutureProvider.family<SalesOrderModel, String>((ref, accessToken) async {
  return SalesViewService(accessToken).getSalesOrdersViewService(accessToken);
});

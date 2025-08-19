import 'package:green_biller/features/sales/models/sales_view_model.dart';
import 'package:green_biller/features/sales/service/sales_view_service.dart';

class SalesViewController {
  Future<SalesViewModel> getSalesViewController(String accessToken) async {
    try {
      final response =
          await SalesViewService(accessToken).getSalesViewService(accessToken);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'package:green_biller/features/purchase/models/purchase_view_model/purchase_view_model.dart';
import 'package:green_biller/features/purchase/services/purchase_view_service.dart';

class ViewPurchaseController {
  Future<PurchaseViewModel> getViewPurchaseController(
      String accessToken, String startDate, String endDate) async {
    try {
      final response =
          await PurchaseViewService().getPurchaseViewService(accessToken);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PurchaseViewModel> getViewPurchaseReturnController(
      String accessToken, String startDate, String endDate) async {
    try {
      final response =
          await PurchaseViewService().getPurchaseReturnViewService(accessToken);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

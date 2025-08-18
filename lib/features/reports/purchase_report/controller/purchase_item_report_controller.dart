import 'package:green_biller/features/reports/purchase_report/models/purchase_item/purchase_item_report_model.dart';
import 'package:green_biller/features/reports/purchase_report/service/purchase_item_report_service.dart';

class PurchaseItemReportController {
  Future<PurchaseItemReportModel> getPurchaseItemReportController(
      String accessToken,
      String fromDate,
      String toDate,
      String storeId,
      String itemId) async {
    try {
      final response = await PurchaseItemReportService()
          .getPurchaseItemReportService(
              accessToken, fromDate, toDate, storeId, itemId);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

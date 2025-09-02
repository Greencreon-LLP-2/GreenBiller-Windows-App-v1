import 'package:green_biller/features/sales/models/sale_item_report_model.dart/sale_item_report_model.dart';
import 'package:green_biller/features/sales/service/sale_item_report_service.dart';

class SalesReportController {
  Future<SaleItemReportModel> getSaleItemReport(String accessToken,
      String startDate, String endDate, String storeId, String itemId) async {
    try {
      final response = await SaleItemReportService()
          .getSaleItemReport(accessToken, startDate, endDate, storeId, itemId);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

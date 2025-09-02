import 'package:green_biller/features/reports/sales_report/models/sales_summary/sales_summary_model.dart';
import 'package:green_biller/features/reports/sales_report/services/sales_summary_service.dart';

class SalesSummaryController {
  Future<SalesSummaryModel> getSalesSummaryController(
      String accessToken,
      String startDate,
      String endDate,
      String? storeId,
      String? customerId) async {
    try {
      final response = await getSalesSummaryService(
          accessToken, startDate, endDate, storeId, customerId);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

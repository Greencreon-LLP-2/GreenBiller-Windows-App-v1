import 'package:green_biller/features/reports/sales_report/models/sales_customer_summary/sales_customer_summary_model.dart';
import 'package:green_biller/features/reports/sales_report/services/sales_customer_summary_service.dart';

class StoreCustomerSummaryController {
  Future<SalesSummaryCustomerModel> getSalesCustomerSummaryController(
      String accessToken,
      String startDate,
      String endDate,
      String storeId,
      String customerId) async {
    try {
      final response = await SalesCustomerSummaryService()
          .getSalesCustomerSummaryService(
              accessToken, startDate, endDate, storeId, customerId);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

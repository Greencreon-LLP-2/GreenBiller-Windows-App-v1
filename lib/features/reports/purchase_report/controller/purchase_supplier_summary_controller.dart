import 'package:green_biller/features/reports/purchase_report/models/purchase_supplier_summary/purchase_suppiler_summary_model.dart';
import 'package:green_biller/features/reports/purchase_report/service/purchase_supplier_summary.dart';

class PurchaseSupplierSummaryController {
  Future<PurchaseSummaryBySupplierModel> getPurchaseSupplierSummaryController(
      String accessToken,
      String startDate,
      String endDate,
      String storeId,
      String supplierId) async {
    try {
      final response = await PurchaseSupplierSummaryService()
          .getPurchaseSupplierSummaryService(
              accessToken, startDate, endDate, storeId, supplierId);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

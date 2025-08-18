import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/reports/purchase_report/models/purchase_supplier_summary/purchase_suppiler_summary_model.dart';
import 'package:http/http.dart' as http;

class PurchaseSupplierSummaryService {
  Future<PurchaseSummaryBySupplierModel> getPurchaseSupplierSummaryService(
      String accessToken,
      String startDate,
      String endDate,
      String storeId,
      String supplierId) async {
    try {
      final response =
          await http.post(Uri.parse(purchaseSupplierSummaryUrl), headers: {
        'Authorization': "Bearer $accessToken",
      }, body: {
        "from_date": startDate,
        "to_date": endDate,
        "store_id": storeId,
        "supplier_id": supplierId,
      });

      if (response.statusCode == 200) {
        return PurchaseSummaryBySupplierModel.fromJson(
            jsonDecode(response.body));
      } else {
        throw Exception('Failed to load purchase supplier summary');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/reports/purchase_report/models/purchase_item/purchase_item_report_model.dart';
import 'package:http/http.dart' as http;

class PurchaseItemReportService {
  Future<PurchaseItemReportModel> getPurchaseItemReportService(
      String accessToken,
      String fromDate,
      String toDate,
      String storeId,
      String itemId) async {
    try {
      final response = await http.post(Uri.parse(purchaseItemSummaryUrl),
          headers: {
            "Authorization": "Bearer $accessToken"
          },
          body: {
            "from_date": fromDate,
            "to_date": toDate,
            "store_id": storeId,
            "item_id": itemId
          });
      if (response.statusCode == 200) {
        return PurchaseItemReportModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

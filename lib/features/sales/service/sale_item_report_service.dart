import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/sales/models/sale_item_report_model.dart/sale_item_report_model.dart';
import 'package:http/http.dart' as http;

class SaleItemReportService {
  Future<SaleItemReportModel> getSaleItemReport(
    String accessToken,
    String startDate,
    String endDate,
    String? storeId,
    String? itemId,
  ) async {
    // Prepare POST body
    final Map<String, String> body = {
      "from_date": startDate,
      "to_date": endDate,
    };

    if (storeId != null && storeId.isNotEmpty) {
      body["store_id"] = storeId;
    }
    if (itemId != null && itemId.isNotEmpty) {
      body["item_id"] = itemId;
    }

    final response = await http.post(
      Uri.parse(salesItemSummaryUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return SaleItemReportModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}

import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/reports/sales_report/models/sales_summary/sales_summary_model.dart';
import 'package:http/http.dart' as http;

Future<SalesSummaryModel> getSalesSummaryService(
  String accessToken,
  String startDate,
  String endDate,
  String? storeId,
  String? customerId,
) async {
  try {
    final Map<String, String> body = {
      "from_date": startDate,
      "to_date": endDate,
    };

    if (storeId != null && storeId.isNotEmpty) {
      body["store_id"] = storeId;
    }
    if (customerId != null && customerId.isNotEmpty) {
      body["customer_id"] = customerId;
    }

    final response = await http.post(
      Uri.parse(salesSummaryUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return SalesSummaryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e);
  }
}

import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/reports/purchase_report/models/purchase_summary/purchase_summary_model.dart';
import 'package:http/http.dart' as http;

class PurchaseSummaryService {
  Future<PurchaseSummaryModel> getPurchaseSummaryService(
    String accessToken,
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await http.post(Uri.parse(purchaseSummaryUrl), headers: {
        "Authorization": "Bearer $accessToken",
      }, body: {
        "from_date": startDate,
        "to_date": endDate,
      });
      if (response.statusCode == 200) {
        return PurchaseSummaryModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load purchase summary');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

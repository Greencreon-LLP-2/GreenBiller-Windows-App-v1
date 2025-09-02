import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/reports/sales_report/models/sales_customer_summary/sales_customer_summary_model.dart';
import 'package:http/http.dart' as http;

class SalesCustomerSummaryService {
  Future<SalesSummaryCustomerModel> getSalesCustomerSummaryService(
      String accessToken,
      String startDate,
      String endDate,
      String storeId,
      String customerId) async {
    try {
      final response =
          await http.post(Uri.parse(salesCustomerSummaryUrl), headers: {
        "Authorization": "Bearer $accessToken",
      }, body: {
        "from_date": startDate,
        "to_date": endDate,
        "store_id": storeId,
        "customer_id": customerId,
      });

      if (response.statusCode == 200) {
        return SalesSummaryCustomerModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

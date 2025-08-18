import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/sales/models/sales_view_model.dart';
import 'package:http/http.dart' as http;

class SalesViewService {
  Future<SalesViewModel> getSalesViewService(String accessToken) async {
    try {
      final response = await http.get(Uri.parse(viewSalesUrl), headers: {
        "Authorization": "Bearer $accessToken",
      });
      if (response.statusCode == 200) {
        return SalesViewModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/home/model/tax_model.dart';
import 'package:http/http.dart' as http;

class TaxService {
  Future<TaxModel> getTaxService() async {
    try {
      final response = await http.get(Uri.parse(viewTaxUrl));
      if (response.statusCode == 200) {
        return TaxModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load tax data');
      }
    } catch (e) {
      throw Exception('Error fetching tax data: $e');
    }
  }
}

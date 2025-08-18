import 'dart:developer';

import 'package:green_biller/features/home/model/tax_model.dart';
import 'package:green_biller/features/home/services/tax_service.dart';

class TaxController {
  Future<TaxModel> getTaxController() async {
    try {
      final response = await TaxService().getTaxService();
      return response;
    } catch (e) {
      throw Exception('Error fetching tax data: $e');
    }
  }

  //* ===================================================This method retrieves a list of tax names from the tax service.
  Future<List<String>> getTaxListController() async {
    try {
      final response = await TaxService().getTaxService();
      final List<String> tax = [];
      response.data?.forEach((e) {
        tax.add(e.taxName ?? '');
      });
      log('tax list is ------$tax');
      // Process the response and populate the tax list
      return tax;
    } catch (e) {
      throw Exception('Error updating tax data: $e');
    }
  }
}

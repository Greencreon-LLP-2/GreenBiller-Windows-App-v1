import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AddSupplierService {
  Future<String> addSupplierService(
      String accessToken,
      int storeId,
      String name,
      String phone,
      String email,
      String address,
      String gstin) async {
    try {
      final response = await http.post(Uri.parse(addSupplierUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      }, body: {
        'store_id': storeId.toString(),
        // 'cound_id': 1,
        // 'supplier_code': 1,
        'supplier_name': name,
        'mobile': phone,
        // 'phone': 1,
        'email': email,
        'gstin': gstin,
        // 'tax_number': 1,
        // 'vatin': 1,
        // 'opening_balance': 1,
        // 'purchase_due': 1,
        // 'purchase_return_due': 1,
        // 'country_id': 1,
        // 'state_id': 1,
        // 'state': 1,
        // 'city': 1,
        // 'postcode': 1,
        'address': address,
        // 'company_id': 1,
        // 'status': 1,
      });
      if (response.statusCode == 201) {
        return "Supplier added successfully";
      } else {
        return response.body;
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}

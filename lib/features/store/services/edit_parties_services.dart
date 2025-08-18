import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class EditPartiesServices {
  final String accestoken;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String gstin;

  EditPartiesServices({
    required this.accestoken,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.gstin,
  });

//*============================================== supplier update api call==============================================*//
  Future<String> editSupplierServices(String supplierId) async {
    try {
      final response = await http.put(
        Uri.parse('$editSupplierUrl/$supplierId'),
        headers: {
          'Authorization': 'Bearer $accestoken',
        },
        body: {
          'supplier_name': name,
          'mobile': phone,
          'email': email,
          'address': address,
          'gstin': gstin,
        },
      );
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['message'] ==
              "Supplier Details updated successfully") {
        log('Supplier updated successfully');
        return 'Supplier updated successfully';
      } else {
        log('Failed to update supplier');
        return 'Failed to update supplier';
      }
    } catch (e) {
      log(e.toString());
      return 'Failed to update supplier';
    }
  }

//*============================================== customer update api call==============================================*//

  Future<String> editCustomerServices(String customerId) async {
    log('$editCustomerUrl/$customerId');
    try {
      final response = await http.put(
        Uri.parse('$editCustomerUrl/$customerId'),
        headers: {
          'Authorization': 'Bearer $accestoken',
        },
        body: {
          'customer_name': name,
          'mobile': phone,
          'email': email,
          'address': address,
          'gstin': gstin,
        },
      );
      log(response.body);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['message'] ==
              "Customer Details updated successfully") {
        return "Customer updated successfully";
      } else {
        return "Failed to update customer";
      }
    } catch (e) {
      log(e.toString());
      return 'Failed to update customer';
    }
  }
}

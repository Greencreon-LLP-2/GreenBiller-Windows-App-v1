import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/store/model/customer_model/customer_model.dart';
import 'package:green_biller/features/store/model/supplier_model/supplier_model.dart';
import 'package:http/http.dart' as http;

class ViewPartiesServies {
  Future<CustomerModel> viewCustomerServies(
      String accessToken, String? storeId) async {
    final isStoreIdValid = storeId != null &&
        storeId.isNotEmpty &&
        storeId != 'null' &&
        storeId != 'undefined';

    String url = isStoreIdValid ? "$viewCustomerUrl/$storeId" : viewCustomerUrl;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log(body.toString());
        return CustomerModel.fromJson(body);
      } else {
        throw Exception(body['message']);
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<SupplierModel> viewSupplierServies(
      String accessToken, String? storeId) async {
    final isStoreIdValid = storeId != null &&
        storeId.isNotEmpty &&
        storeId != 'null' &&
        storeId != 'undefined';

    String url = isStoreIdValid ? "$viewSupplierUrl/$storeId" : viewSupplierUrl;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return SupplierModel.fromJson(body);
      } else {
        throw Exception(body['message']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> deleteCustomerSerivce(
    String accessToken,
    String id,
  ) async {
    String url = "$deleteCustomerUrl/$id";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<int> deleteSupplierSerivce(
    String accessToken,
    String id,
  ) async {
    String url = "$deleteSupplierUrl/$id";
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}

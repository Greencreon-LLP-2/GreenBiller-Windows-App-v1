import 'dart:developer';

import 'package:green_biller/features/store/model/customer_model/customer_model.dart';
import 'package:green_biller/features/store/model/supplier_model/supplier_model.dart';
import 'package:green_biller/features/store/services/view_parties_servies.dart';

class ViewPartiesController {
  Future<CustomerModel> viewCustomer(
      String accessToken, String? storeId) async {
    try {
      final response =
          await ViewPartiesServies().viewCustomerServies(accessToken, storeId);
      return response;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<SupplierModel> viewSupplier(
      String accessToken, String? storeId) async {
    try {
      final response =
          await ViewPartiesServies().viewSupplierServies(accessToken, storeId);
      return response;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<Map<String, String>> supplierList(
      String accessToken, String? storeId) async {
    final supperModel =
        await ViewPartiesServies().viewSupplierServies(accessToken, storeId);

    final Map<String, String> supplierMap = Map.fromEntries(
      supperModel.data!.map((e) => MapEntry(e.supplierName!, e.id.toString())),
    );
    log('$supplierMap');

    // List<String> supplierNameList = supplierMap.keys.toList();
    return supplierMap;
  }

  Future<Map<String, String>> customerList(
      String accessToken, String? storeId) async {
    final customerModel =
        await ViewPartiesServies().viewCustomerServies(accessToken, storeId);

    final Map<String, String> customerMap = Map.fromEntries(
      customerModel.data!
          .map((e) => MapEntry(e.customerName!, e.id.toString())),
    );
    log('$customerMap');

    // List<String> customerNameList = customerMap.keys.toList();
    return customerMap;
  }
}

import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/models/sales_order_model.dart';
import 'package:green_biller/features/sales/models/sales_return_model.dart';
import 'package:green_biller/features/sales/models/sales_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;



class SalesViewService {
  final String accessToken;
  SalesViewService(this.accessToken);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  Future<SalesViewModel> getSalesViewService(String accessToken) async {
    try {
      final response =
          await http.get(Uri.parse(viewSalesUrl), headers: _headers);
      if (response.statusCode == 200) {
        return SalesViewModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> createSalesReturn(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salesreturn-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Sales Return: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['data']['id'];
  }

  Future<void> createSalesItemReturn(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salesitemreturn-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Sales Item Return: ${response.body}');
    }
  }

  Future<void> createSalesPaymentReturn(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salespaymentreturn-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to create Sales Payment Return: ${response.body}');
    }
  }

  Future<SalesReturnModel> getSalesReturnViewService(String accessToken) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/salesreturn-view'),
          headers: _headers);
      if (response.statusCode == 200) {
        return SalesReturnModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> createSalesOrder(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/order-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Sales Order: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return data['data']
        ['id']; // Assuming the response returns the created order ID
  }

  Future<void> createSalesOrderItem(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orderitem-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Order Item: ${response.body}');
    }
  }

  Future<void> createOrderStatus(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orderstatus-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Order Status: ${response.body}');
    }
  }

  Future<SalesOrderModel> getSalesOrdersViewService(String accessToken) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/order-view'), headers: _headers);
      if (response.statusCode == 200) {
        return SalesOrderModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createStockTransferItem(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stocktransferitem-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Order Status: ${response.body}');
    }
  }

  Future<void> createStockAdjustmentItem(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/stockadjustmentitem-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Order Status: ${response.body}');
    }
  }
}

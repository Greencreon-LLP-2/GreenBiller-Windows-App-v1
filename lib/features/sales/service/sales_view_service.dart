import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/sales/models/sales_return_model.dart';
import 'package:green_biller/features/sales/models/sales_view_model.dart';
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

  Future<void> createSalesOrderItem(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salesitemreturn-create'),
      headers: _headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create Sales Item Return: ${response.body}');
    }
  }
}

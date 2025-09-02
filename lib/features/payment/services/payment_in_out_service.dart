import 'dart:convert';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class PaymentInOutService {
  final String accessToken;
  PaymentInOutService(this.accessToken);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<dynamic>> getPaymentIn({String? storeId}) async {
    final url = Uri.parse(
      storeId != null && storeId.isNotEmpty
          ? '$baseUrl/salespayment-in?store_id=$storeId}'
          : '$baseUrl/salespayment-in',
    );

    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    } else {
      throw Exception('Failed to fetch Payment In: ${response.body}');
    }
  }

  Future<List<dynamic>> getPaymentOut({String? storeId}) async {
    final url = Uri.parse(
      storeId != null
          ? '$baseUrl/purchasepayment-out?store_id=$storeId}'
          : '$baseUrl/purchasepayment-out',
    );

    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'] ?? [];
    } else {
      throw Exception('Failed to fetch Payment Out: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> viewCustomerServies(
      String? storeId) async {
    final isStoreIdValid = storeId != null &&
        storeId.isNotEmpty &&
        storeId != 'null' &&
        storeId != 'undefined';

    String url = isStoreIdValid ? "$viewCustomerUrl/$storeId" : viewCustomerUrl;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = body['data'];
        if (data is List) {
          return List<Map<String, dynamic>>.from(
            data.map((e) => Map<String, dynamic>.from(e)),
          );
        } else {
          throw Exception("Expected a list but got: ${data.runtimeType}");
        }
      } else {
        throw Exception(
            body['message'] ?? "Failed with ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching customers: $e");
    }
  }

  Future<List<Map<String, dynamic>>> viewSupplierServies(
      String? storeId) async {
    final isStoreIdValid = storeId != null &&
        storeId.isNotEmpty &&
        storeId != 'null' &&
        storeId != 'undefined';

    String url = isStoreIdValid ? "$viewSupplierUrl/$storeId" : viewSupplierUrl;

    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'];
        if (data is List) {
          return List<Map<String, dynamic>>.from(
            data.map((e) => Map<String, dynamic>.from(e)),
          );
        } else {
          throw Exception("Expected a list but got: ${data.runtimeType}");
        }
      } else {
        throw Exception(body['message']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> savePaymentIn(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/salespayment-in');
    final response =
        await http.post(url, headers: _headers, body: jsonEncode(data));

    if (response.statusCode == 200 || response.statusCode == 422) {
      return jsonDecode(
          response.body); // Laravel sends 422 for validation errors
    } else {
      throw Exception('Failed to save Payment In');
    }
  }

  Future<Map<String, dynamic>> savePaymentOut(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/purchasepayment-out');
    final response =
        await http.post(url, headers: _headers, body: jsonEncode(data));

    if (response.statusCode == 201 || response.statusCode == 422) {
      return jsonDecode(
          response.body); // Laravel sends 422 for validation errors
    } else {
      throw Exception('Failed to save Payment out');
    }
  }
}

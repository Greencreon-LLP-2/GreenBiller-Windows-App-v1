import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/purchase/models/purcahse_single_all_deatils.dart';
import 'package:green_biller/features/purchase/models/purchase_view_model/purchase_view_model.dart';
import 'package:http/http.dart' as http;

class PurchaseViewService {
  Future<PurchaseViewModel> getPurchaseViewService(String accessToken) async {
    try {
      final response = await http.get(Uri.parse(viewPurchaseUrl), headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (response.statusCode == 200) {
        return PurchaseViewModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<PurcahseSingleAllDeatils> getPurchaseViewByIdService(
      String accessToken, String purcahseId) async {
    try {
      final url = '$viewPurchaseUrl/$purcahseId';
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (response.statusCode == 200) {
        return PurcahseSingleAllDeatils.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e, stack) {
      print(stack);
      throw Exception(e);
    }
  }

  Future<PurcahseSingleAllDeatils> createPurchaseReturnService(
    String accessToken,
    Map<String, dynamic> returnData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/purchasereturn-create'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(returnData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return PurcahseSingleAllDeatils.fromJson(
            responseData['data'] ?? responseData);
      } else {
        throw Exception('Failed to create purchase return: ${response.body}');
      }
    } catch (e) {
      print('Error in createPurchaseReturnService: $e');
      rethrow;
    }
  }

  Future<dynamic> createPurchaseItemReturnService(
    String accessToken,
    Map<String, dynamic> itemData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/purchaseitemreturn-create'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(itemData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to create purchase item return: ${response.body}');
      }
    } catch (e) {
      print('Error in createPurchaseItemReturnService: $e');
      rethrow;
    }
  }

  Future<dynamic> createPurchasePaymentReturnService(
    String accessToken,
    Map<String, dynamic> paymentData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/purchasepaymentreturn-create'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(paymentData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to create purchase payment return: ${response.body}');
      }
    } catch (e) {
      print('Error in createPurchasePaymentReturnService: $e');
      rethrow;
    }
  }

  Future<PurchaseViewModel> getPurchaseReturnViewService(
      String accessToken) async {
    try {
      final response =
          await http.get(Uri.parse(purchaseReturnViewUrl), headers: {
        "Authorization": "Bearer $accessToken",
      });

      if (response.statusCode == 200) {
        return PurchaseViewModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

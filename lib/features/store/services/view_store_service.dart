import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/store/model/store_model/store_model.dart';
import 'package:green_biller/features/store/model/store_model_by_id/store_model_by_id.dart';
import 'package:http/http.dart' as http;

Future<StoreModel> viewStoreService(String accessToken) async {
  try {
    final response = await http.get(
      Uri.parse(viewStoreUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return StoreModel.fromJson(body as Map<String, dynamic>);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  } catch (e, st) {
    log('API Call Failed: $e\n$st');
    rethrow; // keeps the real error visible in Riverpod
  }
}

Future<StoreModel> viewStoreServiceByStoreId(
    String accessToken, int storeId) async {
  final url = "$viewStoreUrl/$storeId";
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "content-type": "application/json"
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final storeModel = StoreModel.fromJson(body);
      return storeModel;
    } else {
      throw Exception(body['message']);
    }
  } catch (e) {
    log(e.toString());
    throw Exception(e);
  }
}

Future<StoreModelById> newViewStoreServiceByStoreId(
    String accessToken, int storeId) async {
  final url = "$viewStoreUrl/$storeId";
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "content-type": "application/json"
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (body["data"] != null && body["data"].isNotEmpty) {
        return StoreModelById.fromJson(body["data"][0]); // 👈 FIX
      } else {
        throw Exception("No store found for id $storeId");
      }
    } else {
      throw Exception(body['message'] ?? 'Failed to fetch store');
    }
  } catch (e) {
    log("newViewStoreServiceByStoreId error: $e");
    throw Exception('Failed to load store: $e');
  }
}

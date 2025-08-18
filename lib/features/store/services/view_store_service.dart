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
        "content-type": "application/json"
      },
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return StoreModel.fromJson(json.decode(response.body));
    } else {
      // Handle API errors
      throw Exception('API Error: ${response.statusCode}');
    }
  } catch (e) {
    log('API Call Failed: $e');
    throw Exception('Failed to load stores');
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
      final storeModel = StoreModelById.fromJson(body);
      return storeModel;
    } else {
      throw Exception(body['message']);
    }
  } catch (e) {
    log(e.toString());
    throw Exception(e);
  }
}

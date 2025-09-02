import 'dart:convert';

import 'package:green_biller/main.dart';
import 'package:http/http.dart' as http;

class BatchService {
  Future<Map<String, String>> getBatchDataService({
    required String accessToken,
    required String userId,
    required String storeId,
    required String productName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.example.com/batch/$productName'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'user_id': userId,
          'store_id': storeId,
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final Map<String, dynamic> batchData = {};
        return data.map((key, value) {
          batchData[key] = value.toString();
        });
      } else {
        logger.e("Failed to fetch batch data: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      logger.e("Error fetching batch data: $e");
      return {};
    }
  }

  Future<bool> createBatchService({
    required String accessToken,
    required String userId,
    required String storeId,
    required String productName,
    required String batchNumber,
    required String purchasePrice,
    required String salesPrice,
  }) async {
    return http.post(
      Uri.parse('https://api.example.com/batch/create'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'user_id': userId,
        'store_id': storeId,
        'product_name': productName,
        'batch_number': batchNumber,
        'purchase_price': purchasePrice,
        'sales_price': salesPrice,
      },
    ).then((response) {
      if (response.statusCode == 201) {
        logger.i("Batch created successfully");
        return true;
      } else {
        logger.e("Failed to create batch: ${response.statusCode}");
        return false;
      }
    }).catchError((error) {
      logger.e("Error creating batch: $error");
      return false;
    });
  }
}

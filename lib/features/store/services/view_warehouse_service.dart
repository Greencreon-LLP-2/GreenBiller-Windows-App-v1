import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/model/warehouse_model/warehouse_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class ViewWarehouseService {
  final String accessToken;

  ViewWarehouseService({required this.accessToken});

  Future<WarehouseModel> viewWarehouseService() async {
    try {
      final response = await http.get(
        Uri.parse(viewWarehouseUrl),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      log('Warehouse API Response: ${response.body}');
      final decodedData = jsonDecode(response.body);
      log('Decoded Data: $decodedData');

      if (response.statusCode == 200) {
        final model = WarehouseModel.fromJson(decodedData);
        log('Parsed Model: ${model.toString()}');
        if (model.data != null && model.data!.isNotEmpty) {
          log('First Warehouse Name: ${model.data![0].warehouseName}');
        }
        return model;
      } else {
        throw Exception(
            decodedData['message'] ?? 'Failed to fetch warehouse data');
      }
    } catch (e) {
      log('Error in viewWarehouseService: $e');
      throw Exception('Failed to load Warehouses');
    }
  }

  Future<WarehouseModel> viewWarehouseByIdService(String storeId) async {
    try {
      final response = await http.get(
        Uri.parse("$viewWarehouseUrl/$storeId"),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      log('Warehouse API Response: ${response.body}');
      final decodedData = jsonDecode(response.body);
      log('Decoded Data: $decodedData');

      if (response.statusCode == 200) {
        final model = WarehouseModel.fromJson(decodedData);
        log('Parsed Model: ${model.toString()}');
        if (model.data != null && model.data!.isNotEmpty) {
          log('First Warehouse Name: ${model.data![0].warehouseName}');
        }
        return model;
      } else {
        throw Exception(
            decodedData['message'] ?? 'Failed to fetch warehouse data');
      }
    } catch (e) {
      log('Error in viewWarehouseService: $e');
      throw Exception('Failed to load Warehouses');
    }
  }
}

final warehouseByIdProvider =
    FutureProvider.family<WarehouseModel, String>((ref, warehouseId) async {
  final user = ref.watch(userProvider);
  final accessToken = user?.accessToken ?? '';
  if (accessToken.isEmpty) {
    throw Exception('Missing access token');
  }

  final uri = Uri.parse('$viewSingleWarehouseUrl?store_id=$warehouseId');
  final response = await http.get(
    uri,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    },
  );

  log('Warehouse API Response (${uri.toString()}): ${response.body}');
  final decodedData = jsonDecode(response.body);
  log('Decoded Data: $decodedData');

  if (response.statusCode == 200) {
    final model = WarehouseModel.fromJson(decodedData);
    log('Parsed Model: ${model.toString()}');
    if (model.data != null && model.data!.isNotEmpty) {
      log('First Warehouse Name: ${model.data![0].warehouseName}');
    }
    return model;
  } else {
    throw Exception(decodedData['message'] ?? 'Failed to fetch warehouse data');
  }
});

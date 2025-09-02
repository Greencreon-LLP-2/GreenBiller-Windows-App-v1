import 'dart:developer';

import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/model/warehouse_model/warehouse_model.dart';
import 'package:green_biller/features/store/services/view_warehouse_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewWarehouseController {
  final String accessToken;

  ViewWarehouseController({required this.accessToken});

  Future<WarehouseModel?> viewWarehouseController() async {
    try {
      final response = await ViewWarehouseService(accessToken: accessToken)
          .viewWarehouseService();
      log(response.toString());
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, String>> warehouseListController() async {
    try {
      final response = await ViewWarehouseService(accessToken: accessToken)
          .viewWarehouseService();
      final Map<String, String> warehouseMap = Map.fromEntries(
        response.data!.map((e) => MapEntry(e.warehouseName!, e.id.toString())),
      );
      return warehouseMap;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, String>> warehouseListByIdController(
      String storeId) async {
    try {
      final response = await ViewWarehouseService(accessToken: accessToken)
          .viewWarehouseByIdService(storeId);
      final Map<String, String> warehouseMap = Map.fromEntries(
        response.data!.map((e) => MapEntry(e.warehouseName!, e.id.toString())),
      );
      return warehouseMap;
    } catch (e) {
      throw Exception(e);
    }
  }
}

final warehouseListProvider = FutureProvider<WarehouseModel?>((ref) {
  final user = ref.watch(userProvider);
  final accessToken = user?.accessToken ?? '';
  if (accessToken.isEmpty) {
    throw Exception('Missing access token');
  }
  return ViewWarehouseController(accessToken: accessToken)
      .viewWarehouseController();
});

final singleWarehouseProvider = FutureProvider<WarehouseModel?>((ref) {
  final user = ref.watch(userProvider);
  final accessToken = user?.accessToken ?? '';
  if (accessToken.isEmpty) {
    throw Exception('Missing access token');
  }
  return ViewWarehouseController(accessToken: accessToken)
      .viewWarehouseController();
});

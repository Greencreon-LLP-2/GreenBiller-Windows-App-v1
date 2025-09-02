import 'dart:math';

import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final warehouseCountProvider = FutureProvider.family<int, String>(
  (ref, storeId) async {
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken ?? '';
    if (accessToken.isEmpty) {
      throw Exception('Missing access token');
    }
    try {
      final warehouseMap =
          await ViewWarehouseController(accessToken: accessToken)
              .warehouseListByIdController(storeId);
      return warehouseMap.length;
    } catch (e) {
      log('Error fetching warehouse count for store $storeId: $e' as num);
      return 0;
    }
  },
);
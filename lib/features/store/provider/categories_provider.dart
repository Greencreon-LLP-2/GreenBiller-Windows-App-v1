import 'dart:math';

import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/services/category/view_categories_service.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoriesProvider = FutureProvider.family<List<dynamic>, String>(
  (ref, storeId) async {
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken ?? '';
    if (accessToken.isEmpty) {
      throw Exception('Authentication required');
    }
    try {
      ref.watch(storesProvider);
      return await getCategoriesService(accessToken, storeId);
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        log('Token expired, please log in again' as num);
        throw Exception('Session expired. Please log in again.');
      }
      rethrow;
    }
  },
);
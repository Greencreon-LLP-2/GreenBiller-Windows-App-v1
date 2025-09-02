// // lib/features/store/controller/store_providers.dart
// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:green_biller/core/constants/api_constants.dart';
// import 'package:green_biller/features/auth/login/model/user_model.dart';
// import 'package:green_biller/features/store/model/store_model/store_model.dart';
// import 'package:green_biller/features/store/model/store_model_by_id/store_model_by_id.dart';
// import 'package:green_biller/features/store/model/user_role_model.dart';
// import 'package:http/http.dart' as http;

// /// Provider to get the current user's store (requires user.storeId)
// final userStoreProvider = FutureProvider<StoreModel?>((ref) async {
//   final user = ref.watch(userProvider);
//   if (user == null || user.user?.userLevel == null) {
//     throw Exception('User not logged in');
//   }

//   // Parse role and ensure user has access (example: non-admins need storeId)
//   final role = UserRoleModel.fromIdString(user.user?.userLevel);
//   final storeId = user.user?.storeId;
//   final accessToken = user.accessToken ?? '';

//   if (storeId == null) {
//     return null; // or throw if you want to enforce it
//   }

//   // Example: all roles except none can fetch their own store
//   if (role == UserRoleModel.none) {
//     throw Exception('Invalid role, cannot fetch store');
//   }

//   return await viewStoreServiceByStoreId(accessToken, storeId);
// });

// /// Provider to get all stores (admin-only)
// final allStoresProvider = FutureProvider<List<StoreModel>>((ref) async {
//   final user = ref.watch(userProvider);
//   if (user == null || user.user?.userLevel == null) {
//     throw Exception('User not logged in');
//   }

//   final role = UserRoleModel.fromIdString(user.user?.userLevel);
//   final accessToken = user.accessToken ?? '';

//   // Only permit admin-like roles to fetch all stores
//   final allowedAdminRoles = [
//     UserRoleModel.superAdmin,
//     UserRoleModel.manager,
//     UserRoleModel.storeAdmin,
//     UserRoleModel.storeManager,
//     UserRoleModel.storeAccountant,
//   ];
//   if (!allowedAdminRoles.contains(role)) {
//     throw Exception('Unauthorized to view all stores');
//   }

//   return await fetchAllStoresService(accessToken);
// });

// /// Provider to get warehouses for the current user's store (requires storeId)
// final userWarehousesProvider = FutureProvider<List<dynamic>>((ref) async {
//   final user = ref.watch(userProvider);
//   if (user == null || user.user?.userLevel == null) {
//     throw Exception('User not logged in');
//   }

//   final role = UserRoleModel.fromIdString(user.user?.userLevel);
//   final storeId = user.user?.storeId;
//   final accessToken = user.accessToken ?? '';

//   if (storeId == null) {
//     return []; // or throw
//   }

//   if (role == UserRoleModel.none) {
//     throw Exception('Invalid role, cannot fetch warehouses');
//   }

//   return await fetchWarehousesByStoreId(accessToken, storeId);
// });

// /// Provider to get all warehouses (admin-only)
// final allWarehousesProvider = FutureProvider<List<dynamic>>((ref) async {
//   final user = ref.watch(userProvider);
//   if (user == null || user.user?.userLevel == null) {
//     throw Exception('User not logged in');
//   }

//   final role = UserRoleModel.fromIdString(user.user?.userLevel);
//   final accessToken = user.accessToken ?? '';

//   final allowedAdminRoles = [
//     UserRoleModel.superAdmin,
//     UserRoleModel.manager,
//     UserRoleModel.storeAdmin,
//     UserRoleModel.storeManager,
//     UserRoleModel.storeAccountant,
//   ];
//   if (!allowedAdminRoles.contains(role)) {
//     throw Exception('Unauthorized to view all warehouses');
//   }

//   return await fetchAllWarehousesService(accessToken);
// });

import 'dart:io';

import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/model/category/category_list_model.dart';
import 'package:green_biller/features/item/services/category/add_category_service.dart';
import 'package:green_biller/features/item/services/category/view_categories_service.dart';
import 'package:green_biller/features/store/services/view_store_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddCategoryController {
  final List<Map<int, String>> storeList = [];

  Future<String?> addCategoryController(
      String accessToken, String categoryName, String userId, int? storeId,
      {File? imageFile}) async {
    final response = await addCategoryService(
        accessToken, categoryName, userId, storeId,
        imageFile: imageFile);
    if (response == "Category created successfully") {
      return response;
    } else {
      return response;
    }
  }

  Future<List<Map<int, String>>> getStoreList(String accessToken) async {
    final response = await viewStoreService(accessToken);
    final newCategories = response.data!
        .where((e) => e.id != null && e.storeName != null)
        .map<Map<int, String>>((e) => {e.id!: e.storeName!})
        .toList();

    storeList.addAll(newCategories);
    return storeList;
  }

  Future<List<Map<int, String>>> getCategoryList(
      String accessToken, String? storeId) async {
    final CategoryListModel model =
        await viewCategoriesService(accessToken, storeId);
    final categories = model.categories ?? [];

    return categories
        .where((c) => c.id != null && c.name != null)
        .map((c) => {c.id!: c.name!})
        .toList();
  }
}

final categoriesProvider = FutureProvider<CategoryListModel>((ref) {
  final user = ref.watch(userProvider);
  final accessToken = user?.accessToken ?? '';
  if (accessToken.isEmpty) {
    throw Exception('Missing access token');
  }
  return viewCategoriesService(accessToken, null);
});

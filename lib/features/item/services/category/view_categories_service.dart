import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/item/model/category/category_list_model.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:http/http.dart' as http;

Future<CategoryListModel> viewCategoriesService(
    String accessToken, String? storeId) async {
  String url =
      storeId != null ? '$viewCategoriesUrl/$storeId' : viewCategoriesUrl;
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
      "content-type": "application/json"
    });
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final categories = CategoryListModel.fromJson(body);
      return categories;
    } else {
      return CategoryListModel();
    }
  } catch (e) {
    log(e.toString());
    throw Exception(e);
  }
}

Future<int?> deleteCatgoryById(String? accessToken, String? id) async {
  try {
    final response = await http.delete(
      Uri.parse("$deleteCategoriesUrl/$id"),
      headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.statusCode;
  } catch (e) {
    return 500;
  }
}

Future<List<dynamic>> getCategoriesService(
    String accessToken, String storeId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/category-view'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return data['data'] ?? [];
    } else {
      throw Exception(
          'Failed to load categories: ${response.statusCode} - ${response.body}');
    }
  } catch (e, stackTrace) {
    throw Exception('Error fetching categories: $e');
  }
}

Future<List<Item>> getItemsBasedOnCateId(
    String accessToken, String cateId) async {
  final String url = "$baseUrl/category/$cateId/items";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        "content-type": "application/json"
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['data'] != null) {
      final List<dynamic> dataList = body['data'];
      final List<Item> items = dataList.map((e) => Item.fromJson(e)).toList();
      return items;
    } else {
      log("Error ${response.statusCode}: ${body.toString()}");
      return [];
    }
  } catch (e, stack) {
    log(stack.toString());
    throw Exception(e);
  }
}

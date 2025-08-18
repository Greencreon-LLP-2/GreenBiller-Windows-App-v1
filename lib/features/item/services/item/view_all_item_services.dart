import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:http/http.dart' as http;

Future<ItemModel> getAllItemService({
  required String accessToken,
  String? storeId,
}) async {
  try {
    final url = storeId != null ? "$viewAllItemUrl/$storeId" : viewAllItemUrl;
    final response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final itemModel = ItemModel.fromJson(data);

      return itemModel;
    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<int?> deleteItemById(String? accessToken, String? id) async {
  try {
    final response = await http.delete(
      Uri.parse("$deleteItemUrl/$id"),
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

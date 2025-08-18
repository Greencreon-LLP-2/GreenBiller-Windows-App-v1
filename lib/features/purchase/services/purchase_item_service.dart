import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/purchase/models/purchase_item_model.dart';
import 'package:http/http.dart' as http;

class PurchaseItemService {
  Future<PurchaseItemModel> getPurchaseItemService(
      String accessToken, String storeId) async {
    try {
      final response =
          await http.post(Uri.parse(purchaseItemViewUrl), headers: {
        "Authorization": "Bearer $accessToken"
      }, body: {
        "store_id": storeId,
      });
      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        final purchaseItemModel = PurchaseItemModel.fromJson(decodedBody);
        return purchaseItemModel;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

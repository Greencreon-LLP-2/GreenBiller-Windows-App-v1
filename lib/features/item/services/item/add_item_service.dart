import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AddItemService {
  final String accessToken;
  final int userId;
  final int storeId;
  final int? categoryId;
  final int? brandId;
  final String itemName;
  final File? itemImage;
  final String sku;
  final String hsnCode;
  final String itemCode;
  final String barcode;
  final String unit;
  final int purchasePrice;
  final String taxType;
  final int taxRate;
  final int salesPrice;
  final String mrp;
  final String discountType;
  final int discount;
  final double profitMargin;
  final String warehouse;
  final String openingStock;
  final int alertQuantity;

  AddItemService({
    required this.accessToken,
    required this.userId,
    required this.storeId,
    required this.categoryId,
    required this.brandId,
    required this.itemName,
    required this.itemImage,
    required this.sku,
    required this.hsnCode,
    required this.itemCode,
    required this.barcode,
    required this.unit,
    required this.purchasePrice,
    required this.taxType,
    required this.taxRate,
    required this.salesPrice,
    required this.mrp,
    required this.discountType,
    required this.discount,
    required this.profitMargin,
    required this.alertQuantity,
    required this.warehouse,
    required this.openingStock,
  });

  Future<String?> addItemService() async {
    try {
      var uri = Uri.parse(addItemUrl);
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['store_id'] = storeId.toString();
      request.fields['user_id'] = userId.toString();
      request.fields['category_id'] = categoryId.toString();
      request.fields['brand_id'] = brandId.toString();
      request.fields['item_name'] = itemName;
      request.fields['SKU'] = sku;
      request.fields['HSN_code'] = hsnCode;
      request.fields['Item_code'] = itemCode;
      request.fields['Barcode'] = barcode;
      request.fields['Unit'] = unit;
      request.fields['Purchase_price'] = purchasePrice.toString();
      request.fields['Tax_type'] = taxType;
      request.fields['Tax_rate'] = taxRate.toString();
      request.fields['Sales_Price'] = salesPrice.toString();
      request.fields['MRP'] = mrp;
      request.fields['Discount_type'] = discountType;
      request.fields['Discount'] = discount.toString();
      request.fields['Profit_margin'] = profitMargin.toString();
      request.fields['Warehouse'] = warehouse; // Corrected field name
      request.fields['Opening_Stock'] = openingStock; // Corrected field name
      request.fields['Alert_Quantity'] = alertQuantity.toString();

      // Upload image if available
      if (itemImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'item_image',
          itemImage!.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return body['message'];
      } else {
        return body['message'] ?? 'Error';
      }
    } catch (e) {
      log('Upload failed: $e');
      return null;
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class EditItemService {
  final String accessToken;
  // final String storeId;
  // final String userId;
  // final String categoryId;
  // final String brandId;
  final String itemId;
  final String itemName;
  // final String itemImage;
  final String sku;
  // final String hsnCode;
  final String itemCode;
  final String barcode;
  final String unit;
  final String purchasePrice;
  final String taxType;
  final String taxRate;
  final String salesPrice;
  final String mrp;
  final String discountType;
  final String discount;
  final String profitMargin;
  // final String warhouse;
  final String openingStock;
  final String alertQuantity;

  EditItemService(
      {required this.accessToken,
      required this.itemId,
      required this.itemName,
      required this.sku,
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
      // required this.warhouse,
      required this.openingStock,
      required this.alertQuantity});

  Future<String> editItemService() async {
    try {
      log('accessToken: $accessToken');
      log('itemId: $itemId');
      log('item_name: $itemName');
      log('SKU: $sku');
      log('Item_code: $itemCode');
      log('Barcode: $barcode');
      log('Unit: $unit');
      log('Purchase_price: $purchasePrice');
      log('Tax_type: $taxType');
      log('Tax_rate: $taxRate');
      log('Sales_Price: $salesPrice');
      log('MRP: $mrp');
      log('Discount_type: $discountType');
      log('Discount: $discount');
      log('Profit_margin: $profitMargin');
      // log('warhouse: $warhouse');
      log('Opening_stock: $openingStock');
      log('Alert_Quantity: $alertQuantity');
      log('editItemUrl: $editItemUrl');
      final response =
          await http.put(Uri.parse('$editItemUrl/$itemId'), headers: {
        'Authorization': 'Bearer $accessToken',
      }, body: {
        'item_name': itemName,
        'SKU': sku,
        'Item_code': itemCode,
        'Barcode': barcode,
        'Unit': unit,
        'Purchase_price': purchasePrice,
        'Tax_type': taxType,
        'Tax_rate': taxRate,
        'Sales_Price': salesPrice,
        'MRP': mrp,
        'Discount_type': discountType,
        'Discount': discount,
        'Profit_margin': profitMargin,
        // 'Warhouse': warhouse,
        'Opening_stock': openingStock,
        'Alert_Quantity': alertQuantity
      });
      final jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          jsonResponse['message'] == 'Item updated successfully') {
        return "Item updated successfully";
      } else {
        throw Exception('Failed to edit item');
      }
    } catch (e) {
      return e.toString();
    }
  }
}

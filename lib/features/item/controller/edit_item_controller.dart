import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_biller/features/item/services/item/edit_item_service.dart';

class EditItemController {
  final String accessToken;
  final String itemId;
  final String sku;
  final String itemName;
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

  EditItemController(
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

  Future<String> editItemController(BuildContext context) async {
    try {
      final response = await EditItemService(
              accessToken: accessToken,
              itemId: itemId,
              itemName: itemName,
              sku: sku,
              itemCode: itemCode,
              barcode: barcode,
              unit: unit,
              purchasePrice: purchasePrice,
              taxType: taxType,
              taxRate: taxRate,
              salesPrice: salesPrice,
              mrp: mrp,
              discountType: discountType,
              discount: discount,
              profitMargin: profitMargin,
              // warhouse: warhouse,
              openingStock: openingStock,
              alertQuantity: alertQuantity)
          .editItemService();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return response;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      log(e.toString());
      return e.toString();
    }
  }
}

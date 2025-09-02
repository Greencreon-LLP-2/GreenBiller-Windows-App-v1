import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_biller/features/item/controller/add_category_controller.dart';
import 'package:green_biller/features/item/services/item/add_item_service.dart';
import 'package:green_biller/features/item/view/pages/add_items_page/add_items_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddItemController {
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
  final int alertQuantity;
  final String warehouse;
  final String openingStock;

  AddItemController({
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

  Future<bool> addItemController(BuildContext context, WidgetRef ref) async {
    try {
      final service = AddItemService(
        accessToken: accessToken,
        userId: userId,
        storeId: storeId,
        categoryId: categoryId,
        brandId: brandId,
        itemName: itemName,
        itemImage: itemImage,
        sku: sku,
        hsnCode: hsnCode,
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
        alertQuantity: alertQuantity,
        warehouse: warehouse,
        openingStock: openingStock,
      );

      final response = await service.addItemService();

      if (response == "Item created successfully") {
        ref.refresh(categoriesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AddItemsPage()),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response ?? 'Failed to add item'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error in addItemController: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}

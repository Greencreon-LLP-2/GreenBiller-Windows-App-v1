import 'dart:developer';

import 'package:green_biller/features/purchase/services/single_item_purchase_service.dart';

class SingleItemPurchase {
  final String accessToken;

  final String storeId;
  final String purchaseId;
  final String itemId;
  final String purchaseQty;
  final String pricePerUnit;
  final String taxName;
  final String taxId;
  final String taxAmount;
  final String discountType;
  final String discountAmount;
  final String totalCost;
  final String itemName;
  String batchNo;
  final String barcode;
  final String unitSalesPrice;
  final String unit;
  final String warehouseId;

  SingleItemPurchase({
    required this.accessToken,
    required this.storeId,
    required this.purchaseId,
    required this.itemId,
    required this.purchaseQty,
    required this.pricePerUnit,
    required this.taxName,
    required this.taxId,
    required this.taxAmount,
    required this.discountType,
    required this.discountAmount,
    required this.totalCost,
    required this.barcode,
    required this.itemName,
    required this.batchNo,
    required this.unitSalesPrice,
    required this.warehouseId,
    required this.unit,
  });

  Future<bool> singleItemPurchaseController() async {
    try {
      if (batchNo == "") {
        batchNo = "GB2025"; // Default value for batchNo if not provided
      }
      final response =
          await SingleItemPurchaseService().singleItemPurchaseService(
        accessToken: accessToken,
        barcode: barcode,
        batchNo: batchNo,
        discountAmount: discountAmount,
        discountType: discountType,
        itemId: itemId,
        itemName: itemName,
        pricePerUnit: pricePerUnit,
        purchaseId: purchaseId,
        purchaseQty: purchaseQty,
        storeId: storeId,
        taxAmount: taxAmount,
        taxId: taxId,
        taxName: taxName,
        totalCost: totalCost,
        unitSalesPrice: unitSalesPrice,
        warehouseId: warehouseId,
        unit: unit,
      );
      if (response) {
        return true; // Return true if the operation is successful
      } else {
        return false; // Return false if the operation fails
      }
    } catch (e) {
      log("Error in single item purchase: $e");
      return false; // Return false if an error occurs
    }
  }
}

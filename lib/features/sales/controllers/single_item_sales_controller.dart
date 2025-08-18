import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_biller/features/sales/service/single_item_sales_service.dart';

class SingleItemSalesController {
  final String accessToken;
  final String userId;
  final String storeId;
  final String salesId;
  final String customerId;
  final String itemName;
  final String description;
  final String itemId;
  final String salesQty;
  final String pricePerUnit;
  final String taxName;
  final String taxId;
  final String taxAmount;
  final String discountType;
  final String discountAmount;
  final String totalCost;

  SingleItemSalesController({
    required this.accessToken,
    required this.userId,
    required this.storeId,
    required this.salesId,
    required this.customerId,
    required this.itemName,
    required this.description,
    required this.itemId,
    required this.salesQty,
    required this.pricePerUnit,
    required this.taxName,
    required this.taxId,
    required this.taxAmount,
    required this.discountType,
    required this.discountAmount,
    required this.totalCost,
  });

  Future<bool> singleItemSalesController(BuildContext context) async {
    try {
      final response = await SingleItemSaleService().singleItemSalesService(
        accessToken: accessToken,
        userId: userId,
        storeId: storeId,
        salesId: salesId,
        customerId: customerId,
        itemName: itemName,
        description: description,
        itemId: itemId,
        salesQty: salesQty,
        pricePerUnit: pricePerUnit,
        taxName: taxName,
        taxId: taxId,
        taxAmount: taxAmount,
        discountType: discountType,
        discountAmount: discountAmount,
        totalCost: totalCost,
      );
      if (response == false) {
        log("Failed to process the sale");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to process the sale"),
            backgroundColor: Colors.red,
          ),
        );
        return false; // Return false if the service call fails
      } else {
        log("Item sold successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item sold successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
      return response; // Return the response directly
    } catch (e) {
      log('Error in singleItemSalesController: $e');
      return false; // Return false in case of an error
    }
  }
}

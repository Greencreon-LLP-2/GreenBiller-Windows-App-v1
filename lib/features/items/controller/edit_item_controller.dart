import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:logger/logger.dart';

class EditItemController extends GetxController {
  final DioClient dioClient = DioClient();
  final Logger _logger = Logger();

  // Reactive form state
  final storeId = ''.obs;
  final itemId = ''.obs;
  final itemName = ''.obs;
  final sku = ''.obs;
  final itemCode = ''.obs;
  final barcode = ''.obs;
  final unit = ''.obs;
  final purchasePrice = ''.obs;
  final salesPrice = ''.obs;
  final mrp = ''.obs;
  final profitMargin = ''.obs;
  final taxType = ''.obs;
  final taxRate = ''.obs;
  final discountType = ''.obs;
  final discount = ''.obs;
  final openingStock = ''.obs;
  final alertQuantity = ''.obs;

  // State tracking
  final isLoading = false.obs;
  final error = ''.obs;

  void initialize(Map<String, String> args) {
    storeId.value = args['storeId'] ?? '';
    itemId.value = args['itemId'] ?? '';
    itemName.value = args['itemName'] ?? '';
    sku.value = args['sku'] ?? '';
    itemCode.value = args['itemCode'] ?? '';
    barcode.value = args['barcode'] ?? '';
    unit.value = args['unit'] ?? '';
    purchasePrice.value = args['purchasePrice'] ?? '';
    salesPrice.value = args['salesPrice'] ?? '';
    mrp.value = args['mrp'] ?? '';
    profitMargin.value = args['profitMargin'] ?? '';
    taxType.value = args['taxType'] ?? '';
    taxRate.value = args['taxRate'] ?? '';
    discountType.value = args['discountType'] ?? '';
    discount.value = args['discount'] ?? '';
    openingStock.value = args['Opening_Stock'] ?? '';
    alertQuantity.value = args['alertQuantity'] ?? '';
  }

  Future<bool> editItem() async {
    isLoading.value = true;
    error.value = '';

    // ✅ Inline validation
    if (itemName.value.isEmpty) return _fail("Item name is required");
    if (sku.value.isEmpty) return _fail("SKU is required");
    if (salesPrice.value.isEmpty) return _fail("Sales price is required");

    try {
      final response = await dioClient.dio.put(
        "$editItemUrl/${itemId.value}",
        data: {
          "store_id": storeId.value,
          "item_name": itemName.value,
          "sku": sku.value,
          "item_code": itemCode.value,
          "barcode": barcode.value,
          "unit": unit.value,
          "purchase_price": purchasePrice.value,
          "sales_price": salesPrice.value,
          "mrp": mrp.value,
          "profit_margin": profitMargin.value,
          "tax_type": taxType.value,
          "tax_rate": taxRate.value,
          "discount_type": discountType.value,
          "discount": discount.value,
          "Opening_Stock": openingStock.value,
          "alert_quantity": alertQuantity.value,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Item updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        return _fail(response.data['message'] ?? 'Failed to update item');
      }
    } catch (e) {
      _logger.e("Error updating item");
      return _fail("Failed to update item: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _fail(String message) {
    error.value = message;
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    isLoading.value = false;
    return false;
  }
}

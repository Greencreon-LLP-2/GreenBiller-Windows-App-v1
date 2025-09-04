import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:logger/logger.dart';

class EditItemController extends GetxController {
  final DioClient dioClient = DioClient();
  final Logger _logger = Logger();

  // Reactive state for form fields

  final RxString itemId = ''.obs;
  final RxString itemName = ''.obs;
  final RxString sku = ''.obs;
  final RxString itemCode = ''.obs;
  final RxString barcode = ''.obs;
  final RxString unit = ''.obs;
  final RxString purchasePrice = ''.obs;
  final RxString salesPrice = ''.obs;
  final RxString mrp = ''.obs;
  final RxString profitMargin = ''.obs;
  final RxString taxType = ''.obs;
  final RxString taxRate = ''.obs;
  final RxString discountType = ''.obs;
  final RxString discount = ''.obs;
  final RxString openingStock = ''.obs;
  final RxString alertQuantity = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Initialize controller with arguments
  void initialize(Map<String, String> args) {
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
    openingStock.value = args['openingStock'] ?? '';
    alertQuantity.value = args['alertQuantity'] ?? '';
  }

  Future<String> editItemController(BuildContext context) async {
    isLoading.value = true;
    error.value = '';

    // Basic validation
    if (itemName.value.isEmpty) {
      error.value = 'Item name is required';
      isLoading.value = false;
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return error.value;
    }
    if (sku.value.isEmpty) {
      error.value = 'SKU is required';
      isLoading.value = false;
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return error.value;
    }
    if (salesPrice.value.isEmpty) {
      error.value = 'Sales price is required';
      isLoading.value = false;
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return error.value;
    }

    try {
      final response = await dioClient.dio.put(
        '$editItemUrl/${itemId.value}',
        data: {
          'item_name': itemName.value,
          'sku': sku.value,
          'item_code': itemCode.value,
          'barcode': barcode.value,
          'unit': unit.value,
          'purchase_price': purchasePrice.value,
          'sales_price': salesPrice.value,
          'mrp': mrp.value,
          'profit_margin': profitMargin.value,
          'tax_type': taxType.value,
          'tax_rate': taxRate.value,
          'discount_type': discountType.value,
          'discount': discount.value,
          'opening_stock': openingStock.value,
          'alert_quantity': alertQuantity.value,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Item updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return 'Item updated successfully';
      } else {
        error.value = response.data['message'] ?? 'Failed to update item';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return error.value;
      }
    } catch (e) {
      _logger.e('Error updating item: $e');
      error.value = 'Failed to update item: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return error.value;
    } finally {
      isLoading.value = false;
    }
  }
}

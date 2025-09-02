import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart' as ApiConstants;
import 'package:greenbiller/core/app_handler/dio_client.dart';

import 'package:greenbiller/core/app_handler/hive_service.dart';


class PurchaseItem {
  final TextEditingController item = TextEditingController();
  final TextEditingController serialNo = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final TextEditingController unit = TextEditingController();
  final TextEditingController pricePerUnit = TextEditingController();
  final TextEditingController purchasePrice = TextEditingController();
  final TextEditingController sku = TextEditingController();
  final TextEditingController discountPercent = TextEditingController();
  final TextEditingController discountAmount = TextEditingController();
  final TextEditingController taxPercent = TextEditingController();
  final TextEditingController taxAmount = TextEditingController();
  final TextEditingController totalAmount = TextEditingController();

  PurchaseItem() {
    // Add listeners for automatic calculations
    qty.addListener(_calculateAmount);
    pricePerUnit.addListener(_calculateAmount);
    discountPercent.addListener(_calculateDiscount);
    taxPercent.addListener(_calculateTax);
  }

  void _calculateAmount() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double total = quantity * price;

    // Update purchase price if not manually set
    if (purchasePrice.text.isEmpty) {
      purchasePrice.text = price.toString();
    }

    _updateTotalAmount();
  }

  void _calculateDiscount() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double discountPerc = double.tryParse(discountPercent.text) ?? 0.0;

    double subtotal = quantity * price;
    double discountAmt = (subtotal * discountPerc) / 100;

    discountAmount.text = discountAmt.toStringAsFixed(2);
    _updateTotalAmount();
  }

  void _calculateTax() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double discountAmt = double.tryParse(discountAmount.text) ?? 0.0;
    double taxPerc = double.tryParse(taxPercent.text) ?? 0.0;

    double subtotal = (quantity * price) - discountAmt;
    double taxAmt = (subtotal * taxPerc) / 100;

    taxAmount.text = taxAmt.toStringAsFixed(2);
    _updateTotalAmount();
  }

  void _updateTotalAmount() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double discountAmt = double.tryParse(discountAmount.text) ?? 0.0;
    double taxAmt = double.tryParse(taxAmount.text) ?? 0.0;

    double total = (quantity * price) - discountAmt + taxAmt;
    totalAmount.text = total.toStringAsFixed(2);
  }

  void dispose() {
    item.dispose();
    serialNo.dispose();
    qty.dispose();
    unit.dispose();
    pricePerUnit.dispose();
    purchasePrice.dispose();
    sku.dispose();
    discountPercent.dispose();
    discountAmount.dispose();
    taxPercent.dispose();
    taxAmount.dispose();
    totalAmount.dispose();
  }
}

class NewPurchaseController extends GetxController {
  // Services
final DioClient dioClient = DioClient();
  final HiveService hiveService = Get.find<HiveService>();

  // Purchase Information Controllers
  final TextEditingController storeController = TextEditingController();
  final TextEditingController warehouseController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController billDateController = TextEditingController();

  // Purchase Details Controllers
  final TextEditingController noteController = TextEditingController();
  final TextEditingController otherChargesController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();

  // Reactive Variables
  final RxString paymentType = ''.obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;
  final RxDouble totalTax = 0.0.obs;
  final RxDouble otherCharges = 0.0.obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxDouble paidAmount = 0.0.obs;
  final RxDouble balanceAmount = 0.0.obs;

  // Purchase Items List
  final RxList<PurchaseItem> items = <PurchaseItem>[].obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Add initial item
    addItem();

    // Set default bill date to today
    billDateController.text = DateTime.now().toString().split(' ')[0];

    // Add listeners for automatic calculations
    otherChargesController.addListener(() {
      otherCharges.value = double.tryParse(otherChargesController.text) ?? 0.0;
      calculateTotals();
    });

    paidAmountController.addListener(() {
      paidAmount.value = double.tryParse(paidAmountController.text) ?? 0.0;
      calculateBalance();
    });
  }

  @override
  void onClose() {
    // Dispose all controllers
    storeController.dispose();
    warehouseController.dispose();
    billNumberController.dispose();
    supplierController.dispose();
    billDateController.dispose();
    noteController.dispose();
    otherChargesController.dispose();
    paidAmountController.dispose();

    // Dispose all items
    for (var item in items) {
      item.dispose();
    }

    super.onClose();
  }

  // Add new item to the list
  void addItem() {
    items.add(PurchaseItem());
    calculateTotals();
  }

  // Remove item from the list
  void removeItem(int index) {
    if (items.length > 1) {
      items[index].dispose();
      items.removeAt(index);
      calculateTotals();
    }
  }

  // Calculate totals
  void calculateTotals() {
    double sub = 0.0;
    double discount = 0.0;
    double tax = 0.0;

    for (var item in items) {
      double itemTotal = double.tryParse(item.totalAmount.text) ?? 0.0;
      double itemDiscount = double.tryParse(item.discountAmount.text) ?? 0.0;
      double itemTax = double.tryParse(item.taxAmount.text) ?? 0.0;

      double qty = double.tryParse(item.qty.text) ?? 0.0;
      double price = double.tryParse(item.pricePerUnit.text) ?? 0.0;

      sub += qty * price;
      discount += itemDiscount;
      tax += itemTax;
    }

    subtotal.value = sub;
    totalDiscount.value = discount;
    totalTax.value = tax;

    grandTotal.value =
        subtotal.value -
        totalDiscount.value +
        totalTax.value +
        otherCharges.value;

    calculateBalance();
  }

  // Calculate balance amount
  void calculateBalance() {
    balanceAmount.value = grandTotal.value - paidAmount.value;
  }

  // Validate form
  bool validateForm() {
    if (storeController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter store name');
      return false;
    }

    if (supplierController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter supplier name');
      return false;
    }

    if (billNumberController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter bill number');
      return false;
    }

    if (items.isEmpty) {
      Get.snackbar('Error', 'Please add at least one item');
      return false;
    }

    // Validate items
    for (int i = 0; i < items.length; i++) {
      if (items[i].item.text.isEmpty) {
        Get.snackbar('Error', 'Please enter item name for row ${i + 1}');
        return false;
      }

      if (items[i].qty.text.isEmpty ||
          double.tryParse(items[i].qty.text) == 0) {
        Get.snackbar('Error', 'Please enter valid quantity for row ${i + 1}');
        return false;
      }

      if (items[i].pricePerUnit.text.isEmpty ||
          double.tryParse(items[i].pricePerUnit.text) == 0) {
        Get.snackbar('Error', 'Please enter valid price for row ${i + 1}');
        return false;
      }
    }

    return true;
  }

  // Save purchase to API
  Future<void> savePurchase() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      // Create purchase data
      Map<String, dynamic> purchaseData = {
        'store': storeController.text,
        'warehouse': warehouseController.text,
        'billNumber': billNumberController.text,
        'supplier': supplierController.text,
        'billDate': billDateController.text,
        'paymentType': paymentType.value,
        'note': noteController.text,
        'subtotal': subtotal.value,
        'totalDiscount': totalDiscount.value,
        'totalTax': totalTax.value,
        'otherCharges': otherCharges.value,
        'grandTotal': grandTotal.value,
        'paidAmount': paidAmount.value,
        'balanceAmount': balanceAmount.value,
        'items': items
            .map(
              (item) => {
                'item': item.item.text,
                'serialNo': item.serialNo.text,
                'qty': item.qty.text,
                'unit': item.unit.text,
                'pricePerUnit': item.pricePerUnit.text,
                'purchasePrice': item.purchasePrice.text,
                'sku': item.sku.text,
                'discountPercent': item.discountPercent.text,
                'discountAmount': item.discountAmount.text,
                'taxPercent': item.taxPercent.text,
                'taxAmount': item.taxAmount.text,
                'totalAmount': item.totalAmount.text,
              },
            )
            .toList(),
      };

      // Save to API using DioClient
      final response = await dioClient.dio.post(
        ApiConstants.createPurchaseUrl,
        data: purchaseData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        // Check if the API response indicates success
        if (responseData['success'] == true || responseData['status'] == true) {
          // Optionally save to local storage using HiveService for offline access
          try {
            // await hiveService.savePurchase(purchaseData);
          } catch (e) {
            // Log error but don't show to user since API save was successful
            print('Failed to save purchase locally: $e');
          }

          Get.snackbar(
            'Success',
            'Purchase saved successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Clear form after successful save
          clearForm();
        } else {
          // Handle API response that has status code 200 but contains error
          final errorMessage =
              responseData['message'] ?? 'Failed to save purchase';
          throw Exception(errorMessage);
        }
      } else {
        // Handle non-200 status codes
        final errorMessage =
            response.data['message'] ??
            'Failed to save purchase. Status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save purchase: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    storeController.clear();
    warehouseController.clear();
    billNumberController.clear();
    supplierController.clear();
    billDateController.text = DateTime.now().toString().split(' ')[0];
    noteController.clear();
    otherChargesController.clear();
    paidAmountController.clear();

    paymentType.value = '';

    // Clear all items and add one empty item
    for (var item in items) {
      item.dispose();
    }
    items.clear();
    addItem();
  }

  // Auto-generate bill number
  void generateBillNumber() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    billNumberController.text =
        'PUR${timestamp.substring(timestamp.length - 6)}';
  }

  // Set bill date
  void setBillDate(DateTime date) {
    billDateController.text = date.toString().split(' ')[0];
  }
}

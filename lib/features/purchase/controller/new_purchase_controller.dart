import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'dart:developer';

import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:logger/logger.dart';

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
  String? itemId; // Added to store item ID for API
  String? taxName; // Added to store tax name for API

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

  PurchaseItem() {
    qty.addListener(_calculateAmount);
    pricePerUnit.addListener(_calculateAmount);
    discountPercent.addListener(_calculateDiscount);
    taxPercent.addListener(_calculateTax);
  }

  void _calculateAmount() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double total = quantity * price;

    if (purchasePrice.text.isEmpty) {
      purchasePrice.text = total.toStringAsFixed(2);
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
}

class NewPurchaseController extends GetxController {
  // Services
  late DioClient dioClient;
  late HiveService hiveService;
  late AuthController authController;
  late CommonApiFunctionsController commonApi;
  late Logger logger;

  // Form Controllers
  late TextEditingController storeController;
  late TextEditingController warehouseController;
  late TextEditingController billNumberController;
  late TextEditingController supplierController;
  late TextEditingController billDateController;
  late TextEditingController noteController;
  late TextEditingController otherChargesController;
  late TextEditingController paidAmountController;

  // Reactive
  final RxString paymentType = ''.obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble totalDiscount = 0.0.obs;
  final RxDouble totalTax = 0.0.obs;
  final RxDouble otherCharges = 0.0.obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxDouble paidAmount = 0.0.obs;
  final RxDouble balanceAmount = 0.0.obs;
  final RxList<PurchaseItem> items = <PurchaseItem>[].obs;
  final isLoading = false.obs;
  final isLoadingStores = false.obs;
  final isLoadingWarehouses = false.obs;
  final isLoadingSuppliers = false.obs;
  final isLoadingItems = false.obs;
  final isLoadingTaxes = false.obs;
  final RxInt userId = 0.obs;

  // Dropdown Data
  final RxMap<String, String> storeMap = <String, String>{}.obs;
  final RxMap<String, String> warehouseMap = <String, String>{}.obs;
  final RxMap<String, String> supplierMap = <String, String>{}.obs;
  final RxList<Map<String, dynamic>> itemsList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> taxList = <Map<String, dynamic>>[].obs;
  final RxString selectedStoreId = ''.obs;
  final RxString selectedWarehouseId = ''.obs;
  final RxString selectedSupplierId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    hiveService = HiveService();
    authController = Get.find<AuthController>();
    commonApi = Get.find<CommonApiFunctionsController>();
    logger = Logger();

    storeController = TextEditingController();
    warehouseController = TextEditingController();
    billNumberController = TextEditingController();
    supplierController = TextEditingController();
    billDateController = TextEditingController();
    noteController = TextEditingController();
    otherChargesController = TextEditingController();
    paidAmountController = TextEditingController();

    userId.value = authController.user.value?.userId ?? 0;

    // Init values
    addItem();
    billDateController.text = DateTime.now().toString().split(' ')[0];

    // Listeners
    otherChargesController.addListener(() {
      otherCharges.value = double.tryParse(otherChargesController.text) ?? 0.0;
      calculateTotals();
    });
    paidAmountController.addListener(() {
      paidAmount.value = double.tryParse(paidAmountController.text) ?? 0.0;
      calculateBalance();
    });

    // Initial API
    fetchStores();
    fetchTaxes();
  }

  @override
  void onClose() {
    storeController.dispose();
    warehouseController.dispose();
    billNumberController.dispose();
    supplierController.dispose();
    billDateController.dispose();
    noteController.dispose();
    otherChargesController.dispose();
    paidAmountController.dispose();

    for (var item in items) {
      item.dispose();
    }

    super.onClose();
  }

  void addItem() {
    items.add(PurchaseItem());
    calculateTotals();
  }

  void removeItem(int index) {
    if (items.length > 1) {
      items[index].dispose();
      items.removeAt(index);
      calculateTotals();
    }
  }

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

  void calculateBalance() {
    balanceAmount.value = grandTotal.value - paidAmount.value;
  }

  Future<void> fetchStores() async {
    isLoadingStores.value = true;
    try {
      final List<dynamic> response = await commonApi.fetchStoreList();

      storeMap.value = {
        for (var store in response) store['store_name']: store['id'].toString(),
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch stores: $e');
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> fetchWarehouses(String storeId) async {
    isLoadingWarehouses.value = true;
    try {
      final List<dynamic> response = await commonApi.fetchWarehousesByStoreID(
        int.parse(storeId),
      );
      warehouseMap.value = {
        for (var warehouse in response)
          warehouse['warehouse_name']: warehouse['id'].toString(),
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch warehouses: $e');
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  Future<void> fetchSuppliers(String storeId) async {
    isLoadingSuppliers.value = true;
    try {
      final List<dynamic> response = await commonApi.fetchSuppliers(storeId);

      supplierMap.value = {
        for (var supplier in response)
          supplier['supplier_name']: supplier['id'].toString(),
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch suppliers: $e');
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  Future<void> fetchItems(String storeId) async {
    isLoadingItems.value = true;
    try {
      final response = await commonApi.fetchAllItems(storeId); // await here
      if (response.isEmpty) {
        Get.snackbar('Error', 'Please add items first, emtpy store');
      }
      itemsList.value = response
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch items: $e',
        backgroundColor: Colors.redAccent,
      );
    } finally {
      isLoadingItems.value = false;
    }
  }

  Future<void> fetchTaxes() async {
    isLoadingTaxes.value = true;
    try {
      final response = await dioClient.dio.get('$baseUrl/tax-view');
      if (response.statusCode == 200) {
        taxList.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch taxes: $e');
    } finally {
      isLoadingTaxes.value = false;
    }
  }

  void onStoreSelected(String? storeName) {
    if (storeName != null && storeMap.value.containsKey(storeName)) {
      selectedStoreId.value = storeMap.value[storeName]!;
      storeController.text = storeName;
      selectedWarehouseId.value = '';
      selectedSupplierId.value = '';
      warehouseMap.clear();
      supplierMap.clear();
      itemsList.clear();
      fetchWarehouses(selectedStoreId.value);
      fetchSuppliers(selectedStoreId.value);
      fetchItems(selectedStoreId.value);
    }
  }

  void onWarehouseSelected(String? warehouseName) {
    if (warehouseName != null &&
        warehouseMap.value.containsKey(warehouseName)) {
      selectedWarehouseId.value = warehouseMap.value[warehouseName]!;
      warehouseController.text = warehouseName;
    }
  }

  void onSupplierSelected(String? supplierName) {
    if (supplierName != null && supplierMap.value.containsKey(supplierName)) {
      selectedSupplierId.value = supplierMap.value[supplierName]!;
      supplierController.text = supplierName;
    }
  }

  void onItemSelected(int index, Map<String, dynamic> item) {
    if (index < items.length) {
      final purchaseItem = items[index];
      purchaseItem.item.text = item['item_name'] ?? '';
      purchaseItem.itemId = item['id'].toString();
      purchaseItem.sku.text = item['sku'] ?? '';
      purchaseItem.unit.text = item['unit'] ?? '';
      purchaseItem.pricePerUnit.text = item['purchase_price'] ?? '';
      purchaseItem.qty.text = '1';
      purchaseItem.discountPercent.text = item['discount'] ?? '0';
      purchaseItem.taxPercent.text = item['tax_rate'] ?? '0';
      purchaseItem.taxName = item['tax_type'] ?? '';
      calculateTotals();
    }
  }

  void onTaxSelected(int index, Map<String, dynamic> tax) {
    if (index < items.length) {
      final purchaseItem = items[index];
      purchaseItem.taxName = tax['tax_name'];
      purchaseItem.taxPercent.text = tax['tax_rate'] ?? '0';
      calculateTotals();
    }
  }

  bool validateForm() {
    if (selectedStoreId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a store');
      return false;
    }
    if (selectedSupplierId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a supplier');
      return false;
    }
    if (selectedWarehouseId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a warehouse');
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
    if (paymentType.value.isEmpty) {
      Get.snackbar('Error', 'Please select a payment type');
      return false;
    }
    return true;
  }

  Future<void> savePurchase() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final purchaseCode =
          'G_B_${selectedStoreId.value}_${DateTime.now().millisecondsSinceEpoch}_${userId.value}';
      Map<String, dynamic> purchaseData = {
        'user_id': userId.value,
        'store_id': selectedStoreId.value,
        'warehouse_id': selectedWarehouseId.value,
        'purchase_code': purchaseCode,
        'reference_no': billNumberController.text,
        'purchase_date': billDateController.text,
        'supplier_id': selectedSupplierId.value,
        'other_charge_amt': otherChargesController.text,
        'total_discount_to_all_amt': totalDiscount.value.toString(),
        'subtotal': subtotal.value.toString(),
        'grand_total': grandTotal.value.toString(),
        'purchase_note': noteController.text,
        'paid_amount': paidAmountController.text,
      };

      final purchaseResponse = await dioClient.dio.post(
        '$baseUrl/purchase-create',
        data: purchaseData,
      );

      if (purchaseResponse.statusCode == 200 ||
          purchaseResponse.statusCode == 201) {
        final purchaseId = purchaseResponse.data['data']['id'].toString();

        for (var item in items) {
          Map<String, dynamic> itemData = {
            'item_id': item.itemId,
            'store_id': selectedStoreId.value,
            'warehouse_id': selectedWarehouseId.value,
            'purchase_id': purchaseId,
            'purchase_qty': item.qty.text,
            'price_per_unit': item.pricePerUnit.text,
            'tax_name': item.taxName,
            'tax_amount': item.taxAmount.text,
            'discount_amount': item.discountAmount.text,
            'total_cost': item.totalAmount.text,
            'item_name': item.item.text,
            'batch_no': item.serialNo.text,
            'barcode': item.sku.text,
            'unit': item.unit.text,
          };

          await dioClient.dio.post(
            '$baseUrl/purchaseitem-create',
            data: itemData,
          );
        }

        Map<String, dynamic> paymentData = {
          'user_id': userId.value,
          'purchase_id': purchaseId,
          'store_id': selectedStoreId.value,
          'payment_method': paymentType.value,
          'payment_amount': paidAmountController.text,
          'payment_date': billDateController.text,
          'supplier_id': selectedSupplierId.value,
          'payment_note': noteController.text,
        };

        await dioClient.dio.post(
          '$baseUrl/purchasepayment-create',
          data: paymentData,
        );

        try {
          await hiveService.savePurchase({
            ...purchaseData,
            'items': items
                .map(
                  (item) => {
                    'item_id': item.itemId,
                    'item_name': item.item.text,
                    'serial_no': item.serialNo.text,
                    'qty': item.qty.text,
                    'unit': item.unit.text,
                    'price_per_unit': item.pricePerUnit.text,
                    'purchase_price': item.purchasePrice.text,
                    'sku': item.sku.text,
                    'discount_percent': item.discountPercent.text,
                    'discount_amount': item.discountAmount.text,
                    'tax_percent': item.taxPercent.text,
                    'tax_amount': item.taxAmount.text,
                    'total_amount': item.totalAmount.text,
                    'tax_name': item.taxName,
                  },
                )
                .toList(),
          });
        } catch (e) {
          log('Failed to save purchase locally: $e');
        }

        Get.snackbar(
          'Success',
          'Purchase saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        clearForm();
      } else {
        throw Exception(
          'Failed to save purchase: ${purchaseResponse.data['message']}',
        );
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
    selectedStoreId.value = '';
    selectedWarehouseId.value = '';
    selectedSupplierId.value = '';
    warehouseMap.clear();
    supplierMap.clear();
    itemsList.clear();
    for (var item in items) {
      item.dispose();
    }
    items.clear();
    addItem();
    calculateTotals();
  }

  void generateBillNumber() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    billNumberController.text =
        'PUR${timestamp.substring(timestamp.length - 6)}';
  }

  void setBillDate(DateTime date) {
    billDateController.text = date.toString().split(' ')[0];
  }
}

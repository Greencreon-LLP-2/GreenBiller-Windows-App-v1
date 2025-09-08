import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/model/tax_model.dart';
import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';
import 'package:hive/hive.dart';

class SalesController extends GetxController {
  // Authentication and dependencies
  late final DioClient _dioClient;
  late final CommonApiFunctionsController _commonApi;
  late final AuthController _authController;
  late final DropdownController storeDropdownController;
  final accessToken = RxnString();
  final userId = 0.obs;

  // Loading states
  final isLoading = false.obs;
  final isLoadingStores = false.obs;
  final isLoadingWarehouses = false.obs;
  final isLoadingCustomers = false.obs;
  final isLoadingItems = false.obs;
  final isLoadingTaxes = false.obs;
  final isLoadingSave = false.obs;
  final isLoadingSavePrint = false.obs;

  // Form data
  final storeId = RxnString();
  final customerId = RxnString();
  final selectedWarehouse = RxnString();
  final salesType = 'Cash'.obs;
  final tempSubTotal = 0.0.obs;
  final tempTotalDiscount = 0.0.obs;
  final tempTotalTax = 0.0.obs;
  final rowCount = 1.obs;
  final taxModel = Rxn<TaxModel>();

  // Data collections
  final selectedItem = Rxn<Item>();
  final tempPurchaseItems = <TempPurchaseItem>[].obs;
  final showDropdownRows = <int>{}.obs;
  final rowFields = <int, Map<String, String>>{}.obs;
  final newSalesPrices = <int, String>{}.obs;
  final priceOldValues = <int, String>{}.obs;

  // Dropdown Data
  final RxMap<String, String> storeMap = <String, String>{}.obs;
  final RxMap<String, String> warehouseMap = <String, String>{}.obs;
  final RxMap<String, String> customerMap = <String, String>{}.obs;
  final RxList<Map<String, dynamic>> itemsList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> taxList = <Map<String, dynamic>>[].obs;
  final RxString selectedStoreId = ''.obs;
  final RxString selectedWarehouseId = ''.obs;
  final RxString selectedSupplierId = ''.obs;
  late TextEditingController warehouseController = TextEditingController();
  late TextEditingController customerController = TextEditingController();
  late TextEditingController saleBillConrtoller = TextEditingController();
  late TextEditingController storeController = TextEditingController();
  // Input controllers

  final quantityControllers = <int, TextEditingController>{}.obs;
  final priceControllers = <int, TextEditingController>{}.obs;
  final salesPriceControllers = <int, TextEditingController>{}.obs;
  final discountPercentControllers = <int, TextEditingController>{}.obs;
  final discountAmountControllers = <int, TextEditingController>{}.obs;
  final batchNoControllers = <int, TextEditingController>{}.obs;
  final itemInputControllers = <int, TextEditingController>{}.obs;
  final unitControllers = List.generate(10, (_) => TextEditingController()).obs;
  final priceFocusNodes = <int, FocusNode>{}.obs;
  final itemInputFocusNodes = <int, FocusNode>{}.obs;
  final otherChargesController = TextEditingController();
  final paidAmountController = TextEditingController();
  final salesNoteController = TextEditingController();
  final serialNumbersControllers = <int, TextEditingController>{}.obs;
  // Hive storage
  Box? _settingsBox;

  @override
  void onInit() async {
    super.onInit();
    _initializeDependencies();
    await _initializeHive();
    await fetchInitialData();
  }

  @override
  void onClose() {
    _disposeControllers();
    _settingsBox?.close();
    super.onClose();
  }

  void generateBillNumber() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    saleBillConrtoller.text =
        'SALE${timestamp.substring(timestamp.length - 6)}';
  }

  // Initialize dependencies
  void _initializeDependencies() {
    _dioClient = DioClient();
    _commonApi = CommonApiFunctionsController();
    _authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();
    userId.value = _authController.user.value?.userId ?? 0;
    accessToken.value = _authController.user.value?.accessToken;
  }

  // Initialize Hive box
  Future<void> _initializeHive() async {
    try {
      _settingsBox = await Hive.openBox('settings');
    } catch (e) {
      debugPrint('Error opening Hive box: $e');
    }
  }

  // Dispose all controllers and focus nodes
  void _disposeControllers() {
    quantityControllers.forEach((_, controller) => controller.dispose());
    priceControllers.forEach((_, controller) => controller.dispose());
    salesPriceControllers.forEach((_, controller) => controller.dispose());
    discountPercentControllers.forEach((_, controller) => controller.dispose());
    discountAmountControllers.forEach((_, controller) => controller.dispose());
    batchNoControllers.forEach((_, controller) => controller.dispose());
    itemInputControllers.forEach((_, controller) => controller.dispose());
    for (var controller in unitControllers) {
      controller.dispose();
    }
    priceFocusNodes.forEach((_, node) => node.dispose());
    itemInputFocusNodes.forEach((_, node) => node.dispose());
    otherChargesController.dispose();
    paidAmountController.dispose();

    salesNoteController.dispose();
  }

  // Fetch initial data for sales setup
  Future<void> fetchInitialData() async {
    if (accessToken.value == null) return;
    isLoading.value = true;
    try {
      await fetchTaxes();
      await fetchStores();
      await loadSavedState();
      generateBillNumber();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch initial data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch tax data from API
  Future<void> fetchTaxes() async {
    isLoadingTaxes.value = true;
    try {
      final response = await _dioClient.dio.get('$baseUrl/tax-view');
      if (response.statusCode == 200) {
        taxList.value = List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch taxes: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch taxes: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingTaxes.value = false;
    }
  }

  Future<void> fetchItems(String storeId) async {
    isLoadingItems.value = true;
    try {
      final response = await _commonApi.fetchAllItems(storeId);
      if (response.isEmpty) {
        Get.snackbar('Error', 'Please add items first, empty store');
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

  // Fetch store list from API
  Future<void> fetchStores() async {
    isLoadingStores.value = true;
    try {
      final response = await _commonApi.fetchStoreList();
      storeMap.value = {
        for (var store in response) store['store_name']: store['id'].toString(),
      };
      if (storeMap.isNotEmpty) {
        storeId.value = storeMap.keys.first;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingStores.value = false;
    }
  }

  // Fetch warehouses by store ID
  Future<void> fetchWarehouses(String storeId) async {
    isLoadingWarehouses.value = true;
    try {
      final response = await _commonApi.fetchWarehousesByStoreID(
        int.parse(storeId),
      );
      warehouseMap.value = {
        for (var warehouse in response)
          warehouse['warehouse_name']: warehouse['id'].toString(),
      };
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch warehouses: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  Future<void> fetchCustomers(String storeId) async {
    isLoadingCustomers.value = true;
    try {
      final List<dynamic> response = await _commonApi.fetchCustomers(storeId);
      customerMap.value = {
        for (var customer in response)
          customer['customer_name']: customer['id'].toString(),
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch suppliers: $e');
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  void onStoreSelected(String? storeName) async {
    if (storeName != null && storeMap.containsKey(storeName)) {
      selectedStoreId.value = storeMap[storeName]!;
      storeController.text = storeName;
      selectedWarehouseId.value = '';
      selectedSupplierId.value = '';
      warehouseMap.clear();
      customerMap.clear();
      itemsList.clear();
      await fetchWarehouses(selectedStoreId.value);
      await fetchCustomers(selectedStoreId.value);
      await fetchItems(selectedStoreId.value);
    }
  }

  // Load saved state from Hive
  Future<void> loadSavedState() async {
    try {
      final savedStoreId = _settingsBox?.get('storeId') as String?;
      final savedCustomerId = _settingsBox?.get('customerId') as String?;
      final savedWarehouseId = _settingsBox?.get('warehouseId') as String?;
      final savedBillNo = _settingsBox?.get('billNo') as String?;

      saleBillConrtoller.text = savedBillNo ?? '';

      if (savedStoreId != null && storeMap.containsValue(savedStoreId)) {
        storeId.value = storeMap.entries
            .firstWhere(
              (entry) => entry.value == savedStoreId,
              orElse: () => MapEntry('', ''),
            )
            .key;
      }

      if (savedWarehouseId != null &&
          warehouseMap.containsValue(savedWarehouseId)) {
        selectedWarehouse.value = warehouseMap.entries
            .firstWhere(
              (entry) => entry.value == savedWarehouseId,
              orElse: () => MapEntry('', ''),
            )
            .key;
      }

      if (savedCustomerId != null) {
        if (savedCustomerId == "Walk-in Customer") {
          customerId.value = "Walk-in Customer";
        } else if (customerMap.containsValue(savedCustomerId)) {
          customerId.value = customerMap.entries
              .firstWhere(
                (entry) => entry.value == savedCustomerId,
                orElse: () => MapEntry('', ''),
              )
              .key;
        }
      }
    } catch (e) {
      debugPrint('Error loading state from Hive: $e');
    }
  }

  // Save current state to Hive
  Future<void> saveCurrentState() async {
    try {
      await _settingsBox?.put('storeId', storeMap[storeId.value] ?? '');
      await _settingsBox?.put(
        'customerId',
        customerId.value == "Walk-in Customer"
            ? "Walk-in Customer"
            : customerMap[customerId.value] ?? '',
      );
      await _settingsBox?.put(
        'warehouseId',
        warehouseMap[selectedWarehouse.value] ?? '',
      );
      await _settingsBox?.put('billNo', saleBillConrtoller.text ?? '');
    } catch (e) {
      debugPrint('Error saving state to Hive: $e');
    }
  }

  // Initialize controllers for a row
  void initControllers(int index) {
    if (quantityControllers.containsKey(index)) return;

    final skuCount = (rowFields[index]?['batchNo'] ?? '')
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .length;

    final price = double.tryParse(rowFields[index]?['price'] ?? '0') ?? 0;
    final quantity = rowFields[index]?['quantity'] != null
        ? double.tryParse(rowFields[index]?['quantity'] ?? '0') ?? 0
        : skuCount.toDouble();

    final salesPrice = quantity * price;
    final discountPercent =
        double.tryParse(rowFields[index]?['discountPercent'] ?? '0') ?? 0;
    final discountAmount = (salesPrice * discountPercent) / 100;
    final taxRate = double.tryParse(rowFields[index]?['taxRate'] ?? '0') ?? 0;
    final taxAmount = salesPrice * taxRate / 100;

    quantityControllers[index] = TextEditingController(
      text: quantity.toString(),
    );
    priceControllers[index] = TextEditingController(
      text: rowFields[index]?['price'] ?? '',
    );
    salesPriceControllers[index] = TextEditingController(
      text: salesPrice.toStringAsFixed(2),
    );
    discountPercentControllers[index] = TextEditingController(
      text: rowFields[index]?['discountPercent'] ?? '',
    );
    discountAmountControllers[index] = TextEditingController(
      text: discountAmount.toStringAsFixed(2),
    );
    batchNoControllers[index] = TextEditingController(
      text: rowFields[index]?['batchNo'] ?? '',
    );
    serialNumbersControllers[index] = TextEditingController(
      text: rowFields[index]?['serialNumbers'] ?? '',
    );

    unitControllers[index].text = rowFields[index]?['unit'] ?? '';
    priceFocusNodes[index] = FocusNode();
    itemInputFocusNodes[index] = FocusNode();
    itemInputControllers[index] = TextEditingController();

    rowFields[index] = {
      ...?rowFields[index],
      'quantity': quantity.toString(),
      'salesPrice': salesPrice.toStringAsFixed(2),
      'discountAmount': discountAmount.toStringAsFixed(2),
      'taxAmount': taxAmount.toStringAsFixed(2),
    };
  }

  // Recalculate grand total
  double recalculateGrandTotal() {
    double subTotalSum = 0.0;
    double taxSum = 0.0;

    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null) continue;

      final salesPrice = double.tryParse(fields['salesPrice'] ?? '0') ?? 0;
      final taxAmount = double.tryParse(fields['taxAmount'] ?? '0') ?? 0;

      subTotalSum += salesPrice;
      taxSum += taxAmount;
    }

    tempSubTotal.value = subTotalSum;
    tempTotalTax.value = taxSum;

    final otherCharges = double.tryParse(otherChargesController.text) ?? 0;
    final totalDiscount = tempTotalDiscount.value;

    return subTotalSum + taxSum + otherCharges - totalDiscount;
  }

  // Recalculate total discount
  double recalculateTotalDiscount() {
    double discountSum = 0.0;

    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null) continue;

      final discountAmount =
          double.tryParse(fields['discountAmount'] ?? '0') ?? 0;
      discountSum += discountAmount;
    }

    tempTotalDiscount.value = discountSum;
    return discountSum;
  }

  // Handle sales type change
  void onSalesTypeChanged(String? value) {
    salesType.value = value ?? 'Cash';
  }

  // Format current date
  String getCurrentDateFormatted() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
  }

  // Handle item selection
  // In SalesController, update the onItemSelected method:
  void onItemSelected(Item item, int index) {
    try{
      initControllers(index);
    const quantity = 1.0;
    final price = double.tryParse(item.salesPrice) ?? 0;
    final salesPrice = quantity * price;
    final taxRate = double.tryParse(item.taxRate) ?? 0;
    final taxAmount = salesPrice * taxRate / 100;
    final discountPercent = double.tryParse(item.discount) ?? 0;
    final double discountAmount = discountPercent > 0
        ? (salesPrice * discountPercent) / 100
        : 0;

    rowFields[index] = {
      'itemName': item.itemName,
      'barcode': item.barcode,
      'unit': item.unitId ?? '',
      'price': item.salesPrice,
      'taxRate': item.taxRate,
      'taxName': item.taxType,
      'discount': item.discount,
      'discountPercent': item.discount,
      'discountAmount': discountAmount.toStringAsFixed(2),
      'quantity': quantity.toString(),
      'salesPrice': salesPrice.toStringAsFixed(2),
      'itemId': item.id.toString(),
      'taxAmount': taxAmount.toStringAsFixed(2),
      'batchNo': item.sku,
      'serialNumbers': '',
      'taxId': '',
    };

    _updateRowControllers(index, item, salesPrice, discountAmount);
    priceOldValues[index] = item.salesPrice;
    newSalesPrices[index] = item.salesPrice;

    // Force update the controllers
    quantityControllers[index]?.text = quantity.toString();
    salesPriceControllers[index]?.text = salesPrice.toStringAsFixed(2);
    discountAmountControllers[index]?.text = discountAmount.toStringAsFixed(2);

    recalculateGrandTotal();
    recalculateTotalDiscount();

    // Add row automatically
    if (index < 9) {
      // Use a small delay to ensure the UI updates properly
      Future.delayed(const Duration(milliseconds: 100), () {
        rowCount.value = (index + 2).clamp(1, 10);
        initControllers(index + 1);

        // Clear the current input field and focus the next one
        itemInputControllers[index]?.clear();
        Future.delayed(const Duration(milliseconds: 50), () {
          itemInputFocusNodes[index + 1]?.requestFocus();
        });
      });
    }
    // Add to tempPurchaseItems
    if (tempPurchaseItems.length <= index) {
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: customerId.value ?? '',
          purchaseId: '',
          itemId: item.id.toString(),
          itemName: item.itemName,
          purchaseQty: quantity.toString(),
          pricePerUnit: item.salesPrice,
          taxName: item.taxType,
          taxId: '',
          taxAmount: taxAmount.toStringAsFixed(2),
          discountType: item.discount,
          discountAmount: discountAmount.toStringAsFixed(2),
          totalCost: salesPrice.toStringAsFixed(2),
          unit: item.unitId ?? '',
          taxRate: item.taxRate,
          batchNo: item.sku,
          barcode: item.barcode,
          serialNumbers: '',
        ),
      );
    } else {
      tempPurchaseItems[index] = TempPurchaseItem(
        customerId: customerMap[customerId.value] ?? '',
        purchaseId: '',
        itemId: item.id.toString(),
        itemName: item.itemName,
        purchaseQty: quantity.toString(),
        pricePerUnit: item.salesPrice,
        taxName: item.taxType,
        taxId: '',
        taxAmount: taxAmount.toStringAsFixed(2),
        discountType: item.discount,
        discountAmount: discountAmount.toStringAsFixed(2),
        totalCost: salesPrice.toStringAsFixed(2),
        unit: item.unitId ?? '',
        taxRate: item.taxRate,
        batchNo: item.sku,
        barcode: item.barcode,
        serialNumbers: '',
      );
    }
    }catch(e,stack){
      print(stack);
    }
  }

  // In SalesController, add this method to ensure tempPurchaseItems is properly sized
  void ensureTempPurchaseItemsSize(int index) {
    while (tempPurchaseItems.length <= index) {
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: customerMap[customerId.value] ?? '',
          purchaseId: '',
          itemId: '',
          itemName: '',
          purchaseQty: '1',
          pricePerUnit: '0',
          taxName: '',
          taxId: '',
          taxAmount: '0',
          discountType: '',
          discountAmount: '0',
          totalCost: '0',
          unit: '',
          taxRate: '0',
          batchNo: '',
          barcode: '',
          serialNumbers: '',
        ),
      );
    }
  }

  // Call this method before accessing tempPurchaseItems[index]
  // Update row controllers with item data
  void _updateRowControllers(
    int index,
    Item item,
    double salesPrice,
    double discountAmount,
  ) {
    quantityControllers[index]?.text = '1';
    priceControllers[index]?.text = item.salesPrice ?? '0';
    salesPriceControllers[index]?.text = salesPrice.toStringAsFixed(2);
    discountPercentControllers[index]?.text = item.discount ?? '0';
    discountAmountControllers[index]?.text = discountAmount.toStringAsFixed(2);
    batchNoControllers[index]?.text = item.sku ?? '';
    unitControllers[index].text = item.unitId ?? '';
  }

  // Check if a row has data
  bool rowHasData(int index) {
    final row = rowFields[index] ?? {};
    return row.values.any((v) => v.trim().isNotEmpty);
  }

  void updateRowCount() {
    for (int i = 0; i < 10; i++) {
      if (rowHasData(i) && rowCount.value == i + 1 && rowCount.value < 10) {
        rowCount.value = i + 2;
        initControllers(i + 1);
        break;
      }
    }
  }

  // Create a new sale
  Future<String> createSales({
    required String storeId,
    required String warehouseId,
    required String referenceNo,
    required String salesDate,
    required String customerId,
    required String otherChargesAmt,
    required String discountAmt,
    required String subTotal,
    required String grandTotal,
    required String salesNote,
    required String paidAmount,
    required String orderId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        createSalesUrl,
        data: {
          "store_id": storeId,
          "warehouse_id": warehouseId,
          "reference_no": referenceNo,
          "sales_date": salesDate,
          "customer_id": customerId,
          "other_charges_amt": otherChargesAmt,
          "discount_amt": discountAmt,
          "subtotal": subTotal,
          "grand_total": grandTotal,
          "sales_note": salesNote,
          "paid_amount": paidAmount,
          "order_id": orderId,
          "status": "1",
          "app_order": "1",
          "tax_report": "0",
        },
      );
      if (response.statusCode == 201) {
        return response.data["data"]["id"].toString();
      }
      return "sales failed";
    } catch (e) {
      return e.toString();
    }
  }

  // Create a single item sale
  Future<bool> singleItemSales({
    required String storeId,
    required String salesId,
    required String customerId,
    required String itemName,
    required String description,
    required String itemId,
    required String salesQty,
    required String pricePerUnit,
    required String taxName,
    required String taxId,
    required String taxAmount,
    required String discountType,
    required String discountAmount,
    required String totalCost,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        salesItemCreateUrl,
        data: {
          "store_id": storeId,
          "sales_id": salesId,
          "customer_id": customerId,
          "sales_status": "1",
          "item_id": itemId,
          "item_name": itemName,
          "description": description,
          "sales_qty": salesQty,
          "price_per_unit": pricePerUnit,
          "tax_type": taxName,
          "tax_id": taxId,
          "tax_amt": taxAmount,
          "discount_type": "1",
          "discount_input": discountType,
          "discount_amt": discountAmount,
          "unit_total_cost": "",
          "total_cost": totalCost,
          "status": "1",
          "seller_points": "",
          "purchase_price": "",
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Create a sales payment
  Future<bool> salesPaymentCreate({
    required String storeId,
    required String salesId,
    required String customerId,
    required String paymentMethod,
    required String paymentAmount,
    required String paymentDate,
    required String paymentNote,
    required String accountId,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        salesPaymentCreateUrl,
        data: {
          "store_id": storeId,
          "sales_id": salesId,
          "customer_id": customerId,
          "payment_method": paymentMethod,
          "payment_amount": paymentAmount,
          "payment_date": paymentDate,
          "payment_note": paymentNote,
          "account_id": accountId,
          "status": "1",
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Save a sale and optionally print
  Future<void> saveSale({
    required bool print,
    required BuildContext context,
  }) async {
    if (!_validateRequiredFields()) {
      Get.snackbar(
        'Error',
        'Please fill all required fields.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final isLoadingFlag = print ? isLoadingSavePrint : isLoadingSave;
    isLoadingFlag.value = true;

    try {
      await _buildTempPurchaseItems();
      final saleId = await _createSaleRecord();
      if (saleId == "sales failed") {
        Get.snackbar(
          'Error',
          saleId,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _processItemSales(saleId);
      await _processPayment(saleId);
      await saveCurrentState();

      Get.snackbar(
        'Success',
        print
            ? 'Sale saved and printed successfully'
            : 'Sale saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFlag.value = false;
    }
  }

  // Validate required fields
  bool _validateRequiredFields() {
    return storeId.value != null &&
        selectedWarehouse.value != null &&
        saleBillConrtoller.text.isNotEmpty &&
        salesType.value != null &&
        customerId.value != null &&
        tempSubTotal.value > 0;
  }

  // Build temporary purchase items
  Future<void> _buildTempPurchaseItems() async {
    tempPurchaseItems.clear();
    for (int i = 0; i < 10; i++) {
      final fields = rowFields[i];
      if (fields == null ||
          (fields['price'] == null && fields['quantity'] == null))
        continue;
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: customerMap[customerId.value]!,
          purchaseId: '',
          itemName: fields['itemId'] ?? '',
          itemId: fields['itemId'] ?? '',
          purchaseQty: fields['quantity'] ?? '',
          pricePerUnit: fields['price'] ?? '',
          taxName: fields['taxName'] ?? '',
          taxId: fields['taxId'] ?? '',
          taxAmount: fields['taxAmount'] ?? '',
          discountType: fields['discount'] ?? '',
          discountAmount: fields['discountAmount'] ?? '',
          totalCost: fields['salesPrice'] ?? '',
          unit: fields['unit'] ?? '',
          taxRate: fields['taxRate'] ?? '0',
          batchNo: fields['batchNo'] ?? '',
          barcode: fields['barcode'] ?? '',
          serialNumbers: '',
        ),
      );
    }
  }

  // Create sale record
  Future<String> _createSaleRecord() async {
    final otherChargesValue = double.tryParse(otherChargesController.text) ?? 0;
    final grandTotal =
        tempSubTotal.value +
        tempTotalTax.value +
        otherChargesValue -
        tempTotalDiscount.value;
    return await createSales(
      storeId: storeMap[storeId.value]!,
      warehouseId: warehouseMap[selectedWarehouse.value]!,
      referenceNo: saleBillConrtoller.text.trim(),
      salesDate: getCurrentDateFormatted(),
      customerId: customerMap[customerId.value]!,
      otherChargesAmt: otherChargesValue.toString(),
      discountAmt: tempTotalDiscount.value.toString(),
      subTotal: tempSubTotal.value.toString(),
      grandTotal: grandTotal.toString(),
      salesNote: salesNoteController.text,
      paidAmount: paidAmountController.text,
      orderId: saleBillConrtoller.text.trim(),
    );
  }

  // Process individual item sales
  Future<void> _processItemSales(String saleId) async {
    for (var item in tempPurchaseItems) {
      final success = await singleItemSales(
        storeId: storeMap[storeId.value]!,
        salesId: saleId,
        customerId: customerMap[customerId.value]!,
        itemName: item.itemName,
        description: '',
        itemId: item.itemId,
        salesQty: item.purchaseQty,
        pricePerUnit: item.pricePerUnit,
        taxName: item.taxName,
        taxId: item.taxId,
        taxAmount: item.taxAmount,
        discountType: item.discountType,
        discountAmount: item.discountAmount,
        totalCost: item.totalCost,
      );
      if (!success) {
        Get.snackbar(
          'Error',
          'Failed to process item sale for item ID ${item.itemId}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Process payment
  Future<void> _processPayment(String saleId) async {
    final success = await salesPaymentCreate(
      storeId: storeMap[storeId.value]!,
      salesId: saleId,
      customerId: customerMap[customerId.value]!,
      paymentMethod: salesType.value,
      paymentAmount: paidAmountController.text,
      paymentDate: getCurrentDateFormatted(),
      paymentNote: salesNoteController.text,
      accountId: "",
    );
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to process payment',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

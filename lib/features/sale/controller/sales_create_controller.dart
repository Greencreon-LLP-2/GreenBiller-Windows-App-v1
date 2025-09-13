import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/alerts/app_snackbar.dart';
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
  late final AuthController authController;
  late final DropdownController storeDropdownController;
  final accessToken = RxnString();
  final userId = 0.obs;
  final Rx<Uint8List?> appLogoBytes = Rx<Uint8List?>(null);
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
  final grandTotal = 0.0.obs;
  final balance = 0.0.obs;
  final rowCount = 1.obs;
  final taxModel = Rxn<TaxModel>();
  final customerType = false.obs;
  // Data collections
  final selectedItem = Rxn<Item>();
  final tempPurchaseItems = <TempPurchaseItem>[].obs;
  final showDropdownRows = <int>{}.obs;
  final rowFields = <int, Map<String, String>>{}.obs;
  final newSalesPrices = <int, String>{}.obs;
  final priceOldValues = <int, String>{}.obs;
  final RxString selectedCustomerType = 'None'.obs; // "B2B", "B2C", "None"
  final RxBool showGstField = false.obs;
  final RxBool isGstFieldEditable = false.obs;
  // Dropdown Data

  final RxMap<String, String> storeMap = <String, String>{}.obs;
  final RxList<dynamic> actualStoreData = <dynamic>[].obs;
  final RxMap<String, String> warehouseMap = <String, String>{}.obs;
  final RxMap<String, String> customerMap = <String, String>{}.obs;
  final RxList<dynamic> actualCustomerData = <dynamic>[].obs;
  final RxList<Map<String, dynamic>> itemsList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> taxList = <Map<String, dynamic>>[].obs;
  final RxString selectedStoreId = ''.obs;
  final RxString selectedWarehouseId = ''.obs;
  final RxString selectedCustomerId = ''.obs;

  late TextEditingController warehouseController = TextEditingController();
  late TextEditingController customerController = TextEditingController();
  late TextEditingController saleBillConrtoller = TextEditingController();
  late TextEditingController storeController = TextEditingController();
  late TextEditingController saleDateController = TextEditingController();
  late TextEditingController referenceNocontroller = TextEditingController();
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
  final gstController = TextEditingController();

  final serialNumbersControllers = <int, TextEditingController>{}.obs;
  final taxAmountControllers = <int, TextEditingController>{}.obs;
  final amountControllers = <int, TextEditingController>{}.obs;
  final gstRegex = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );
  // Hive storage
  Box? _settingsBox;

  @override
  void onInit() async {
    super.onInit();
    _initializeDependencies();
    await _initializeHive();
    await fetchInitialData();
    // Add listener for paidAmountController to update balance
    paidAmountController.addListener(updateBalance);
  }

  @override
  void onClose() {
    _disposeControllers();
    paidAmountController.removeListener(updateBalance);
    _settingsBox?.close();
    super.onClose();
  }

  void updateBalance() {
    final grandTotal = this.grandTotal.value;
    final paidAmount = double.tryParse(paidAmountController.text) ?? 0.0;
    balance.value = grandTotal - paidAmount;
  }

  void generateBillNumber() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    saleBillConrtoller.text =
        'SALE-${timestamp.substring(timestamp.length - 8)}';
  }

  // Initialize dependencies
  void _initializeDependencies() {
    _dioClient = DioClient();
    _commonApi = CommonApiFunctionsController();
    authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();
    userId.value = authController.user.value?.userId ?? 0;
    accessToken.value = authController.user.value?.accessToken;
    _getAppLogo();
  }

  // Initialize Hive box
  Future<void> _initializeHive() async {
    try {
      _settingsBox = await Hive.openBox('settings');
    } catch (e) {
      debugPrint('Error opening Hive box: $e');
    }
  }

  Future<void> _getAppLogo() async {
    try {
      final response = await _dioClient.dio.get<List<int>>(
        appUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        appLogoBytes.value = Uint8List.fromList(response.data!);
      } else {
        appLogoBytes.value = null; // fallback handling later
      }
    } catch (e) {
      // log or handle error
      appLogoBytes.value = null;
    }
  }

  // Dispose all controllers and focus nodes
  void _disposeControllers() {
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
      // await loadSavedState();
      generateBillNumber();
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch initial data: $e',
        color: Colors.red,
        icon: Icons.error,
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
        AppSnackbar.show(
          title: 'Error',
          message: 'Failed to fetch taxes: ${response.statusCode}',
          color: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch taxes: $e',
        color: Colors.red,
        icon: Icons.error,
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
        AppSnackbar.show(
          title: 'Error',
          message: 'Please add items first, empty store',
        );
      }
      itemsList.value = response
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch items: $e',
        color: Colors.red,
        icon: Icons.error,
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
      actualStoreData.value = response;
      storeMap.value = {
        for (var store in response) store['store_name']: store['id'].toString(),
      };
      if (storeMap.isNotEmpty) {
        storeId.value = storeMap.keys.first;
      }
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch stores: $e',
        color: Colors.red,
        icon: Icons.error,
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
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch warehouses: $e',
        color: Colors.red,
        icon: Icons.error,
      );
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  Future<void> fetchCustomers(String storeId) async {
    isLoadingCustomers.value = true;
    try {
      final List<dynamic> response = await _commonApi.fetchCustomers(storeId);
      actualCustomerData.value = response;
      customerMap.value = {
        for (var customer in response)
          customer['customer_name']: customer['id'].toString(),
      };
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch suppliers: $e',
      );
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  void onStoreSelected(String? storeName) async {
    if (storeName != null && storeMap.containsKey(storeName)) {
      selectedStoreId.value = storeMap[storeName]!;

      storeController.text = storeName;
      selectedWarehouseId.value = '';
      selectedCustomerId.value = '';
      showGstField.value = false;
      selectedCustomerType.value = 'None';
      warehouseMap.clear();
      customerMap.clear();
      itemsList.clear();
      generateBillNumber();
      await fetchWarehouses(selectedStoreId.value);
      await fetchCustomers(selectedStoreId.value);
      await fetchItems(selectedStoreId.value);
    }
  }

  void onWarehouseSelected(String? warehouseName) async {
    if (warehouseName != null && warehouseMap.containsKey(warehouseName)) {
      selectedWarehouseId.value = warehouseMap[warehouseName]!;
      selectedWarehouse.value = warehouseName;
      warehouseController.text = warehouseName;
    }
  }

  void onCustomerSelected(String? customerName) {
    if (customerName != null && customerMap.containsKey(customerName)) {
      selectedCustomerId.value = customerMap[customerName]!;
      customerId.value = customerName;
      customerController.text = customerName;
    } else if (customerName == 'Walk-in Customer') {
      selectedCustomerId.value = 'Walk-in Customer';
      customerId.value = customerName;
      customerController.text = customerName ?? '';
    }

    // Find selected customer data
    final selectedCustomer = actualCustomerData.firstWhereOrNull(
      (c) => c['id'].toString() == selectedCustomerId.value,
    );

    // Check GST
    if (selectedCustomer != null &&
        selectedCustomer['gstin'] != null &&
        (selectedCustomer['gstin'] as String).isNotEmpty) {
      selectedCustomerType.value = 'B2B';
      showGstField.value = true;
      isGstFieldEditable.value = false;
      gstController.text = selectedCustomer['gstin'];
    } else {
      selectedCustomerType.value = ''; // force user to pick
      showGstField.value = false;
      isGstFieldEditable.value = true;
      gstController.clear();
    }
  }

  void onCustomerTypeChanged(String? type) {
    selectedCustomerType.value = type ?? '';
    if (selectedCustomerType.value == 'B2B') {
      showGstField.value = true;
    } else {
      showGstField.value = false;
      gstController.clear();
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
    final amount = salesPrice + taxAmount - discountAmount;

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
    taxAmountControllers[index] = TextEditingController(
      text: taxAmount.toStringAsFixed(2),
    );
    amountControllers[index] = TextEditingController(
      text: amount.toStringAsFixed(2),
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
      'amount': amount.toStringAsFixed(2),
    };
  }

  // Recalculate grand total
  double recalculateGrandTotal() {
    double subTotalSum = 0.0;
    double taxSum = 0.0;

    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null ||
          fields['itemId'] == null ||
          fields['itemId']!.isEmpty)
        continue;

      final salesPrice = double.tryParse(fields['salesPrice'] ?? '0') ?? 0;
      final taxAmount = double.tryParse(fields['taxAmount'] ?? '0') ?? 0;

      subTotalSum += salesPrice;
      taxSum += taxAmount;
    }

    tempSubTotal.value = subTotalSum;
    tempTotalTax.value = taxSum;

    final otherCharges = double.tryParse(otherChargesController.text) ?? 0;
    final totalDiscount = tempTotalDiscount.value;

    grandTotal.value = subTotalSum + taxSum + otherCharges - totalDiscount;
    updateBalance();
    return grandTotal.value;
  }

  // Recalculate total discount
  double recalculateTotalDiscount() {
    double discountSum = 0.0;

    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null ||
          fields['itemId'] == null ||
          fields['itemId']!.isEmpty)
        continue;

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
  void setBillDate(DateTime date) {
    saleDateController.text = date.toString().split(' ')[0];
  }

  void onItemSelected(Item item, int rowIndex) {
    try {
      initControllers(rowIndex);
      const quantity = 1.0;
      final price = double.tryParse(item.salesPrice) ?? 0;
      final salesPrice = quantity * price;
      final taxRate = double.tryParse(item.taxRate) ?? 0;
      final taxAmount = salesPrice * taxRate / 100;
      final discountPercent = double.tryParse(item.discount) ?? 0;
      final double discountAmount = discountPercent > 0
          ? (salesPrice * discountPercent) / 100
          : 0;
      final amount = salesPrice + taxAmount - discountAmount;

      // Update rowFields reactively
      rowFields[rowIndex] = {
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
        'amount': amount.toStringAsFixed(2),
        'batchNo': item.sku,
        'serialNumbers': '',
        'taxId': '',
      };

      // Force UI update
      rowFields.refresh();

      _updateRowControllers(
        rowIndex,
        item,
        salesPrice,
        discountAmount,
        taxAmount,
        amount,
      );
      priceOldValues[rowIndex] = item.salesPrice;
      newSalesPrices[rowIndex] = item.salesPrice;

      // Update controllers
      quantityControllers[rowIndex]?.text = quantity.toString();
      salesPriceControllers[rowIndex]?.text = salesPrice.toStringAsFixed(2);
      discountAmountControllers[rowIndex]?.text = discountAmount
          .toStringAsFixed(2);
      taxAmountControllers[rowIndex]?.text = taxAmount.toStringAsFixed(2);
      amountControllers[rowIndex]?.text = amount.toStringAsFixed(2);

      // Update tempPurchaseItems for the current row only
      ensureTempPurchaseItemsSize(rowIndex);
      tempPurchaseItems[rowIndex] = TempPurchaseItem(
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
      );

      recalculateGrandTotal();
      recalculateTotalDiscount();

      // Add new row reactively only if the current row has valid data
      if (rowIndex < 9 &&
          rowIndex == rowCount.value - 1 &&
          rowHasData(rowIndex)) {
        rowCount.value++;
        initControllers(rowIndex + 1);

        // Focus the next input field
        WidgetsBinding.instance.addPostFrameCallback((_) {
          itemInputFocusNodes[rowIndex + 1]?.requestFocus();
        });
      }
    } catch (e, stack) {
      print('Error in onItemSelected: $e');
      print(stack);
    }
  }

  // Ensure tempPurchaseItems size only for valid rows
  void ensureTempPurchaseItemsSize(int index) {
    while (tempPurchaseItems.length <= index) {
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: customerId.value ?? '',
          purchaseId: '',
          itemId: '',
          itemName: '',
          purchaseQty: '0',
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

  // Filter valid tempPurchaseItems for singleItemSales
  List<TempPurchaseItem> getValidPurchaseItems() {
    return tempPurchaseItems
        .asMap()
        .entries
        .where((entry) {
          final index = entry.key;
          final item = entry.value;
          final row = rowFields[index];
          return row != null &&
              row['itemId'] != null &&
              row['itemId']!.isNotEmpty &&
              item.itemId.isNotEmpty;
        })
        .map((entry) => entry.value)
        .toList();
  }

  // Update row controllers with item data
  void _updateRowControllers(
    int index,
    Item item,
    double salesPrice,
    double discountAmount,
    double taxAmount,
    double amount,
  ) {
    quantityControllers[index]?.text = '1';
    priceControllers[index]?.text = item.salesPrice ?? '0';
    salesPriceControllers[index]?.text = salesPrice.toStringAsFixed(2);
    discountPercentControllers[index]?.text = item.discount ?? '0';
    discountAmountControllers[index]?.text = discountAmount.toStringAsFixed(2);
    taxAmountControllers[index]?.text = taxAmount.toStringAsFixed(2);
    amountControllers[index]?.text = amount.toStringAsFixed(2);
    batchNoControllers[index]?.text = item.sku ?? '';
    unitControllers[index].text = item.unitId ?? '';
  }

  // Check if a row has data
  bool rowHasData(int index) {
    final row = rowFields[index] ?? {};
    return row['itemId']?.isNotEmpty ?? false;
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

  // Clear fields after a successful save, preserving store, warehouse, and customer
  void clearFieldsAfterSave() {
    // Clear row-related data
    tempPurchaseItems.clear();
    rowFields.clear();
    showDropdownRows.clear();
    newSalesPrices.clear();
    priceOldValues.clear();
    selectedItem.value = null;
    rowCount.value = 1;

    // Dispose and clear row-specific controllers
    quantityControllers.forEach((_, controller) => controller.dispose());
    quantityControllers.clear();
    priceControllers.forEach((_, controller) => controller.dispose());
    priceControllers.clear();
    salesPriceControllers.forEach((_, controller) => controller.dispose());
    salesPriceControllers.clear();
    discountPercentControllers.forEach((_, controller) => controller.dispose());
    discountPercentControllers.clear();
    discountAmountControllers.forEach((_, controller) => controller.dispose());
    discountAmountControllers.clear();
    batchNoControllers.forEach((_, controller) => controller.dispose());
    batchNoControllers.clear();
    itemInputControllers.forEach((_, controller) => controller.dispose());
    itemInputControllers.clear();
    taxAmountControllers.forEach((_, controller) => controller.dispose());
    taxAmountControllers.clear();
    amountControllers.forEach((_, controller) => controller.dispose());
    amountControllers.clear();
    serialNumbersControllers.forEach((_, controller) => controller.dispose());
    serialNumbersControllers.clear();
    priceFocusNodes.forEach((_, node) => node.dispose());
    priceFocusNodes.clear();
    itemInputFocusNodes.forEach((_, node) => node.dispose());
    itemInputFocusNodes.clear();
    for (var controller in unitControllers) {
      controller.dispose();
    }
    unitControllers.value = List.generate(10, (_) => TextEditingController());

    // Clear totals and other fields
    tempSubTotal.value = 0.0;
    tempTotalDiscount.value = 0.0;
    tempTotalTax.value = 0.0;
    grandTotal.value = 0.0;
    balance.value = 0.0;
    salesType.value = 'Cash';
    otherChargesController.clear();
    paidAmountController.clear();
    salesNoteController.clear();
    taxModel.value = null;

    // Initialize controllers for the first row
    initControllers(0);
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
    required String customerNewType,
    required String customerGst,
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
          "customer_gst": customerGst,
          "customer_type": customerNewType,
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
          "payment_type": paymentMethod,
          "payment": paymentAmount,
          "payment_date": paymentDate,
          "payment_note": paymentNote,
          "account_id": accountId,
          "status": "1",
        },
      );
      return response.statusCode == 200;
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
      AppSnackbar.show(
        title: 'Error',
        message: 'Please fill all required fields.',
        color: Colors.red,
        icon: Icons.error,
      );
      return;
    }
    if (showGstField.value) {
      if (gstController.text.isEmpty) {
        AppSnackbar.show(
          color: Colors.red,
          title: "Error",
          message: "GST Number is required for B2B customers.",
          icon: Icons.error,
        );
        return;
      } else if (!gstRegex.hasMatch(gstController.text)) {
        AppSnackbar.show(
          color: Colors.red,
          title: "Error",
          message: "Invalid GST Number format.",
          icon: Icons.error,
        );
        return;
      }
    }

    // Validate Sale Date
    if (saleDateController.text.isEmpty) {
      AppSnackbar.show(
        color: Colors.red,
        title: "Error",
        message: "Sale Date is required.",
        icon: Icons.error,
      );
      return;
    }

    final isLoadingFlag = print ? isLoadingSavePrint : isLoadingSave;
    isLoadingFlag.value = true;

    String? saleId;
    try {
      await _buildTempPurchaseItems();
      final validItems = getValidPurchaseItems();
      if (validItems.isEmpty) {
        AppSnackbar.show(
          title: 'Error',
          message: 'No valid items selected for sale.',
          color: Colors.red,
          icon: Icons.error,
        );
        return;
      }

      saleId = await _createSaleRecord();
      if (saleId == "sales failed") {
        AppSnackbar.show(
          title: 'Error',
          message: saleId,
          color: Colors.red,
          icon: Icons.error,
        );
        return;
      }

      await _processItemSales(saleId);
      await _processPayment(saleId);

      // Show success message before clearing fields
      AppSnackbar.show(
        title: 'Success',
        message: print
            ? 'Sale saved and printed successfully'
            : 'Sale saved successfully',

        color: Colors.green,
        icon: Icons.thumb_up,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Something went wrong: $e',
        color: Colors.red,
        icon: Icons.error,
      );
      return;
    } finally {
      isLoadingFlag.value = false;
    }
    generateBillNumber();
    // Clear fields and generate new bill number in a separate try-catch
    try {
      clearFieldsAfterSave();
    } catch (e) {
      debugPrint('Error during field clearing: $e');
      // Do not show error snackbar to avoid overriding success message
    }
  }

  // Validate required fields
  bool _validateRequiredFields() {
    final isValid =
        selectedStoreId.value.isNotEmpty &&
        selectedWarehouseId.value.isNotEmpty &&
        saleBillConrtoller.text.isNotEmpty &&
        salesType.value.isNotEmpty &&
        customerId.value != null &&
        tempSubTotal.value > 0;

    return isValid;
  }

  // Build temporary purchase items
  Future<void> _buildTempPurchaseItems() async {
    tempPurchaseItems.clear();
    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null ||
          fields['itemId'] == null ||
          fields['itemId']!.isEmpty) {
        continue; // Skip rows without a valid itemId
      }
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: customerId.value == 'Walk-in Customer'
              ? 'Walk-in Customer'
              : customerMap[customerId.value] ?? '',
          purchaseId: '',
          itemName: fields['itemName'] ?? '',
          itemId: fields['itemId'] ?? '',
          purchaseQty: fields['quantity'] ?? '0',
          pricePerUnit: fields['price'] ?? '0',
          taxName: fields['taxName'] ?? '',
          taxId: fields['taxId'] ?? '',
          taxAmount: fields['taxAmount'] ?? '0',
          discountType: fields['discount'] ?? '',
          discountAmount: fields['discountAmount'] ?? '0',
          totalCost: fields['salesPrice'] ?? '0',
          unit: fields['unit'] ?? '',
          taxRate: fields['taxRate'] ?? '0',
          batchNo: fields['batchNo'] ?? '',
          barcode: fields['barcode'] ?? '',
          serialNumbers: fields['serialNumbers'] ?? '',
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
      referenceNo: referenceNocontroller.text.trim(),
      salesDate: saleDateController.text,
      customerId: customerId.value == 'Walk-in Customer'
          ? 'Walk-in Customer'
          : customerMap[customerId.value]!,
      otherChargesAmt: otherChargesValue.toString(),
      discountAmt: tempTotalDiscount.value.toString(),
      subTotal: tempSubTotal.value.toString(),
      grandTotal: grandTotal.toString(),
      salesNote: salesNoteController.text,
      paidAmount: paidAmountController.text,
      orderId: saleBillConrtoller.text.trim(),
      customerNewType: selectedCustomerType.value,
      customerGst: gstController.text,
    );
  }

  // Process individual item sales
  Future<void> _processItemSales(String saleId) async {
    final validItems = getValidPurchaseItems();
    for (var item in validItems) {
      final success = await singleItemSales(
        storeId: storeMap[storeId.value]!,
        salesId: saleId,
        customerId: customerId.value == 'Walk-in Customer'
            ? 'Walk-in Customer'
            : customerMap[customerId.value]!,
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
        AppSnackbar.show(
          title: 'Error',
          message: 'Failed to process item sale for item ID ${item.itemId}',
          color: Colors.red,
          icon: Icons.error,
        );
      }
    }
  }

  // Process payment
  Future<void> _processPayment(String saleId) async {
    final success = await salesPaymentCreate(
      storeId: storeMap[storeId.value]!,
      salesId: saleId,
      customerId: customerId.value == 'Walk-in Customer'
          ? 'Walk-in Customer'
          : customerMap[customerId.value]!,
      paymentMethod: salesType.value,
      paymentAmount: paidAmountController.text.isNotEmpty
          ? paidAmountController.text
          : '0',
      paymentDate: saleDateController.text,
      paymentNote: salesNoteController.text,
      accountId: "",
    );
    if (!success) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to process payment',
        color: Colors.red,
        icon: Icons.error,
      );
    }
  }
}

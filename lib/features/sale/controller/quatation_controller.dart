import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/sale/model/quotation_model.dart';
import 'package:hive/hive.dart';
import 'package:greenbiller/features/items/model/item_model.dart';

import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';

class QuotationController extends GetxController {
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
  final isLoadingCustomers = false.obs;
  final isLoadingItems = false.obs;
  final isLoadingSave = false.obs;

  // Form data
  final storeId = RxnString();
  final customerId = RxnString();
  final tempSubTotal = 0.0.obs;
  final rowCount = 1.obs;

  // Data collections
  final selectedItem = Rxn<Item>();
  final tempPurchaseItems = <TempPurchaseItem>[].obs;
  final showDropdownRows = <int>{}.obs;
  final rowFields = <int, Map<String, String>>{}.obs;

  // Dropdown Data
  final RxMap<String, String> storeMap = <String, String>{}.obs;
  final RxList<dynamic> actualStoreData = <dynamic>[].obs;
  final RxMap<String, String> customerMap = <String, String>{}.obs;
  final RxList<dynamic> actualCustomerData = <dynamic>[].obs;
  final RxList<Map<String, dynamic>> itemsList = <Map<String, dynamic>>[].obs;
  final RxString selectedStoreId = ''.obs;
  final RxString selectedCustomerId = ''.obs;
  final RxString quotationNumber = ''.obs;
  late TextEditingController customerController;
  late TextEditingController storeController;

  // Input controllers
  final quantityControllers = <int, TextEditingController>{}.obs;
  final priceControllers = <int, TextEditingController>{}.obs;
  final unitControllers = <int, TextEditingController>{}.obs;

  // Quotation data for orders page
  final quotationsData = Rxn<QuotationListModel>();
  final isLoadingQuotations = false.obs;
  final errorMessage = ''.obs;
  final selectedQuotationFilter = 'All'.obs;
  final quotationSearchText = ''.obs;

  // Hive storage
  Box? _settingsBox;

  @override
  void onInit() async {
    super.onInit();
    _initializeDependencies();
    await _initializeHive();
    _initializeControllers();
    await fetchInitialData();
  }

  @override
  void onClose() {
    _disposeControllers();
    _settingsBox?.close();
    super.onClose();
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

  // Initialize controllers
  void _initializeControllers() {
    customerController = TextEditingController();
    storeController = TextEditingController();
    initControllers(0);
  }

  Future<void> _getAppLogo() async {
    ;

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

  // Initialize Hive box
  Future<void> _initializeHive() async {
    try {
      _settingsBox = await Hive.openBox('settings');
    } catch (e) {
      debugPrint('Error opening Hive box: $e');
    }
  }

  // Dispose all controllers
  void _disposeControllers() {
    customerController.dispose();
    storeController.dispose();
    quantityControllers.forEach((_, controller) => controller.dispose());
    priceControllers.forEach((_, controller) => controller.dispose());
    unitControllers.forEach((_, controller) => controller.dispose());
    quantityControllers.clear();
    priceControllers.clear();
    unitControllers.clear();
  }

  // Fetch initial data for quotation setup
  Future<void> fetchInitialData() async {
    if (accessToken.value == null) return;
    isLoading.value = true;
    try {
      await fetchStores();
      fetchQuotations();
      generateQuoteNumber();
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

  // Generate unique quote number
  void generateQuoteNumber() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    quotationNumber.value = 'QUOTE${timestamp.substring(timestamp.length - 6)}';
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
        selectedStoreId.value = storeMap.values.first;
        storeController.text = storeMap.keys.first;
        await fetchCustomers(selectedStoreId.value);
        await fetchItems(selectedStoreId.value);
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

  // Fetch customers by store ID
  Future<void> fetchCustomers(String storeId) async {
    isLoadingCustomers.value = true;
    try {
      final List<dynamic> response = await _commonApi.fetchCustomers(storeId);
      actualCustomerData.value = response;
      customerMap.value = {
        for (var customer in response)
          customer['customer_name']: customer['id'].toString(),
      };
      if (customerMap.isNotEmpty) {
        selectedCustomerId.value = customerMap.values.first;
        customerId.value = customerMap.values.first;
        customerController.text = customerMap.keys.first;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch customers: $e');
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  // Fetch items by store ID
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

  // Handle store selection
  void onStoreSelected(String? storeName) async {
    if (storeName != null && storeMap.containsKey(storeName)) {
      selectedStoreId.value = storeMap[storeName]!;
      storeController.text = storeName;
      selectedCustomerId.value = '';
      customerId.value = null;
      customerController.clear();
      customerMap.clear();
      itemsList.clear();
      await fetchCustomers(selectedStoreId.value);
      await fetchItems(selectedStoreId.value);
    }
  }

  // Handle customer selection
  void onCustomerSelected(String? customerName) {
    if (customerName != null && customerMap.containsKey(customerName)) {
      selectedCustomerId.value = customerMap[customerName]!;
      customerId.value = customerMap[customerName]!;
      customerController.text = customerName;
    }
  }

  // Initialize controllers for a row
  void initControllers(int index) {
    if (!quantityControllers.containsKey(index)) {
      quantityControllers[index] = TextEditingController(
        text: rowFields[index]?['quantity'] ?? '1.0',
      );
    }
    if (!priceControllers.containsKey(index)) {
      priceControllers[index] = TextEditingController(
        text: rowFields[index]?['price'] ?? '0',
      );
    }
    if (!unitControllers.containsKey(index)) {
      unitControllers[index] = TextEditingController(
        text: rowFields[index]?['unit'] ?? '',
      );
    }
    rowFields[index] = {
      ...?rowFields[index],
      'quantity': rowFields[index]?['quantity'] ?? '1.0',
      'price': rowFields[index]?['price'] ?? '0',
      'subtotal':
          rowFields[index]?['subtotal'] ??
          ((double.tryParse(rowFields[index]?['quantity'] ?? '1.0') ?? 1.0) *
                  (double.tryParse(rowFields[index]?['price'] ?? '0') ?? 0))
              .toStringAsFixed(2),
      'itemName': rowFields[index]?['itemName'] ?? '',
      'unit': rowFields[index]?['unit'] ?? '',
      'itemId': rowFields[index]?['itemId'] ?? '',
      'barcode': rowFields[index]?['barcode'] ?? '',
    };
  }

  // Recalculate subtotal
  double recalculateSubTotal() {
    double subTotalSum = 0.0;
    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null ||
          fields['itemId'] == null ||
          fields['itemId']!.isEmpty) {
        continue;
      }
      final subtotal = double.tryParse(fields['subtotal'] ?? '0') ?? 0;
      subTotalSum += subtotal;
    }
    tempSubTotal.value = subTotalSum;
    return subTotalSum;
  }

  // Format current date
  String getCurrentDateFormatted() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
  }

  // Handle item selection
  void onItemSelected(Item item, int rowIndex) {
    try {
      initControllers(rowIndex);
      const quantity = 1.0;
      final price = double.tryParse(item.salesPrice) ?? 0;
      final subtotal = quantity * price;

      rowFields[rowIndex] = {
        'itemName': item.itemName,
        'barcode': item.barcode,
        'unit': item.unitId ?? '',
        'price': item.salesPrice,
        'quantity': quantity.toString(),
        'subtotal': subtotal.toStringAsFixed(2),
        'itemId': item.id.toString(),
      };

      quantityControllers[rowIndex]?.text = quantity.toString();
      priceControllers[rowIndex]?.text = item.salesPrice;
      unitControllers[rowIndex]?.text = item.unitId ?? '';

      ensureTempPurchaseItemsSize(rowIndex);
      tempPurchaseItems[rowIndex] = TempPurchaseItem(
        customerId: selectedCustomerId.value,
        purchaseId: '',
        itemId: item.id.toString(),
        itemName: item.itemName,
        purchaseQty: quantity.toString(),
        pricePerUnit: item.salesPrice,
        taxName: '',
        taxId: '',
        taxAmount: '0',
        discountType: '',
        discountAmount: '0',
        totalCost: subtotal.toStringAsFixed(2),
        unit: item.unitId ?? '',
        taxRate: '0',
        batchNo: item.sku,
        barcode: item.barcode,
        serialNumbers: '',
      );

      recalculateSubTotal();

      if (rowIndex < 9 &&
          rowIndex == rowCount.value - 1 &&
          rowHasData(rowIndex)) {
        rowCount.value++;
        initControllers(rowIndex + 1);
      }
    } catch (e, stack) {
      debugPrint('Error in onItemSelected: $e');
      debugPrint(stack.toString());
    }
  }

  // Ensure tempPurchaseItems size
  void ensureTempPurchaseItemsSize(int index) {
    while (tempPurchaseItems.length <= index) {
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: selectedCustomerId.value,
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

  // Filter valid tempPurchaseItems
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

  // Check if a row has data
  bool rowHasData(int index) {
    final row = rowFields[index] ?? {};
    return row['itemId']?.isNotEmpty ?? false;
  }

  void clearFieldsAfterSave() {
    // Clear reactive collections
    tempPurchaseItems.clear();
    rowFields.clear();
    showDropdownRows.clear();
    quantityControllers.clear();
    priceControllers.clear();
    unitControllers.clear();
    tempSubTotal.value = 0.0;

    // Reset dropdowns
    customerController.text = '';
    storeController.text = '';
    selectedCustomerId.value = '';
    selectedStoreId.value = '';
    customerId.value = null;
    selectedItem.value = null;

    // Reset row count
    rowCount.value = 1;

    // Initialize new empty row
    rowFields[0] = {
      'itemName': '',
      'itemId': '',
      'quantity': '1.0',
      'price': '0',
      'subtotal': '0',
      'unit': '',
      'barcode': '',
    };
    initControllers(0);
    fetchStores();
  }

  // Validate required fields
  bool _validateRequiredFields() {
    return selectedStoreId.value.isNotEmpty &&
        quotationNumber.value.isNotEmpty &&
        selectedCustomerId.value.isNotEmpty &&
        tempSubTotal.value > 0;
  }

  // Create a quotation record
  Future<String?> _createQuotationRecord() async {
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/quotation-create',
        data: {
          "store_id": int.parse(selectedStoreId.value),
          "customer_id": int.parse(selectedCustomerId.value),
          "quote_number": quotationNumber.value,
          "quote_date": getCurrentDateFormatted(),
          "total_amount": tempSubTotal.value.toString(),
          "status": "1",
          "created_by": userId.value.toString(),
          "items": tempPurchaseItems
              .asMap()
              .entries
              .where(
                (entry) => rowFields[entry.key]?['itemId']?.isNotEmpty ?? false,
              )
              .map((entry) {
                final item = entry.value;
                return {
                  "item_id": item.itemId,
                  "item_name": item.itemName,
                  "quantity": (double.parse(item.purchaseQty)).toInt(),
                  "price_per_unit": double.parse(item.pricePerUnit),
                  "tax_name": item.taxName,
                  "tax_id": item.taxId,
                  "tax_amount": double.parse(item.taxAmount),
                  "discount_type": item.discountType,
                  "discount_amount": double.parse(item.discountAmount),
                  "unit": item.unit,
                  "tax_rate": double.parse(item.taxRate),
                  "barcode": item.barcode,
                  "total_cost": double.parse(item.totalCost),
                  "serial_numbers": item.serialNumbers,
                  "batch_no": item.batchNo,
                };
              })
              .toList(),
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["data"]["id"].toString();
      } else {
        debugPrint("Create quotation failed: ${response.data}");
        return null;
      }
    } catch (e) {
      debugPrint('Error creating quotation: $e');
      return null;
    }
  }

  // Build temporary purchase items
  Future<void> _buildTempPurchaseItems() async {
    tempPurchaseItems.clear();
    for (int i = 0; i < rowCount.value; i++) {
      final fields = rowFields[i];
      if (fields == null ||
          fields['itemId'] == null ||
          fields['itemId']!.isEmpty) {
        continue;
      }
      tempPurchaseItems.add(
        TempPurchaseItem(
          customerId: selectedCustomerId.value,
          purchaseId: '',
          itemName: fields['itemName'] ?? '',
          itemId: fields['itemId'] ?? '',
          purchaseQty: fields['quantity'] ?? '1.0',
          pricePerUnit: fields['price'] ?? '0',
          taxName: '',
          taxId: '',
          taxAmount: '0',
          discountType: '',
          discountAmount: '0',
          totalCost: fields['subtotal'] ?? '0',
          unit: fields['unit'] ?? '',
          taxRate: '0',
          batchNo: fields['barcode'] ?? '',
          barcode: fields['barcode'] ?? '',
          serialNumbers: '',
        ),
      );
    }
  }

  // Save a quotation
  Future<void> saveQuotation({required BuildContext context}) async {
    if (!_validateRequiredFields()) {
      Get.snackbar(
        'Error',
        'Please fill all required fields (Store, Customer, Quote Number, and at least one item).',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingSave.value = true;
    String? quotationId;

    try {
      await _buildTempPurchaseItems();
      final validItems = getValidPurchaseItems();
      if (validItems.isEmpty) {
        Get.snackbar(
          'Error',
          'No valid items selected for quotation.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      quotationId = await _createQuotationRecord();
      if (quotationId == null) {
        Get.snackbar(
          'Error',
          'Quotation creation failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Get.snackbar(
        'Success',
        'Quotation saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      generateQuoteNumber();
      selectedStoreId.value = '';
      selectedCustomerId.value = '';
      try {
        clearFieldsAfterSave();
      } catch (e) {
        print(e);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save quotation: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingSave.value = false;
    }
  }

  // Fetch quotations
  Future<void> fetchQuotations() async {
    isLoadingQuotations.value = true;
    errorMessage.value = '';
    try {
      final response = await _dioClient.dio.get('$baseUrl/quotation-view');
      if (response.statusCode == 200) {
        quotationsData.value = QuotationListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch quotations: ${response.data}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch quotations: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingQuotations.value = false;
    }
  }

  // Filtered quotations getter
  List<Quotation> get filteredQuotations {
    final data = quotationsData.value?.data ?? [];
    return data.where((quotation) {
      if (selectedQuotationFilter.value != 'All') {
        if (selectedQuotationFilter.value == 'Pending' &&
            quotation.status != 'pending') {
          return false;
        }
        if (selectedQuotationFilter.value == 'Accepted' &&
            quotation.status != 'accepted') {
          return false;
        }
      }
      if (quotationSearchText.value.isNotEmpty) {
        final term = quotationSearchText.value.toLowerCase();
        final matchQuoteNo = quotation.quoteNumber.toLowerCase().contains(term);
        final matchCustomer = quotation.customerId != null
            ? (customerMap[quotation.customerId] ?? '').toLowerCase().contains(
                term,
              )
            : false;
        final matchItems = quotation.items.any(
          (i) => i.itemName.toLowerCase().contains(term),
        );
        if (!matchQuoteNo && !matchCustomer && !matchItems) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}

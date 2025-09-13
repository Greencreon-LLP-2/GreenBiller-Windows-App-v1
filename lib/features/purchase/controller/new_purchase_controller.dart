import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/alerts/app_snackbar.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/core/utils/subscription_util.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/settings/controller/account_settings_controller.dart';
import 'package:greenbiller/routes/app_routes.dart';

import 'package:dio/dio.dart' as dio;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PurchaseItem {
  final TextEditingController item = TextEditingController();
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
  final RxList<String> serials = <String>[].obs; // List for serial numbers
  String? itemId;
  String? taxName;

  PurchaseItem() {
    qty.addListener(_calculateAmount);
    pricePerUnit.addListener(_calculateAmount);
    discountPercent.addListener(_calculateDiscount);
    discountAmount.addListener(_calculateTax);
    taxPercent.addListener(_calculateTax);
    serials.listen((_) => _updateQuantityFromSerials());
  }

  void _calculateAmount() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double total = quantity * price;
    purchasePrice.text = total.toStringAsFixed(2);
    _calculateDiscount();
  }

  void _calculateDiscount() {
    double quantity = double.tryParse(qty.text) ?? 0.0;
    double price = double.tryParse(pricePerUnit.text) ?? 0.0;
    double discountPerc = double.tryParse(discountPercent.text) ?? 0.0;
    double subtotal = quantity * price;
    double discountAmt = (subtotal * discountPerc) / 100;
    discountAmount.text = discountAmt.toStringAsFixed(2);
    _calculateTax();
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

  void _updateQuantityFromSerials() {
    if (serials.isNotEmpty &&
        serials.length > (double.tryParse(qty.text) ?? 0)) {
      qty.text = serials.length.toString();
      _calculateAmount();
    }
  }

  void dispose() {
    item.dispose();
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
  late DioClient dioClient;
  late HiveService hiveService;
  late AuthController authController;
  late CommonApiFunctionsController commonApi;
  final Rx<Uint8List?> appLogoBytes = Rx<Uint8List?>(null);
  late AccountController accountController;
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
  final RxString selectedAccountId = ''.obs;
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
  final RxList<dynamic> actualStoreData = <dynamic>[].obs;
  final RxMap<String, String> warehouseMap = <String, String>{}.obs;
  final RxMap<String, String> supplierMap = <String, String>{}.obs;
  final RxList<dynamic> actualsupplierData = <dynamic>[].obs;
  final RxList<Map<String, dynamic>> itemsList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> taxList = <Map<String, dynamic>>[].obs;
  final RxString selectedStoreId = ''.obs;
  final RxString selectedWarehouseId = ''.obs;
  final RxString selectedSupplierId = ''.obs;

  final isLoadingSavePrint = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    hiveService = HiveService();
    authController = Get.find<AuthController>();
    accountController = Get.put(AccountController());
    commonApi = Get.find<CommonApiFunctionsController>();

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
    generateBillNumber();
    // Initial API
    _getAppLogo();
    fetchStores();
    fetchTaxes();
    accountController.fetchAccounts();
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

  Future<void> _getAppLogo() async {
    try {
      final response = await dioClient.dio.get<List<int>>(
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
      double qty = double.tryParse(item.qty.text) ?? 0.0;
      double price = double.tryParse(item.pricePerUnit.text) ?? 0.0;
      double itemDiscount = double.tryParse(item.discountAmount.text) ?? 0.0;
      double itemTax = double.tryParse(item.taxAmount.text) ?? 0.0;
      double itemTotal = (qty * price) - itemDiscount + itemTax;

      item.totalAmount.text = itemTotal.toStringAsFixed(2);
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
      actualStoreData.value = response;
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
      actualsupplierData.value = response;
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
      final response = await commonApi.fetchAllItems(storeId);
      if (response.isEmpty) {
        AppSnackbar.show(
          title: 'Error',
          message: 'Please add items first, empty store',
          color: errorColor,
          icon: Icons.error_outline,
        );
        return;
      }
      itemsList.value = response
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (e) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Failed to fetch items: $e',
        color: errorColor,
        icon: Icons.error_outline,
      );
    } finally {
      isLoadingItems.value = false;
    }
  }

  Future<void> fetchTaxes() async {
    isLoadingTaxes.value = true;
    try {
      final response = await dioClient.dio.get(viewTaxUrl);
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
    if (storeName != null && storeMap.containsKey(storeName)) {
      selectedStoreId.value = storeMap[storeName]!;
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
    if (warehouseName != null && warehouseMap.containsKey(warehouseName)) {
      selectedWarehouseId.value = warehouseMap[warehouseName]!;
      warehouseController.text = warehouseName;
    }
  }

  void onSupplierSelected(String? supplierName) {
    if (supplierName != null && supplierMap.containsKey(supplierName)) {
      selectedSupplierId.value = supplierMap[supplierName]!;
      supplierController.text = supplierName;
    }
  }

  void onItemSelected(int index, Map<String, dynamic> item) {
    if (index < items.length) {
      final purchaseItem = items[index];
      purchaseItem.item.text = item['item_name'] ?? '';
      purchaseItem.itemId = item['id'].toString();
      purchaseItem.sku.text = item['SKU'] ?? '';
      purchaseItem.unit.text = item['unit_id'].toString();
      purchaseItem.pricePerUnit.text = (item['Purchase_price'] ?? '0')
          .toString();
      purchaseItem.qty.text = '1';
      purchaseItem.discountPercent.text = (item['Discount'] ?? '0').toString();
      purchaseItem.taxPercent.text = (item['Tax_rate'] ?? '0').toString();
      purchaseItem.taxName = item['Tax_type'] ?? '';
      purchaseItem.serials.clear();
      calculateTotals();
    }
  }

  void onTaxSelected(int index, Map<String, dynamic> tax) {
    if (index < items.length) {
      final purchaseItem = items[index];
      purchaseItem.taxName = tax['tax_name'];
      purchaseItem.taxPercent.text = tax['tax_rate']?.toString() ?? '0';
      calculateTotals();
    }
  }

  bool validateForm() {
    if (selectedStoreId.value.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please select a store',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return false;
    }
    if (selectedSupplierId.value.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please select a supplier',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return false;
    }
    if (selectedWarehouseId.value.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please select a warehouse',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return false;
    }
    if (billNumberController.text.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please enter bill number',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return false;
    }
    if (items.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please add at least one item',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return false;
    }

    for (int i = 0; i < items.length; i++) {
      if (items[i].item.text.isEmpty) {
        AppSnackbar.show(
          title: 'Error',
          message: 'Please enter item name for row ${i + 1}',
          color: errorColor,
          icon: Icons.error_outline,
        );
        return false;
      }
      if (items[i].qty.text.isEmpty ||
          double.tryParse(items[i].qty.text) == 0) {
        AppSnackbar.show(
          title: 'Error',
          message: 'Please enter valid quantity for row ${i + 1}',
          color: errorColor,
          icon: Icons.error_outline,
        );
        return false;
      }
      if (items[i].pricePerUnit.text.isEmpty ||
          double.tryParse(items[i].pricePerUnit.text) == 0) {
        AppSnackbar.show(
          title: 'Error',
          message: 'Please enter valid price for row ${i + 1}',
          color: errorColor,
          icon: Icons.error_outline,
        );
        return false;
      }
      if (items[i].serials.isNotEmpty &&
          items[i].serials.length != double.tryParse(items[i].qty.text)) {
        AppSnackbar.show(
          title: 'Error',
          message:
              'Serial numbers count does not match quantity for row ${i + 1}',
          color: errorColor,
          icon: Icons.error_outline,
        );
        return false;
      }
    }

    if (paymentType.value.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please select a payment type',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return false;
    }

    return true;
  }

  Future<void> savePurchase({
    bool printer = false,
    required BuildContext context,
  }) async {
    if (!validateForm()) return;
    if (selectedAccountId.value.isEmpty) {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please select an account before proceeding.',
        color: errorColor,
        icon: Icons.error_outline,
      );
      return;
    }

    // Preserve items for printing
    final itemsCopy = List<PurchaseItem>.from(items);

    final isLoadingFlag = printer ? isLoadingSavePrint : isLoading;
    isLoadingFlag.value = true;

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
          String batchNo = '0';
          bool ifBatch = item.serials.isNotEmpty;
          if (ifBatch) {
            final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
            final batchPrefix =
                'BAT${timestamp.substring(timestamp.length - 6)}';
            batchNo = '${item.serials.join(',')},$batchPrefix';
          }

          Map<String, dynamic> itemData = {
            'item_id': item.itemId,
            'store_id': selectedStoreId.value,
            'warehouse_id': selectedWarehouseId.value,
            'purchase_id': purchaseId,
            'purchase_qty': item.qty.text,
            'price_per_unit': item.pricePerUnit.text,
            'tax_type': item.taxName,
            'tax_amt': item.taxAmount.text,
            'discount_amt': item.discountAmount.text,
            'total_cost': item.totalAmount.text,
            'unit_total_cost': item.purchasePrice.text,
            'discount_input': item.discountPercent.text,
            'description': item.item.text,
            'if_batch': ifBatch ? 1 : 0,
            'batch_no': batchNo,
            'if_expirydate': false,
            'stock': 0,
            'status': 1,
            'purchase_status': 1,
          };

          await dioClient.dio.post(
            '$baseUrl/purchaseitem-create',
            data: itemData,
          );

          for (var serial in item.serials) {
            Map<String, dynamic> serialData = {
              'store_id': selectedStoreId.value,
              'item_id': item.itemId,
              'serialno': serial,
              'purchase_id': purchaseId,
              'sales_id': 0,
              'purchase_return_id': null,
              'sales_return_id': null,
              'created_by': userId.value,
              'status': 1,
            };

            final serialResponse = await dioClient.dio.post(
              '$baseUrl/items/serialnumber-create',
              data: serialData,
            );

            if (serialResponse.statusCode != 200 &&
                serialResponse.statusCode != 201) {
              throw Exception(
                'Failed to save serial number: ${serialResponse.data['message']}',
              );
            }
          }
        }

        Map<String, dynamic> paymentData = {
          'store_id': int.parse(selectedStoreId.value),
          'purchase_id': int.parse(purchaseId),
          'supplier_id': int.parse(selectedSupplierId.value),
          'payment_date': billDateController.text,
          'payment_type': paymentType.value,
          'payment': paidAmountController.text.isNotEmpty
              ? paidAmountController.text
              : '0',
          'account_id': int.parse(selectedAccountId.value),
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
                    'serial_no': item.serials.join(','),
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
          // logger.e('Failed to save purchase locally: $e');
        }

        Get.snackbar(
          'Success',
          printer
              ? 'Purchase saved and printed successfully!'
              : 'Purchase saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        generateBillNumber();
        // Restore items for printing
        if (printer) {
          items.clear();
          items.addAll(itemsCopy);
          calculateTotals();
          final selectedStore = actualStoreData.firstWhere(
            (store) => store['id'].toString() == selectedStoreId.value,
            orElse: () => {},
          );
          final selectedSupplier = actualsupplierData.toList().firstWhere(
            (supplier) => supplier['id'].toString() == selectedSupplierId.value,
            orElse: () => <String, dynamic>{},
          );

          await printPurchaseBill(context, selectedStore, selectedSupplier);
        }

        clearForm();
      } else {
        _handleErrorResponse(purchaseResponse);
      }
    } catch (e, stack) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
      print(stack);
    } finally {
      isLoadingFlag.value = false;
    }
  }

  void _handleErrorResponse(dio.Response<dynamic> response) {
    String message = 'Something went wrong.';

    final data = response.data is Map<String, dynamic> ? response.data : {};

    if (response.statusCode == 500) {
      message = data['message'] ?? 'Server error. Please try again.';
    } else if (response.statusCode == 422) {
      if (data['errors'] != null) {
        final errors = (data['errors'] as Map<String, dynamic>).values
            .expand((e) => e)
            .join('\n');
        message = errors;
      } else {
        message = data['message'] ?? 'Validation failed.';
      }
    } else if (response.statusCode == 401) {
      message = 'Your session has expired. Please login again.';
      Get.offAllNamed(AppRoutes.login);
    } else {
      message = data['message'] ?? 'Unknown error occurred.';
    }

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  void clearForm() {
    storeController.clear();
    warehouseController.clear();

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
    selectedAccountId.value = '';
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

  Future<pw.Font> loadFont() async {
    final fontData = await rootBundle.load(systemWideFontPath);
    return pw.Font.ttf(fontData);
  }

  Future<void> printPurchaseBill(
    BuildContext context,
    Map<String, dynamic> storeData,
    Map<String, dynamic> supplierData,
  ) async {
    final font = await loadFont();
    final doc = pw.Document();
    final isA4 = storeData['default_printer'] == 'a4';
    final currencySymbol = storeData['currency_symbol'] ?? '₹';

    final user = authController.user.value;
    final isFreeVersion = !SubscriptionUtil.hasValidSubscription(user);

    // Load logo for free version
    final logoImage = isFreeVersion
        ? pw.MemoryImage(
            (await rootBundle.load(fallbackAppurl)).buffer.asUint8List(),
          )
        : null;

    // Create a non-reactive snapshot of items
    final itemsSnapshot = List<PurchaseItem>.from(items);

    String getStoreValue(String key, {String fallback = 'N/A'}) {
      return storeData[key]?.toString() ?? fallback;
    }

    String getSupplierValue(String key, {String fallback = 'N/A'}) {
      return supplierData[key]?.toString() ?? fallback;
    }

    // Free version footer content
    pw.Widget buildFreeVersionFooter() {
      return pw.Column(
        children: [
          if (isA4) ...[
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 10),
          ] else ...[
            pw.SizedBox(height: 5),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 3),
          ],
          if (isFreeVersion) ...[
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                if (logoImage != null)
                  pw.Container(
                    width: isA4 ? 80 : 40,
                    height: isA4 ? 30 : 15,
                    child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                  ),
                pw.Expanded(
                  child: pw.Container(
                    padding: pw.EdgeInsets.only(right: isA4 ? 10 : 5),
                    child: pw.Text(
                      'This bill is generated by greenbiller.in',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: isA4 ? 10 : 6,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                        fontStyle: pw.FontStyle.italic,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ],
          pw.SizedBox(height: isA4 ? 10 : 5),
          pw.Container(
            width: double.infinity,
            child: pw.Text(
              'Thank you for your purchase!',
              style: pw.TextStyle(
                font: font,
                fontSize: isA4 ? 12 : 8,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
          if (isA4) ...[
            pw.SizedBox(height: 10),
            pw.Container(
              width: double.infinity,
              child: pw.Text(
                'Payment is due upon receipt. Please contact us at ${getStoreValue('store_email')} for any inquiries.',
                style: pw.TextStyle(font: font, fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
            ),
            if (isFreeVersion) ...[
              pw.SizedBox(height: 5),
              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  'Upgrade to Pro for custom branding and remove this footer!',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 8,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.italic,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          ],
        ],
      );
    }

    doc.addPage(
      pw.Page(
        pageFormat: isA4 ? PdfPageFormat.a4 : PdfPageFormat.roll80,
        margin: pw.EdgeInsets.all(isA4 ? 40 : 5),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              if (isA4) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          getStoreValue(
                            'store_name',
                            fallback: 'Your Store Name',
                          ),
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          getStoreValue('store_address'),
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          getStoreValue('store_city'),
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          getStoreValue('store_state'),
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          getStoreValue('store_country'),
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          getStoreValue('store_postal_code'),
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Phone: ${getStoreValue('store_phone')}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Email: ${getStoreValue('store_email')}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Tax Number: ${getStoreValue('tax_number')}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Purchase Invoice',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'Bill No: ${billNumberController.text}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Date: ${billDateController.text}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Supplier: ${getSupplierValue('supplier_name', fallback: supplierController.text)}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Owner: ${getStoreValue('owner_name')}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                        pw.Text(
                          'Email: ${getStoreValue('owner_email')}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
              ] else ...[
                pw.Text(
                  getStoreValue(
                    'store_name',
                    fallback: storeController.text.isNotEmpty
                        ? storeController.text
                        : 'Your Store Name',
                  ),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Date: ${billDateController.text}',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  'Supplier: ${getSupplierValue('supplier_name', fallback: supplierController.text)}',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  'Bill No: ${billNumberController.text}',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.SizedBox(height: 5),
              ],
              // Items Title
              pw.Text(
                'Items',
                style: pw.TextStyle(
                  font: font,
                  fontSize: isA4 ? 16 : 7,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: isA4 ? 10 : 2),
              // Itemized Table
              pw.Table(
                border: pw.TableBorder.all(width: isA4 ? 1 : 0.5),
                columnWidths: isA4
                    ? {
                        0: const pw.FixedColumnWidth(30),
                        1: const pw.FlexColumnWidth(3),
                        2: const pw.FixedColumnWidth(60),
                        3: const pw.FixedColumnWidth(50),
                        4: const pw.FixedColumnWidth(60),
                        5: const pw.FixedColumnWidth(60),
                        6: const pw.FixedColumnWidth(60),
                        7: const pw.FixedColumnWidth(80),
                      }
                    : {
                        0: const pw.FixedColumnWidth(12),
                        1: const pw.FixedColumnWidth(60),
                        2: const pw.FixedColumnWidth(25),
                        3: const pw.FixedColumnWidth(18),
                        4: const pw.FixedColumnWidth(25),
                        5: const pw.FixedColumnWidth(20),
                        6: const pw.FixedColumnWidth(20),
                        7: const pw.FixedColumnWidth(30),
                      },
                children: [
                  // Header Row
                  pw.TableRow(
                    children:
                        [
                              '#',
                              'Item',
                              'SKU',
                              'Qty',
                              'Price',
                              'Disc',
                              'Tax',
                              'Total',
                            ]
                            .map(
                              (header) => pw.Padding(
                                padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                                child: pw.Text(
                                  header,
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: isA4 ? 12 : 7,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  // Item Rows
                  ...itemsSnapshot
                      .asMap()
                      .entries
                      .where((entry) => entry.value.item.text.isNotEmpty)
                      .map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                '${index + 1}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                item.item.text.isNotEmpty
                                    ? item.item.text
                                    : 'Unknown Item',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                item.sku.text.isNotEmpty ? item.sku.text : '-',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                item.qty.text.isNotEmpty ? item.qty.text : '0',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                '$currencySymbol${item.pricePerUnit.text.isNotEmpty ? double.parse(item.pricePerUnit.text).toStringAsFixed(2) : '0.00'}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                '$currencySymbol${item.discountAmount.text.isNotEmpty ? double.parse(item.discountAmount.text).toStringAsFixed(2) : '0.00'}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                '$currencySymbol${item.taxAmount.text.isNotEmpty ? double.parse(item.taxAmount.text).toStringAsFixed(2) : '0.00'}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.all(isA4 ? 8 : 2),
                              child: pw.Text(
                                '$currencySymbol${item.totalAmount.text.isNotEmpty ? double.parse(item.totalAmount.text).toStringAsFixed(2) : '0.00'}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: isA4 ? 12 : 7,
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                      .toList(),
                ],
              ),
              pw.SizedBox(height: isA4 ? 20 : 2),
              // Totals
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Subtotal: $currencySymbol${subtotal.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: isA4 ? 12 : 7),
                    ),
                    pw.SizedBox(height: isA4 ? 8 : 2),
                    pw.Text(
                      'Total Tax: $currencySymbol${totalTax.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: isA4 ? 12 : 7),
                    ),
                    pw.SizedBox(height: isA4 ? 8 : 2),
                    pw.Text(
                      'Total Discount: $currencySymbol${totalDiscount.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: isA4 ? 12 : 7),
                    ),
                    pw.SizedBox(height: isA4 ? 8 : 2),
                    pw.Text(
                      'Other Charges: $currencySymbol${otherCharges.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: isA4 ? 12 : 7),
                    ),
                    pw.SizedBox(height: isA4 ? 8 : 2),
                    pw.Text(
                      'Grand Total: $currencySymbol${grandTotal.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: isA4 ? 12 : 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: isA4 ? 8 : 2),
                    pw.Text(
                      'Paid Amount: $currencySymbol${paidAmount.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: isA4 ? 12 : 7),
                    ),
                    pw.SizedBox(height: isA4 ? 8 : 2),
                    pw.Text(
                      'Balance: $currencySymbol${balanceAmount.value.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: font, fontSize: isA4 ? 12 : 7),
                    ),
                  ],
                ),
              ),
              // Footer
              buildFreeVersionFooter(),
            ],
          );
        },
      ),
    );

    // Sanitize bill number to ensure valid file name
    final billNumber = billNumberController.text.isNotEmpty
        ? billNumberController.text.replaceAll(RegExp(r'[^\w\-]'), '_')
        : 'invoice';
    final fileName = 'Bill_$billNumber.pdf';
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: fileName,
      format: isA4 ? PdfPageFormat.a4 : PdfPageFormat.roll80,
    );
  }
}

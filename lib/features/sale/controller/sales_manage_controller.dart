import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/model/credit_note_model.dart';
import 'package:greenbiller/features/sale/model/sales_order_model.dart';
import 'package:greenbiller/features/sale/model/sales_return_model.dart';
import 'package:greenbiller/features/sale/model/sales_view_model.dart';
import 'package:intl/intl.dart';

class SalesManageController extends GetxController {
  // State variables for response data
  final salesData = Rxn<SalesViewModel>();
  final salesReturnData = Rxn<SalesReturnModel>();
  final salesOrderData = Rxn<SalesOrderModel>();
  final salesReturnId = RxnInt();
  final salesOrderId = RxnInt();

  // Credit note state variables
  final selectedDate = Rx<DateTime>(DateTime.now());
  final returnNumber = RxString('');
  final selectedStoreName = RxString('');
  final selectedStoreId = RxString('');
  final selectedCustomerName = RxString('Walk-in Customer');
  final selectedItems = RxList<CreditNoteItem>([]);
  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final invoiceDateController = TextEditingController();
  final invoiceNumberController = TextEditingController();
  final isLoadingCustomers = false.obs;

  // Item selection state variables
  final itemsList = <Map<String, dynamic>>[].obs;
  final filteredItems = <Map<String, dynamic>>[].obs;
  final isLoadingItems = false.obs;
  final selectedItem = Rxn<Item>();
  final selectedUnit = RxString('');
  final selectedTaxType = RxString('Without Tax');
  final selectedTaxRate = 0.0.obs;

  final quantityController = TextEditingController(text: '1');
  final rateController = TextEditingController();

  final searchText = ''.obs;
  final quantityText = '1'.obs;

  // Loading states
  final isLoading = false.obs;
  final isLoadingSalesReturn = false.obs;

  final isLoadingCreateSalesReturn = false.obs;
  final isLoadingCreateSalesItemReturn = false.obs;
  final isLoadingCreateSalesPaymentReturn = false.obs;
  final isLoadingCreateSalesOrder = false.obs;
  final isLoadingCreateSalesOrderItem = false.obs;
  final isLoadingCreateOrderStatus = false.obs;
  final isLoadingCreateStockTransferItem = false.obs;
  final isLoadingCreateStockAdjustmentItem = false.obs;
  final isLoadingStores = false.obs;

  // Error state
  final hasError = false.obs;

  // Authentication

  late final DioClient _dioClient;
  late final AuthController _authController;
  late final CommonApiFunctionsController _commonApi;
  final RxMap<String, String> storeMap = <String, String>{}.obs;
  final RxMap<String, String> customerMap = <String, String>{}.obs;

  //sale Order
  final selectedOrderFilter = 'All'.obs;
  final salesOrderSerchText = ''.obs;
  final isLoadingSalesOrder = false.obs;
  final errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _dioClient = DioClient();
    _commonApi = CommonApiFunctionsController();
    _authController = Get.find<AuthController>();

    invoiceDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.now());
    returnNumber.value = generateReturnNumber();
    fetchSalesData();
    fetchStores();
    fetchSalesReturnData();
    fetchSalesOrderData();
  }

  @override
  void onClose() {
    quantityController.dispose();
    rateController.dispose();
    super.onClose();
  }

  String generateReturnNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final randomString = List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
    return 'RT_ITEM_$randomString';
  }

  double calculateTotal() {
    return selectedItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  Future<void> fetchItems(String storeId) async {
    isLoadingItems.value = true;
    try {
      final response = await _commonApi.fetchAllItems(storeId);
      if (response.isEmpty) {
        Get.snackbar(
          'Error',
          'Please add items first, empty store',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
      itemsList.value = response
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      filteredItems.value = itemsList.value;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch items: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoadingItems.value = false;
    }
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredItems.value = itemsList.value;
    } else {
      filteredItems.value = itemsList.value
          .where(
            (item) => (item['item_name'] as String).toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  List<SaleOrderList> get filteredOrders {
    final data = salesOrderData.value?.data ?? [];

    return data.where((order) {
      // Filter by status
      if (selectedOrderFilter.value != 'All') {
        if (selectedOrderFilter.value == 'Open Orders' &&
            order.orderstatusId != '1') {
          return false;
        }
        if (selectedOrderFilter.value == 'Closed Orders' &&
            order.orderstatusId == '1') {
          return false;
        }
      }

      // Search filter
      if (salesOrderSerchText.value.isNotEmpty) {
        final term = salesOrderSerchText.value.toLowerCase();

        final matchOrderId = order.uniqueOrderId.toLowerCase().contains(term);
        final matchCustomer =
            order.orderAddress?.toLowerCase().contains(term) ?? false;
        final matchItems = order.items.any(
          (i) => i.itemId.toLowerCase().contains(term),
        );

        if (!matchOrderId && !matchCustomer && !matchItems) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void selectItem(Map<String, dynamic> itemMap) {
    final item = Item.fromJson(itemMap);
    selectedItem.value = item;
    selectedTaxType.value = 'Without Tax';
    selectedTaxRate.value = 0.0;
    rateController.text = item.salesPrice.isNotEmpty
        ? double.parse(item.salesPrice).toStringAsFixed(2)
        : '0.00';
    quantityController.text = '1';

    filteredItems.value = itemsList.value;
  }

  void saveItem() {
    if (selectedItem.value == null) {
      Get.snackbar(
        'Error',
        'Please select an item.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (quantityController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a quantity.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (rateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a rate.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final quantity = int.tryParse(quantityController.text) ?? 1;
    final rate = double.tryParse(rateController.text) ?? 0.0;
    if (quantity <= 0) {
      Get.snackbar(
        'Error',
        'Quantity must be greater than zero.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (rate <= 0) {
      Get.snackbar(
        'Error',
        'Rate must be greater than zero.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final creditNoteItem = CreditNoteItem(
      item: selectedItem.value!,
      rate: rate,
      quantity: quantity,
      unit: 'Piece', // Default unit since unit_id is not mapped to a name
      taxRate: selectedTaxRate.value,
      taxType: selectedTaxType.value,
    );

    selectedItems.add(creditNoteItem);
    selectedItem.value = null;
    selectedTaxType.value = 'Without Tax';
    selectedTaxRate.value = 0.0;

    quantityController.text = '1';
    rateController.clear();
    Get.back();
  }

  Future<void> saveCreditNote(BuildContext context) async {
    if (selectedStoreId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a store.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one item.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (invoiceNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an invoice number.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final creditNote = CreditNote(
      returnNumber: returnNumber.value,
      returnDate: selectedDate.value,
      customerName: selectedCustomerName.value,
      phoneNumber: phoneController.text.isNotEmpty
          ? phoneController.text
          : null,
      invoiceDate: invoiceDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(invoiceDateController.text)
          : null,
      invoiceNumber: invoiceNumberController.text.isNotEmpty
          ? invoiceNumberController.text
          : null,
      items: selectedItems.toList(),
      totalAmount: calculateTotal(),
      storeId: selectedStoreId.value,
      customerId: selectedCustomerName.value != 'Walk-in Customer'
          ? customerMap.value[selectedCustomerName.value]
          : null,
    );

    final payload = {
      'store_id': creditNote.storeId,
      'sales_id': creditNote.invoiceNumber,
      'return_code': creditNote.returnNumber,
      'grand_total': creditNote.totalAmount,
      'customer_id': creditNote.customerId ?? '0',
      'return_date': DateFormat('yyyy-MM-dd').format(creditNote.returnDate),
      if (creditNote.phoneNumber != null)
        'phone_number': creditNote.phoneNumber,
      if (creditNote.invoiceDate != null)
        'invoice_date': DateFormat(
          'yyyy-MM-dd',
        ).format(creditNote.invoiceDate!),
    };

    try {
      final returnId = await createSalesReturn(payload);

      for (final item in creditNote.items) {
        await createSalesItemReturn({
          'store_id': creditNote.storeId,
          'sales_id': creditNote.invoiceNumber,
          'return_id': returnId,
          'customer_id': creditNote.customerId ?? '0',
          'item_id': item.item.id,
          'item_name': item.item.itemName,
          'sales_qty': item.quantity,
          'price_per_unit': item.rate,
          'total_cost': item.subtotal,
          'tax_type': item.taxType,
          'tax_rate': item.taxRate,
        });
      }

      await createSalesPaymentReturn({
        'store_id': creditNote.storeId,
        'return_id': returnId,
        'customer_id': creditNote.customerId ?? '0',
        'payment_date': DateFormat('yyyy-MM-dd').format(creditNote.returnDate),
        'payment_type': 'cash',
        'payment': creditNote.totalAmount,
        'account_id': 1,
        'payment_note':
            'Credit note refund for Sales Return #${creditNote.returnNumber}',
      });

      selectedItems.clear();
      selectedStoreId.value = '';
      selectedStoreName.value = '';
      selectedCustomerName.value = 'Walk-in Customer';
      customerNameController.clear();
      phoneController.clear();
      invoiceNumberController.clear();
      invoiceDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now());
      returnNumber.value = generateReturnNumber();

      Get.snackbar(
        'Success',
        'Credit note saved & refund processed successfully!',
        backgroundColor: accentColor,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save credit note: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  Future<void> fetchCustomers(String storeId) async {
    isLoadingCustomers.value = true;
    try {
      final List<dynamic> response = await _commonApi.fetchCustomers(storeId);
      customerMap.value = {
        'Walk-in Customer': '',
        for (var customer in response)
          customer['customer_name']: customer['id'].toString(),
      };
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch customers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  // Fetch sales data
  Future<void> fetchSalesData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await _dioClient.dio.get(viewSalesUrl);
      if (response.statusCode == 200) {
        salesData.value = SalesViewModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch sales data: ${response.statusCode}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to fetch sales data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create sales return
  Future<int> createSalesReturn(Map<String, dynamic> payload) async {
    isLoadingCreateSalesReturn.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/salesreturn-create',
        data: payload,
      );
      if (response.statusCode == 201) {
        salesReturnId.value = response.data['data']['id'] as int;
        return salesReturnId.value!;
      } else {
        throw Exception('Failed to create Sales Return: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create sales return: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoadingCreateSalesReturn.value = false;
    }
  }

  // Create sales item return
  Future<void> createSalesItemReturn(Map<String, dynamic> payload) async {
    isLoadingCreateSalesItemReturn.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/salesitemreturn-create',
        data: payload,
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create Sales Item Return: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create sales item return: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoadingCreateSalesItemReturn.value = false;
    }
  }

  // Create sales payment return
  Future<void> createSalesPaymentReturn(Map<String, dynamic> payload) async {
    isLoadingCreateSalesPaymentReturn.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/salespaymentreturn-create',
        data: payload,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(
          'Failed to create Sales Payment Return: ${response.data}',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create sales payment return: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoadingCreateSalesPaymentReturn.value = false;
    }
  }

  // Fetch sales return data
  Future<void> fetchSalesReturnData() async {
    isLoadingSalesReturn.value = true;
    try {
      final response = await _dioClient.dio.get('$baseUrl/salesreturn-view');
      if (response.statusCode == 200) {
        salesReturnData.value = SalesReturnModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch sales return data: ${response.data}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch sales return data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingSalesReturn.value = false;
    }
  }

  // Fetch sales orders
  Future<void> fetchSalesOrderData() async {
    isLoadingSalesOrder.value = true;
    errorMessage.value = '';
    try {
      final response = await _dioClient.dio.get('$baseUrl/order-view');
      if (response.statusCode == 200) {
        salesOrderData.value = SalesOrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch sales orders: ${response.data}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch sales orders: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingSalesOrder.value = false;
    }
  }

  // Create stock transfer item
  Future<void> createStockTransferItem(Map<String, dynamic> payload) async {
    isLoadingCreateStockTransferItem.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/stocktransferitem-create',
        data: payload,
      );
      if (response.statusCode != 201) {
        throw Exception(
          'Failed to create Stock Transfer Item: ${response.data}',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create stock transfer item: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoadingCreateStockTransferItem.value = false;
    }
  }

  // Create stock adjustment item
  Future<void> createStockAdjustmentItem(Map<String, dynamic> payload) async {
    isLoadingCreateStockAdjustmentItem.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/stockadjustmentitem-create',
        data: payload,
      );
      if (response.statusCode != 201) {
        throw Exception(
          'Failed to create Stock Adjustment Item: ${response.data}',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create stock adjustment item: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoadingCreateStockAdjustmentItem.value = false;
    }
  }
}

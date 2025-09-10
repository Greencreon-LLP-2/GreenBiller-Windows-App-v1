// controllers/sales_order_controller.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/model/sale_order_model.dart';

class SalesOrderController extends GetxController {
  // ----------------- Formatters -----------------
  final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  final dateFormatter = DateFormat('dd MMM yyyy');

  // ----------------- Auth / User -----------------
  final userId = 0.obs;
  final salesOrderId = RxnInt();

  // ----------------- Order State -----------------
  final selectedDate = DateTime.now().obs;
  final selectedDueDate = DateTime.now().add(const Duration(days: 5)).obs;

  final salesOrderNumber = ''.obs;
  final selectedStoreId = ''.obs;
  final selectedStoreName = ''.obs;
  final selectedCustomerName = ''.obs;

  final selectedItems = <SaleOrderModelItem>[].obs;

  // ----------------- Dropdown Data -----------------
  final storeMap = <String, String>{}.obs;
  final warehouseMap = <String, String>{}.obs;
  final customerMap = <String, String>{}.obs;

  // ----------------- Loading States -----------------
  final isLoadingStores = false.obs;
  final isLoadingCustomers = false.obs;
  final isLoadingWarehouses = false.obs;
  final isLoadingItems = false.obs;

  final isLoadingCreateOrder = false.obs;
  final isLoadingCreateOrderItem = false.obs;
  final isLoadingCreateOrderStatus = false.obs;

  // ----------------- Form Controllers -----------------
  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final orderDateController = TextEditingController();
  final orderNumberController = TextEditingController();
  final totalAmountController = TextEditingController();

  // ----------------- Item Management -----------------
  RxString searchText = ''.obs;
  final quantityController = TextEditingController(text: '1');
  final rateController = TextEditingController();

  final selectedItem = Rxn<Item>();
  final selectedUnit = ''.obs;
  final selectedTaxType = 'Without Tax'.obs;
  final selectedTaxRate = 0.0.obs;

  final itemsList = <Map<String, dynamic>>[].obs;
  final filteredItems = <Map<String, dynamic>>[].obs;

  // ----------------- Services -----------------
  late final DioClient _dioClient;
  late final CommonApiFunctionsController _commonApi;
  late final AuthController _authController;
  late final DropdownController storeDropdownController;

  // ----------------- Lifecycle -----------------
  @override
  void onInit() {
    super.onInit();
    _dioClient = DioClient();
    _commonApi = CommonApiFunctionsController();
    _authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();

    userId.value = _authController.user.value?.userId ?? 0;

    _initializeSalesOrder();
  }

  @override
  void onClose() {
    customerNameController.dispose();
    phoneController.dispose();
    orderDateController.dispose();
    orderNumberController.dispose();
    totalAmountController.dispose();

    quantityController.dispose();
    rateController.dispose();
    super.onClose();
  }

  // ----------------- Initialization -----------------
  void _initializeSalesOrder() {
    salesOrderNumber.value = _generateSalesOrderNumber();
    orderDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fetchStores();
  }

  String _generateSalesOrderNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'SO_${List.generate(8, (_) => chars[random.nextInt(chars.length)]).join()}';
  }

  String _generateUniqueOrderId() {
    final now = DateTime.now();
    final rand = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'ORD_${now.year}${now.month}${now.day}_$rand';
  }

  // ----------------- Calculations -----------------
  double calculateTotal() =>
      selectedItems.fold(0, (sum, item) => sum + item.subtotal);

  // ----------------- Store / Customer / Warehouse -----------------
  Future<void> fetchStores() async {
    isLoadingStores.value = true;
    try {
      final response = await _commonApi.fetchStoreList();
      storeMap.value = {
        for (var store in response) store['store_name']: store['id'].toString(),
      };
    } catch (e) {
      _showError('Failed to fetch stores: $e');
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> fetchCustomers(String storeId) async {
    isLoadingCustomers.value = true;
    try {
      final response = await _commonApi.fetchCustomers(storeId);
      customerMap.value = {
        for (var c in response) c['customer_name']: c['id'].toString(),
      };
    } catch (e) {
      _showError('Failed to fetch customers: $e');
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  Future<void> fetchWarehouses(String storeId) async {
    isLoadingWarehouses.value = true;
    try {
      final response = await _commonApi.fetchWarehousesByStoreID(
        int.parse(storeId),
      );
      warehouseMap.value = {
        for (var w in response) w['warehouse_name']: w['id'].toString(),
      };
    } catch (e) {
      _showError('Failed to fetch warehouses: $e');
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  void onStoreSelected(String? storeName) async {
    if (storeName == null || !storeMap.containsKey(storeName)) return;

    selectedStoreName.value = storeName;
    selectedStoreId.value = storeMap[storeName] ?? '';
    selectedCustomerName.value = ''; // no default

    customerNameController.clear();
    await fetchCustomers(selectedStoreId.value);
  }

  void onCustomerSelected(String? customerName) {
    if (customerName == null) return;

    selectedCustomerName.value = customerName;
    customerNameController.text = customerName != 'Walk-in Customer'
        ? customerName
        : '';
  }

  // ----------------- Save Order -----------------
  Future<void> saveSalesOrder() async {
    if (selectedItems.isEmpty) {
      _showError('Please add at least 1 item');
      return;
    }

    final uniqueOrderId = orderNumberController.text.isEmpty
        ? _generateUniqueOrderId()
        : orderNumberController.text;

    final order = SaleOrderModel(
      customerName: selectedCustomerName.value,
      phoneNumber: phoneController.text,
      orderDate: orderDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(orderDateController.text)
          : DateTime.now(),
      orderNumber: uniqueOrderId,
      items: selectedItems,
      totalAmount: calculateTotal(),
      storeId: selectedStoreId.value,
      customerId: selectedCustomerName.value != 'Walk-in Customer'
          ? customerMap[selectedCustomerName.value] ?? ''
          : null,
    );

    try {
      final orderId = await _createSalesOrder({
        'unique_order_id': uniqueOrderId,
        'orderstatus_id': '1',
        'store_id': order.storeId,
        'user_id': userId.value.toString(),
        'customer_id': order.customerId != null
            ? order.customerId.toString()
            : '0',
        'paid_amount': order.totalAmount.toString(),
        'if_sales': '0',
        'sales_id': '0',
        'shipping_address_id': '0',
        'if_redeem': '0',
        'deliveryboy_id': '0',
        'notifi_deliveryboy': '0',
        'sub_total': order.totalAmount.toString(),
        'order_totalamt': order.totalAmount.toString(),
        'payment_mode': 'cash',
      });

      for (final item in order.items) {
        final itemTotal = item.quantity * item.rate;
        final taxAmount = itemTotal * (item.taxRate / 100);

        await _createSalesOrderItem({
          'order_id': orderId.toString(),
          'user_id': userId.value.toString(),
          'store_id': order.storeId,
          'item_id': item.item.id.toString(),
          'selling_price': item.rate.toString(),
          'qty': item.quantity.toString(),
          'tax_rate': item.taxRate.toString(),
          'tax_type': item.taxType,
          'tax_amt': taxAmount.toString(),
          'total_price': (itemTotal + taxAmount).toString(),
          'if_offer': '0',
        });
      }

      Get.snackbar(
        'Success',
        'Sales Order created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearForm();
    
    } catch (e) {
      _showError('Failed to save sales order: $e');
    }
  }

  Future<int> _createSalesOrder(Map<String, dynamic> payload) async {
    isLoadingCreateOrder.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/order-create',
        data: payload,
      );
      if (response.statusCode == 201) {
        salesOrderId.value = response.data['data']['id'] as int;
        return salesOrderId.value!;
      } else {
        throw Exception('Failed: ${response.data}');
      }
    } finally {
      isLoadingCreateOrder.value = false;
    }
  }

  Future<void> _createSalesOrderItem(Map<String, dynamic> payload) async {
    isLoadingCreateOrderItem.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/orderitem-create',
        data: payload,
      );
      if (response.statusCode != 201) {
        throw Exception('Failed: ${response.data}');
      }
    } finally {
      isLoadingCreateOrderItem.value = false;
    }
  }

  Future<void> createOrderStatus(Map<String, dynamic> payload) async {
    isLoadingCreateOrderStatus.value = true;
    try {
      final response = await _dioClient.dio.post(
        '$baseUrl/orderstatus-create',
        data: payload,
      );
      if (response.statusCode != 201) {
        throw Exception('Failed: ${response.data}');
      }
    } finally {
      isLoadingCreateOrderStatus.value = false;
    }
  }

  // ----------------- Items -----------------
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

  void onTaxTypeChanged(String? value) {
    if (value == null) return;
    selectedTaxType.value = value;
    selectedTaxRate.value = value == 'GST'
        ? 18.0
        : value == 'VAT'
        ? 12.5
        : 0.0;
  }

  SaleOrderModelItem? saveSelectedItem() {
    if (selectedItem.value == null) {
      _showError('Please select an item.');
      return null;
    }

    if (quantityController.text.isEmpty) {
      _showError('Please enter a quantity.');
      return null;
    }

    final quantity = int.tryParse(quantityController.text) ?? 1;

    final newItem = SaleOrderModelItem(
      item: selectedItem.value!,
      rate: double.parse(selectedItem.value!.salesPrice),
      quantity: quantity,
      unit: selectedUnit.value,
      taxRate: selectedTaxRate.value,
      taxType: selectedTaxType.value,
    );

    selectedItems.add(newItem);
    clearItemSelection();
    return newItem;
  }

  void clearItemSelection() {
    selectedItem.value = null;
    searchText.value = '';
    quantityController.text = '1';
    rateController.clear();
    selectedTaxType.value = 'Without Tax';
    selectedTaxRate.value = 0.0;
    filteredItems.value = itemsList;
  }

  // ----------------- Utils -----------------
  void clearForm() {
    selectedItems.clear();
    selectedStoreName.value = '';
    selectedStoreId.value = '';
    selectedCustomerName.value = '';
    customerNameController.clear();
    phoneController.clear();
    orderNumberController.clear();
    totalAmountController.clear();
    salesOrderNumber.value = _generateSalesOrderNumber();
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

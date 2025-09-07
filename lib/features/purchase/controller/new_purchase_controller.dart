import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/settings/controller/account_settings_controller.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart' as dio;

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
  late Logger logger;
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
    accountController = Get.put(AccountController());
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
      final response = await commonApi.fetchAllItems(storeId);
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
      if (items[i].serials.isNotEmpty &&
          items[i].serials.length != double.tryParse(items[i].qty.text)) {
        Get.snackbar(
          'Error',
          'Serial numbers count does not match quantity for row ${i + 1}',
        );
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
    if (selectedAccountId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an account before proceeding.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
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
          'payment': paidAmountController.text,
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
          logger.e('Failed to save purchase locally: $e');
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
        _handleErrorResponse(purchaseResponse);
      }
    } on dio.DioException catch (e) {
      if (e.response != null) {
        _handleErrorResponse(e.response!);
      } else {
        Get.snackbar(
          'Error',
          'Network error: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
    selectedAccountId.value='';
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

class SerialNumberModal extends StatelessWidget {
  final PurchaseItem item;
  final VoidCallback onSave;

  SerialNumberModal({required this.item, required this.onSave});

  final TextEditingController serialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.qr_code, color: Colors.green.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Add Serial Numbers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: serialController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Scan or Enter Serial Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.green.shade600,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty && !item.serials.contains(value)) {
                  item.serials.add(value);
                  serialController.clear();
                }
              },
            ),
            const SizedBox(height: 16),
            Obx(
              () => Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: item.serials.isEmpty
                        ? [const Text('No serial numbers added')]
                        : item.serials.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String serial = entry.value;
                            return ListTile(
                              title: Text(serial),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  item.serials.removeAt(idx);
                                },
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    onSave();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

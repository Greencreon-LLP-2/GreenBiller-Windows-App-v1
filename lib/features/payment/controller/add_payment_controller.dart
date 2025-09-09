import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:logger/logger.dart';

class AddPaymentController extends GetxController {
  late final DioClient dioClient;
  late final Logger logger;
  AddPaymentController();

  // ================= CUSTOMER SEARCH & SELECTION =================
  final searchController = TextEditingController();
  final customers = <Map<String, dynamic>>[].obs;
  final selectedCustomer = Rxn<Map<String, dynamic>>();
  final isLoadingCustomers = false.obs;
  final customerSuggestions = <Map<String, dynamic>>[].obs;
  final showSuggestions = false.obs;

  final suppliers = <Map<String, dynamic>>[].obs;
  final selectedSupplier = Rxn<Map<String, dynamic>>();
  final isLoadingSuppliers = false.obs;
  final supplierSuggestions = <Map<String, dynamic>>[].obs;
  final showSupplierSuggestions = false.obs;

  // ================= PAYMENT FIELDS =================
  final saleIdController = TextEditingController();
  final paymentController = TextEditingController();
  final referenceController = TextEditingController();
  final noteController = TextEditingController();
  final paymentType = 'Cash'.obs;
  final selectedDate = DateTime.now().obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    logger = Logger();
    fetchCustomers();
    fetchSuppliers();
    searchController.addListener(onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    saleIdController.dispose();
    paymentController.dispose();
    referenceController.dispose();
    noteController.dispose();
    super.onClose();
  }

  // ================= CUSTOMER METHODS =================
  Future<void> fetchCustomers({String? storeId}) async {
    try {
      isLoadingCustomers.value = true;
      final response = await dioClient.dio.get(
        '$viewCustomerUrl${storeId != null ? '/$storeId' : ''}',
      );
      if (response.data != null && response.data['data'] != null) {
        customers.value = List<Map<String, dynamic>>.from(
          response.data['data'],
        );
      }
    } catch (e) {
      logger.e('Error fetching customers: $e');
      Get.snackbar('Error', 'Failed to load customers');
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  void onSearchChanged() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      customerSuggestions.clear();
      showSuggestions.value = false;
      return;
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      final filtered = customers
          .where(
            (c) => (c['customer_name'] ?? '').toString().toLowerCase().contains(
              query,
            ),
          )
          .toList();
      customerSuggestions.value = filtered;
      showSuggestions.value = filtered.isNotEmpty;
    });
  }

  void selectCustomer(Map<String, dynamic> customer) {
    selectedCustomer.value = customer;
    searchController.text = customer['customer_name'] ?? '';
    showSuggestions.value = false;
  }

  void refreshCustomers() {
    fetchCustomers();
    selectedCustomer.value = null;
    searchController.clear();
  }

  // ================= SUPPLIER METHODS =================
  Future<void> fetchSuppliers({String? storeId}) async {
    try {
      isLoadingSuppliers.value = true;
      final response = await dioClient.dio.get(
        '$viewSupplierUrl${storeId != null ? '/$storeId' : ''}',
      );
      if (response.data != null && response.data['data'] != null) {
        suppliers.value = List<Map<String, dynamic>>.from(
          response.data['data'],
        );
      }
    } catch (e) {
      logger.e('Error fetching suppliers: $e');
      Get.snackbar('Error', 'Failed to load suppliers');
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  void onSupplierSearch(String query) {
    if (query.isEmpty) {
      supplierSuggestions.clear();
      showSupplierSuggestions.value = false;
      return;
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      final filtered = suppliers
          .where(
            (s) => (s['supplier_name'] ?? '').toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
      supplierSuggestions.value = filtered;
      showSupplierSuggestions.value = filtered.isNotEmpty;
    });
  }

  void selectSupplier(Map<String, dynamic> supplier) {
    selectedSupplier.value = supplier;
    showSupplierSuggestions.value = false;
  }

  void refreshSuppliers() {
    fetchSuppliers();
    selectedSupplier.value = null;
  }

  // ================== PAYMENT METHODS ==================
  void pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) selectedDate.value = picked;
  }

  Future<void> savePaymentIn() async {
    if (selectedCustomer.value == null) {
      Get.snackbar('Error', 'Please select a customer first');
      return;
    }

    int? saleId = int.tryParse(saleIdController.text);
    double? payment = double.tryParse(paymentController.text);

    if (saleId == null) {
      Get.snackbar('Error', 'Sale ID must be a number');
      return;
    }
    if (payment == null || payment <= 0) {
      Get.snackbar('Error', 'Enter a valid payment amount');
      return;
    }

    final data = {
      'customer_id': selectedCustomer.value!['id'],
      'sale_id': saleId,
      'payment': payment.toString(),
      'payment_date': selectedDate.value.toIso8601String().split('T')[0],
      'payment_type': paymentType.value,
      'reference_no': referenceController.text.isNotEmpty
          ? referenceController.text
          : null,
      'payment_note': noteController.text.isNotEmpty
          ? noteController.text
          : null,
    };

    await _savePayment('$baseUrl/salespayment-in', data);
  }

  Future<void> savePaymentOut() async {
    if (selectedSupplier.value == null) {
      Get.snackbar('Error', 'Please select a supplier first');
      return;
    }

    double? payment = double.tryParse(paymentController.text);
    if (payment == null || payment <= 0) {
      Get.snackbar('Error', 'Enter a valid payment amount');
      return;
    }

    final supplierDue =
        double.tryParse(
          selectedSupplier.value!['purchase_due']?.toString() ?? '0',
        ) ??
        0;

    if (supplierDue > 0 && payment > supplierDue) {
      Get.snackbar('Error', 'Payment exceeds supplier due of ₹ $supplierDue');
      return;
    }

    final data = {
      'supplier_id': selectedSupplier.value!['id'],
      'payment': payment.toString(),
      'payment_date': selectedDate.value.toIso8601String().split('T')[0],
      'payment_type': paymentType.value,
      'payment_note': noteController.text.isNotEmpty
          ? noteController.text
          : null,
      'purchase_id': saleIdController.text.isNotEmpty
          ? saleIdController.text
          : null,
      'reference_no': referenceController.text.isNotEmpty
          ? referenceController.text
          : null,
    };

    await _savePayment('$baseUrl/purchasepayment-out', data);
  }

  Future<void> _savePayment(String url, Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      final response = await dioClient.dio.post(url, data: data);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['status'] == true) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Payment saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
        // Clear inputs
        saleIdController.clear();
        paymentController.clear();
        referenceController.clear();
        noteController.clear();
        selectedCustomer.value = null;
        selectedSupplier.value = null;
        searchController.clear();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to save payment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      logger.e('Error saving payment: $e');
      Get.snackbar(
        'Error',
        'Failed to save payment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}

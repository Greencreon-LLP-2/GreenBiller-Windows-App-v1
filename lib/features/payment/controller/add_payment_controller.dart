import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/parties/models/customer_model.dart';
import 'package:greenbiller/features/parties/models/supplier_model.dart';

class AddPaymentController extends GetxController {
  final DioClient _dioClient = DioClient();
  final TextEditingController searchCustomerController =
      TextEditingController();
  final TextEditingController searchSupplierController =
      TextEditingController();
  final TextEditingController saleIdController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final selectedDate = DateTime.now().obs;
  final paymentType = 'Cash'.obs;
  final isSaving = false.obs;

  final customerList = <CustomerData>[].obs;
  final supplierList = <SupplierData>[].obs;
  final customerSuggestions = <CustomerData>[].obs;
  final supplierSuggestions = <SupplierData>[].obs;
  final selectedCustomer = Rxn<CustomerData>();
  final selectedSupplier = Rxn<SupplierData>();
  final showSuggestions = false.obs;
  final showSupplierSuggestions = false.obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchCustomerController.addListener(onCustomerSearch);
    searchSupplierController.addListener(onSupplierSearch);
    fetchCustomers();
    fetchSuppliers();
  }

  Future<void> fetchCustomers() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final response = await _dioClient.dio.get(viewCustomerUrl);

      if (response.statusCode == 200) {
        final customerModel = CustomerModel.fromJson(response.data);
        if (customerModel.status == 1 && customerModel.data != null) {
          customerSuggestions.assignAll(customerModel.data!);
          customerList.assignAll(customerModel.data!);
          print('Fetched ${customerModel.data!.length} customers');
        } else {
          throw Exception(customerModel.message ?? 'Failed to load customers');
        }
      } else {
        throw Exception('Failed to load customers: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to load customers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching customers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onCustomerSearch() {
    final query = searchCustomerController.text.trim().toLowerCase();

    // If no customers in the list
    if (customerList.isEmpty) {
      Get.snackbar(
        "No Customers Found",
        "Please add customers first",
        snackPosition: SnackPosition.BOTTOM,
      );
      showSuggestions.value = false;
      customerSuggestions.clear();
      return;
    }

    if (query.isEmpty) {
      showSuggestions.value = false;
      customerSuggestions.clear();
      return;
    }

    showSuggestions.value = true;

    final results = customerList
        .where(
          (customer) =>
              (customer.customerName ?? '').toLowerCase().contains(query) ||
              (customer.mobile ?? '').toLowerCase().contains(query),
        )
        .toList();

    customerSuggestions.assignAll(results);
    print('Customer suggestions filtered: ${customerSuggestions.length}');
    for (var c in results) {
      print(
        '➡️ ID: ${c.id}, Name: ${c.customerName}, Mobile: ${c.mobile}, Email: ${c.email}',
      );
    }
  }

  // ------------------ SUPPLIER ------------------
  void onSupplierSearch() {
    final query = searchSupplierController.text.trim().toLowerCase();

    // If no suppliers in the list
    if (supplierList.isEmpty) {
      Get.snackbar(
        "No Suppliers Found",
        "Please add suppliers first",
        snackPosition: SnackPosition.BOTTOM,
      );
      showSupplierSuggestions.value = false;
      supplierSuggestions.clear();
      return;
    }

    if (query.isEmpty) {
      showSupplierSuggestions.value = false;
      supplierSuggestions.clear();
      return;
    }

    showSupplierSuggestions.value = true;

    final results = supplierList
        .where(
          (supplier) =>
              (supplier.supplierName ?? '').toLowerCase().contains(query) ||
              (supplier.mobile ?? '').toLowerCase().contains(query),
        )
        .toList();

    supplierSuggestions.assignAll(results);

    print('Supplier suggestions filtered: ${supplierSuggestions.length}');
    for (var s in results) {
      print(
        '➡️ ID: ${s.id}, Name: ${s.supplierName}, Mobile: ${s.mobile}, Email: ${s.email}',
      );
    }
  }

  Future<void> fetchSuppliers() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final authController = Get.find<AuthController>();
      final accessToken = authController.user.value?.accessToken;
      if (accessToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dioClient.dio.get(
        viewSupplierUrl,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final supplierModel = SupplierModel.fromJson(response.data);
        if (supplierModel.status == 1 && supplierModel.data != null) {
          supplierSuggestions.assignAll(supplierModel.data!);
          supplierList.assignAll(supplierModel.data!);
          print('Fetched ${supplierModel.data!.length} suppliers');
        } else {
          throw Exception(supplierModel.message ?? 'Failed to load suppliers');
        }
      } else {
        throw Exception('Failed to load suppliers: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to load suppliers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching suppliers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCustomer(CustomerData customer) {
    selectedCustomer.value = customer;
    showSuggestions.value = false;
    searchCustomerController.clear();
    print('Selected customer: ${customer.customerName}');
  }

  void selectSupplier(SupplierData supplier) {
    selectedSupplier.value = supplier;
    showSupplierSuggestions.value = false;
    searchSupplierController.clear();
    print('Selected supplier: ${supplier.supplierName}');
  }

  Future<void> refreshCustomers() async {
    await fetchCustomers();
    selectedCustomer.value = null;
    print('Customers refreshed');
  }

  Future<void> refreshSuppliers() async {
    await fetchSuppliers();
    selectedSupplier.value = null;
    print('Suppliers refreshed');
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate.value = picked;
      print('Selected date: $picked');
    }
  }

  Future<void> savePaymentIn() async {
    if (selectedCustomer.value == null) {
      Get.snackbar(
        'Error',
        'Please select a customer',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (saleIdController.text.isEmpty || paymentController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    isSaving.value = true;
    try {
      final response = await _dioClient.dio.post(
        addSalesPaymentInUrl, // Assumed in api_constants.dart
        data: {
          'customer_id': selectedCustomer.value!.id,
          'sale_id': saleIdController.text,
          'payment': paymentController.text,
          'payment_type': paymentType.value,
          'reference_no': referenceController.text,
          'payment_note': noteController.text,
          'payment_date': selectedDate.value.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Payment In saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
     
      } else {
        throw Exception('Failed to save payment: ${response.statusMessage}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save payment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saving payment in: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> savePaymentOut() async {
    if (selectedSupplier.value == null) {
      Get.snackbar(
        'Error',
        'Please select a supplier',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (saleIdController.text.isEmpty || paymentController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    isSaving.value = true;
    try {
      final response = await _dioClient.dio.post(
        addPurcahsePaymentInUrl, // Assumed in api_constants.dart
        data: {
          'supplier_id': selectedSupplier.value!.id,
          'purchase_id': saleIdController.text,
          'payment': paymentController.text,
          'payment_type': paymentType.value,
          'reference_no': referenceController.text,
          'payment_note': noteController.text,
          'payment_date': selectedDate.value.toIso8601String(),
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Payment Out saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
    
      } else {
        throw Exception('Failed to save payment: ${response.statusMessage}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save payment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error saving payment out: $e');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    searchSupplierController.dispose();
    saleIdController.dispose();
    paymentController.dispose();
    referenceController.dispose();
    noteController.dispose();
    super.onClose();
  }
}

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/parties/controller/store_drtopdown_controller.dart';
import 'package:greenbiller/features/parties/models/customer_model.dart';
import 'package:greenbiller/features/parties/models/supplier_model.dart';

class PartiesController extends GetxController {
  final DioClient dioClient = DioClient();
  final HiveService hiveService = HiveService();
  final AuthController authController = Get.find<AuthController>();
  final StoreDropdownController storeDropdownController =
      Get.find<StoreDropdownController>();
  // Reactive Variables for Customers
  final customerSearchController = TextEditingController();
  final customerSearchQuery = ''.obs;
  final customerSelectedFilter = 'All Customers'.obs;
  final selectedCustomerStore = Rx<String?>(null);
  final selectedCustomerStoreId = Rx<int?>(null);
  final isLoadingCustomers = false.obs;
  final customerError = Rx<String?>(null);
  final customerSuccess = Rx<String?>(null);
  final customerModel = Rx<CustomerModel?>(null);
  final customers = <CustomerData>[].obs;
  final filteredCustomers = <CustomerData>[].obs;

  // Reactive Variables for Suppliers
  final supplierSearchController = TextEditingController();
  final supplierSearchQuery = ''.obs;
  final supplierSelectedFilter = 'All Suppliers'.obs;
  final selectedSupplierStore = Rx<String?>(null);

  final isLoadingSuppliers = false.obs;
  final supplierError = Rx<String?>(null);
  final supplierSuccess = Rx<String?>(null);
  final supplierModel = Rx<SupplierModel?>(null);
  final suppliers = <SupplierData>[].obs;
  final filteredSuppliers = <SupplierData>[].obs;

  final RxInt userId = 0.obs;
  // Tab Index
  final currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = authController.user.value?.userId ?? 0;

    // Load initial data
    loadCustomers();
    loadSuppliers();
    // Listen to search and filter changes
    ever(customerSearchQuery, (_) => filterCustomers());
    ever(customerSelectedFilter, (_) => filterCustomers());
    ever(selectedCustomerStoreId, (_) => loadCustomers());
    ever(supplierSearchQuery, (_) => filterSuppliers());
    ever(supplierSelectedFilter, (_) => filterSuppliers());
    ever(storeDropdownController.selectedStoreId, (_) => loadSuppliers());
  }

  @override
  void onClose() {
    customerSearchController.dispose();
    supplierSearchController.dispose();
    super.onClose();
  }

  void refreshCustomers() {
    loadCustomers();
  }

  void refreshSuppliers() {
    loadSuppliers();
  }

  Future<void> loadCustomers() async {
    isLoadingCustomers.value = true;
    customerError.value = null;

    try {
      final response = await dioClient.dio.get(
        viewCustomerUrl,
        queryParameters: selectedCustomerStoreId.value != null
            ? {'store_id': selectedCustomerStoreId.value}
            : null,
      );
      if (response.statusCode == 200) {
        customerModel.value = CustomerModel.fromJson(response.data);
        customers.value = customerModel.value?.data ?? [];
        filterCustomers();
        // Save to Hive
        // await hiveService.saveCustomers(customers.toList());
      }
    } catch (e) {
      customerError.value = e.toString().replaceAll('Exception:', '').trim();
      log('Error loading customers: $e');
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  Future<void> loadSuppliers() async {
    isLoadingSuppliers.value = true;
    supplierError.value = null;

    try {
      final response = await dioClient.dio.get(
        viewSupplierUrl,
        queryParameters: storeDropdownController.selectedStoreId.value != null
            ? {'store_id': storeDropdownController.selectedStoreId.value}
            : null,
      );
      if (response.statusCode == 200) {
        supplierModel.value = SupplierModel.fromJson(response.data);
        suppliers.value = supplierModel.value?.data ?? [];
        filterSuppliers();
        // Save to Hive
        // await hiveService.saveSuppliers(suppliers.toList());
      }
    } catch (e) {
      supplierError.value = e.toString().replaceAll('Exception:', '').trim();
      log('Error loading suppliers: $e');
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  void filterCustomers() {
    final query = customerSearchQuery.value;
    final filter = customerSelectedFilter.value;

    filteredCustomers.value = customers.where((customer) {
      final matchesSearch =
          query.isEmpty ||
          customer.customerName?.toLowerCase().contains(query) == true ||
          customer.mobile?.toLowerCase().contains(query) == true ||
          customer.email?.toLowerCase().contains(query) == true;
      final matchesFilter =
          filter == 'All Customers' ||
          (filter == 'Active Customers' && customer.status == '1') ||
          (filter == 'Inactive Customers' && customer.status != '1');
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void filterSuppliers() {
    final query = supplierSearchQuery.value;
    final filter = supplierSelectedFilter.value;

    filteredSuppliers.value = suppliers.where((supplier) {
      final matchesSearch =
          query.isEmpty ||
          supplier.supplierName?.toLowerCase().contains(query) == true ||
          supplier.mobile?.toLowerCase().contains(query) == true ||
          supplier.email?.toLowerCase().contains(query) == true;
      final matchesFilter =
          filter == 'All Suppliers' ||
          (filter == 'Active Suppliers' && supplier.status == '1') ||
          (filter == 'Inactive Suppliers' && supplier.status != '1');
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void showCustomerFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Filter Customers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(
              context,
              'All Customers',
              customerSelectedFilter,
            ),
            _buildFilterOption(
              context,
              'Active Customers',
              customerSelectedFilter,
            ),
            _buildFilterOption(
              context,
              'Inactive Customers',
              customerSelectedFilter,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void showSupplierFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Filter Suppliers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(
              context,
              'All Suppliers',
              supplierSelectedFilter,
            ),
            _buildFilterOption(
              context,
              'Active Suppliers',
              supplierSelectedFilter,
            ),
            _buildFilterOption(
              context,
              'Inactive Suppliers',
              supplierSelectedFilter,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String option,
    RxString selectedFilter,
  ) {
    final isSelected = selectedFilter.value == option;
    return ListTile(
      title: Text(option),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: accentColor)
          : null,
      onTap: () {
        selectedFilter.value = option;
        Get.back();
      },
    );
  }

  Future<bool> addCustomer(
    BuildContext context,
    String name,
    String phone,
    String email,
    String address,
    String gstin,
  ) async {
    customerError.value = '';
    customerSuccess.value = '';
    try {
      final response = await dioClient.dio.post(
        addCustomerUrl,
        data: {
          'customer_name': name,
          'mobile': phone,
          'email': email,
          'address': address,
          'gstin': gstin,
          'store_id': selectedCustomerStoreId.value,
          'user_id': userId.value,
          "created_by": userId.value,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Customer added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        customerSuccess.value = 'Customer added successfully';

        refreshCustomers();
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to add customer',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        customerError.value = 'Failed to add customer';
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      customerError.value = 'Failed to add customer: $e';
      return false;
    }
  }

  Future<bool> addSupplier(
    BuildContext context,
    String name,
    String phone,
    String email,
    String address,
    String gstin,
    String tax,
    int? storeId,
  ) async {
    supplierError.value = '';
    supplierSuccess.value = '';
    try {
      final response = await dioClient.dio.post(
        addSupplierUrl,
        data: {
          'supplier_name': name,
          'mobile': phone,
          'email': email,
          'address': address,
          'gstin': gstin,
          'tax_number': tax,
          'store_id': storeId,
          'user_id': userId.value,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Supplier added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshSuppliers();
        supplierSuccess.value = 'Supplier added successfully';
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to add supplier',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        supplierError.value =  'Failed to add supplier';
        return false;
      }
    } catch (e) {
      supplierError.value = 'Failed to add supplier: $e';
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> handleSaveCustomerChanges(
    BuildContext context,
    String customerId,
    String name,
    String phone,
    String email,
    String address,
    String gstin,
  ) async {
    try {
      final response = await dioClient.dio.post(
        '$editCustomerUrl/$customerId',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'address': address,
          'gstin': gstin,
          'store_id': selectedCustomerStoreId.value,
        },
      );
      if (response.statusCode == 200 &&
          response.data['message'] == 'Customer updated successfully') {
        Get.snackbar(
          'Success',
          'Customer updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshCustomers();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update customer',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    Get.back();
  }

  Future<void> handleSaveSupplierChanges(
    BuildContext context,
    String supplierId,
    String name,
    String phone,
    String email,
    String address,
    String gstin,
  ) async {
    try {
      final response = await dioClient.dio.put(
        '$editSupplierUrl/$supplierId',
        data: {
          'name': name,
          'phone': phone,
          'email': email,
          'address': address,
          'gstin': gstin,
        },
      );
      if (response.statusCode == 200 &&
          response.data['message'] == 'Supplier updated successfully') {
        Get.snackbar(
          'Success',
          'Supplier updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshSuppliers();
      } else {
        Get.snackbar(
          'Error',
          'Failed to update supplier',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    Get.back();
  }

  Future<void> handleDeleteCustomer(
    BuildContext context,
    String customerId,
  ) async {
    try {
      final response = await dioClient.dio.delete(
        '$deleteCustomerUrl/$customerId',
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Customer deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshCustomers();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete customer',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> handleDeleteSupplier(
    BuildContext context,
    String supplierId,
  ) async {
    try {
      final response = await dioClient.dio.delete(
        '$deleteSupplierUrl/$supplierId',
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Supplier deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        refreshSuppliers();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete supplier',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}

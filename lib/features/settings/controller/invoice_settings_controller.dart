// invoice_settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';

class InvoiceSettingsController extends GetxController {
  final DioClient _dioClient = DioClient();
  final CommonApiFunctionsController commonApi =
      Get.find<CommonApiFunctionsController>();

  // Form controllers
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessEmailController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final taxIdController = TextEditingController();
  final invoicePrefixController = TextEditingController();
  final startingNumberController = TextEditingController();
  final taxRateController = TextEditingController();
  final paymentDetailsController = TextEditingController();
  final invoiceNotesController = TextEditingController();

  // Store related states
  final selectedStore = Rxn<String>();
  final selectedStoreId = Rxn<int>();
  final isLoadingStores = false.obs;
  final storeMap = <String, int>{}.obs;

  // Settings state
  final enableTax = true.obs;
  final showLogo = true.obs;
  final includeNotes = false.obs;
  final autoNumbering = true.obs;
  final sendCopy = false.obs;
  final selectedTemplate = "Template A".obs;

  final isLoading = false.obs;
  final hasChanges = false.obs;
  final hasExistingSettings = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    loadStores();
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessAddressController.dispose();
    businessEmailController.dispose();
    businessPhoneController.dispose();
    taxIdController.dispose();
    invoicePrefixController.dispose();
    startingNumberController.dispose();
    taxRateController.dispose();
    paymentDetailsController.dispose();
    invoiceNotesController.dispose();
    super.onClose();
  }

  void _setupListeners() {
    final controllers = [
      businessNameController,
      businessAddressController,
      businessEmailController,
      businessPhoneController,
      taxIdController,
      invoicePrefixController,
      startingNumberController,
      taxRateController,
      paymentDetailsController,
      invoiceNotesController,
    ];

    for (final controller in controllers) {
      controller.addListener(_markAsChanged);
    }
  }

  void _markAsChanged() {
    hasChanges.value = true;
  }

  Future<void> loadStores() async {
    try {
      isLoadingStores.value = true;
      final stores = await commonApi.fetchStores();

      if (stores.isNotEmpty) {
        storeMap.assignAll(stores);
        selectedStore.value = stores.keys.first;
        selectedStoreId.value = stores.values.first;
        // Load settings for the first store
        await loadSettings(stores.values.first.toString());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load stores: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> onStoreChanged(String? storeName) async {
    if (storeName == null) return;

    selectedStore.value = storeName;
    selectedStoreId.value = storeMap[storeName];

    if (selectedStoreId.value != null) {
      await loadSettings(selectedStoreId.value.toString());
    }
  }

  Future<void> loadSettings(String storeId) async {
    isLoading.value = true;
    try {
      final response = await _dioClient.dio.get(
        '$baseUrl/invoice-view?store_id=$storeId',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 1 &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          // Load first invoice setting
          _populateForm(data['data'][0]);
          hasExistingSettings.value = true;
        } else {
          _loadDefaultValues();
          hasExistingSettings.value = false;
        }
      } else {
        _loadDefaultValues();
        hasExistingSettings.value = false;
      }
    } catch (e) {
      _loadDefaultValues();
      hasExistingSettings.value = false;
      Get.snackbar(
        'Error',
        'Failed to load settings: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _toBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) return value == "1" || value.toLowerCase() == "true";
    if (value is num) return value == 1;
    return defaultValue;
  }

  void _populateForm(Map<String, dynamic> data) {
    businessNameController.text = data['business_name'] ?? '';
    businessAddressController.text =
        data['address'] ?? ''; // fixed key mismatch
    businessEmailController.text = data['email'] ?? '';
    businessPhoneController.text = data['phone'] ?? '';
    taxIdController.text = data['gst_number'] ?? '';
    invoicePrefixController.text = data['prefix'] ?? 'INV-';
    startingNumberController.text = data['start_number']?.toString() ?? '1001';
    taxRateController.text = data['taxrate']?.toString() ?? '18';
    paymentDetailsController.text = data['payment_details'] ?? '';
    invoiceNotesController.text = data['invoice_notes'] ?? '';

    enableTax.value = _toBool(data['enable_tax'], defaultValue: true);
    showLogo.value = _toBool(data['show_logo'], defaultValue: true);
    includeNotes.value = _toBool(data['include_notes']);
    autoNumbering.value = _toBool(
      data['invoice_numbering'],
      defaultValue: true,
    );
    sendCopy.value = _toBool(data['copy_customer']);
    selectedTemplate.value = data['template'] ?? 'Template A';

    hasChanges.value = false;
  }

  void _loadDefaultValues() {
    businessNameController.text = "GreenBiller Solutions";
    businessAddressController.text =
        "123 Business Street, Suite 100\nCity, State 12345";
    businessEmailController.text = "info@greenbiller.com";
    businessPhoneController.text = "+1 (555) 123-4567";
    taxIdController.text = "GST123456789";
    invoicePrefixController.text = "INV-";
    startingNumberController.text = "1001";
    taxRateController.text = "18";
    paymentDetailsController.text =
        "Bank Transfer\nAccount: 1234567890\nIFSC: ABCD0123456\nUPI: business@paytm";
    invoiceNotesController.text = "Thank you for your business!";

    enableTax.value = true;
    showLogo.value = true;
    includeNotes.value = false;
    autoNumbering.value = true;
    sendCopy.value = false;
    selectedTemplate.value = "Template A";

    hasChanges.value = false;
  }

  Future<bool> saveSettings() async {
    if (selectedStoreId.value == null) {
      Get.snackbar('Error', 'Please select a store first');
      return false;
    }

    if (!_validateForm()) return false;

    isLoading.value = true;
    try {
      final settingsData = {
        'business_name': businessNameController.text,
        'business_address': businessAddressController.text,
        'business_email': businessEmailController.text,
        'business_phone': businessPhoneController.text,
        'tax_id': taxIdController.text,
        'invoice_prefix': invoicePrefixController.text,
        'start_number': int.tryParse(startingNumberController.text) ?? 1001,
        'tax_rate': double.tryParse(taxRateController.text) ?? 18.0,
        'payment_details': paymentDetailsController.text,
        'invoice_notes': invoiceNotesController.text,
        'enable_tax': enableTax.value,
        'show_logo': showLogo.value,
        'include_notes': includeNotes.value,
        'auto_numbering': autoNumbering.value,
        'send_copy': sendCopy.value,
        'selected_template': selectedTemplate.value,
        'store_id': selectedStoreId.value,
      };

      // Check if settings already exist
      final existingResponse = await _dioClient.dio.get(
        '$baseUrl/invoice-view?store_id=${selectedStoreId.value}',
      );

      if (existingResponse.statusCode == 200 &&
          existingResponse.data['status'] == 1 &&
          existingResponse.data['data'] is List &&
          existingResponse.data['data'].isNotEmpty) {
        // Update existing settings
        final existingId = existingResponse.data['data'][0]['id'];
        final updateResponse = await _dioClient.dio.put(
          '$baseUrl/invoice-update/$existingId',
          data: settingsData,
        );

        if (updateResponse.statusCode == 200) {
          _showSuccessMessage("Invoice settings updated successfully!");
          hasChanges.value = false;
          hasExistingSettings.value = true;
          return true;
        } else {
          throw Exception('Failed to update invoice settings');
        }
      } else {
        // Create new settings
        final createResponse = await _dioClient.dio.post(
          '$baseUrl/invoice-create',
          data: settingsData,
        );

        if (createResponse.statusCode == 200 ||
            createResponse.statusCode == 201) {
          _showSuccessMessage("Invoice settings created successfully!");
          hasChanges.value = false;
          hasExistingSettings.value = true;
          return true;
        } else {
          throw Exception('Failed to create invoice settings');
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save settings: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  bool _validateForm() {
    if (businessNameController.text.isEmpty) {
      Get.snackbar('Error', 'Business name is required');
      return false;
    }

    if (businessEmailController.text.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(businessEmailController.text)) {
        Get.snackbar('Error', 'Please enter a valid email address');
        return false;
      }
    }

    if (startingNumberController.text.isNotEmpty) {
      final number = int.tryParse(startingNumberController.text);
      if (number == null || number <= 0) {
        Get.snackbar('Error', 'Please enter a valid starting number');
        return false;
      }
    }

    if (enableTax.value && taxRateController.text.isNotEmpty) {
      final rate = double.tryParse(taxRateController.text);
      if (rate == null || rate < 0 || rate > 100) {
        Get.snackbar('Error', 'Tax rate must be between 0 and 100');
        return false;
      }
    }

    return true;
  }

  void resetToDefaults() {
    _loadDefaultValues();
    Get.snackbar(
      'Reset',
      'Settings reset to defaults',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void selectTemplate(String template) {
    selectedTemplate.value = template;
    hasChanges.value = true;
  }

  double calculateTax() {
    if (!enableTax.value || taxRateController.text.isEmpty) return 0.0;
    final rate = double.tryParse(taxRateController.text) ?? 0.0;
    return 2500.0 * rate / 100;
  }

  double calculateTotal() {
    return 2500.0 + calculateTax();
  }
}

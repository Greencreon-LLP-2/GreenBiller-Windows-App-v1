// invoice_settings_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';

class InvoiceSettingsController extends GetxController {
  final DioClient _dioClient = DioClient();

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

  // Settings state
  final enableTax = true.obs;
  final showLogo = true.obs;
  final includeNotes = false.obs;
  final autoNumbering = true.obs;
  final sendCopy = false.obs;
  final selectedTemplate = "Template A".obs;

  final isLoading = false.obs;
  final hasChanges = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    loadSettings();
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
    // Listen to all text controllers for changes
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

  Future<void> loadSettings() async {
    isLoading.value = true;
    try {
      // Replace with your actual API endpoint
      final response = await _dioClient.dio.get(
        '$baseUrl/invoice-settings',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        _populateForm(data);
      } else {
        // Load default values if no settings found
        _loadDefaultValues();
      }
    } catch (e) {
      _loadDefaultValues();
    } finally {
      isLoading.value = false;
    }
  }

  void _populateForm(Map<String, dynamic> data) {
    businessNameController.text = data['business_name'] ?? '';
    businessAddressController.text = data['business_address'] ?? '';
    businessEmailController.text = data['business_email'] ?? '';
    businessPhoneController.text = data['business_phone'] ?? '';
    taxIdController.text = data['tax_id'] ?? '';
    invoicePrefixController.text = data['invoice_prefix'] ?? 'INV-';
    startingNumberController.text = data['starting_number']?.toString() ?? '1001';
    taxRateController.text = data['tax_rate']?.toString() ?? '18';
    paymentDetailsController.text = data['payment_details'] ?? '';
    invoiceNotesController.text = data['invoice_notes'] ?? '';

    enableTax.value = data['enable_tax'] ?? true;
    showLogo.value = data['show_logo'] ?? true;
    includeNotes.value = data['include_notes'] ?? false;
    autoNumbering.value = data['auto_numbering'] ?? true;
    sendCopy.value = data['send_copy'] ?? false;
    selectedTemplate.value = data['selected_template'] ?? 'Template A';

    hasChanges.value = false;
  }

  void _loadDefaultValues() {
    businessNameController.text = "GreenBiller Solutions";
    businessAddressController.text = "123 Business Street, Suite 100\nCity, State 12345";
    businessEmailController.text = "info@greenbiller.com";
    businessPhoneController.text = "+1 (555) 123-4567";
    taxIdController.text = "GST123456789";
    invoicePrefixController.text = "INV-";
    startingNumberController.text = "1001";
    taxRateController.text = "18";
    paymentDetailsController.text = "Bank Transfer\nAccount: 1234567890\nIFSC: ABCD0123456\nUPI: business@paytm";
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
        'starting_number': int.parse(startingNumberController.text),
        'tax_rate': double.parse(taxRateController.text),
        'payment_details': paymentDetailsController.text,
        'invoice_notes': invoiceNotesController.text,
        'enable_tax': enableTax.value,
        'show_logo': showLogo.value,
        'include_notes': includeNotes.value,
        'auto_numbering': autoNumbering.value,
        'send_copy': sendCopy.value,
        'selected_template': selectedTemplate.value,
      };

      final response = await _dioClient.dio.post(
        '$baseUrl/invoice-settings/save',
        data: settingsData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        hasChanges.value = false;
        Get.snackbar(
          'Success',
          'Invoice settings saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        throw Exception('Failed to save settings');
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
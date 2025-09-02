// invoice_settings_service.dart
import 'dart:convert';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class InvoiceSettingsService {
  final String accessToken;
  InvoiceSettingsService(this.accessToken);

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Fetch invoice settings
  Future<Map<String, dynamic>> fetchInvoiceSettings(String storeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoice-view?store_id=$storeId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          // Return the first invoice setting (assuming one per user)
          return data['data'][0];
        }
        return {};
      } else {
        throw Exception(
            'Failed to fetch invoice settings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching invoice settings: $e');
    }
  }

  // Create or update invoice settings
  Future<bool> saveInvoiceSettings(
      Map<String, dynamic> data, String storeId) async {
    try {
      // First, try to fetch existing settings to determine if we need to create or update
      final existingSettings = await fetchInvoiceSettings(storeId);

      if (existingSettings.isNotEmpty && existingSettings['id'] != null) {
        // Update existing settings
        final response = await http.put(
          Uri.parse('$baseUrl/invoice-update/${existingSettings['id']}'),
          headers: _headers,
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          throw Exception(
              'Failed to update invoice settings: ${response.statusCode}');
        }
      } else {
        // Create new settings
        final response = await http.post(
          Uri.parse('$baseUrl/invoice-create'),
          headers: _headers,
          body: json.encode(data),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          return true;
        } else {
          throw Exception(
              'Failed to create invoice settings: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Error saving invoice settings: $e');
    }
  }
}

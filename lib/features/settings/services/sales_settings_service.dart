// lib/services/sales_settings_service.dart
import 'dart:convert';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class SalesSettingsService {
  final String accessToken;
  SalesSettingsService({required this.accessToken});

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get sales settings
  Future<Map<String, dynamic>> getSalesSettings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/salessettings-view'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load sales settings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load sales settings: $e');
    }
  }

  // Create new sales settings
  Future<Map<String, dynamic>> createSalesSettings(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/salessettings-create'),
        headers: _headers,
        body: json.encode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to create sales settings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to create sales settings: $e');
    }
  }

  // Update existing sales settings
  Future<Map<String, dynamic>> updateSalesSettings(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/salessettings-update/$id'),
        headers: _headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to update sales settings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to update sales settings: $e');
    }
  }

  // Get sales settings by ID
  Future<Map<String, dynamic>> getSalesSettingsById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/salessettings-view/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load sales settings: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load sales settings: $e');
    }
  }
}

// --- edit_warehouse_service.dart ---
import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Future<String> editWarehouseService({
  required String warehouseId,
  String? name,
  String? address,
  String? warehouseType,
  String? mobile,
  String? email,
  required String accessToken,
}) async {
  try {
    final Map<String, dynamic> payload = {};
    if (name != null && name.isNotEmpty) payload['warehouse_name'] = name;
    if (address != null && address.isNotEmpty) payload['address'] = address;
    if (warehouseType != null && warehouseType.isNotEmpty) {
      payload['warehouse_type'] = warehouseType;
    }
    if (mobile != null && mobile.isNotEmpty) payload['mobile'] = mobile;
    if (email != null && email.isNotEmpty) payload['email'] = email;

    if (payload.isEmpty) {
      return 'no_changes';
    }

    final response = await http.put(
      Uri.parse('$editWarehouseUrl/$warehouseId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return 'success';
    } else {
      throw Exception('Failed to update warehouse}');
    }
  } catch (e) {
    throw Exception('Error updating warehouse: $e');
  }
}

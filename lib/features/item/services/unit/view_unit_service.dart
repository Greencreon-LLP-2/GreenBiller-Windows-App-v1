import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/item/model/unit/unit_model.dart';
import 'package:http/http.dart' as http;

class ViewUnitService {
  final String accessToken;
  ViewUnitService({required this.accessToken});
  Future<UnitModel> viewUnit() async {
    try {
      final response = await http.get(Uri.parse(viewUnitUrl),
          headers: {'Authorization': 'Bearer $accessToken'});
      log(response.body);
      if (response.statusCode == 200) {
        final unitModel = UnitModel.fromJson(jsonDecode(response.body));
        return unitModel;
      } else {
        return UnitModel(message: response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> deleteUnitSerivce(int unitId) async {
    try {
      final response = await http.delete(Uri.parse("$deleteUnitUrl/$unitId"),
          headers: {'Authorization': 'Bearer $accessToken'});
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<String?> addUnitService(dynamic payload) async {
    try {
      final response = await http.post(
        Uri.parse(createUnitUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      log('AddUnitService response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Assuming backend returns something like { message: "...", status: 1 }
        if (body is Map && body['message'] != null) {
          return body['message'] as String;
        }
        return 'Units Detail Created Successfully';
      } else if (response.statusCode == 422) {
        // Validation error
        final body = jsonDecode(response.body);
        if (body is Map && body['errors'] != null) {
          return (body['errors'] as Map)
              .values
              .expand((e) => (e as List).map((v) => v.toString()))
              .join(', ');
        }
        return body['message'] ?? 'Validation failed';
      } else {
        return 'Failed to add unit: ${response.statusCode}';
      }
    } catch (e) {
      log('AddUnitService exception: $e');
      return 'Error: ${e.toString()}';
    }
  }
}

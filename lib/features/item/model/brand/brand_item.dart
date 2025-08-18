import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart' as ApiEndpoints;
import 'package:green_biller/features/item/services/brand/view_brand_service.dart';
import 'package:http/http.dart' as http;

class BrandItem {
  final int id;
  final String brandName;
  final String storeId;

  BrandItem({
    required this.id,
    required this.brandName,
    required this.storeId,
  });

  factory BrandItem.fromJson(Map<String, dynamic> json) {
    return BrandItem(
      id: json['id'] ?? 0,
      brandName: json['brand_name'] ?? '',
      storeId: json['store_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_name': brandName,
      'store_id': storeId,
    };
  }
}

class ViewBrandController {
  final String accessToken;
  ViewBrandController({required this.accessToken});

  Future<List<BrandItem>> viewBrandController() async {
    try {
      final viewBrandService = ViewBrandService(accessToken: accessToken);
      final brandModel = await viewBrandService.viewBrand();
      final List<BrandItem> brandList = [];

      if (brandModel.data != null) {
        for (var brand in brandModel.data!) {
          if (brand.id != null &&
              brand.brandName != null &&
              brand.storeId != null) {
            brandList.add(BrandItem(
              id: brand.id!,
              brandName: brand.brandName!,
              storeId: brand.storeId!,
            ));
          }
        }
      }
      return brandList;
    } catch (e) {
      print('Error in viewBrandController: $e');
      throw Exception('Failed to load brands: $e');
    }
  }

  Future<List<BrandItem>> viewBrandByIdController(int storeId) async {
    try {
      final viewBrandService = ViewBrandService(accessToken: accessToken);
      final brandModel = await viewBrandService.viewBrandById(storeId);
      final List<BrandItem> brandList = [];

      if (brandModel.data != null) {
        for (var brand in brandModel.data!) {
          if (brand.id != null &&
              brand.brandName != null &&
              brand.storeId != null) {
            brandList.add(BrandItem(
              id: brand.id!,
              brandName: brand.brandName!,
              storeId: brand.storeId!,
            ));
          }
        }
      }

      return brandList;
    } catch (e) {
      print('Error in viewBrandByIdController: $e');
      throw Exception('Failed to load brands by store ID: $e');
    }
  }
}

// Edit Brand Service
Future<Map<String, dynamic>> editBrandService(
    String accessToken, int brandId, String brandName, String storeId) async {
  try {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/brands/$brandId');
    print('PUT request to: $url');
    print('Request body: ${jsonEncode({
          'brand_name': brandName,
          'store_id': storeId,
        })}');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'brand_name': brandName,
        'store_id': storeId,
      }),
    );

    print('Edit Brand Response Status: ${response.statusCode}');
    print('Edit Brand Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'message': responseData['message'] ?? 'Brand updated successfully',
        'data': responseData
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Failed to update brand',
        'error': errorData
      };
    }
  } catch (e) {
    print('Error in editBrandService: $e');
    return {
      'success': false,
      'message': 'Network error occurred',
      'error': e.toString()
    };
  }
}

// Edit Brand Controller
Future<bool> editBrandController(
    String accessToken, int brandId, String brandName, String storeId) async {
  try {
    final response =
        await editBrandService(accessToken, brandId, brandName, storeId);
    return response['success'] ?? false;
  } catch (e) {
    print('Error in editBrandController: $e');
    return false;
  }
}

// Delete Brand Service
Future<Map<String, dynamic>> deleteBrandService(
    String accessToken, int brandId) async {
  try {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/brand-delete/$brandId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Some APIs return 204 (No Content) for successful deletions
      try {
        final responseData =
            response.body.isNotEmpty ? jsonDecode(response.body) : {};
        return {
          'success': true,
          'message': responseData['message'] ?? 'Brand deleted successfully',
          'data': responseData
        };
      } catch (e) {
        // If response body is empty or not JSON, still consider it success
        return {
          'success': true,
          'message': 'Brand deleted successfully',
          'data': {}
        };
      }
    } else {
      try {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to delete brand',
          'error': errorData
        };
      } catch (e) {
        return {
          'success': false,
          'message': 'Failed to delete brand',
          'error': 'HTTP ${response.statusCode}'
        };
      }
    }
  } catch (e) {
    print('Error in deleteBrandService: $e');
    return {
      'success': false,
      'message': 'Network error occurred',
      'error': e.toString()
    };
  }
}

// Delete Brand Controller
Future<bool> deleteBrandController(String accessToken, int brandId) async {
  try {
    final response = await deleteBrandService(accessToken, brandId);
    return response['success'] ?? false;
  } catch (e) {
    print('Error in deleteBrandController: $e');
    return false;
  }
}

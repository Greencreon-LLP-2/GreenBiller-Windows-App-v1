import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/item/model/brand/brand_model.dart';
import 'package:http/http.dart' as http;

class ViewBrandService {
  final String accessToken;
  ViewBrandService({required this.accessToken});

  Future<BrandModel> viewBrand() async {
    try {
      final response = await http.get(Uri.parse(viewBrandUrl), headers: {
        'Authorization': 'Bearer $accessToken',
      });
      if (response.statusCode == 200) {
        return BrandModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BrandModel> viewBrandById(int storeId) async {
    try {
      final response = await http.post(
        Uri.parse(viewBrandUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'store_id': storeId.toString(),
        },
      );
      if (response.statusCode == 200) {
        return BrandModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

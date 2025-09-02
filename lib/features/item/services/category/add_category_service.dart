import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Future<String?> addCategoryService(
    String accessToken, String categoryName, String userId, int? storeId,
    {File? imageFile}) async {
  String categoryCode =
      "CnCd-$userId${DateTime.now().millisecondsSinceEpoch.toString()}";

  try {
    var uri = Uri.parse(addCategoriesUrl);
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $accessToken';

    // Add text fields
    request.fields['category_name'] = categoryName;
    request.fields['category_code'] = categoryCode;
    request.fields['store_id'] = storeId.toString();

    // Add image file if provided, else send empty
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    } else {
      // Send an empty file field if no image is provided
      request.fields['image'] = '';
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = jsonDecode(response.body);

    log("category response ${response.body}");

    if (response.statusCode == 201) {
      return body['message'];
    } else {
      return body['message'];
    }
  } catch (e) {
    log(e.toString());
  }
  return null;
  // TODO: Implement the logic to add a new category
}

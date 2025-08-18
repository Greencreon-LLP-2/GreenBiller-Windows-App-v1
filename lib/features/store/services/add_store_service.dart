import 'dart:developer';
import 'dart:io';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Future<String?> addStoreService(
  String accessToken,
  String userId,
  String slug,
  File? storeImage,
  String storeName,
  String storeWebsite,
  String address,
  String storePhone,
  String storeEmail,
) async {
  try {
    final uri = Uri.parse(addStoreUrl);
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $accessToken';

    // Add text fields
    request.fields.addAll({
      "user_id": userId,
      "store_code": slug,
      "slug": slug,
      "store_name": storeName,
      "store_website": storeWebsite,
      "email": storeEmail,
      "mobile": storePhone,
      "address": address,
    });

    if (storeImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'store_logo', // API expects this field name
        storeImage.path,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      log(response.body);
      return "Store added successfully";
    } else {
      log('Failed: ${response.statusCode} ${response.body}');
      return "Error";
    }
  } catch (e) {
    log("Exception: $e");
    return null;
  }
}

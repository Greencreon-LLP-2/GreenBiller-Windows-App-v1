import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Future<String> addBrandService(
    String accessToken, String brandName, String storeId, String userId) async {
  try {
    final response = await http.post(Uri.parse(addBrandUrl), headers: {
      'Authorization': 'Bearer $accessToken',
    }, body: {
      "store_id": storeId,
      "slug": '',
      "count_id": "1",
      "brand_code": "br-1",
      "brand_name": brandName,
      "brand_image": "",
      "description": "test",
      "status": "1",
      "inapp_view": "1",
      "user_id": userId,
    });
    if (response.statusCode == 201) {
      return "Brand added successfully";
    } else {
      return response.body;
    }
  } catch (e) {
    return e.toString();
  }
}

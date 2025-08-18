import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

Future<int> deleteWareHouseSerivce(
  String accessToken,
  String wareHouseId,
) async {
  String url = "$deleteWarehouseUrl$wareHouseId";

  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    return response.statusCode;
  } catch (e) {
    return 500;
  }
}

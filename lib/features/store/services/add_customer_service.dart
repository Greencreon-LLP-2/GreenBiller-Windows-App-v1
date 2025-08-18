import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class AddCustomerService {
  final String accessToken;
  final int storeId;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String gstin;
  final String userName;

  AddCustomerService({
    required this.accessToken,
    required this.storeId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.gstin,
    required this.userName,
  });

  Future<String> addCustomerService() async {
    try {
      final response = await http.post(
        Uri.parse(addCustomerUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "store_id": storeId.toString(),
          "user_id": userId,
          "customer_name": name,
          "mobile": phone,
          "email": email,
          "gstin": gstin,
          "address": address,
          "created_by": userName,
        },
      );
      if (response.statusCode == 201) {
        return "Customer added successfully";
      } else {
        return response.body;
      }
    } catch (e) {
      return e.toString();
    }
  }
}

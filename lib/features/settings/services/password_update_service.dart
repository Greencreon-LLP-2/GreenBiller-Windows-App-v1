import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class PasswordUpdateService {
  static Future<bool> updatePassword(
      String newPassword, String accessToken) async {
    try {
      final response = await http.post(Uri.parse(passwordResetUrl), headers: {
        'Authorization': 'Bearer $accessToken'
      }, body: {
        'password': newPassword,
        'password_confirmation': newPassword
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

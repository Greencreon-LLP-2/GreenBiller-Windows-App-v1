import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final signInServiceProvider = Provider((ref) => SignInService());

class SignInService {
  final _authService = AuthService();

  Future<int?> signInWithPassword(
      WidgetRef ref, String mobile, String countryCode, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'mobile': mobile,
          'country_code': countryCode,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decodedata = jsonDecode(response.body);

        final userModel = UserModel.fromJson(decodedata);

        // Verify that we have the required data
        if (userModel.accessToken == null) {
          throw Exception('Access token missing from response');
        }

        // Update the provider state
        ref.read(userProvider.notifier).state = userModel;

        // Save user data to persist login
        await _authService.saveUserData(userModel);
        return 1;
      } else {
        const errorMessage =
            'Incorrect username or password. Please try again.';

        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception(' $e');
    }
  }
}

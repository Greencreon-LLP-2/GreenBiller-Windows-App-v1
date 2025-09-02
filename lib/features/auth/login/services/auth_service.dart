import 'dart:convert';

import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKey = 'user_data';

  // Save user data to shared preferences
  Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  // Get user data from shared preferences
  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Clear user data (for logout)
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final userData = await getUserData();
    return userData?.accessToken != null;
  }
}

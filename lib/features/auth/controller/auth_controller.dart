import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart' as ApiConstants;
import 'package:greenbiller/core/dio_client.dart';
import 'package:greenbiller/core/hive_service.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController {
  final DioClient dioClient = DioClient();
  final HiveService hiveService = HiveService();
  final logger = Logger();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final countryCode = '+91'.obs;
  final phoneNumber = ''.obs;
  final otp = ''.obs;
  final countryCodes = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    _loadCountryCodes();
    Future.microtask(() {
      try {
        user.value = hiveService.getUser();
        if (user.value != null && user.value!.accessToken != null) {
          logger.i('User found in Hive, setting auth token');
          dioClient.setAuthToken(user.value!.accessToken!);
          redirectToRoleBasedScreen();
        } else {
          logger.i('No user found or no access token, navigating to login');
          Get.offAllNamed(AppRoutes.login);
        }
      } catch (e, stackTrace) {
        logger.e('Error in onInit: $e', e, stackTrace);
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> _loadCountryCodes() async {
    try {
      final response = await dioClient.dio.get(ApiConstants.countryCodeUrl);

      if (response.statusCode == 200) {
        final data = response.data;
        List<String> codes = [];

        for (var item in data['data']) {
          String? phoneCode;

       
          if (item['mobile_code'] != null &&
              item['mobile_code'].toString().isNotEmpty) {
            phoneCode = item['mobile_code'].toString();
          } else {
            // fallback: check all possible fields
            final possibleFields = [
              'phone_code',
              'dial_code',
              'calling_code',
              'country_code',
              'phonecode',
              'international_code',
              'isd_code',
              'code',
            ];

            for (String field in possibleFields) {
              if (item[field] != null && item[field].toString().isNotEmpty) {
                phoneCode = item[field].toString();
                break;
              }
            }
          }

          if (phoneCode != null) {
            if (!phoneCode.startsWith('+')) {
              phoneCode = '+$phoneCode';
            }
            codes.add(phoneCode);
          }
        }

        if (codes.isNotEmpty) {
          // remove duplicates + sort numerically
          codes = codes.toSet().toList();
          codes.sort((a, b) {
            final aNum = int.tryParse(a.substring(1)) ?? 9999;
            final bNum = int.tryParse(b.substring(1)) ?? 9999;
            return aNum.compareTo(bNum);
          });

          countryCodes.value = codes;
          return;
        }
      }
    } catch (e) {
      logger.w('Failed to load country codes from API: $e');
    }
  }

  Future<void> sendOtp() async {
    try {
      isLoading.value = true;
      final response = await dioClient.dio.post(
        ApiConstants.sendOtpUrl,
        data: {'name': countryCode.value, 'mobile': phoneNumber.value},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP sent successfully',
          backgroundColor: Colors.green,
        );
        Get.toNamed(AppRoutes.otpVerify);
      } else {
        throw Exception('Failed to send OTP: ${response.data}');
      }
    } catch (e, stackTrace) {
      logger.e('Send OTP error: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to send OTP: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;
      final response = await dioClient.dio.post(
        ApiConstants.verifyOtpUrl,
        data: {
          'otp': otp.value,
          'mobile': phoneNumber.value,
          'country_code': countryCode.value,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        logger.i('Verify OTP response: $data');
        final isExistingUser = data['is_existing_user'] == true;
        if (isExistingUser) {
          final userModel = UserModel.fromJson(data);
          user.value = userModel;
          await hiveService.saveUser(userModel);
          dioClient.setAuthToken(userModel.accessToken!);
          Get.snackbar(
            'Success',
            'Login successful',
            backgroundColor: Colors.green,
          );
          redirectToRoleBasedScreen();
        } else {
          Get.snackbar(
            'Success',
            'Please create your account',
            backgroundColor: Colors.green,
          );
          Get.toNamed(AppRoutes.signUp);
        }
      } else {
        throw Exception('Failed to verify OTP: ${response.data['message']}');
      }
    } catch (e, stackTrace) {
      logger.e('Verify OTP error: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'OTP verification failed: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithPassword(String mobile, String password) async {
    try {
      isLoading.value = true;

      final payload = {
        "mobile": mobile.trim(),
        "country_code": countryCode.value.trim(),
        "password": password.trim(),
      };

      logger.i("Login payload: $payload"); // debug

      final response = await dioClient.dio.post(
        ApiConstants.loginUrl,
        data: payload,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      logger.i("Login response: ${response.data}");

      if (response.statusCode == 200 && response.data["status"] == true) {
        final userModel = UserModel.fromJson(response.data);
        if (userModel.accessToken == null) {
          throw Exception("Access token missing in response");
        }

        user.value = userModel;
        await hiveService.saveUser(userModel);
        dioClient.setAuthToken(userModel.accessToken!);

        Get.snackbar(
          "Success",
          "Login successful",
          backgroundColor: Colors.green,
        );
        redirectToRoleBasedScreen();
      } else {
        final message =
            response.data["message"] ?? "Invalid username or password";
        Get.snackbar("Error", message, backgroundColor: Colors.red);
        throw Exception(message);
      }
    } catch (e, stackTrace) {
      logger.e("Login error: $e", e, stackTrace);
      Get.snackbar("Error", "Login failed: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String referralCode,
  }) async {
    try {
      isLoading.value = true;
      final response = await dioClient.dio.post(
        ApiConstants.signUpUrl,
        data: {
          'user_level': '4', // Default to Customer
          'name': name,
          'email': email,
          'country_code': countryCode.value,
          'mobile': phone,
          'password': password,
          'password_confirmation': password,
          'referralCode': referralCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(response.data);
        final userModel = UserModel.fromJson(response.data);
        user.value = userModel;
        await hiveService.saveUser(userModel);
        dioClient.setAuthToken(userModel.accessToken!);
        Get.snackbar(
          'Success',
          'Account created successfully',
          backgroundColor: Colors.green,
        );
        redirectToRoleBasedScreen();
      } else {
        throw Exception('Signup failed: ${response.data['message']}');
      }
    } catch (e, stackTrace) {
      logger.e('Signup error: $e', e, stackTrace);
      Get.snackbar('Error', 'Signup failed: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      user.value = null;
      await hiveService.clearUser();
      dioClient.clearAuthToken();
      Get.offAllNamed(AppRoutes.login);
    } catch (e, stackTrace) {
      logger.e('Logout error: $e', e, stackTrace);
      Get.snackbar('Error', 'Logout failed: $e', backgroundColor: Colors.red);
    }
  }

  void redirectToRoleBasedScreen() {
    try {
      final level = user.value?.userLevel ?? 4;
      logger.i('Navigating based on userLevel: $level');
      switch (level) {
        case 1: // Admin
          Get.offAllNamed(AppRoutes.adminDashboard);
          break;
        case 2: // Manager
          Get.offAllNamed(AppRoutes.managerDashboard);
          break;
        case 3: // Staff
          Get.offAllNamed(AppRoutes.staffDashboard);
          break;
        case 4: // Customer
        default:
          Get.offAllNamed(AppRoutes.customerDashboard);
      }
    } catch (e, stackTrace) {
      logger.e('Navigation error: $e', e, stackTrace);
      Get.offAllNamed(AppRoutes.login);
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart' as ApiConstants;
import 'package:greenbiller/core/app_handler/push_notification_service.dart';
import 'package:greenbiller/core/app_handler/session_service.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';

import 'package:greenbiller/features/auth/model/user_model.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:logger/logger.dart';

class AuthController extends GetxController {
  final DioClient dioClient = DioClient();
  final HiveService hiveService = HiveService();
  final SessionService sessionService = SessionService();
  final logger = Logger();

  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final countryCode = '+91'.obs;
  final phoneNumber = '7012545907'.obs;
  final otp = ''.obs;
  final countryCodes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCountryCodes();
    dioClient.setAuthToken(
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIwMTk3NDQ0OS04NmEwLTcxMjEtODk2NC0yMjUzODNiZmU0MzUiLCJqdGkiOiI3OGIwZDc0NzU2MDZiM2Q3YzNlNTQ1OTMxZDlmMGMzOTFlOTM1Y2ZjZDUxNzZkODdmNjEyZmQwYzg0YWQyNzA3MWFlOTY2ODQwZmY4ZDRlMyIsImlhdCI6MTc1NjcyMDIzMS40NjY5NDYsIm5iZiI6MTc1NjcyMDIzMS40NjY5NTIsImV4cCI6MTc3MjM1ODYzMS40MTMzNDQsInN1YiI6IjYyIiwic2NvcGVzIjpbXX0.ZVMeK8uZKSU9_jbgm39gp2ai6fAarKYV-0Qh9XzGga3_ybnA-z63Q6R3w1MCPKi8k41f-BxYDXMR-uEvvOW-umbPhW0mzB5XeQbskzabIbfVSI-_-anCxzV3Z8KQWY1UAH-_P8X1NvPWGpQALuBQeZ7cwqbFOAhVwCTguwBTdrUp8YxlMldRtje2EzH1q2l-tx68mah-Wgv-Te7LZCNzDSIXH9hMuU5H17l3DoM5KV0Hi5xR8lpD7y3WSjMVhOSmw68kDQinFNzYtEeLGQs3BH5KWuDkJdr-oyB4Jgb6HIN_UzGvcnhwqZ-VQXfj3L6hNjOXPuTEyIq1Ovj81lr6fkdscWX0x6BEY9MpsN_pBPh6DzBRq8_g4wQjg8GcEbt0EDhW7Gh0hzeX5Gb1yiB_QNyD3fqYkSfxVpXdRM2whMoEELYwTtME03ONfeQyDH5UEUyhsn2OvAg27L1v6ZgbwRHCiMagPBS3xRpQ0rEFHHizf3lonIrbBth2bYXpmC0tVoI45v0aOICBuicHNkAFHAcV-dMRDydXRe5kqC1jNfteFmB00CqDla0DhUhEuhyFnn-A6vT62QC2b_sIAmQdeIv4RbAueQ_4oYh798PyK7-1hwFnh37BN67E3bqmqdylyoz1ocHUM0QRVijeui0ucV5yqMzaUxz2_gHdBGAmSI8',
    );
    Future.microtask(() async {
      try {
        logger.i('Ensuring Hive is initialized');
        await hiveService.ensureInitialized();
        logger.i('Checking for stored user in Hive');
        user.value = hiveService.getUser();
        if (user.value != null && user.value!.accessToken != null) {
          logger.i('User found: ${user.value!.toJson()}');
          dioClient.setAuthToken(user.value!.accessToken!);
          final isValid = await _validateToken(user.value!.accessToken!);
          if (isValid) {
            logger.i('Token valid, starting services');
            dioClient.setAuthToken(user.value!.accessToken!);
            sessionService.startSessionCheck(user.value!.accessToken!);
            if (!Platform.isLinux) {
              await Get.find<PushNotificationService>().setUserData(
                user.value!,
              );
            }
            redirectToRoleBasedScreen();
          } else {
            logger.w('Token invalid or server error, checking offline mode');
            if (await _isNetworkError()) {
              logger.i(
                'Offline mode: Proceeding to dashboard without validation',
              );
              sessionService.startSessionCheck(user.value!.accessToken!);
              if (!Platform.isLinux) {
                await Get.find<PushNotificationService>().setUserData(
                  user.value!,
                );
              }
              redirectToRoleBasedScreen();
            } else {
              logger.i('Invalid token, logging out');
              // await logout();
            }
          }
        } else {
          logger.i('No user or token found in Hive, navigating to login');
          Get.offAllNamed(AppRoutes.login);
          // Get.offAllNamed(AppRoutes.usersSettings);
        }
      } catch (e, stackTrace) {
        logger.e('Error in onInit: $e', e, stackTrace);
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<bool> _isNetworkError() async {
    try {
      await dioClient.dio.get(
        'https://www.google.com',
        options: Options(validateStatus: (status) => true),
      );
      return false;
    } catch (e) {
      logger.w('Network unavailable: $e');
      return true;
    }
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.userSessionCheckUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      logger.i(
        'Token validation response: ${response.statusCode}, ${response.data}',
      );
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      logger.e('Token validation failed: $e');
      return false;
    }
  }

  @override
  void onClose() {
    logger.i('Stopping SessionService on controller close');
    sessionService.stopSessionCheck();
    super.onClose();
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
      final msg = _extractErrorMessage(e);
      Get.snackbar('Error', msg, backgroundColor: Colors.red);
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
          logger.i('Saving user to Hive: ${userModel.toJson()}');
          await hiveService.saveUser(userModel);
          final savedUser = hiveService.getUser();
          logger.i('Verified saved user: ${savedUser?.toJson() ?? 'null'}');
          dioClient.setAuthToken(userModel.accessToken!);
          sessionService.startSessionCheck(userModel.accessToken!);
          if (!Platform.isLinux) {
            await Get.find<PushNotificationService>().setUserData(userModel);
          }

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
      final msg = _extractErrorMessage(e);
      Get.snackbar('Error', msg, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithPassword(String mobile, String password) async {
    try {
      isLoading.value = true;
      final payload = {
        'mobile': mobile.trim(),
        'country_code': countryCode.value.trim(),
        'password': password.trim(),
      };
      logger.i('Login payload: $payload');
      final response = await dioClient.dio.post(
        ApiConstants.loginUrl,
        data: payload,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      logger.i('Login response: ${response.data}');
      if (response.statusCode == 200 && response.data['status'] == true) {
        final userModel = UserModel.fromJson(response.data);
        if (userModel.accessToken == null) {
          throw Exception('Access token missing in response');
        }
        user.value = userModel;
        logger.i('Saving user to Hive: ${userModel.toJson()}');
        await hiveService.saveUser(userModel);
        final savedUser = hiveService.getUser();
        logger.i('Verified saved user: ${savedUser?.toJson() ?? 'null'}');
        dioClient.setAuthToken(userModel.accessToken!);
        sessionService.startSessionCheck(userModel.accessToken!);
        if (!Platform.isLinux) {
          await Get.find<PushNotificationService>().setUserData(userModel);
        }
        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: Colors.green,
        );
        redirectToRoleBasedScreen();
      } else {
        final message =
            response.data['message'] ?? 'Invalid username or password';
        Get.snackbar('Error', message, backgroundColor: Colors.red);
        throw Exception(message);
      }
    } catch (e, stackTrace) {
      logger.e('Login error: $e', e, stackTrace);
      final msg = _extractErrorMessage(e);
      Get.snackbar('Error', msg, backgroundColor: Colors.red);
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
          'user_level': '4',
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
        final userModel = UserModel.fromJson(response.data);
        user.value = userModel;
        logger.i('Saving user to Hive: ${userModel.toJson()}');
        await hiveService.saveUser(userModel);
        final savedUser = hiveService.getUser();
        logger.i('Verified saved user: ${savedUser?.toJson() ?? 'null'}');
        dioClient.setAuthToken(userModel.accessToken!);
        sessionService.startSessionCheck(userModel.accessToken!);
        if (!Platform.isLinux) {
          await Get.find<PushNotificationService>().setUserData(userModel);
        }
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
      final msg = _extractErrorMessage(e);
      Get.snackbar('Error', msg, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  String _extractErrorMessage(dynamic error) {
    try {
      if (error is DioException) {
        final response = error.response;
        if (response != null && response.data is Map<String, dynamic>) {
          return response.data['message']?.toString() ??
              'Email Already Existing.';
        }
        return error.message ?? 'Network error. Please try again.';
      } else if (error is Map && error['message'] != null) {
        return error['message'].toString();
      } else if (error is String) {
        return error;
      }
      return 'Unexpected error occurred. Please try again.';
    } catch (_) {
      return 'Unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    try {
      user.value = null;
      await hiveService.clearUser();
      sessionService.stopSessionCheck();
      dioClient.clearAuthToken();
      if (!Platform.isLinux) {
        Get.find<PushNotificationService>().removeUserData();
      }
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
        case 4:
          Get.offAllNamed(AppRoutes.adminDashboard);
          break;
        case 2:
          Get.offAllNamed(AppRoutes.managerDashboard);
          break;
        case 3:
          Get.offAllNamed(AppRoutes.staffDashboard);
          break;
        case 1:
        default:
          Get.offAllNamed(AppRoutes.customerDashboard);
      }
    } catch (e, stackTrace) {
      logger.e('Navigation error: $e', e, stackTrace);
      Get.offAllNamed(AppRoutes.login);
    }
  }
}

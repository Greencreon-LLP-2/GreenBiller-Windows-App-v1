import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/entry_point/model/dashboard_model.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

class StoreAdminController extends GetxController {
  final DioClient _dioClient = DioClient();
  final dashboardData = Rxn<DashboardModel>();
  final isLoading = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final authController = Get.find<AuthController>();
      final accessToken = authController.user.value?.accessToken;
      if (accessToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dioClient.dio.get(
        dashboardUrl, // Assumes dashboardUrl is defined in api_constants.dart
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200) {
        final dashboardModel = DashboardModel.fromJson(response.data);
        if (!dashboardModel.success) {
          throw Exception(
            dashboardModel.message ?? 'Failed to load dashboard data',
          );
        }
        dashboardData.value = dashboardModel;
        print('Dashboard data fetched successfully');
      } else {
        throw Exception('Failed to load dashboard: ${response.statusMessage}');
      }
    } catch (e,stack) {
      print(e);
      print(stack);
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:async';
import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/app_status_model.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/routes/app_routes.dart';

class SessionService {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  String? _currentToken;
  bool _isRunning = false;
  final dioClient = DioClient();
  Future<void> startSessionCheck(String token) async {
    if (_isRunning) return;

    _isRunning = true;
    _currentToken = token;
    _receivePort = ReceivePort();

    try {
      _isolate = await Isolate.spawn(_sessionCheckIsolate, {
        'token': token,
        'sendPort': _receivePort!.sendPort,
      });

      _receivePort!.listen((message) {
        if (message is AppStatusModel) {
          _handleStatusUpdate(message);
        }
      });
    } catch (e) {
      _isRunning = false;
      _cleanupResources();
    }
  }

  void _handleStatusUpdate(AppStatusModel newStatus) {
    // 🔹 Case: Unauthorized/session timeout
    if (newStatus.status == 401 || _shouldLogoutUser(newStatus)) {
      _logoutUser();
      if (Get.currentRoute != AppRoutes.maintenance) {
        Get.offAllNamed(
          AppRoutes.maintenance,
          arguments: {
            'body': 'Your session has timed out. Please login again.',
            'showLogin': true, // 🔥 tell UI to show login button
          },
        );
      }
      return;
    }

    // 🔹 Case: Server down / maintenance mode
    if (newStatus.shutdown == true ||
        newStatus.settings?.appMaintenanceMode == true) {
      if (Get.currentRoute != AppRoutes.maintenance) {
        Get.offAllNamed(
          AppRoutes.maintenance,
          arguments: {
            'body': newStatus.message ?? 'Server is under maintenance',
            'showLogin': false,
          },
        );
      }
      return;
    }

    if (newStatus.isLoggedIn == true && newStatus.userExists == true) {
      if (Get.currentRoute == AppRoutes.maintenance) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      }
      return;
    }
  }

  bool _shouldLogoutUser(AppStatusModel newStatus) {
    return newStatus.shutdown == true ||
        newStatus.userBlocked == true ||
        newStatus.isLoggedIn == false ||
        newStatus.userExists == false;
  }

  Future<void> _logoutUser() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e) {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void stopSessionCheck() {
    if (_isRunning) {
      _cleanupResources();
      _isRunning = false;
      _currentToken = null;
    }
  }

  void _cleanupResources() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _isolate = null;
    _receivePort = null;
  }

  void _sessionCheckIsolate(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;

    while (true) {
      try {
        final response = await dioClient.dio.post(userSessionCheckUrl);
        if (response.statusCode == 200) {
          final status = AppStatusModel.fromJson(response.data);
          sendPort.send(status);
        } else if (response.statusCode == 401) {
          // Explicit unauthorized case
          final unauthorizedStatus = AppStatusModel(
            shutdown: false,
            success: false,
            message: 'Unauthorized access. Please login again.',
            isLoggedIn: false,
            userExists: false,
            userBlocked: false,
            user: null,
            settings: null,
            status: 401,
            maintenanceData: _mapErrorToMaintenance(401),
          );
          sendPort.send(unauthorizedStatus);
        } else {
          final maintenanceModel = _mapErrorToMaintenance(
            response.statusCode ?? 500,
          );
          final isMaintenanceCode = [
            500,
            501,
            502,
            503,
          ].contains(response.statusCode);

          final errorStatus = AppStatusModel(
            shutdown: !isMaintenanceCode,
            success: false,
            message: response.data['message']?.toString() ?? 'Unknown error',
            isLoggedIn: isMaintenanceCode,
            userExists: isMaintenanceCode,
            userBlocked: !isMaintenanceCode,
            user: null,
            settings: null,
            status: response.statusCode,
            maintenanceData: maintenanceModel,
          );

          sendPort.send(errorStatus);
        }
      } catch (e) {
        final maintenanceModel = MaintenanceModel(
          code: 0,
          message: 'Network error occurred',
          icon: Icons.wifi_off,
          onTap: () {},
        );

        final errorStatus = AppStatusModel(
          shutdown: true,
          success: false,
          message: 'Network error',
          isLoggedIn: false,
          userExists: false,
          userBlocked: true,
          user: null,
          settings: null,
          status: 0,
          maintenanceData: maintenanceModel,
        );

        sendPort.send(errorStatus);
      }

      await Future.delayed(const Duration(minutes: 1));
    }
  }

  static MaintenanceModel _mapErrorToMaintenance(int code) {
    const maintenanceMessages = {
      503: 'App is under maintenance',
      401: 'Unauthorized access. Please login again.',
      404: 'Oops! The page you\'re looking for doesn\'t exist.',
      302: 'Uh-oh! Our servers are taking a quick break.',
      500: "Our servers took a quick nap. We'll wake them up shortly!",
    };

    const maintenanceIcons = {
      503: Icons.settings_applications_sharp,
      401: Icons.lock,
      404: Icons.delete_forever_rounded,
      302: Icons.wifi_protected_setup_outlined,
      500: Icons.cloud_off,
    };

    return MaintenanceModel(
      code: code,
      message: maintenanceMessages[code] ?? 'Oops! Something went wrong.',
      icon: maintenanceIcons[code] ?? Icons.warning_amber_rounded,
      onTap: () {},
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:dio/dio.dart';

import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/app_status_model.dart';
import 'package:greenbiller/core/dio_client.dart';
import 'package:greenbiller/core/hive_service.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';

import 'package:greenbiller/routes/app_routes.dart';
import 'package:logger/logger.dart';

import 'package:flutter/material.dart';

class SessionService {
  final DioClient dioClient = DioClient();
  final HiveService hiveService = HiveService();
  final logger = Logger();
  Isolate? _isolate;
  ReceivePort? _receivePort;
  String? _currentToken;
  bool _isRunning = false;

  Future<void> startSessionCheck(String token) async {
    if (_isRunning) {
      logger.i('Session check already running');
      return;
    }
    _isRunning = true;
    _currentToken = token;

    // Initialize ReceivePort for Isolate communication
    _receivePort = ReceivePort();
    try {
      _isolate = await Isolate.spawn(_sessionCheckIsolate, {
        'token': token,
        'sendPort': _receivePort!.sendPort,
      });
      logger.i('Session check Isolate started');

      // Listen for messages from the Isolate
      _receivePort!.listen((message) {
        if (message is AppStatusModel) {
          _handleStatusUpdate(message);
        } else if (message is String) {
          logger.e('Session check error: $message');
        }
      });
    } catch (e, stackTrace) {
      _isRunning = false;
      logger.e('Failed to start session check Isolate: $e', e, stackTrace);
    }
  }

  void _handleStatusUpdate(AppStatusModel newStatus) {
    // 🚨 Maintenance/server errors → skip logout
    if (newStatus.maintenanceData != null &&
        (newStatus.status == 500 ||
            newStatus.status == 501 ||
            newStatus.status == 502 ||
            newStatus.status == 503)) {
      logger.w(
        'Server maintenance mode: ${newStatus.maintenanceData?.message}',
      );

      // Show maintenance UI/snackbar
      Get.snackbar(
        'Maintenance',
        newStatus.maintenanceData?.message ?? 'Server under maintenance',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      return; // ✅ don’t call logout
    }

    // 🔑 Only run logout checks for auth/session issues
    if (_shouldLogoutUser(newStatus)) {
      logger.i('Session invalid, logging out user');
      // _logoutUser();
    } else if (_shouldUpdateStatus(newStatus)) {
      logger.i('Session status updated: ${newStatus.message}');
      Get.snackbar(
        'Status Update',
        newStatus.message ?? 'Session status updated',
        backgroundColor: newStatus.success == true ? Colors.green : Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _shouldUpdateStatus(AppStatusModel oldStatus, AppStatusModel newStatus) {
    print("🔍 _shouldUpdateStatus check:");
    print(
      "   old: userExists=${oldStatus.userExists}, "
      "isLoggedIn=${oldStatus.isLoggedIn}, "
      "userBlocked=${oldStatus.userBlocked}, "
      "shutdown=${oldStatus.shutdown}",
    );
    print(
      "   new: userExists=${newStatus.userExists}, "
      "isLoggedIn=${newStatus.isLoggedIn}, "
      "userBlocked=${newStatus.userBlocked}, "
      "shutdown=${newStatus.shutdown}",
    );

    if (oldStatus.shutdown != newStatus.shutdown) {
      print("⚡ Updating: shutdown changed");
      return true;
    }
    if (oldStatus.userBlocked != newStatus.userBlocked) {
      print("⚡ Updating: userBlocked changed");
      return true;
    }
    if (oldStatus.isLoggedIn != newStatus.isLoggedIn) {
      print("⚡ Updating: isLoggedIn changed");
      return true;
    }
    if (oldStatus.userExists != newStatus.userExists) {
      print("⚡ Updating: userExists changed");
      return true;
    }

    print("✅ No update needed");
    return false;
  }

  bool _shouldLogoutUser(AppStatusModel newStatus) {
    print(
      "🔍 _shouldLogoutUser check: "
      "userExists=${newStatus.userExists}, "
      "isLoggedIn=${newStatus.isLoggedIn}, "
      "userBlocked=${newStatus.userBlocked}, "
      "shutdown=${newStatus.shutdown}",
    );

    if (newStatus.shutdown == true) {
      print("❌ Logging out: shutdown=true");
      return true;
    }
    if (newStatus.userBlocked == true) {
      print("❌ Logging out: userBlocked=true");
      return true;
    }
    if (newStatus.isLoggedIn == false) {
      print("❌ Logging out: isLoggedIn=false");
      return true;
    }
    if (newStatus.userExists == false) {
      print("❌ Logging out: userExists=false");
      return true;
    }

    print("✅ No logout needed");
    return false;
  }

  Future<void> _logoutUser() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e, stackTrace) {
      logger.e('Logout error in session service: $e', e, stackTrace);
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void stopSessionCheck() {
    if (_isRunning) {
      _isolate?.kill(priority: Isolate.immediate);
      _receivePort?.close();
      _isRunning = false;
      _currentToken = null;
      logger.i('Session check Isolate stopped');
    }
  }

  static void _sessionCheckIsolate(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final token = params['token'] as String;
    final dio = DioClient();
    final logger = Logger();

    while (true) {
      try {
        final response = await dio.dio.post(
          userSessionCheckUrl,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

        final statusCode = response.statusCode;
        final body = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        if (statusCode == 200) {
          final status = AppStatusModel.fromJson(body);
          sendPort.send(status);
        } else {
          final maintenanceModel = _mapErrorToMaintenance(statusCode ?? 500);

          // ✅ For server/maintenance errors: don’t logout the user
          final isMaintenanceCode = [500, 501, 502, 503].contains(statusCode);

          final errorStatus = AppStatusModel(
            shutdown: !isMaintenanceCode, // 👈 only true if real shutdown
            success: false,
            message: body['message']?.toString() ?? 'Unknown error',
            isLoggedIn: isMaintenanceCode, // 👈 keep logged in
            userExists: isMaintenanceCode, // 👈 keep user valid
            userBlocked: !isMaintenanceCode, // 👈 only block if auth issue
            user: null,
            settings: null,
            status: statusCode,
            maintenanceData: maintenanceModel,
          );

          sendPort.send(errorStatus);
        }
      } catch (e, stackTrace) {
        logger.e('Session check error: $e', e, stackTrace);
        final maintenanceModel = MaintenanceModel(
          code: 0,
          message: 'Network error occurred',
          icon: Icons.wifi_off,
          onTap: () {},
        );
        final errorStatus = AppStatusModel(
          shutdown: true,
          success: false,
          message: e.toString(),
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
      await Future.delayed(const Duration(seconds: 30));
    }
  }

  static MaintenanceModel _mapErrorToMaintenance(int code) {
    return switch (code) {
      503 => MaintenanceModel(
        code: 503,
        message: 'App is under maintenance',
        icon: Icons.settings_applications_sharp,
        onTap: () {},
      ),
      401 => MaintenanceModel(
        code: 401,
        message: 'Unauthorized access. Please login again.',
        icon: Icons.lock,
        onTap: () {},
      ),
      404 => MaintenanceModel(
        code: 404,
        message: 'Oops! The page you\'re looking for doesn\'t exist.',
        icon: Icons.delete_forever_rounded,
        onTap: () {},
      ),
      302 => MaintenanceModel(
        code: 302,
        message: 'Uh-oh! Our servers are taking a quick break.',
        icon: Icons.wifi_protected_setup_outlined,
        onTap: () {},
      ),
      500 => MaintenanceModel(
        code: 500,
        message: "Our servers took a quick nap. We'll wake them up shortly!",
        icon: Icons.cloud_off,
        onTap: () {},
      ),
      _ => MaintenanceModel(
        code: code,
        message: 'Oops! Something went wrong.',
        icon: Icons.warning_amber_rounded,
        onTap: () {},
      ),
    };
  }
}

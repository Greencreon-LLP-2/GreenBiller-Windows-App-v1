import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/app_management/app_status_model.dart';
import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppStatusNotifier extends StateNotifier<AppStatusModel> {
  final Ref ref;
  Timer? _pollingTimer;
  AppStatusModel? _lastEmittedStatus;
  String? _currentToken;

  AppStatusNotifier(this.ref) : super(AppStatusModel.initial());

  void startPolling(String token, String userId) {
    // Cancel existing timer if running
    _pollingTimer?.cancel();

    // Reset tracking variables for new session
    _lastEmittedStatus = null;
    _currentToken = token;

    // Start periodic polling
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _performStatusCheck();
    });

    // Perform immediate first check
    _performStatusCheck();
  }

  Future<void> _performStatusCheck() async {
    if (_currentToken == null) return;

    try {
      final result = await _fetchAppStatus(_currentToken!);
      final int statusCode = result['statusCode'];
      final Map<String, dynamic>? data = result['body'];

      if (statusCode == 200) {
        final newStatus = AppStatusModel.fromJson(data!);
        _handleSuccessfulStatus(newStatus);
        return;
      }

      if (statusCode == 302) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      }
      // Handle error status codes
      _handleErrorStatus(statusCode);
    } catch (e) {
      _handleNetworkError();
    }
  }

  void _handleSuccessfulStatus(AppStatusModel newStatus) {
    // Check if we need to update the state
    if (_shouldUpdateStatus(state, newStatus)) {
      // Check if we need to logout the user
      if (_shouldLogoutUser(newStatus)) {
        _clearUserData();
      }

      // Update the last emitted status and state
      _lastEmittedStatus = newStatus;
      state = newStatus;
    }
  }

  Future<void> _handleErrorStatus(int statusCode) async {
    // Special handling for unauthorized/redirect cases

    final maintenanceModel = _mapErrorToMaintenance(statusCode);
    final updatedStatus = state.copyWith(
      isLoggedIn: false,
      shutdown: true,
      status: 0,
      userBlocked: true,
      success: false,
      userExists: false,
      maintenanceData: maintenanceModel,
    );

    if (_shouldUpdateStatus(state, updatedStatus)) {
      _lastEmittedStatus = updatedStatus;
      state = updatedStatus;
    }
  }

  void _handleNetworkError() {
    final offlineModel = MaintenanceModel(
      code: 0,
      message: 'Looks like something went wrong on our end.',
      icon: Icons.wifi_off,
      onTap: () {},
    );

    final updatedStatus = state.copyWith(
      isLoggedIn: true,
      status: 0,
      userBlocked: true,
      success: false,
      userExists: false,
      shutdown: true,
      maintenanceData: offlineModel,
    );

    if (_shouldUpdateStatus(state, updatedStatus)) {
      _lastEmittedStatus = updatedStatus;
      state = updatedStatus;
    }
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ref.read(userProvider.notifier).state = null;
  }

  bool _shouldUpdateStatus(AppStatusModel oldStatus, AppStatusModel newStatus) {
    // Always update if first time or if critical fields changed
    return _lastEmittedStatus == null ||
        oldStatus.success != newStatus.success ||
        oldStatus.shutdown != newStatus.shutdown ||
        oldStatus.isLoggedIn != newStatus.isLoggedIn ||
        oldStatus.userBlocked != newStatus.userBlocked ||
        oldStatus.settings?.appMaintenanceMode !=
            newStatus.settings?.appMaintenanceMode ||
        oldStatus.settings?.appVersion != newStatus.settings?.appVersion;
  }

  bool _shouldLogoutUser(AppStatusModel newStatus) {
    return newStatus.userExists != true ||
        newStatus.isLoggedIn != true ||
        newStatus.userBlocked != false;
  }

  Future<Map<String, dynamic>> _fetchAppStatus(String accessToken) async {
    int responseCode = 500;
    try {
      final response = await http.post(
        Uri.parse(userSessionCheckUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
            'Accept': 'application/json',
        },
      );
      responseCode = response.statusCode;
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      return {
        'statusCode': response.statusCode,
        'body': body,
      };
    } catch (e) {
      return {
        'statusCode': responseCode,
        'body': {'message': e.toString()},
      };
    }
  }

  MaintenanceModel _mapErrorToMaintenance(int code) {
    return switch (code) {
      503 => MaintenanceModel(
          code: 503,
          message: 'App is under maintainance',
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

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _currentToken = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

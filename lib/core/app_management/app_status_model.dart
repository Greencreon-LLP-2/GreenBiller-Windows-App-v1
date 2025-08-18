import 'package:flutter/material.dart';
import 'package:green_biller/core/app_management/app_settings_model.dart';

class AppStatusModel {
  late bool shutdown;
  final bool? success;
  final String? message;
  final bool? isLoggedIn;
  final bool? userExists;
  final bool? userBlocked;
  final UserTempModel? user;
  final AppSettings? settings;
  final int? status;
  final MaintenanceModel? maintenanceData;

  AppStatusModel({
    required this.shutdown,
    required this.success,
    required this.message,
    required this.isLoggedIn,
    required this.userExists,
    required this.userBlocked,
    required this.user,
    required this.settings,
    required this.status,
    this.maintenanceData,
  });
  factory AppStatusModel.fromJson(Map<String, dynamic> json) {
    final appMaintenanceMode =
        json['settings']?['settings']?['app_maintenance_mode'];

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      if (value is num) return value == 1;
      return false;
    }

    return AppStatusModel(
      success: parseBool(json["success"]),
      message: json["message"],
      isLoggedIn: parseBool(json["is_logged_in"]),
      userExists: parseBool(json["user_exists"]),
      userBlocked: parseBool(json["user_blocked"]),
      status: json["status"],
      shutdown: parseBool(appMaintenanceMode),
      settings: AppSettings.fromJson(json['settings']?['settings'] ?? {}),
      user: json['user'] != null ? UserTempModel.fromJson(json['user']) : null,
      maintenanceData: null,
    );
  }

  factory AppStatusModel.initial() {
    return AppStatusModel(
      shutdown: false,
      success: false,
      message: '',
      isLoggedIn: true,
      userExists: true,
      userBlocked: false,
      status: 0,
      settings: AppSettings.initial(),
      user: null,
      maintenanceData: null,
    );
  }

  AppStatusModel copyWith({
    bool? shutdown,
    bool? success,
    String? message,
    bool? isLoggedIn,
    bool? userExists,
    bool? userBlocked,
    UserTempModel? user,
    AppSettings? settings,
    int? status,
    MaintenanceModel? maintenanceData,
  }) {
    return AppStatusModel(
      shutdown: shutdown ?? false,
      success: success ?? this.success,
      message: message ?? this.message,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userExists: userExists ?? this.userExists,
      userBlocked: userBlocked ?? this.userBlocked,
      user: user ?? this.user,
      settings: settings ?? this.settings,
      status: status ?? this.status,
      maintenanceData: maintenanceData ?? this.maintenanceData,
    );
  }
}

class MaintenanceModel {
  final int code;
  final String message;
  final IconData icon;
  final VoidCallback? onTap;

  MaintenanceModel({
    required this.code,
    required this.message,
    required this.icon,
    required this.onTap,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'iconCode': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': icon.fontPackage,
      'onTap': onTap,
    };
  }

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      code: map['code'] ?? 0,
      message: map['message'] ?? '',
      icon: IconData(
        map['iconCode'] ?? Icons.warning.codePoint,
        fontFamily: map['fontFamily'],
        fontPackage: map['fontPackage'],
      ),
      onTap: map['onTap'] ?? () {},
    );
  }
}

class UserTempModel {
  UserTempModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.profileImage,
    required this.status,
  });

  final int? id;
  final dynamic name;
  final dynamic email;
  final String? mobile;
  final String? profileImage;
  final dynamic status;

  factory UserTempModel.fromJson(Map<String, dynamic> json) {
    return UserTempModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobile: json["mobile"],
      profileImage: json["profile_image"],
      status: json["status"],
    );
  }
}

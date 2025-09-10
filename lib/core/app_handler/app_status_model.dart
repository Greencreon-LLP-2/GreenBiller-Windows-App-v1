import 'package:flutter/material.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';

class AppStatusModel {
  final bool shutdown;
  final bool? success;
  final String? message;
  final bool? isLoggedIn;
  final bool? userExists;
  final bool? userBlocked;
  final UserModel? user;
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
    final appMaintenanceMode = json['settings']?['settings']?['app_maintenance_mode'];

    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      if (value is num) return value == 1;
      return false;
    }

    return AppStatusModel(
      success: parseBool(json['success']),
      message: json['message']?.toString(),
      isLoggedIn: parseBool(json['is_logged_in']),
      userExists: parseBool(json['user_exists']),
      userBlocked: parseBool(json['user_blocked']),
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()),
      shutdown: parseBool(appMaintenanceMode),
      settings: json['settings']?['settings'] != null
          ? AppSettings.fromJson(json['settings']['settings'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
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
    UserModel? user,
    AppSettings? settings,
    int? status,
    MaintenanceModel? maintenanceData,
  }) {
    return AppStatusModel(
      shutdown: shutdown ?? this.shutdown,
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
    this.onTap,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'iconCode': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': icon.fontPackage,
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
      onTap: map['onTap'],
    );
  }
}

class AppSettings {
  final int? id;
  final String? siteUrl;
  final String? version;
  final String? appVersion;
  final String? appPackageName;
  final String? iosAppVersion;
  final String? iosPackageId;
  final String? siteTitle;
  final String? siteDescription;
  final String? metaKeyword;
  final String? metaDetails;
  final String? logo;
  final String? minLogo;
  final String? favIcon;
  final String? webLogo;
  final String? appLogo;
  final String? address;
  final String? siteEmail;
  final String? whatsappNo;
  final String? sendgridAPI;
  final String? ifGooglemap;
  final String? ifFirebase;
  final String? firebaseConfig;
  final String? firebaseAPI;
  final String? codStatus;
  final String? ifBankTransfer;
  final String? bankAccount;
  final String? upiId;
  final String? ifRazorpay;
  final String? razoKeyId;
  final String? razoKeySecret;
  final String? ifCcavenue;
  final String? ccavenueTestmode;
  final String? ccavenueMerchantId;
  final String? ccavenueAccessCode;
  final String? ccavenueWorkingKey;
  final String? ifPhonepe;
  final String? phonepeMerchantId;
  final String? phonepeSaltkey;
  final String? phonepeMode;
  final String? ifOnesignal;
  final String? onesignalId;
  final String? onesignalKey;
  final String? smtpHost;
  final String? smtpPort;
  final String? smtpUsername;
  final String? smtpPassword;
  final String? ifTestOtp;
  final String? ifMsg91;
  final String? msg91Apikey;
  final String? ifTextlocal;
  final String? textlocalApikey;
  final String? ifGreensms;
  final String? greensmsAccessToken;
  final String? greensmsAccessTokenKey;
  final String? smsSenderId;
  final String? smsEntityId;
  final String? smsDltId;
  final String? smsMsg;
  final bool? maintenanceMode;
  final bool? appMaintenanceMode;
  final String? deviceIdCheckReg;
  final String? createdAt;
  final String? updatedAt;

  AppSettings({
    this.id,
    this.siteUrl,
    this.version,
    this.appVersion,
    this.appPackageName,
    this.iosAppVersion,
    this.iosPackageId,
    this.siteTitle,
    this.siteDescription,
    this.metaKeyword,
    this.metaDetails,
    this.logo,
    this.minLogo,
    this.favIcon,
    this.webLogo,
    this.appLogo,
    this.address,
    this.siteEmail,
    this.whatsappNo,
    this.sendgridAPI,
    this.ifGooglemap,
    this.ifFirebase,
    this.firebaseConfig,
    this.firebaseAPI,
    this.codStatus,
    this.ifBankTransfer,
    this.bankAccount,
    this.upiId,
    this.ifRazorpay,
    this.razoKeyId,
    this.razoKeySecret,
    this.ifCcavenue,
    this.ccavenueTestmode,
    this.ccavenueMerchantId,
    this.ccavenueAccessCode,
    this.ccavenueWorkingKey,
    this.ifPhonepe,
    this.phonepeMerchantId,
    this.phonepeSaltkey,
    this.phonepeMode,
    this.ifOnesignal,
    this.onesignalId,
    this.onesignalKey,
    this.smtpHost,
    this.smtpPort,
    this.smtpUsername,
    this.smtpPassword,
    this.ifTestOtp,
    this.ifMsg91,
    this.msg91Apikey,
    this.ifTextlocal,
    this.textlocalApikey,
    this.ifGreensms,
    this.greensmsAccessToken,
    this.greensmsAccessTokenKey,
    this.smsSenderId,
    this.smsEntityId,
    this.smsDltId,
    this.smsMsg,
    this.maintenanceMode,
    this.appMaintenanceMode,
    this.deviceIdCheckReg,
    this.createdAt,
    this.updatedAt,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic value) {
      if (value is bool) return value;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      if (value is num) return value == 1;
      return false;
    }

    return AppSettings(
      id: json['id'] as int?,
      siteUrl: json['siteurl']?.toString(),
      version: json['version']?.toString(),
      appVersion: json['app_version']?.toString(),
      appPackageName: json['app_package_name']?.toString(),
      iosAppVersion: json['ios_app_version']?.toString(),
      iosPackageId: json['ios_packageid']?.toString(),
      siteTitle: json['site_title']?.toString(),
      siteDescription: json['site_description']?.toString(),
      metaKeyword: json['meta_keyword']?.toString(),
      metaDetails: json['meta_details']?.toString(),
      logo: json['logo']?.toString(),
      minLogo: json['min_logo']?.toString(),
      favIcon: json['fav_icon']?.toString(),
      webLogo: json['web_logo']?.toString(),
      appLogo: json['app_logo']?.toString(),
      address: json['address']?.toString(),
      siteEmail: json['site_email']?.toString(),
      whatsappNo: json['whatsapp_no']?.toString(),
      sendgridAPI: json['sendgrid_API']?.toString(),
      ifGooglemap: json['if_googlemap']?.toString(),
      ifFirebase: json['if_firebase']?.toString(),
      firebaseConfig: json['firebase_config']?.toString(),
      firebaseAPI: json['firebase_API']?.toString(),
      codStatus: json['cod_status']?.toString(),
      ifBankTransfer: json['if_bank_transfer']?.toString(),
      bankAccount: json['bank_account']?.toString(),
      upiId: json['upi_id']?.toString(),
      ifRazorpay: json['if_razorpay']?.toString(),
      razoKeyId: json['razo_key_id']?.toString(),
      razoKeySecret: json['razo_key_secret']?.toString(),
      ifCcavenue: json['if_ccavenue']?.toString(),
      ccavenueTestmode: json['ccavenue_testmode']?.toString(),
      ccavenueMerchantId: json['ccavenue_merchant_id']?.toString(),
      ccavenueAccessCode: json['ccavenue_access_code']?.toString(),
      ccavenueWorkingKey: json['ccavenue_working_key']?.toString(),
      ifPhonepe: json['if_phonepe']?.toString(),
      phonepeMerchantId: json['phonepe_merchantId']?.toString(),
      phonepeSaltkey: json['phonepe_saltkey']?.toString(),
      phonepeMode: json['phonepe_mode']?.toString(),
      ifOnesignal: json['if_onesignal']?.toString(),
      onesignalId: json['onesignal_id']?.toString(),
      onesignalKey: json['onesignal_key']?.toString(),
      smtpHost: json['smtp_host']?.toString(),
      smtpPort: json['smtp_port']?.toString(),
      smtpUsername: json['smtp_username']?.toString(),
      smtpPassword: json['smtp_password']?.toString(),
      ifTestOtp: json['if_testotp']?.toString(),
      ifMsg91: json['if_msg91']?.toString(),
      msg91Apikey: json['msg91_apikey']?.toString(),
      ifTextlocal: json['if_textlocal']?.toString(),
      textlocalApikey: json['textlocal_apikey']?.toString(),
      ifGreensms: json['if_greensms']?.toString(),
      greensmsAccessToken: json['greensms_accessToken']?.toString(),
      greensmsAccessTokenKey: json['greensms_accessTokenKey']?.toString(),
      smsSenderId: json['sms_senderid']?.toString(),
      smsEntityId: json['sms_entityId']?.toString(),
      smsDltId: json['sms_dltid']?.toString(),
      smsMsg: json['sms_msg']?.toString(),
      maintenanceMode: parseBool(json['maintenance_mode']),
      appMaintenanceMode: parseBool(json['app_maintenance_mode']),
      deviceIdCheckReg: json['device_id_check_reg']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  factory AppSettings.initial() {
    return AppSettings(
      appVersion: '1.0.0',
      maintenanceMode: false,
      appMaintenanceMode: false,
      siteTitle: '',
      siteDescription: '',
      iosAppVersion: '',
    );
  }
}
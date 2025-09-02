bool? parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  if (value is num) return value == 1;
  return null;
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
    return AppSettings(
      id: json['id'] as int?,
      siteUrl: json['siteurl'],
      version: json['version'],
      appVersion: json['app_version'],
      appPackageName: json['app_package_name'],
      iosAppVersion: json['ios_app_version'],
      iosPackageId: json['ios_packageid'],
      siteTitle: json['site_title'],
      siteDescription: json['site_description'],
      metaKeyword: json['meta_keyword'],
      metaDetails: json['meta_details'],
      logo: json['logo'],
      minLogo: json['min_logo'],
      favIcon: json['fav_icon'],
      webLogo: json['web_logo'],
      appLogo: json['app_logo'],
      address: json['address'],
      siteEmail: json['site_email'],
      whatsappNo: json['whatsapp_no'],
      sendgridAPI: json['sendgrid_API'],
      ifGooglemap: json['if_googlemap'],
      ifFirebase: json['if_firebase'],
      firebaseConfig: json['firebase_config'],
      firebaseAPI: json['firebase_API'],
      codStatus: json['cod_status'],
      ifBankTransfer: json['if_bank_transfer'],
      bankAccount: json['bank_account'],
      upiId: json['upi_id'],
      ifRazorpay: json['if_razorpay'],
      razoKeyId: json['razo_key_id'],
      razoKeySecret: json['razo_key_secret'],
      ifCcavenue: json['if_ccavenue'],
      ccavenueTestmode: json['ccavenue_testmode'],
      ccavenueMerchantId: json['ccavenue_merchant_id'],
      ccavenueAccessCode: json['ccavenue_access_code'],
      ccavenueWorkingKey: json['ccavenue_working_key'],
      ifPhonepe: json['if_phonepe'],
      phonepeMerchantId: json['phonepe_merchantId'],
      phonepeSaltkey: json['phonepe_saltkey'],
      phonepeMode: json['phonepe_mode'],
      ifOnesignal: json['if_onesignal'],
      onesignalId: json['onesignal_id'],
      onesignalKey: json['onesignal_key'],
      smtpHost: json['smtp_host'],
      smtpPort: json['smtp_port'],
      smtpUsername: json['smtp_username'],
      smtpPassword: json['smtp_password'],
      ifTestOtp: json['if_testotp'],
      ifMsg91: json['if_msg91'],
      msg91Apikey: json['msg91_apikey'],
      ifTextlocal: json['if_textlocal'],
      textlocalApikey: json['textlocal_apikey'],
      ifGreensms: json['if_greensms'],
      greensmsAccessToken: json['greensms_accessToken'],
      greensmsAccessTokenKey: json['greensms_accessTokenKey'],
      smsSenderId: json['sms_senderid'],
      smsEntityId: json['sms_entityId'],
      smsDltId: json['sms_dltid'],
      smsMsg: json['sms_msg'],
      maintenanceMode: parseBool(json['maintenance_mode']),
      appMaintenanceMode: parseBool(json['app_maintenance_mode']),
      deviceIdCheckReg: json['device_id_check_reg'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'siteurl': siteUrl,
      'version': version,
      'app_version': appVersion,
      'app_package_name': appPackageName,
      'ios_app_version': iosAppVersion,
      'ios_packageid': iosPackageId,
      'site_title': siteTitle,
      'site_description': siteDescription,
      'meta_keyword': metaKeyword,
      'meta_details': metaDetails,
      'logo': logo,
      'min_logo': minLogo,
      'fav_icon': favIcon,
      'web_logo': webLogo,
      'app_logo': appLogo,
      'address': address,
      'site_email': siteEmail,
      'whatsapp_no': whatsappNo,
      'sendgrid_API': sendgridAPI,
      'if_googlemap': ifGooglemap,
      'if_firebase': ifFirebase,
      'firebase_config': firebaseConfig,
      'firebase_API': firebaseAPI,
      'cod_status': codStatus,
      'if_bank_transfer': ifBankTransfer,
      'bank_account': bankAccount,
      'upi_id': upiId,
      'if_razorpay': ifRazorpay,
      'razo_key_id': razoKeyId,
      'razo_key_secret': razoKeySecret,
      'if_ccavenue': ifCcavenue,
      'ccavenue_testmode': ccavenueTestmode,
      'ccavenue_merchant_id': ccavenueMerchantId,
      'ccavenue_access_code': ccavenueAccessCode,
      'ccavenue_working_key': ccavenueWorkingKey,
      'if_phonepe': ifPhonepe,
      'phonepe_merchantId': phonepeMerchantId,
      'phonepe_saltkey': phonepeSaltkey,
      'phonepe_mode': phonepeMode,
      'if_onesignal': ifOnesignal,
      'onesignal_id': onesignalId,
      'onesignal_key': onesignalKey,
      'smtp_host': smtpHost,
      'smtp_port': smtpPort,
      'smtp_username': smtpUsername,
      'smtp_password': smtpPassword,
      'if_testotp': ifTestOtp,
      'if_msg91': ifMsg91,
      'msg91_apikey': msg91Apikey,
      'if_textlocal': ifTextlocal,
      'textlocal_apikey': textlocalApikey,
      'if_greensms': ifGreensms,
      'greensms_accessToken': greensmsAccessToken,
      'greensms_accessTokenKey': greensmsAccessTokenKey,
      'sms_senderid': smsSenderId,
      'sms_entityId': smsEntityId,
      'sms_dltid': smsDltId,
      'sms_msg': smsMsg,
      'maintenance_mode': maintenanceMode,
      'app_maintenance_mode': appMaintenanceMode,
      'device_id_check_reg': deviceIdCheckReg,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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

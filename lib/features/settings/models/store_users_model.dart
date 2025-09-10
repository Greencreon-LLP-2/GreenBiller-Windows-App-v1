class StoreUsersModel {
  final int id;
  final String userLevel;
  final String storeId;
  final String name;
  final String email;
  final String countryCode;
  final String mobile;

  final String? password;
  final String? whatsappNo;
  final String? userCard;
  final String? profileImage;
  final String? dob;
  final String? countId;
  final String? employeeCode;
  final String? warehouseId;
  final String? currentLatitude;
  final String? currentLongitude;
  final String? zone;
  final String? otp;
  final String? expiresAt;
  final String? mobileVerify;
  final String? emailVerify;
  final String? status;
  final String? ban;
  final String? createdBy;
  final String? subcriptionId;
  final String? subcriptionStart;
  final String? subcriptionEnd;
  final String? referralCode;
  final String? licenseKey;
  final String? rememberToken;
  final String? createdAt;
  final String? updatedAt;
  final String? usersLevel;
  final String? storeName;

  StoreUsersModel({
    required this.id,
    required this.userLevel,
    required this.storeId,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.mobile,
    this.password,
    this.whatsappNo,
    this.userCard,
    this.profileImage,
    this.dob,
    this.countId,
    this.employeeCode,
    this.warehouseId,
    this.currentLatitude,
    this.currentLongitude,
    this.zone,
    this.otp,
    this.expiresAt,
    this.mobileVerify,
    this.emailVerify,
    this.status,
    this.ban,
    this.createdBy,
    this.subcriptionId,
    this.subcriptionStart,
    this.subcriptionEnd,
    this.referralCode,
    this.licenseKey,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
    this.usersLevel,
    this.storeName,
  });

  factory StoreUsersModel.fromJson(Map<String, dynamic> json) {
    return StoreUsersModel(
      id: json['id'] ?? 0,
      userLevel: json['user_level']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      password: json['password']?.toString(),
      whatsappNo: json['whatsapp_no']?.toString(),
      userCard: json['user_card']?.toString(),
      profileImage: json['profile_image']?.toString(),
      dob: json['dob']?.toString(),
      countId: json['count_id']?.toString(),
      employeeCode: json['employee_code']?.toString(),
      warehouseId: json['warehouse_id']?.toString(),
      currentLatitude: json['current_latitude']?.toString(),
      currentLongitude: json['current_longitude']?.toString(),
      zone: json['zone']?.toString(),
      otp: json['otp']?.toString(),
      expiresAt: json['expires_at']?.toString(),
      mobileVerify: json['mobile_verify']?.toString(),
      emailVerify: json['email_verify']?.toString(),
      status: json['status']?.toString(),
      ban: json['ban']?.toString(),
      createdBy: json['created_by']?.toString(),
      subcriptionId: json['subcription_id']?.toString(),
      subcriptionStart: json['subcription_start']?.toString(),
      subcriptionEnd: json['subcription_end']?.toString(),
      referralCode: json['referralCode']?.toString(),
      licenseKey: json['license_key']?.toString(),
      rememberToken: json['remember_token']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      usersLevel: json['users_level']?.toString(),
      storeName: json['store_name']?.toString(),
    );
  }
}

class StoreUsersModelsResponse {
  final String message;
  final List<StoreUsersModel> data;
  final int total;
  final int status;

  StoreUsersModelsResponse({
    required this.message,
    required this.data,
    required this.total,
    required this.status,
  });

  factory StoreUsersModelsResponse.fromJson(Map<String, dynamic> json) {
    return StoreUsersModelsResponse(
      message: json['message'],
      data: (json['data'] as List<dynamic>)
          .map((e) => StoreUsersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'],
      status: json['status'],
    );
  }
}

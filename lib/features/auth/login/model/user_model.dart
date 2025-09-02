import 'package:hooks_riverpod/legacy.dart';

class UserModel {
  final bool? status;
  final String? message;
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;
  final User? user;
  final String? redirectTo;
  final bool? isExistingUser;

  const UserModel({
    this.status,
    this.message,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.user,
    this.redirectTo,
    this.isExistingUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json['status'] as bool?,
    message: json['message'] as String?,
    accessToken: json['access_token'] as String?,
    tokenType: json['token_type'] as String?,
    expiresIn: json['expires_in'] as int?,
    user: json['data'] != null ? User.fromJson(json['data']) : null,
    redirectTo: json['redirect_to'] as String?,
    isExistingUser: json['is_existing_user'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'access_token': accessToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
    'data': user?.toJson(),
    'redirect_to': redirectTo,
    'is_existing_user': isExistingUser,
  };

  UserModel copyWith({
    bool? status,
    String? message,
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    User? user,
    String? redirectTo,
    bool? isExistingUser,
  }) {
    return UserModel(
      status: status ?? this.status,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      user: user ?? this.user,
      redirectTo: redirectTo ?? this.redirectTo,
      isExistingUser: isExistingUser ?? this.isExistingUser,
    );
  }
}

class UserLevel {
  final int? id;
  final String? name;
  final int? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserLevel({
    this.id,
    this.name,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLevel.fromJson(Map<String, dynamic> json) => UserLevel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    role: json['role'] as int?,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  UserLevel copyWith({
    int? id,
    String? name,
    int? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class User {
  final int? id;
  final int? userLevelId; // ✅ store role id
  final String? userLevel; // ✅ store role name
  final String? storeId;
  final String? name;
  final String? email;
  final String? countryCode;
  final String? mobile;
  final dynamic whatsappNo;
  final dynamic userCard;
  final dynamic profileImage;
  final dynamic dob;
  final dynamic countId;
  final dynamic employeeCode;
  final dynamic warehouseId;
  final dynamic currentLatitude;
  final dynamic currentLongitude;
  final dynamic zone;
  final dynamic otp;
  final dynamic mobileVerify;
  final dynamic emailVerify;
  final dynamic status;
  final dynamic ban;
  final dynamic createdBy;
  final dynamic subcriptionId;
  final dynamic subscriptionStart;
  final dynamic subscriptionEnd;
  final dynamic referralCode;
  final dynamic licenseKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    this.userLevelId,
    this.userLevel,
    this.storeId,
    this.name,
    this.email,
    this.countryCode,
    this.mobile,
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
    this.mobileVerify,
    this.emailVerify,
    this.status,
    this.ban,
    this.createdBy,
    this.subcriptionId,
    this.subscriptionStart,
    this.subscriptionEnd,
    this.referralCode,
    this.licenseKey,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    userLevelId: (json['users_level']?['id'] as int?) ?? 4,
    userLevel: (json['users_level']?['name'] as String?) ?? 'Store Admin',

    storeId: json['store_id'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    countryCode: json['country_code'] as String?,
    mobile: json['mobile'] as String?,
    whatsappNo: json['whatsapp_no'],
    userCard: json['user_card'],
    profileImage: json['profile_image'],
    dob: json['dob'],
    countId: json['count_id'],
    employeeCode: json['employee_code'],
    warehouseId: json['warehouse_id'],
    currentLatitude: json['current_latitude'],
    currentLongitude: json['current_longitude'],
    zone: json['zone'],
    otp: json['otp'],
    mobileVerify: json['mobile_verify'],
    emailVerify: json['email_verify'],
    status: json['status'],
    ban: json['ban'],
    createdBy: json['created_by'],
    subcriptionId: json['subcription_id'],
    subscriptionStart: json['subcription_start'],
    subscriptionEnd: json['subcription_end'],
    referralCode: json['referralCode'],
    licenseKey: json['license_key'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_level_id': userLevelId, // ✅ serialize id
    'user_level': userLevel, // ✅ serialize name
    'store_id': storeId,
    'name': name,
    'email': email,
    'country_code': countryCode,
    'mobile': mobile,
    'whatsapp_no': whatsappNo,
    'user_card': userCard,
    'profile_image': profileImage,
    'dob': dob,
    'count_id': countId,
    'employee_code': employeeCode,
    'warehouse_id': warehouseId,
    'current_latitude': currentLatitude,
    'current_longitude': currentLongitude,
    'zone': zone,
    'otp': otp,
    'mobile_verify': mobileVerify,
    'email_verify': emailVerify,
    'status': status,
    'ban': ban,
    'created_by': createdBy,
    'subcription_id': subcriptionId,
    'subcription_start': subscriptionStart,
    'subcription_end': subscriptionEnd,
    'referralCode': referralCode,
    'license_key': licenseKey,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  User copyWith({
    int? id,
    int? userLevelId,
    String? userLevel,
    String? storeId,
    String? name,
    String? email,
    String? countryCode,
    String? mobile,
    dynamic whatsappNo,
    dynamic userCard,
    dynamic profileImage,
    dynamic dob,
    dynamic countId,
    dynamic employeeCode,
    dynamic warehouseId,
    dynamic currentLatitude,
    dynamic currentLongitude,
    dynamic zone,
    dynamic otp,
    dynamic mobileVerify,
    dynamic emailVerify,
    dynamic status,
    dynamic ban,
    dynamic createdBy,
    dynamic subcriptionId,
    dynamic subscriptionStart,
    dynamic subscriptionEnd,
    dynamic referralCode,
    dynamic licenseKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      userLevelId: userLevelId ?? this.userLevelId,
      userLevel: userLevel ?? this.userLevel,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      mobile: mobile ?? this.mobile,
      whatsappNo: whatsappNo ?? this.whatsappNo,
      userCard: userCard ?? this.userCard,
      profileImage: profileImage ?? this.profileImage,
      dob: dob ?? this.dob,
      countId: countId ?? this.countId,
      employeeCode: employeeCode ?? this.employeeCode,
      warehouseId: warehouseId ?? this.warehouseId,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      zone: zone ?? this.zone,
      otp: otp ?? this.otp,
      mobileVerify: mobileVerify ?? this.mobileVerify,
      emailVerify: emailVerify ?? this.emailVerify,
      status: status ?? this.status,
      ban: ban ?? this.ban,
      createdBy: createdBy ?? this.createdBy,
      subcriptionId: subcriptionId ?? this.subcriptionId,
      subscriptionStart: subscriptionStart ?? this.subscriptionStart,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      referralCode: referralCode ?? this.referralCode,
      licenseKey: licenseKey ?? this.licenseKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// ✅ Riverpod Provider stays the same
final userProvider = StateProvider<UserModel?>((ref) => null);

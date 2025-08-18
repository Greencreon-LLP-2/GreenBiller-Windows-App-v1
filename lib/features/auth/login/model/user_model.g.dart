// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      accessToken: json['access_token'] as String?,
      user: json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
      redirectTo: json['redirect_to'] as String?,
      isExistingUser: json['is_existing_user'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'access_token': instance.accessToken,
      'data': instance.user,
      'redirect_to': instance.redirectTo,
      'is_existing_user': instance.isExistingUser,
    };

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      id: (json['id'] as num?)?.toInt(),
      userLevel: json['user_level'] as String?,
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'id': instance.id,
      'user_level': instance.userLevel,
      'store_id': instance.storeId,
      'name': instance.name,
      'email': instance.email,
      'country_code': instance.countryCode,
      'mobile': instance.mobile,
      'whatsapp_no': instance.whatsappNo,
      'user_card': instance.userCard,
      'profile_image': instance.profileImage,
      'dob': instance.dob,
      'count_id': instance.countId,
      'employee_code': instance.employeeCode,
      'warehouse_id': instance.warehouseId,
      'current_latitude': instance.currentLatitude,
      'current_longitude': instance.currentLongitude,
      'zone': instance.zone,
      'otp': instance.otp,
      'mobile_verify': instance.mobileVerify,
      'email_verify': instance.emailVerify,
      'status': instance.status,
      'ban': instance.ban,
      'created_by': instance.createdBy,
      'subcription_id': instance.subcriptionId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

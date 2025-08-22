// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: "status") bool? status,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "access_token") String? accessToken,
    @JsonKey(name: "data") User? user,
    @JsonKey(name: "redirect_to") String? redirectTo,
    @JsonKey(name: "is_existing_user") bool? isExistingUser,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "user_level") String? userLevel,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "country_code") String? countryCode,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "whatsapp_no") dynamic whatsappNo,
    @JsonKey(name: "user_card") dynamic userCard,
    @JsonKey(name: "profile_image") dynamic profileImage,
    @JsonKey(name: "dob") dynamic dob,
    @JsonKey(name: "count_id") dynamic countId,
    @JsonKey(name: "employee_code") dynamic employeeCode,
    @JsonKey(name: "warehouse_id") dynamic warehouseId,
    @JsonKey(name: "current_latitude") dynamic currentLatitude,
    @JsonKey(name: "current_longitude") dynamic currentLongitude,
    @JsonKey(name: "zone") dynamic zone,
    @JsonKey(name: "otp") dynamic otp,
    @JsonKey(name: "mobile_verify") dynamic mobileVerify,
    @JsonKey(name: "email_verify") dynamic emailVerify,
    @JsonKey(name: "status") dynamic status,
    @JsonKey(name: "ban") dynamic ban,
    @JsonKey(name: "created_by") dynamic createdBy,
    @JsonKey(name: "subcription_id") dynamic subcriptionId,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

final userProvider = StateProvider<UserModel?>((ref) => null);

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountModel _$AccountModelFromJson(Map<String, dynamic> json) =>
    _AccountModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AccountModelToJson(_AccountModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  id: (json['id'] as num?)?.toInt(),
  accountName: json['account_name'] as String?,
  bankName: json['bank_name'] as String?,
  accountNumber: json['account_number'] as String?,
  ifscCode: json['ifsc_code'] as String?,
  upiId: json['upi_id'] as String?,
  balance: json['balance'] as String?,
  userId: json['user_id'] as String?,
  storeId: json['store_id'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
  'id': instance.id,
  'account_name': instance.accountName,
  'bank_name': instance.bankName,
  'account_number': instance.accountNumber,
  'ifsc_code': instance.ifscCode,
  'upi_id': instance.upiId,
  'balance': instance.balance,
  'user_id': instance.userId,
  'store_id': instance.storeId,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

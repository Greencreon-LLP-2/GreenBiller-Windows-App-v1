// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaxModel _$TaxModelFromJson(Map<String, dynamic> json) => _TaxModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaxModelToJson(_TaxModel instance) => <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      taxName: json['tax_name'] as String?,
      tax: json['tax'] as String?,
      ifGroup: json['if_group'] as String?,
      subtaxIds: json['subtax_ids'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'tax_name': instance.taxName,
      'tax': instance.tax,
      'if_group': instance.ifGroup,
      'subtax_ids': instance.subtaxIds,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

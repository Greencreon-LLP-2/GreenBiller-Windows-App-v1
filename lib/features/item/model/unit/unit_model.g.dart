// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => _UnitModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnitModelToJson(_UnitModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      parentId: json['parent_id'] as String?,
      unitName: json['unit_name'] as String?,
      unitValue: json['unit_value'] as String?,
      description: json['description'] as String?,
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
      'parent_id': instance.parentId,
      'unit_name': instance.unitName,
      'unit_value': instance.unitValue,
      'description': instance.description,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => _BrandModel(
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$BrandModelToJson(_BrandModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  id: (json['id'] as num?)?.toInt(),
  storeId: json['store_id'] as String?,
  slug: json['slug'] as String?,
  countId: json['count_id'] as String?,
  brandCode: json['brand_code'] as String?,
  brandName: json['brand_name'] as String?,
  brandImage: json['brand_image'] as String?,
  description: json['description'] as String?,
  status: (json['status'] as num?)?.toInt(),
  inappView: json['inapp_view'] as String?,
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
  'slug': instance.slug,
  'count_id': instance.countId,
  'brand_code': instance.brandCode,
  'brand_name': instance.brandName,
  'brand_image': instance.brandImage,
  'description': instance.description,
  'status': instance.status,
  'inapp_view': instance.inappView,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

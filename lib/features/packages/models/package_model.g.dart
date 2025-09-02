// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackageModel _$PackageModelFromJson(Map<String, dynamic> json) =>
    _PackageModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PackageModelToJson(_PackageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  id: (json['id'] as num?)?.toInt(),
  packageName: json['package_name'] as String?,
  description: json['description'] as String?,
  validityDate: json['validity_date'] as String?,
  ifWebpanel: json['if_webpanel'] as String?,
  ifAndroid: json['if_android'] as String?,
  ifIos: json['if_ios'] as String?,
  ifWindows: json['if_windows'] as String?,
  price: json['price'] as String?,
  image: json['image'] as String?,
  ifCustomerApp: json['if_customerapp'] as String?,
  ifDeliveryApp: json['if_deliveryapp'] as String?,
  ifExecutiveApp: json['if_exicutiveapp'] as String?,
  ifMultistore: json['if_multistore'] as String?,
  pricePerStore: json['price_per_store'] as String?,
  ifNumberOfStore: json['if_numberof_store'] as String?,
  status: json['status'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
  'id': instance.id,
  'package_name': instance.packageName,
  'description': instance.description,
  'validity_date': instance.validityDate,
  'if_webpanel': instance.ifWebpanel,
  'if_android': instance.ifAndroid,
  'if_ios': instance.ifIos,
  'if_windows': instance.ifWindows,
  'price': instance.price,
  'image': instance.image,
  'if_customerapp': instance.ifCustomerApp,
  'if_deliveryapp': instance.ifDeliveryApp,
  'if_exicutiveapp': instance.ifExecutiveApp,
  'if_multistore': instance.ifMultistore,
  'price_per_store': instance.pricePerStore,
  'if_numberof_store': instance.ifNumberOfStore,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

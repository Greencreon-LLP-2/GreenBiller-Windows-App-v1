// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleItemReportModel _$SaleItemReportModelFromJson(Map<String, dynamic> json) =>
    _SaleItemReportModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SaleItemReportModelToJson(
  _SaleItemReportModel instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  id: (json['id'] as num?)?.toInt(),
  storeName: json['store_name'] as String?,
  itemName: json['item_name'] as String?,
  salesId: json['sales_id'] as String?,
  pricePerUnit: json['price_per_unit'] as String?,
  salesQty: json['sales_qty'] as String?,
  discountAmt: json['discount_amt'] as String?,
  total: (json['total'] as num?)?.toDouble(),
  salesDate: json['sales_date'] == null
      ? null
      : DateTime.parse(json['sales_date'] as String),
);

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
  'id': instance.id,
  'store_name': instance.storeName,
  'item_name': instance.itemName,
  'sales_id': instance.salesId,
  'price_per_unit': instance.pricePerUnit,
  'sales_qty': instance.salesQty,
  'discount_amt': instance.discountAmt,
  'total': instance.total,
  'sales_date': instance.salesDate?.toIso8601String(),
};

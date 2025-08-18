// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseItemReportModel _$PurchaseItemReportModelFromJson(
        Map<String, dynamic> json) =>
    _PurchaseItemReportModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseItemReportModelToJson(
        _PurchaseItemReportModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
      id: (json['id'] as num?)?.toInt(),
      storeName: json['store_name'] as String?,
      itemName: json['item_name'] as String?,
      purchaseId: json['purchase_id'] as String?,
      pricePerUnit: json['price_per_unit'] as String?,
      purchaseQty: json['purchase_qty'] as String?,
      discountAmt: json['discount_amt'] as String?,
      total: (json['total'] as num?)?.toInt(),
      salesDate: json['sales_date'] == null
          ? null
          : DateTime.parse(json['sales_date'] as String),
    );

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
      'id': instance.id,
      'store_name': instance.storeName,
      'item_name': instance.itemName,
      'purchase_id': instance.purchaseId,
      'price_per_unit': instance.pricePerUnit,
      'purchase_qty': instance.purchaseQty,
      'discount_amt': instance.discountAmt,
      'total': instance.total,
      'sales_date': instance.salesDate?.toIso8601String(),
    };

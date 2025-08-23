// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesSummaryModel _$SalesSummaryModelFromJson(Map<String, dynamic> json) =>
    _SalesSummaryModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SalesSummaryModelToJson(_SalesSummaryModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  id: (json['id'] as num?)?.toInt(),
  storeId: json['store_id'] as String?,
  storeName: json['store_name'] as String?,
  customerId: json['customer_id'] as String?,
  customerName: json['customer_name'] as String?,
  salesCode: json['sales_code'],
  referenceNo: json['reference_no'] as String?,
  grandTotal: json['grand_total'] as String?,
  paidAmount: json['paid_amount'] as String?,
  balance: (json['balance'] as num?)?.toDouble(),
  salesDate: json['sales_date'] == null
      ? null
      : DateTime.parse(json['sales_date'] as String),
);

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
  'id': instance.id,
  'store_id': instance.storeId,
  'store_name': instance.storeName,
  'customer_id': instance.customerId,
  'customer_name': instance.customerName,
  'sales_code': instance.salesCode,
  'reference_no': instance.referenceNo,
  'grand_total': instance.grandTotal,
  'paid_amount': instance.paidAmount,
  'balance': instance.balance,
  'sales_date': instance.salesDate?.toIso8601String(),
};

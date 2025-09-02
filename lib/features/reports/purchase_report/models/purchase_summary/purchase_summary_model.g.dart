// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseSummaryModel _$PurchaseSummaryModelFromJson(
  Map<String, dynamic> json,
) => _PurchaseSummaryModel(
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$PurchaseSummaryModelToJson(
  _PurchaseSummaryModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'data': instance.data,
  'status': instance.status,
};

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
  id: (json['id'] as num?)?.toInt(),
  storeId: json['store_id'] as String?,
  storeName: json['store_name'] as String?,
  supplierId: json['supplier_id'] as String?,
  supplierName: json['supplier_name'] as String?,
  purchaseCode: json['purchase_code'] as String?,
  referenceNo: json['reference_no'] as String?,
  grandTotal: json['grand_total'] as String?,
  paidAmount: json['paid_amount'] as String?,
  balance: (json['balance'] as num?)?.toDouble(),
  purchaseDate: json['purchase_date'] == null
      ? null
      : DateTime.parse(json['purchase_date'] as String),
);

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
  'id': instance.id,
  'store_id': instance.storeId,
  'store_name': instance.storeName,
  'supplier_id': instance.supplierId,
  'supplier_name': instance.supplierName,
  'purchase_code': instance.purchaseCode,
  'reference_no': instance.referenceNo,
  'grand_total': instance.grandTotal,
  'paid_amount': instance.paidAmount,
  'balance': instance.balance,
  'purchase_date': instance.purchaseDate?.toIso8601String(),
};

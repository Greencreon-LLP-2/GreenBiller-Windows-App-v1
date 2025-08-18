// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseViewModel _$PurchaseViewModelFromJson(Map<String, dynamic> json) =>
    _PurchaseViewModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PurchaseViewModelToJson(_PurchaseViewModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      warehouseId: json['warehouse_id'] as String?,
      countId: json['count_id'],
      purchaseCode: json['purchase_code'] as String?,
      referenceNo: json['reference_no'] as String?,
      serialNo: json['serial_no'],
      purchaseDate: json['purchase_date'] == null
          ? null
          : DateTime.parse(json['purchase_date'] as String),
      supplierId: json['supplier_id'] as String?,
      otherChargesInput: json['other_charges_input'],
      otherChargesTaxId: json['other_charges_tax_id'],
      otherChargesAmt: json['other_charges_amt'],
      discountToAllInput: json['discount_to_all_input'],
      discountToAllType: json['discount_to_all_type'],
      totDiscountToAllAmt: json['tot_discount_to_all_amt'] as String?,
      subtotal: json['subtotal'] as String?,
      unit: json['unit'],
      roundOff: json['round_off'] as String?,
      grandTotal: json['grand_total'] as String?,
      purchaseNote: json['purchase_note'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paidAmount: json['paid_amount'] as String?,
      companyId: json['company_id'] as String?,
      status: json['status'] as String?,
      returnBit: json['return_bit'] as String?,
      createdBy: json['created_by'] as String?,
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
      'warehouse_id': instance.warehouseId,
      'count_id': instance.countId,
      'purchase_code': instance.purchaseCode,
      'reference_no': instance.referenceNo,
      'serial_no': instance.serialNo,
      'purchase_date': instance.purchaseDate?.toIso8601String(),
      'supplier_id': instance.supplierId,
      'other_charges_input': instance.otherChargesInput,
      'other_charges_tax_id': instance.otherChargesTaxId,
      'other_charges_amt': instance.otherChargesAmt,
      'discount_to_all_input': instance.discountToAllInput,
      'discount_to_all_type': instance.discountToAllType,
      'tot_discount_to_all_amt': instance.totDiscountToAllAmt,
      'subtotal': instance.subtotal,
      'unit': instance.unit,
      'round_off': instance.roundOff,
      'grand_total': instance.grandTotal,
      'purchase_note': instance.purchaseNote,
      'payment_status': instance.paymentStatus,
      'paid_amount': instance.paidAmount,
      'company_id': instance.companyId,
      'status': instance.status,
      'return_bit': instance.returnBit,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

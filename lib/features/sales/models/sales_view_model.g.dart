// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesViewModel _$SalesViewModelFromJson(Map<String, dynamic> json) =>
    _SalesViewModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SalesViewModelToJson(_SalesViewModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      warehouseId: json['warehouse_id'] as String?,
      initCode: json['init_code'] as String?,
      countId: json['count_id'] as String?,
      salesCode: json['sales_code'] as String?,
      referenceNo: json['reference_no'] as String?,
      salesDate: json['sales_date'] as String?,
      dueDate: json['due_date'] as String?,
      salesStatus: json['sales_status'] as String?,
      customerId: json['customer_id'] as String?,
      otherChargesInput: json['other_charges_input'] as String?,
      otherChargesTaxId: json['other_charges_tax_id'] as String?,
      otherChargesAmt: json['other_charges_amt'] as String?,
      discountToAllInput: json['discount_to_all_input'],
      discountToAllType: json['discount_to_all_type'],
      totDiscountToAllAmt: json['tot_discount_to_all_amt'] as String?,
      subtotal: json['subtotal'] as String?,
      roundOff: json['round_off'] as String?,
      grandTotal: json['grand_total'] as String?,
      salesNote: json['sales_note'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paidAmount: json['paid_amount'] as String?,
      companyId: json['company_id'] as String?,
      pos: json['pos'] as String?,
      returnBit: json['return_bit'],
      customerPreviousDue: json['customer_previous_due'],
      customerTotalDue: json['customer_total_due'],
      quotationId: json['quotation_id'],
      couponId: json['coupon_id'],
      couponAmt: json['coupon_amt'],
      invoiceTerms: json['invoice_terms'],
      status: json['status'] as String?,
      appOrder: json['app_order'] as String?,
      orderId: json['order_id'] as String?,
      taxReport: json['tax_report'] as String?,
      createdBy: json['created_by'],
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
      'init_code': instance.initCode,
      'count_id': instance.countId,
      'sales_code': instance.salesCode,
      'reference_no': instance.referenceNo,
      'sales_date': instance.salesDate,
      'due_date': instance.dueDate,
      'sales_status': instance.salesStatus,
      'customer_id': instance.customerId,
      'other_charges_input': instance.otherChargesInput,
      'other_charges_tax_id': instance.otherChargesTaxId,
      'other_charges_amt': instance.otherChargesAmt,
      'discount_to_all_input': instance.discountToAllInput,
      'discount_to_all_type': instance.discountToAllType,
      'tot_discount_to_all_amt': instance.totDiscountToAllAmt,
      'subtotal': instance.subtotal,
      'round_off': instance.roundOff,
      'grand_total': instance.grandTotal,
      'sales_note': instance.salesNote,
      'payment_status': instance.paymentStatus,
      'paid_amount': instance.paidAmount,
      'company_id': instance.companyId,
      'pos': instance.pos,
      'return_bit': instance.returnBit,
      'customer_previous_due': instance.customerPreviousDue,
      'customer_total_due': instance.customerTotalDue,
      'quotation_id': instance.quotationId,
      'coupon_id': instance.couponId,
      'coupon_amt': instance.couponAmt,
      'invoice_terms': instance.invoiceTerms,
      'status': instance.status,
      'app_order': instance.appOrder,
      'order_id': instance.orderId,
      'tax_report': instance.taxReport,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

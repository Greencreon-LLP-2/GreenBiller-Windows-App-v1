// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PurchaseItemModel _$PurchaseItemModelFromJson(Map<String, dynamic> json) =>
    _PurchaseItemModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PurchaseItemModelToJson(_PurchaseItemModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
      'status': instance.status,
    };

_Datum _$DatumFromJson(Map<String, dynamic> json) => _Datum(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      purchaseId: json['purchase_id'] as String?,
      purchaseStatus: json['purchase_status'] as String?,
      itemId: json['item_id'] as String?,
      itemName: json['item_name'] as String,
      barCode: json['bar_code'] as String?,
      purchaseQty: json['purchase_qty'] as String?,
      pricePerUnit: json['price_per_unit'] as String,
      taxType: json['tax_type'] as String?,
      taxId: json['tax_id'] as String?,
      taxAmt: json['tax_amt'] as String?,
      discountType: json['discount_type'] as String?,
      discountInput: json['discount_input'] as String?,
      discountAmt: json['discount_amt'] as String?,
      unitTotalCost: json['unit_total_cost'] as String?,
      totalCost: json['total_cost'] as String?,
      profitMarginPer: json['profit_margin_per'] as String?,
      unitSalesPrice: json['unit_sales_price'] as String?,
      stock: json['stock'] as String?,
      ifBatch: json['if_batch'] as String?,
      batchNo: json['batch_no'] as String?,
      ifExpirydate: json['if_expirydate'] as String?,
      expireDate: json['expire_date'],
      description: json['description'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$DatumToJson(_Datum instance) => <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'purchase_id': instance.purchaseId,
      'purchase_status': instance.purchaseStatus,
      'item_id': instance.itemId,
      'item_name': instance.itemName,
      'bar_code': instance.barCode,
      'purchase_qty': instance.purchaseQty,
      'price_per_unit': instance.pricePerUnit,
      'tax_type': instance.taxType,
      'tax_id': instance.taxId,
      'tax_amt': instance.taxAmt,
      'discount_type': instance.discountType,
      'discount_input': instance.discountInput,
      'discount_amt': instance.discountAmt,
      'unit_total_cost': instance.unitTotalCost,
      'total_cost': instance.totalCost,
      'profit_margin_per': instance.profitMarginPer,
      'unit_sales_price': instance.unitSalesPrice,
      'stock': instance.stock,
      'if_batch': instance.ifBatch,
      'batch_no': instance.batchNo,
      'if_expirydate': instance.ifExpirydate,
      'expire_date': instance.expireDate,
      'description': instance.description,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'unit': instance.unit,
    };

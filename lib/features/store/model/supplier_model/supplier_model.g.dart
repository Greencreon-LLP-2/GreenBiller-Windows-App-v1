// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) =>
    _SupplierModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SupplierData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      insights: json['insights'] == null
          ? null
          : SupplierInsights.fromJson(json['insights'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupplierModelToJson(_SupplierModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'status': instance.status,
      'insights': instance.insights?.toJson(),
    };

_SupplierData _$SupplierDataFromJson(Map<String, dynamic> json) =>
    _SupplierData(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      coundId: json['cound_id'],
      supplierCode: json['supplier_code'],
      supplierName: json['supplier_name'] as String?,
      mobile: json['mobile'] as String?,
      phone: json['phone'],
      email: json['email'] as String?,
      gstin: json['gstin'] as String?,
      taxNumber: json['tax_number'],
      vatin: json['vatin'],
      openingBalance: json['opening_balance'],
      purchaseDue: json['purchase_due'],
      purchaseReturnDue: json['purchase_return_due'],
      countryId: json['country_id'],
      stateId: json['state_id'],
      state: json['state'],
      city: json['city'],
      postcode: json['postcode'],
      address: json['address'] as String?,
      companyId: json['company_id'],
      status: json['status'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      storeName: json['store_name'] as String?,
    );

Map<String, dynamic> _$SupplierDataToJson(_SupplierData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'cound_id': instance.coundId,
      'supplier_code': instance.supplierCode,
      'supplier_name': instance.supplierName,
      'mobile': instance.mobile,
      'phone': instance.phone,
      'email': instance.email,
      'gstin': instance.gstin,
      'tax_number': instance.taxNumber,
      'vatin': instance.vatin,
      'opening_balance': instance.openingBalance,
      'purchase_due': instance.purchaseDue,
      'purchase_return_due': instance.purchaseReturnDue,
      'country_id': instance.countryId,
      'state_id': instance.stateId,
      'state': instance.state,
      'city': instance.city,
      'postcode': instance.postcode,
      'address': instance.address,
      'company_id': instance.companyId,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'store_name': instance.storeName,
    };

_SupplierInsights _$SupplierInsightsFromJson(Map<String, dynamic> json) =>
    _SupplierInsights(
      totalSuppliers: (json['total_suppliers'] as num?)?.toInt(),
      newSuppliersLast30Days:
          (json['new_suppliers_last_30_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SupplierInsightsToJson(_SupplierInsights instance) =>
    <String, dynamic>{
      'total_suppliers': instance.totalSuppliers,
      'new_suppliers_last_30_days': instance.newSuppliersLast30Days,
    };

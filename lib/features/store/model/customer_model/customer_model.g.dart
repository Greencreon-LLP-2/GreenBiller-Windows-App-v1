// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    _CustomerModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      insights: json['insights'] == null
          ? null
          : CustomerInsights.fromJson(json['insights'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerModelToJson(_CustomerModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data?.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'status': instance.status,
      'insights': instance.insights?.toJson(),
    };

_CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) =>
    _CustomerData(
      id: (json['id'] as num?)?.toInt(),
      storeId: json['store_id'] as String?,
      userId: json['user_id'] as String?,
      countId: json['count_id'],
      customerCode: json['customer_code'],
      customerName: json['customer_name'] as String?,
      mobile: json['mobile'] as String?,
      phone: json['phone'],
      email: json['email'] as String?,
      gstin: json['gstin'] as String?,
      taxNumber: json['tax_number'],
      vatin: json['vatin'],
      openingBalance: json['opening_balance'],
      salesDue: json['sales_due'],
      salesReturnDue: json['sales_return_due'],
      countryId: json['country_id'],
      state: json['state'],
      city: json['city'],
      postcode: json['postcode'],
      address: json['address'] as String?,
      locationLink: json['location_link'],
      attachment1: json['attachment_1'],
      priceLevelType: json['price_level_type'],
      priceLevel: json['price_level'],
      deleteBit: json['delete_bit'],
      totAdvance: json['tot_advance'],
      creditLimit: json['credit_limit'],
      status: json['status'],
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      storeName: json['store_name'] as String?,
      country: json['country'],
    );

Map<String, dynamic> _$CustomerDataToJson(_CustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'user_id': instance.userId,
      'count_id': instance.countId,
      'customer_code': instance.customerCode,
      'customer_name': instance.customerName,
      'mobile': instance.mobile,
      'phone': instance.phone,
      'email': instance.email,
      'gstin': instance.gstin,
      'tax_number': instance.taxNumber,
      'vatin': instance.vatin,
      'opening_balance': instance.openingBalance,
      'sales_due': instance.salesDue,
      'sales_return_due': instance.salesReturnDue,
      'country_id': instance.countryId,
      'state': instance.state,
      'city': instance.city,
      'postcode': instance.postcode,
      'address': instance.address,
      'location_link': instance.locationLink,
      'attachment_1': instance.attachment1,
      'price_level_type': instance.priceLevelType,
      'price_level': instance.priceLevel,
      'delete_bit': instance.deleteBit,
      'tot_advance': instance.totAdvance,
      'credit_limit': instance.creditLimit,
      'status': instance.status,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'store_name': instance.storeName,
      'country': instance.country,
    };

_CustomerInsights _$CustomerInsightsFromJson(Map<String, dynamic> json) =>
    _CustomerInsights(
      totalCustomers: (json['total_customers'] as num?)?.toInt(),
      newCustomersLast30Days:
          (json['new_customers_last_30_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CustomerInsightsToJson(_CustomerInsights instance) =>
    <String, dynamic>{
      'total_customers': instance.totalCustomers,
      'new_customers_last_30_days': instance.newCustomersLast30Days,
    };

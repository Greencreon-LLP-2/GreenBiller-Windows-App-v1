import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
abstract class CustomerModel with _$CustomerModel {
  @JsonSerializable(explicitToJson: true)
  const factory CustomerModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<CustomerData>? data,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "insights") CustomerInsights? insights,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);
}

@freezed
abstract class CustomerData with _$CustomerData {
  @JsonSerializable(explicitToJson: true)
  const factory CustomerData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "user_id") String? userId,
    @JsonKey(name: "count_id") dynamic countId,
    @JsonKey(name: "customer_code") dynamic customerCode,
    @JsonKey(name: "customer_name") String? customerName,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "phone") dynamic phone,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "gstin") String? gstin,
    @JsonKey(name: "tax_number") dynamic taxNumber,
    @JsonKey(name: "vatin") dynamic vatin,
    @JsonKey(name: "opening_balance") dynamic openingBalance,
    @JsonKey(name: "sales_due") dynamic salesDue,
    @JsonKey(name: "sales_return_due") dynamic salesReturnDue,
    @JsonKey(name: "country_id") dynamic countryId,
    @JsonKey(name: "state") dynamic state,
    @JsonKey(name: "city") dynamic city,
    @JsonKey(name: "postcode") dynamic postcode,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "location_link") dynamic locationLink,
    @JsonKey(name: "attachment_1") dynamic attachment1,
    @JsonKey(name: "price_level_type") dynamic priceLevelType,
    @JsonKey(name: "price_level") dynamic priceLevel,
    @JsonKey(name: "delete_bit") dynamic deleteBit,
    @JsonKey(name: "tot_advance") dynamic totAdvance,
    @JsonKey(name: "credit_limit") dynamic creditLimit,
    @JsonKey(name: "status") dynamic status,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "store_name") String? storeName,
    @JsonKey(name: "country") dynamic country,
  }) = _CustomerData;

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);
}

@freezed
abstract class CustomerInsights with _$CustomerInsights {
  @JsonSerializable(explicitToJson: true)
  const factory CustomerInsights({
    @JsonKey(name: "total_customers") int? totalCustomers,
    @JsonKey(name: "new_customers_last_30_days") int? newCustomersLast30Days,
  }) = _CustomerInsights;

  factory CustomerInsights.fromJson(Map<String, dynamic> json) =>
      _$CustomerInsightsFromJson(json);
}

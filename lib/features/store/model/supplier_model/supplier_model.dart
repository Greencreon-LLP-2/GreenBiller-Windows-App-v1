import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_model.freezed.dart';
part 'supplier_model.g.dart';

@freezed
abstract class SupplierModel with _$SupplierModel {
  @JsonSerializable(explicitToJson: true)
  const factory SupplierModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<SupplierData>? data,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "insights") SupplierInsights? insights,
  }) = _SupplierModel;

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);
}

@freezed
abstract class SupplierData with _$SupplierData {
  @JsonSerializable(explicitToJson: true)
  const factory SupplierData({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "cound_id") dynamic coundId,
    @JsonKey(name: "supplier_code") dynamic supplierCode,
    @JsonKey(name: "supplier_name") String? supplierName,
    @JsonKey(name: "mobile") String? mobile,
    @JsonKey(name: "phone") dynamic phone,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "gstin") String? gstin,
    @JsonKey(name: "tax_number") dynamic taxNumber,
    @JsonKey(name: "vatin") dynamic vatin,
    @JsonKey(name: "opening_balance") dynamic openingBalance,
    @JsonKey(name: "purchase_due") dynamic purchaseDue,
    @JsonKey(name: "purchase_return_due") dynamic purchaseReturnDue,
    @JsonKey(name: "country_id") dynamic countryId,
    @JsonKey(name: "state_id") dynamic stateId,
    @JsonKey(name: "state") dynamic state,
    @JsonKey(name: "city") dynamic city,
    @JsonKey(name: "postcode") dynamic postcode,
    @JsonKey(name: "address") String? address,
    @JsonKey(name: "company_id") dynamic companyId,
    @JsonKey(name: "status") dynamic status,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "store_name") String? storeName,
  }) = _SupplierData;

  factory SupplierData.fromJson(Map<String, dynamic> json) =>
      _$SupplierDataFromJson(json);
}

@freezed
abstract class SupplierInsights with _$SupplierInsights {
  @JsonSerializable(explicitToJson: true)
  const factory SupplierInsights({
    @JsonKey(name: "total_suppliers") int? totalSuppliers,
    @JsonKey(name: "new_suppliers_last_30_days") int? newSuppliersLast30Days,
  }) = _SupplierInsights;

  factory SupplierInsights.fromJson(Map<String, dynamic> json) =>
      _$SupplierInsightsFromJson(json);
}

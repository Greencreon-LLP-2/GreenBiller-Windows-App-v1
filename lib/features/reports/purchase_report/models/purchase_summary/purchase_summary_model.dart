import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_summary_model.freezed.dart';
part 'purchase_summary_model.g.dart';

@freezed
abstract class PurchaseSummaryModel with _$PurchaseSummaryModel {
  const factory PurchaseSummaryModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _PurchaseSummaryModel;
  factory PurchaseSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSummaryModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "store_name") String? storeName,
    @JsonKey(name: "supplier_id") String? supplierId,
    @JsonKey(name: "supplier_name") String? supplierName,
    @JsonKey(name: "purchase_code") String? purchaseCode,
    @JsonKey(name: "reference_no") String? referenceNo,
    @JsonKey(name: "grand_total") String? grandTotal,
    @JsonKey(name: "paid_amount") String? paidAmount,
    @JsonKey(name: "balance") double? balance,
    @JsonKey(name: "purchase_date") DateTime? purchaseDate,
  }) = _Datum;
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

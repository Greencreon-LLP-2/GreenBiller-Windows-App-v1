import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_item_report_model.freezed.dart';
part 'purchase_item_report_model.g.dart';

@freezed
abstract class PurchaseItemReportModel with _$PurchaseItemReportModel {
  const factory PurchaseItemReportModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
  }) = _PurchaseItemReportModel;

  factory PurchaseItemReportModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemReportModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_name") String? storeName,
    @JsonKey(name: "item_name") String? itemName,
    @JsonKey(name: "purchase_id") String? purchaseId,
    @JsonKey(name: "price_per_unit") String? pricePerUnit,
    @JsonKey(name: "purchase_qty") String? purchaseQty,
    @JsonKey(name: "discount_amt") String? discountAmt,
    @JsonKey(name: "total") int? total,
    @JsonKey(name: "sales_date") DateTime? salesDate,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

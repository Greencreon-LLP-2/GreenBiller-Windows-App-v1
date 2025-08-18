import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_item_report_model.freezed.dart';
part 'sale_item_report_model.g.dart';

@freezed
abstract class SaleItemReportModel with _$SaleItemReportModel {
  const factory SaleItemReportModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
  }) = _SaleItemReportModel;

  factory SaleItemReportModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemReportModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_name") String? storeName,
    @JsonKey(name: "item_name") String? itemName,
    @JsonKey(name: "sales_id") String? salesId,
    @JsonKey(name: "price_per_unit") String? pricePerUnit,
    @JsonKey(name: "sales_qty") String? salesQty,
    @JsonKey(name: "discount_amt") String? discountAmt,
    @JsonKey(name: "total") double? total,
    @JsonKey(name: "sales_date") DateTime? salesDate,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

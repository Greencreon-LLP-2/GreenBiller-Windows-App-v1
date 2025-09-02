import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_customer_summary_model.freezed.dart';
part 'sales_customer_summary_model.g.dart';

@freezed
abstract class SalesSummaryCustomerModel with _$SalesSummaryCustomerModel {
  const factory SalesSummaryCustomerModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
  }) = _SalesSummaryCustomerModel;

  factory SalesSummaryCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$SalesSummaryCustomerModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "store_name") String? storeName,
    @JsonKey(name: "customer_id") String? customerId,
    @JsonKey(name: "customer_name") String? customerName,
    @JsonKey(name: "sales_code") dynamic salesCode,
    @JsonKey(name: "reference_no") String? referenceNo,
    @JsonKey(name: "grand_total") String? grandTotal,
    @JsonKey(name: "paid_amount") String? paidAmount,
    @JsonKey(name: "balance") int? balance,
    @JsonKey(name: "sales_date") DateTime? salesDate,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

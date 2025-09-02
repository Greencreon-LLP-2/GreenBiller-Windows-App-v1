import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_view_model.freezed.dart';
part 'sales_view_model.g.dart';

@freezed
abstract class SalesViewModel with _$SalesViewModel {
  const factory SalesViewModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _SalesViewModel;

  factory SalesViewModel.fromJson(Map<String, dynamic> json) =>
      _$SalesViewModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "warehouse_id") String? warehouseId,
    @JsonKey(name: "init_code") String? initCode,
    @JsonKey(name: "count_id") String? countId,
    @JsonKey(name: "sales_code") String? salesCode,
    @JsonKey(name: "reference_no") String? referenceNo,
    @JsonKey(name: "sales_date") String? salesDate,
    @JsonKey(name: "due_date") String? dueDate,
    @JsonKey(name: "sales_status") String? salesStatus,
    @JsonKey(name: "customer_id") String? customerId,
    @JsonKey(name: "other_charges_input") String? otherChargesInput,
    @JsonKey(name: "other_charges_tax_id") String? otherChargesTaxId,
    @JsonKey(name: "other_charges_amt") String? otherChargesAmt,
    @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
    @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
    @JsonKey(name: "tot_discount_to_all_amt") String? totDiscountToAllAmt,
    @JsonKey(name: "subtotal") String? subtotal,
    @JsonKey(name: "round_off") String? roundOff,
    @JsonKey(name: "grand_total") String? grandTotal,
    @JsonKey(name: "sales_note") String? salesNote,
    @JsonKey(name: "payment_status") String? paymentStatus,
    @JsonKey(name: "paid_amount") String? paidAmount,
    @JsonKey(name: "company_id") String? companyId,
    @JsonKey(name: "pos") String? pos,
    @JsonKey(name: "return_bit") dynamic returnBit,
    @JsonKey(name: "customer_previous_due") dynamic customerPreviousDue,
    @JsonKey(name: "customer_total_due") dynamic customerTotalDue,
    @JsonKey(name: "quotation_id") dynamic quotationId,
    @JsonKey(name: "coupon_id") dynamic couponId,
    @JsonKey(name: "coupon_amt") dynamic couponAmt,
    @JsonKey(name: "invoice_terms") dynamic invoiceTerms,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "app_order") String? appOrder,
    @JsonKey(name: "order_id") String? orderId,
    @JsonKey(name: "tax_report") String? taxReport,
    @JsonKey(name: "created_by") dynamic createdBy,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

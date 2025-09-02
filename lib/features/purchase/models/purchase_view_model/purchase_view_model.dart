import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_view_model.freezed.dart';
part 'purchase_view_model.g.dart';

@freezed
abstract class PurchaseViewModel with _$PurchaseViewModel {
  const factory PurchaseViewModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _PurchaseViewModel;

  factory PurchaseViewModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseViewModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "warehouse_id") String? warehouseId,
    @JsonKey(name: "count_id") dynamic countId,
    @JsonKey(name: "purchase_code") String? purchaseCode,
    @JsonKey(name: "reference_no") String? referenceNo,
    @JsonKey(name: "serial_no") dynamic serialNo,
    @JsonKey(name: "purchase_date") DateTime? purchaseDate,
    @JsonKey(name: "supplier_id") String? supplierId,
    @JsonKey(name: "other_charges_input") dynamic otherChargesInput,
    @JsonKey(name: "other_charges_tax_id") dynamic otherChargesTaxId,
    @JsonKey(name: "other_charges_amt") dynamic otherChargesAmt,
    @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
    @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
    @JsonKey(name: "tot_discount_to_all_amt") String? totDiscountToAllAmt,
    @JsonKey(name: "subtotal") String? subtotal,
    @JsonKey(name: "unit") dynamic unit,
    @JsonKey(name: "round_off") String? roundOff,
    @JsonKey(name: "grand_total") String? grandTotal,
    @JsonKey(name: "purchase_note") String? purchaseNote,
    @JsonKey(name: "payment_status") String? paymentStatus,
    @JsonKey(name: "paid_amount") String? paidAmount,
    @JsonKey(name: "company_id") String? companyId,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "return_bit") String? returnBit,
    @JsonKey(name: "created_by") String? createdBy,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

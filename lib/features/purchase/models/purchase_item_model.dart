import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_item_model.freezed.dart';
part 'purchase_item_model.g.dart';

@freezed
abstract class PurchaseItemModel with _$PurchaseItemModel {
  const factory PurchaseItemModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _PurchaseItemModel;

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseItemModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "purchase_id") String? purchaseId,
    @JsonKey(name: "purchase_status") String? purchaseStatus,
    @JsonKey(name: "item_id") String? itemId,
    @JsonKey(name: "item_name") required String itemName,
    @JsonKey(name: "bar_code") String? barCode,
    @JsonKey(name: "purchase_qty") String? purchaseQty,
    @JsonKey(name: "price_per_unit") required String pricePerUnit,
    @JsonKey(name: "tax_type") String? taxType,
    @JsonKey(name: "tax_id") String? taxId,
    @JsonKey(name: "tax_amt") String? taxAmt,
    @JsonKey(name: "discount_type") String? discountType,
    @JsonKey(name: "discount_input") String? discountInput,
    @JsonKey(name: "discount_amt") String? discountAmt,
    @JsonKey(name: "unit_total_cost") String? unitTotalCost,
    @JsonKey(name: "total_cost") String? totalCost,
    @JsonKey(name: "profit_margin_per") String? profitMarginPer,
    @JsonKey(name: "unit_sales_price") String? unitSalesPrice,
    @JsonKey(name: "stock") String? stock,
    @JsonKey(name: "if_batch") String? ifBatch,
    @JsonKey(name: "batch_no") String? batchNo,
    @JsonKey(name: "if_expirydate") String? ifExpirydate,
    @JsonKey(name: "expire_date") dynamic expireDate,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
    @JsonKey(name: "unit") String? unit,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

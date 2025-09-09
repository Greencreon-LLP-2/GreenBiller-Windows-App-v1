class PurchaseItemReportModel {
  final String? message;
  final List<SinglePurchaseItemReportModel>? data;

  PurchaseItemReportModel({this.message, this.data});

  factory PurchaseItemReportModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemReportModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
                .map(
                  (e) => SinglePurchaseItemReportModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.map((e) => e.toJson()).toList()};
  }
}

class SinglePurchaseItemReportModel {
  final int? id;
  final String? storeName;
  final String? itemName;
  final String? purchaseId;
  final String? pricePerUnit;
  final String? purchaseQty;
  final String? discountAmt;
  final int? total;
  final DateTime? salesDate;

  SinglePurchaseItemReportModel({
    this.id,
    this.storeName,
    this.itemName,
    this.purchaseId,
    this.pricePerUnit,
    this.purchaseQty,
    this.discountAmt,
    this.total,
    this.salesDate,
  });

  factory SinglePurchaseItemReportModel.fromJson(Map<String, dynamic> json) {
    return SinglePurchaseItemReportModel(
      id: json['id'] as int?,
      storeName: json['store_name'] as String?,
      itemName: json['item_name'] as String?,
      purchaseId: json['purchase_id'] as String?,
      pricePerUnit: json['price_per_unit'] as String?,
      purchaseQty: json['purchase_qty'] as String?,
      discountAmt: json['discount_amt'] as String?,
      total: json['total'] as int?,
      salesDate: json['sales_date'] != null
          ? DateTime.parse(json['sales_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'item_name': itemName,
      'purchase_id': purchaseId,
      'price_per_unit': pricePerUnit,
      'purchase_qty': purchaseQty,
      'discount_amt': discountAmt,
      'total': total,
      'sales_date': salesDate?.toIso8601String(),
    };
  }
}

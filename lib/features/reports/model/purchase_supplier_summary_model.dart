class PurchaseSummaryBySupplierModel {
  final String? message;
  final List<SignlePurchaseSummaryBySupplierModel>? data;
  final int? status;

  PurchaseSummaryBySupplierModel({this.message, this.data, this.status});

  factory PurchaseSummaryBySupplierModel.fromJson(Map<String, dynamic> json) {
    return PurchaseSummaryBySupplierModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
                .map(
                  (e) => SignlePurchaseSummaryBySupplierModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class SignlePurchaseSummaryBySupplierModel {
  final int? id;
  final String? storeId;
  final String? storeName;
  final String? supplierId;
  final String? supplierName;
  final String? purchaseCode;
  final String? referenceNo;
  final String? grandTotal;
  final String? paidAmount;
  final double? balance;
  final DateTime? purchaseDate;

  SignlePurchaseSummaryBySupplierModel({
    this.id,
    this.storeId,
    this.storeName,
    this.supplierId,
    this.supplierName,
    this.purchaseCode,
    this.referenceNo,
    this.grandTotal,
    this.paidAmount,
    this.balance,
    this.purchaseDate,
  });

  factory SignlePurchaseSummaryBySupplierModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SignlePurchaseSummaryBySupplierModel(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      purchaseCode: json['purchase_code'] as String?,
      referenceNo: json['reference_no'] as String?,
      grandTotal: json['grand_total'] as String?,
      paidAmount: json['paid_amount'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'store_name': storeName,
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'purchase_code': purchaseCode,
      'reference_no': referenceNo,
      'grand_total': grandTotal,
      'paid_amount': paidAmount,
      'balance': balance,
      'purchase_date': purchaseDate?.toIso8601String(),
    };
  }
}

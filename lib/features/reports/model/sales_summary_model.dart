class SalesSummaryModel {
  final String? message;
  final List<SingleSalesSummaryItem>? data;
  final int? status;

  SalesSummaryModel({
    this.message,
    this.data,
    this.status,
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((e) => SingleSalesSummaryItem.fromJson(e as Map<String, dynamic>))
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

class SingleSalesSummaryItem {
  final int? id;
  final String? storeId;
  final String? storeName;
  final String? customerId;
  final String? customerName;
  final dynamic salesCode;
  final String? referenceNo;
  final String? grandTotal;
  final String? paidAmount;
  final double? balance;
  final DateTime? salesDate;

  SingleSalesSummaryItem({
    this.id,
    this.storeId,
    this.storeName,
    this.customerId,
    this.customerName,
    this.salesCode,
    this.referenceNo,
    this.grandTotal,
    this.paidAmount,
    this.balance,
    this.salesDate,
  });

  factory SingleSalesSummaryItem.fromJson(Map<String, dynamic> json) {
    return SingleSalesSummaryItem(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String?,
      salesCode: json['sales_code'],
      referenceNo: json['reference_no'] as String?,
      grandTotal: json['grand_total'] as String?,
      paidAmount: json['paid_amount'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      salesDate: json['sales_date'] != null
          ? DateTime.parse(json['sales_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'store_name': storeName,
      'customer_id': customerId,
      'customer_name': customerName,
      'sales_code': salesCode,
      'reference_no': referenceNo,
      'grand_total': grandTotal,
      'paid_amount': paidAmount,
      'balance': balance,
      'sales_date': salesDate?.toIso8601String(),
    };
  }
}
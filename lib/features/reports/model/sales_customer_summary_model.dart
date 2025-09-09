class SalesSummaryCustomerModel {
  final String? message;
  final List<SingleSalesSummaryCustomerItem>? data;

  SalesSummaryCustomerModel({this.message, this.data});

  factory SalesSummaryCustomerModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryCustomerModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
                .map(
                  (e) => SingleSalesSummaryCustomerItem.fromJson(
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

class SingleSalesSummaryCustomerItem {
  final int? id;
  final String? storeId;
  final String? storeName;
  final String? customerId;
  final String? customerName;
  final dynamic salesCode;
  final String? referenceNo;
  final double? grandTotal;
  final double? paidAmount;
  final double? balance;
  final String? salesDate;

  SingleSalesSummaryCustomerItem({
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

  factory SingleSalesSummaryCustomerItem.fromJson(Map<String, dynamic> json) {
    return SingleSalesSummaryCustomerItem(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      customerId: json['customer_id'] as String?,
      customerName: json['customer_name'] as String?,
      salesCode: json['sales_code'],
      referenceNo: json['reference_no'] as String?,
      grandTotal: (json['grand_total'] != null)
          ? double.tryParse(json['grand_total'].toString())
          : null,
      paidAmount: (json['paid_amount'] != null)
          ? double.tryParse(json['paid_amount'].toString())
          : null,
      balance: (json['balance'] != null)
          ? double.tryParse(json['balance'].toString())
          : null,
      salesDate: json['sales_date'] != null
          ? json['sales_date'] as String
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
      'sales_date': salesDate,
    };
  }
}

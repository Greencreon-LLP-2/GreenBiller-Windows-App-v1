class SaleItemReportModel {
  final String? message;
  final List<SIngleSaleItemReportModel>? data;

  SaleItemReportModel({this.message, this.data});

  factory SaleItemReportModel.fromJson(Map<String, dynamic> json) {
    return SaleItemReportModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
                .map(
                  (e) => SIngleSaleItemReportModel.fromJson(
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

class SIngleSaleItemReportModel {
  final int? id;
  final String? storeName;
  final String? itemName;
  final int? salesQty;
  final double? pricePerUnit;
  final double? discountAmt;
  final double? total;
  final DateTime? salesDate;

  SIngleSaleItemReportModel({
    this.id,
    this.storeName,
    this.itemName,
    this.salesQty,
    this.pricePerUnit,
    this.discountAmt,
    this.total,
    this.salesDate,
  });

  factory SIngleSaleItemReportModel.fromJson(Map<String, dynamic> json) {
    return SIngleSaleItemReportModel(
      id: json['id'] as int?,
      storeName: json['store_name'] as String?,
      itemName: json['item_name'] as String?,
      salesQty: json['sales_qty'] is num
          ? (json['sales_qty'] as num).toInt()
          : int.tryParse(json['sales_qty']?.toString() ?? ''),

      pricePerUnit: json['price_per_unit'] is num
          ? (json['price_per_unit'] as num).toDouble()
          : double.tryParse(json['price_per_unit']?.toString() ?? ''),

      discountAmt: json['discount_amt'] is num
          ? (json['discount_amt'] as num).toDouble()
          : double.tryParse(json['discount_amt']?.toString() ?? ''),

      total: json['total'] is num
          ? (json['total'] as num).toDouble()
          : double.tryParse(json['total']?.toString() ?? ''),

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
      'sales_qty': salesQty,
      'price_per_unit': pricePerUnit,
      'discount_amt': discountAmt,
      'total': total,
      'sales_date': salesDate?.toIso8601String(),
    };
  }
}

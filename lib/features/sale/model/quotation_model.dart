class QuotationListModel {
  final bool status;
  final List<Quotation> data;

  QuotationListModel({required this.status, required this.data});

  factory QuotationListModel.fromJson(Map<String, dynamic> json) {
    return QuotationListModel(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map((e) => Quotation.fromJson(e))
          .toList(),
    );
  }
}

class Quotation {
  final int id;
  final String? storeId;
  final String? customerId;
  final String quoteNumber;
  final DateTime? quoteDate;
  final int? itemQty;
  final double? totalAmount;
  final String? createdBy;
  final int status; // keep as int since API sends 0/1
  final List<QuotationItem> items;

  Quotation({
    required this.id,
    this.storeId,
    this.customerId,
    required this.quoteNumber,
    this.quoteDate,
    this.itemQty,
    this.totalAmount,
    this.createdBy,
    required this.status,
    required this.items,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'] ?? 0,
      storeId: json['stor_id']?.toString(),
      customerId: json['customer_id']?.toString(),
      quoteNumber: json['quote_number']?.toString() ?? '',
      quoteDate: json['quote_date'] != null
          ? DateTime.tryParse(json['quote_date'])
          : null,
      itemQty: json['item_qty'] != null ? int.tryParse(json['item_qty'].toString()) : null,
      totalAmount: json['total_amount'] != null
          ? double.tryParse(json['total_amount'].toString())
          : null,
      createdBy: json['created_by']?.toString(),
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => QuotationItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class QuotationItem {
  final int id;
  final String quoteId;
  final String itemId;
  final String itemName;
  final String salesQty;
  final String pricePerUnit;
  final String totalCost;
  final String unit;

  QuotationItem({
    required this.id,
    required this.quoteId,
    required this.itemId,
    required this.itemName,
    required this.salesQty,
    required this.pricePerUnit,
    required this.totalCost,
    required this.unit,
  });

  factory QuotationItem.fromJson(Map<String, dynamic> json) {
    return QuotationItem(
      id: json['id'] ?? 0,
      quoteId: json['quote_id']?.toString() ?? '',
      itemId: json['item_id']?.toString() ?? '',
      itemName: json['item_name'] ?? '',
      salesQty: json['sales_qty']?.toString() ?? '0',
      pricePerUnit: json['price_per_unit']?.toString() ?? '0',
      totalCost: json['total_cost']?.toString() ?? '0',
      unit: json['unit'] ?? '',
    );
  }
}

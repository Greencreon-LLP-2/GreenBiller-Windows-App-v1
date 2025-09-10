class SalesReturnModel {
  final String message;
  final List<SalesReturnRecord> records;
  final SalesReturnTotals totals;
  final int status;

  SalesReturnModel({
    required this.message,
    required this.records,
    required this.totals,
    required this.status,
  });

  factory SalesReturnModel.fromJson(Map<String, dynamic> json) {
    return SalesReturnModel(
      message: json['message'] ?? '',
      records: (json['data'] as List<dynamic>?)
              ?.map((e) => SalesReturnRecord.fromJson(e))
              .toList() ??
          [],
      totals: SalesReturnTotals.fromJson(json['totals'] ?? {}),
      status: json['status'] ?? 0,
    );
  }
}

class SalesReturnRecord {
  final int id;
  final String? storeId;
  final String? countId;
  final String? salesId;
  final String? warehouseId;
  final String? returnCode;
  final String? referenceNo;
  final String? returnDate;
  final String? returnStatus;
  final String? customerId;
  final String? otherChargesInput;
  final String? otherChargesTaxId;
  final String? otherChargesAmt;
  final String? discountToAllInput;
  final String? discountToAllType;
  final String? totDiscountToAllAmt;
  final String? subtotal;
  final String? roundOff;
  final String? grandTotal;
  final String? returnNote;
  final String? paymentStatus;
  final String? paidAmount;
  final String? pos;
  final String? status;
  final String? returnBit;
  final String? couponId;
  final String? couponAmt;
  final String? appOrder;
  final String? orderId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SalesReturnRecord({
    required this.id,
    this.storeId,
    this.countId,
    this.salesId,
    this.warehouseId,
    this.returnCode,
    this.referenceNo,
    this.returnDate,
    this.returnStatus,
    this.customerId,
    this.otherChargesInput,
    this.otherChargesTaxId,
    this.otherChargesAmt,
    this.discountToAllInput,
    this.discountToAllType,
    this.totDiscountToAllAmt,
    this.subtotal,
    this.roundOff,
    this.grandTotal,
    this.returnNote,
    this.paymentStatus,
    this.paidAmount,
    this.pos,
    this.status,
    this.returnBit,
    this.couponId,
    this.couponAmt,
    this.appOrder,
    this.orderId,
    this.customerEmail,
    this.customerName,
    this.customerPhone,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SalesReturnRecord.fromJson(Map<String, dynamic> json) {
    return SalesReturnRecord(
      id: json['id'],
      storeId: json['store_id'],
      countId: json['count_id'],
      salesId: json['sales_id'],
      warehouseId: json['warehouse_id'],
      returnCode: json['return_code'],
      referenceNo: json['reference_no'],
      returnDate: json['return_date'],
      returnStatus: json['return_status'],
      customerId: json['customer_id'],
      otherChargesInput: json['other_charges_input'],
      otherChargesTaxId: json['other_charges_tax_id'],
      otherChargesAmt: json['other_charges_amt'],
      discountToAllInput: json['discount_to_all_input'],
      discountToAllType: json['discount_to_all_type'],
      totDiscountToAllAmt: json['tot_discount_to_all_amt'],
      subtotal: json['subtotal'],
      roundOff: json['round_off'],
      grandTotal: json['grand_total']?.toString(),
      returnNote: json['return_note'],
      paymentStatus: json['payment_status'],
      paidAmount: json['paid_amount']?.toString(),
      pos: json['pos'],
      status: json['status'],
      returnBit: json['return_bit'],
      couponId: json['coupon_id'],
      couponAmt: json['coupon_amt'],
      appOrder: json['app_order'],
      orderId: json['order_id'],
      customerEmail: json['customer_email'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class SalesReturnTotals {
  final int totalReturnCount;
  final num totalReturnAmount;
  final num balanceDue;

  SalesReturnTotals({
    required this.totalReturnCount,
    required this.totalReturnAmount,
    required this.balanceDue,
  });

  factory SalesReturnTotals.fromJson(Map<String, dynamic> json) {
    return SalesReturnTotals(
      totalReturnCount: json['total_return_count'] ?? 0,
      totalReturnAmount:
          num.tryParse(json['total_return_amount'].toString()) ?? 0,
      balanceDue: num.tryParse(json['balance_due'].toString()) ?? 0,
    );
  }
}

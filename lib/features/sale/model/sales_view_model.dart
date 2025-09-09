// Plain Dart model for SalesViewModel
class SalesViewModel {
  final String? message;
  final List<SingleSalesItem>? data;
  final int? status;

  SalesViewModel({this.message, this.data, this.status});

  factory SalesViewModel.fromJson(Map<String, dynamic> json) {
    return SalesViewModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SingleSalesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
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

// Plain Dart model for SingleSalesItem
class SingleSalesItem {
  final int? id;
  final String? storeId;
  final String? warehouseId;
  final String? initCode;
  final String? countId;
  final String? salesCode;
  final String? referenceNo;
  final String? salesDate;
  final String? dueDate;
  final String? salesStatus;
  final String? customerId;
  final String? otherChargesInput;
  final String? otherChargesTaxId;
  final String? otherChargesAmt;
  final dynamic discountToAllInput;
  final dynamic discountToAllType;
  final String? totDiscountToAllAmt;
  final String? subtotal;
  final String? roundOff;
  final String? grandTotal;
  final String? salesNote;
  final String? paymentStatus;
  final String? paidAmount;
  final String? companyId;
  final String? pos;
  final dynamic returnBit;
  final dynamic customerPreviousDue;
  final dynamic customerTotalDue;
  final dynamic quotationId;
  final dynamic couponId;
  final dynamic couponAmt;
  final dynamic invoiceTerms;
  final String? status;
  final String? appOrder;
  final String? orderId;
  final String? taxReport;
  final dynamic createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SingleSalesItem({
    this.id,
    this.storeId,
    this.warehouseId,
    this.initCode,
    this.countId,
    this.salesCode,
    this.referenceNo,
    this.salesDate,
    this.dueDate,
    this.salesStatus,
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
    this.salesNote,
    this.paymentStatus,
    this.paidAmount,
    this.companyId,
    this.pos,
    this.returnBit,
    this.customerPreviousDue,
    this.customerTotalDue,
    this.quotationId,
    this.couponId,
    this.couponAmt,
    this.invoiceTerms,
    this.status,
    this.appOrder,
    this.orderId,
    this.taxReport,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleSalesItem.fromJson(Map<String, dynamic> json) {
    return SingleSalesItem(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      warehouseId: json['warehouse_id'] as String?,
      initCode: json['init_code'] as String?,
      countId: json['count_id'] as String?,
      salesCode: json['sales_code'] as String?,
      referenceNo: json['reference_no'] as String?,
      salesDate: json['sales_date'] as String?,
      dueDate: json['due_date'] as String?,
      salesStatus: json['sales_status'] as String?,
      customerId: json['customer_id'] as String?,
      otherChargesInput: json['other_charges_input'] as String?,
      otherChargesTaxId: json['other_charges_tax_id'] as String?,
      otherChargesAmt: json['other_charges_amt'] as String?,
      discountToAllInput: json['discount_to_all_input'],
      discountToAllType: json['discount_to_all_type'],
      totDiscountToAllAmt: json['tot_discount_to_all_amt'] as String?,
      subtotal: json['subtotal'] as String?,
      roundOff: json['round_off'] as String?,
      grandTotal: json['grand_total'] as String?,
      salesNote: json['sales_note'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paidAmount: json['paid_amount'] as String?,
      companyId: json['company_id'] as String?,
      pos: json['pos'] as String?,
      returnBit: json['return_bit'],
      customerPreviousDue: json['customer_previous_due'],
      customerTotalDue: json['customer_total_due'],
      quotationId: json['quotation_id'],
      couponId: json['coupon_id'],
      couponAmt: json['coupon_amt'],
      invoiceTerms: json['invoice_terms'],
      status: json['status'] as String?,
      appOrder: json['app_order'] as String?,
      orderId: json['order_id'] as String?,
      taxReport: json['tax_report'] as String?,
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'warehouse_id': warehouseId,
      'init_code': initCode,
      'count_id': countId,
      'sales_code': salesCode,
      'reference_no': referenceNo,
      'sales_date': salesDate,
      'due_date': dueDate,
      'sales_status': salesStatus,
      'customer_id': customerId,
      'other_charges_input': otherChargesInput,
      'other_charges_tax_id': otherChargesTaxId,
      'other_charges_amt': otherChargesAmt,
      'discount_to_all_input': discountToAllInput,
      'discount_to_all_type': discountToAllType,
      'tot_discount_to_all_amt': totDiscountToAllAmt,
      'subtotal': subtotal,
      'round_off': roundOff,
      'grand_total': grandTotal,
      'sales_note': salesNote,
      'payment_status': paymentStatus,
      'paid_amount': paidAmount,
      'company_id': companyId,
      'pos': pos,
      'return_bit': returnBit,
      'customer_previous_due': customerPreviousDue,
      'customer_total_due': customerTotalDue,
      'quotation_id': quotationId,
      'coupon_id': couponId,
      'coupon_amt': couponAmt,
      'invoice_terms': invoiceTerms,
      'status': status,
      'app_order': appOrder,
      'order_id': orderId,
      'tax_report': taxReport,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

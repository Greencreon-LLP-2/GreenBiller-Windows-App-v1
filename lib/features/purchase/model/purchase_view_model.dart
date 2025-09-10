class PurchaseViewModel {
  final String? message;
  final List<SinglePurchaseData>? data;
  final int? status;

  PurchaseViewModel({this.message, this.data, this.status});

  factory PurchaseViewModel.fromJson(Map<String, dynamic> json) {
    return PurchaseViewModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SinglePurchaseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );
  }
}

class SinglePurchaseData {
  final int? id;
  final String? storeId;
  final String? warehouseId;
  final dynamic countId;
  final String? purchaseCode;
  final String? referenceNo;
  final dynamic serialNo;
  final DateTime? purchaseDate;
  final String? supplierId;
  final dynamic otherChargesInput;
  final dynamic otherChargesTaxId;
  final dynamic otherChargesAmt;
  final dynamic discountToAllInput;
  final dynamic discountToAllType;
  final String? totDiscountToAllAmt;
  final String? subtotal;
  final dynamic unit;
  final String? roundOff;
  final String? grandTotal;
  final String? purchaseNote;
  final String? paymentStatus;
  final String? paidAmount;
  final String? companyId;
  final String? status;
  final String? returnBit;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SinglePurchaseData({
    this.id,
    this.storeId,
    this.warehouseId,
    this.countId,
    this.purchaseCode,
    this.referenceNo,
    this.serialNo,
    this.purchaseDate,
    this.supplierId,
    this.otherChargesInput,
    this.otherChargesTaxId,
    this.otherChargesAmt,
    this.discountToAllInput,
    this.discountToAllType,
    this.totDiscountToAllAmt,
    this.subtotal,
    this.unit,
    this.roundOff,
    this.grandTotal,
    this.purchaseNote,
    this.paymentStatus,
    this.paidAmount,
    this.companyId,
    this.status,
    this.returnBit,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SinglePurchaseData.fromJson(Map<String, dynamic> json) {
    return SinglePurchaseData(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      warehouseId: json['warehouse_id'] as String?,
      countId: json['count_id'],
      purchaseCode: json['purchase_code'] as String?,
      referenceNo: json['reference_no'] as String?,
      serialNo: json['serial_no'],
      purchaseDate: json['purchase_date'] != null
          ? DateTime.tryParse(json['purchase_date'])
          : null,
      supplierId: json['supplier_id'] as String?,
      otherChargesInput: json['other_charges_input'],
      otherChargesTaxId: json['other_charges_tax_id'],
      otherChargesAmt: json['other_charges_amt'],
      discountToAllInput: json['discount_to_all_input'],
      discountToAllType: json['discount_to_all_type'],
      totDiscountToAllAmt: json['tot_discount_to_all_amt'] as String?,
      subtotal: json['subtotal'] as String?,
      unit: json['unit'],
      roundOff: json['round_off'] as String?,
      grandTotal: json['grand_total'] as String?,
      purchaseNote: json['purchase_note'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paidAmount: json['paid_amount'] as String?,
      companyId: json['company_id'] as String?,
      status: json['status'] as String?,
      returnBit: json['return_bit'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

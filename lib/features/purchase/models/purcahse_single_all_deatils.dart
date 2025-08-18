class PurcahseSingleAllDeatils {
  final int id;
  final String? userId;
  final String? storeId;
  final String? storeName;
  final String? warehouseId;
  final String? warehouseName;
  final String? purchaseCode;
  final String? referenceNo;
  final String? purchaseDate;
  final String? supplierId;
  final String? supplierName;
  final String? subtotal;
  final String? roundOff;
  final String? grandTotal;
  final String? purchaseNote;
  final String? paymentStatus;
  final String? paidAmount;
  final String? companyId;
  final String? status;
  final String? returnBit;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final List<PurchaseItem> items;
  final List<PurchasePayment> payments;

  PurcahseSingleAllDeatils({
    required this.id,
    this.userId,
    this.storeId,
    this.storeName,
    this.warehouseId,
    this.warehouseName,
    this.purchaseCode,
    this.referenceNo,
    this.purchaseDate,
    this.supplierId,
    this.supplierName,
    this.subtotal,
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
    required this.items,
    required this.payments,
  });

  factory PurcahseSingleAllDeatils.fromJson(Map<String, dynamic> json) {
    return PurcahseSingleAllDeatils(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString(),
      storeId: json['store_id']?.toString(),
      warehouseId: json['warehouse_id']?.toString(),
      purchaseCode: json['purchase_code']?.toString(),
      referenceNo: json['reference_no']?.toString(),
      purchaseDate: json['purchase_date']?.toString(),
      supplierId: json['supplier_id']?.toString(),
      subtotal: json['subtotal']?.toString(),
      roundOff: json['round_off']?.toString(),
      grandTotal: json['grand_total']?.toString(),
      purchaseNote: json['purchase_note']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      paidAmount: json['paid_amount']?.toString() ?? '0',
      companyId: json['company_id']?.toString(),
      status: json['status']?.toString(),
      returnBit: json['return_bit']?.toString(),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      supplierName: json['supplier']?['supplier_name']?.toString(),
      warehouseName: json['warehouse']?['warehouse_name']?.toString(),
      storeName: json['store']?['store_name']?.toString(),
      items: (json['items'] as List?)
              ?.map((item) => PurchaseItem.fromJson(item))
              .toList() ??
          [],
      payments: (json['payments'] as List?)
              ?.map((payment) => PurchasePayment.fromJson(payment))
              .toList() ??
          [],
    );
  }
}

class PurchasePayment {
  final int id;
  final String? paymentCode;
  final String? storeId;
  final String? purchaseId;
  final String? paymentDate;
  final String? paymentType;
  final String? payment;
  final String? paymentNote;
  final String? status;
  final String? accountId;
  final String? supplierId;
  final String? createdAt;
  final String? updatedAt;

  PurchasePayment({
    required this.id,
    this.paymentCode,
    this.storeId,
    this.purchaseId,
    this.paymentDate,
    this.paymentType,
    this.payment,
    this.paymentNote,
    this.status,
    this.accountId,
    this.supplierId,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchasePayment.fromJson(Map<String, dynamic> json) {
    return PurchasePayment(
      id: json['id'] ?? 0,
      paymentCode: json['payment_code']?.toString(),
      storeId: json['store_id']?.toString(),
      purchaseId: json['purchase_id']?.toString(),
      paymentDate: json['payment_date']?.toString(),
      paymentType: json['payment_type']?.toString(),
      payment: json['payment']?.toString(),
      paymentNote: json['payment_note']?.toString(),
      status: json['status']?.toString(),
      accountId: json['account_id']?.toString(),
      supplierId: json['supplier_id']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class PurchaseItem {
  final String? id;
  final String? userId;
  final String? storeId;
  final String? purchaseId;
  final String? purchaseStatus;
  final String? itemId;
  final String? itemName;
  final String? barCode;
  final String? purchaseQty;
  final String? pricePerUnit;
  final String? taxType;
  final String? taxId;
  final String? taxAmt;
  final String? discountType;
  final String? discountInput;
  final String? discountAmt;
  final String? unitTotalCost;
  final String? totalCost;
  final String? profitMarginPer;
  final String? unit;
  final String? unitSalesPrice;
  final String? stock;
  final String? ifBatch;
  final String? batchNo;
  final String? ifExpiryDate;
  final String? expireDate;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  PurchaseItem({
    this.id,
    this.userId,
    this.storeId,
    this.purchaseId,
    this.purchaseStatus,
    this.itemId,
    this.itemName,
    this.barCode,
    this.purchaseQty,
    this.pricePerUnit,
    this.taxType,
    this.taxId,
    this.taxAmt,
    this.discountType,
    this.discountInput,
    this.discountAmt,
    this.unitTotalCost,
    this.totalCost,
    this.profitMarginPer,
    this.unit,
    this.unitSalesPrice,
    this.stock,
    this.ifBatch,
    this.batchNo,
    this.ifExpiryDate,
    this.expireDate,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      id: json['id']?.toString(),
      userId: json['user_id']?.toString(),
      storeId: json['store_id'],
      purchaseId: json['purchase_id'],
      purchaseStatus: json['purchase_status'],
      itemId: json['item_id'],
      itemName: json['item']['item_name'],
      barCode: json['bar_code'],
      purchaseQty: json['purchase_qty'],
      pricePerUnit: json['price_per_unit'],
      taxType: json['tax_type'],
      taxId: json['tax_id'],
      taxAmt: json['tax_amt'],
      discountType: json['discount_type'],
      discountInput: json['discount_input'],
      discountAmt: json['discount_amt'],
      unitTotalCost: json['unit_total_cost'],
      totalCost: json['total_cost'],
      profitMarginPer: json['profit_margin_per'],
      unit: json['unit'],
      unitSalesPrice: json['unit_sales_price'],
      stock: json['stock'],
      ifBatch: json['if_batch'],
      batchNo: json['batch_no'],
      ifExpiryDate: json['if_expirydate'],
      expireDate: json['expire_date'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_id': storeId,
      'purchase_id': purchaseId,
      'purchase_status': purchaseStatus,
      'item_id': itemId,
      'item_name': itemName,
      'bar_code': barCode,
      'purchase_qty': purchaseQty,
      'price_per_unit': pricePerUnit,
      'tax_type': taxType,
      'tax_id': taxId,
      'tax_amt': taxAmt,
      'discount_type': discountType,
      'discount_input': discountInput,
      'discount_amt': discountAmt,
      'unit_total_cost': unitTotalCost,
      'total_cost': totalCost,
      'profit_margin_per': profitMarginPer,
      'unit': unit,
      'unit_sales_price': unitSalesPrice,
      'stock': stock,
      'if_batch': ifBatch,
      'batch_no': batchNo,
      'if_expirydate': ifExpiryDate,
      'expire_date': expireDate,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

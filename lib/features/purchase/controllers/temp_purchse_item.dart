class TempPurchaseItem {
  final String userId;
  final String purchaseId;
  final String itemId;
  final String purchaseQty;
  final String pricePerUnit;
  final String taxName;
  final String taxId;
  final String taxAmount;
  final String discountType;
  final String discountAmount;
  final String totalCost;
  final String batchNo;
  final String barcode;
  final String itemName;
  final String unitSalesPrice;
  final String unit;

  TempPurchaseItem({
    required this.userId,
    required this.purchaseId,
    required this.itemId,
    required this.purchaseQty,
    required this.pricePerUnit,
    required this.taxName,
    required this.taxId,
    required this.taxAmount,
    required this.discountType,
    required this.discountAmount,
    required this.totalCost,
    required this.batchNo,
    required this.barcode,
    required this.itemName,
    required this.unitSalesPrice,
    required this.unit,
  });
}

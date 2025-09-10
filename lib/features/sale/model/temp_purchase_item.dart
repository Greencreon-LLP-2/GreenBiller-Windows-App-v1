// TempPurchaseItem Model
class TempPurchaseItem {
  final String customerId;
  final String purchaseId;
  final String itemId;
  final String itemName;
  final String pricePerUnit;
  final String taxName;
  final String taxId;
  final String taxAmount;
  final String discountType;
  final String discountAmount;
  final String unit;
  final String taxRate;
  final String barcode;
  String purchaseQty;
  String totalCost;
  String serialNumbers;
  String batchNo;
  TempPurchaseItem({
    required this.customerId,
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
    required this.unit,
    required this.taxRate,
    required this.batchNo,
    required this.barcode,
    required this.itemName,
    required this.serialNumbers,
  });
}

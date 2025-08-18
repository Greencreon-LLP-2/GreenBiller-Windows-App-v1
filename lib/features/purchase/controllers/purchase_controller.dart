import 'package:green_biller/features/purchase/services/purchase_service.dart';

class PurchaseController {
  final String accessToken;
  final String userId;
  final String storeId;
  final String warehouseId;
  final String purchaseCode;
  final String referenceNo;
  final String purchaseDate;
  final String supplierId;

  final String otherHrgeAmt;

  final String totDiscountToAllAmt;
  final String subtotal;

  final String grandTotal;
  final String purchaseNote;

  final String paidAmount;

  PurchaseController({
    required this.accessToken,
    required this.userId,
    required this.storeId,
    required this.warehouseId,
    required this.purchaseCode,
    required this.referenceNo,
    required this.purchaseDate,
    required this.supplierId,
    required this.otherHrgeAmt,
    required this.totDiscountToAllAmt,
    required this.subtotal,
    required this.grandTotal,
    required this.purchaseNote,
    required this.paidAmount,
  });

  Future<String> purchaseController() async {
    try {
      final response = await PurchaseService(
        accessToken: accessToken,
        userId: userId,
        storeId: storeId,
        warehouseId: warehouseId,
        purchaseCode: purchaseCode,
        referenceNo: referenceNo,
        purchaseDate: purchaseDate,
        supplierId: supplierId,
        otherHrgeAmt: otherHrgeAmt,
        totDiscountToAllAmt: totDiscountToAllAmt,
        subtotal: subtotal,
        grandTotal: grandTotal,
        purchaseNote: purchaseNote,
        paidAmount: paidAmount,
      ).purchaseService();

      if (response != "Purchase failed") {
        return response;
      } else {
        return "Purchase failed";
      }
    } catch (e) {
      return e.toString();
    }
  }
}

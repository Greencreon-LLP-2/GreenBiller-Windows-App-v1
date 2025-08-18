import 'package:green_biller/features/sales/service/sales_create_service.dart';

class SalesCreateController {
  final String accessToken;
  final String storeId;
  final String warehouseId;
  final String referenceNo;
  final String salesDate;
  final String customerId;
  final String otherChargesAmt;
  final String discountAmt;
  final String subTotal;
  final String grandTotal;
  final String salesNote;
  final String paidAmount;
  final String orderId;

  SalesCreateController({
    required this.accessToken,
    required this.storeId,
    required this.warehouseId,
    required this.referenceNo,
    required this.salesDate,
    required this.customerId,
    required this.otherChargesAmt,
    required this.discountAmt,
    required this.subTotal,
    required this.grandTotal,
    required this.salesNote,
    required this.paidAmount,
    required this.orderId,
  });

  Future<String> createSalesController() async {
    try {
      final response = await SalesCreateService(
        accessToken: accessToken,
        storeId: storeId,
        warehouseId: warehouseId,
        referenceNo: referenceNo,
        salesDate: salesDate,
        customerId: customerId,
        otherChargesAmt: otherChargesAmt,
        discountAmt: discountAmt,
        subTotal: subTotal,
        grandTotal: grandTotal,
        salesNote: salesNote,
        paidAmount: paidAmount,
        orderId: orderId,
      ).createSales();
      if (response != "sales failed") {
        return response;
      } else {
        return "Sales creation failed. Please try again.";
      }
    } catch (e) {
      return e.toString();
    }
  }
}

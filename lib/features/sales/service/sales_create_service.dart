import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/main.dart';
import 'package:http/http.dart' as http;

class SalesCreateService {
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

  SalesCreateService({
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

  Future<String> createSales() async {
    try {
      final response = await http.post(
        Uri.parse(createSalesUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "store_id": storeId,
          "warehouse_id": warehouseId,
          "reference_no": referenceNo,
          "sales_date": salesDate,
          "customer_id": customerId,
          "other_charges_amt": otherChargesAmt,
          "discount_amt": discountAmt,
          "subtotal": subTotal,
          "grand_total": grandTotal,
          "sales_note": salesNote,
          "paid_amount": paidAmount,
          "order_id": orderId,
          "status": "1",
          "app_order": "1",
          "tax_report": "0",
        },
      );
      if (response.statusCode == 201) {
        logger.e("${jsonDecode(response.body)["message"]}");
        final salesId = jsonDecode(response.body)["data"]["id"];
        return salesId.toString();
      } else {
        logger.e("Sales creation failed: ${response.body}");
        logger.e("Status Code: ${response.statusCode}");
        return "sales failed";
      }
    } catch (e) {
      return e.toString();
    }
  }
}

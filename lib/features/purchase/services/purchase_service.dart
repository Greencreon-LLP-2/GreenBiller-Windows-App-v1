import 'dart:convert';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class PurchaseService {
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

  PurchaseService({
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

  Future<String> purchaseService() async {
    try {
      final response = await http.post(Uri.parse(createPurchaseUrl), headers: {
        "Authorization": "Bearer $accessToken",
      }, body: {
        'store_id': storeId,
        'warehouse_id': warehouseId,
        'count_id': '',
        'purchase_code': purchaseCode,
        'reference_no': referenceNo,
        'purchase_date': purchaseDate,
        'supplier_id': supplierId,
        'other_charges_input': "",
        'other_charges_tax_id': "",
        'other_hrge_amt': otherHrgeAmt.toString(),
        'discount_to_all_input': "",
        'discount_to_all_type': "",
        'tot_discount_to_all_amt': totDiscountToAllAmt.toString(),
        'subtotal': subtotal.toString(),
        'round_off': '0',
        'grand_total': grandTotal.toString(),
        'purchase_note': purchaseNote,
        'payment_status': '1',
        'paid_amount': paidAmount.toString(),
        'company_id': '1',
        'status': '1',
        'return_bit': '1',
        'created_by': '0'
      });
      final decodeResponse = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final purchaseId = decodeResponse["data"]['id'];
        return purchaseId != null ? purchaseId.toString() : "Purchase failed";
      } else {
        return "Purchase failed";
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

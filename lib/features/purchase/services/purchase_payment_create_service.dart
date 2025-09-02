import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class PurchasePaymentCreateService {
  final String accessToken;
  final String userId;
  final String purchaseId;
  final String storeId;
  final String paymentMethod;
  final String paymentAmount;
  final String paymentDate;
  final String supplierId;
  final String paymentNote;

  PurchasePaymentCreateService({
    required this.accessToken,
    required this.userId,
    required this.purchaseId,
    required this.storeId,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.paymentDate,
    required this.supplierId,
    required this.paymentNote,
  });

  Future<bool> purchaseCreatePaymentService() async {
    try {
      final response = await http.post(
        Uri.parse(purchasePaymentCreateUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          "payment_code": "123",
          "store_id": storeId,
          "purchase_id": purchaseId,
          "payment_date": paymentDate,
          "payment_type": paymentMethod,
          "payment": paymentAmount,
          "payment_note": paymentNote,
          "account_id": "1",
          "supplier_id": supplierId,
          // Additional payment data if needed
        },
      );
      if (response.statusCode == 201) {
        log("Payment created successfully");
        return true;
      } else {
        log("Failed to create payment: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error creating payment: $e");
      return false;
      // Handle error appropriately
    }
    // Implement the payment creation logic here
  }
}

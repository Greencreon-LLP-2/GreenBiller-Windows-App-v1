import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_biller/features/purchase/services/purchase_payment_create_service.dart';

class PaymentCreateController {
  final String accessToken;
  final String userId;
  final String purchaseId;
  final String storeId;
  final String paymentMethod;
  final String paymentAmount;
  final String paymentDate;
  final String supplierId;
  final String paymentNote;

  PaymentCreateController({
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

  Future<bool> purchasePaymentCroller(context) async {
    try {
      final response = await PurchasePaymentCreateService(
        accessToken: accessToken,
        userId: userId,
        purchaseId: purchaseId,
        storeId: storeId,
        paymentMethod: paymentMethod,
        paymentAmount: paymentAmount,
        paymentDate: paymentDate,
        supplierId: supplierId,
        paymentNote: paymentNote,
      ).purchaseCreatePaymentService();

      if (response) {
        log("Payment created successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Purchase created successfully"),
              backgroundColor: Colors.green),
        );
        // context.pop();
        return true;
      } else {
        log("Failed to create payment");
        return false;
      }
    } catch (e) {
      log("Error creating payment: $e");
      return false;
    }
  }
}

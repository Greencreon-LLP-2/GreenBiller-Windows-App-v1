import 'package:flutter/material.dart';
import 'package:green_biller/features/reports/purchase_report/models/purchase_summary/purchase_summary_model.dart';
import 'package:green_biller/features/reports/purchase_report/service/purchase_summary_service.dart';

class PurchaseSummaryController {
  Future<PurchaseSummaryModel> getPurchaseSummaryController(String accessToken,
      String startDate, String endDate, BuildContext context) async {
    try {
      final response = await PurchaseSummaryService()
          .getPurchaseSummaryService(accessToken, startDate, endDate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchase summary generated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}

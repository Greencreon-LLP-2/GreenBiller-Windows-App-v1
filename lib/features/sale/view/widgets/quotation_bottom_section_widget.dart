
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/sale/controller/quatation_controller.dart';

class QuotationBottomSectionWidget extends StatelessWidget {
  final QuotationController controller;

  const QuotationBottomSectionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              Text(
                '₹${controller.tempSubTotal.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

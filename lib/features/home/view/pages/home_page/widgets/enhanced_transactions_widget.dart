import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/transaction_card_widget.dart';

class EnhancedTransactionsWidget extends StatelessWidget {
  final bool isPhone;
  final bool is7inch;
  final bool is10inch;

  const EnhancedTransactionsWidget({
    super.key,
    required this.isPhone,
    required this.is7inch,
    required this.is10inch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isPhone
            ? 400
            : is7inch
                ? 500
                : double.infinity, // Full height for 10-inch
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: isPhone
            ? 4
            : is7inch
                ? 6
                : 8, // More items for 10-inch
        separatorBuilder: (context, index) => SizedBox(
          height: isPhone ? 8 : 12,
        ),
        itemBuilder: (context, index) {
          final statuses = [
            TransactionStatus.completed,
            TransactionStatus.pending,
            TransactionStatus.failed,
            TransactionStatus.completed,
            TransactionStatus.completed,
            TransactionStatus.failed,
            TransactionStatus.completed,
            TransactionStatus.pending,
          ];

          return TransactionCardWidget(
            invoiceNumber: "INV-${1234 + index}",
            date: "23 Dec, 2024",
            amount: "₹${25450 + (index * 1000)}",
            dueAmount: index == 1 ? "₹5,450" : "₹0",
            customerName: "Customer ${index + 1}",
            status: statuses[index],
          );
        },
      ),
    );
  }
}

enum TransactionStatus {
  completed(
    icon: Icons.check_circle_outline,
    color: successColor,
    progress: 1.0,
  ),
  pending(
    icon: Icons.pending_outlined,
    color: warningColor,
    progress: 0.5,
  ),
  failed(
    icon: Icons.error_outline,
    color: errorColor,
    progress: 0.0,
  );

  final IconData icon;
  final Color color;
  final double progress;

  const TransactionStatus({
    required this.icon,
    required this.color,
    required this.progress,
  });
}

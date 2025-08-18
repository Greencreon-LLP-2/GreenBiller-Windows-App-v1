import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';

class PaymentOutPage extends StatelessWidget {
  const PaymentOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  'Payment Out',
                  style: AppTextStyles.h2.copyWith(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement new payment out
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('New Payment'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Summary Cards
            Row(
              children: [
                _buildSummaryCard(
                  title: 'Total Payments',
                  amount: '\$12,450.00',
                  icon: Icons.payments_outlined,
                  color: accentColor,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  title: 'Pending',
                  amount: '\$2,150.00',
                  icon: Icons.pending_actions,
                  color: warningColor,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  title: 'Completed',
                  amount: '\$10,300.00',
                  icon: Icons.check_circle_outline,
                  color: successColor,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and Filter Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search payments...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: backgroundColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'all',
                        child: Text('All Payments'),
                      ),
                      const PopupMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      const PopupMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payments Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 48), // For actions
                        ],
                      ),
                    ),

                    // Table Body
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10, // Example count
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Payment to Supplier ${index + 1}',
                                    style: const TextStyle(
                                      color: textPrimaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '\$${(index + 1) * 1000}.00',
                                    style: const TextStyle(
                                      color: textPrimaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '2024-03-${index + 1}',
                                    style: const TextStyle(
                                      color: textSecondaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? successColor.withOpacity(0.1)
                                          : warningColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      index % 2 == 0 ? 'Completed' : 'Pending',
                                      style: TextStyle(
                                        color: index % 2 == 0
                                            ? successColor
                                            : warningColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    // TODO: Show payment actions
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: AppTextStyles.h3.copyWith(
                color: textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

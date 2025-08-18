import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/payment/view/pages/payment_in_page/payment_in_page.dart';

class PaymentIn extends StatelessWidget {
  const PaymentIn({super.key});

  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color iconColor, {
    bool isNegative = false,
  }) {
    return Expanded(
      child: CardContainer(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isNegative ? errorColor : textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today, size: 16, color: accentColor),
          SizedBox(width: 8),
          Text(
            "This Month",
            style: TextStyle(
              color: textPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_drop_down, size: 20, color: accentColor),
        ],
      ),
    );
  }

  Widget _buildTransactionTable(BuildContext context) {
    final transactions = [
      {
        "name": "test-124",
        "date": "01/01/2025",
        "payIn": "PayIn : 2",
        "amount": "123.00",
        "status": "Pending"
      },
      {
        "name": "ftg",
        "date": "01/01/2025",
        "payIn": "PayIn : 3",
        "amount": "885.00",
        "status": "Completed"
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 170,
        horizontalMargin: 40,
        headingRowHeight: 60,
        dataRowHeight: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        headingTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        columns: const [
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('PayIn ID')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: transactions.asMap().entries.map((entry) {
          final index = entry.key;
          final transaction = entry.value;
          final isEven = index % 2 == 0;

          return DataRow(
            color: MaterialStateProperty.all(
              isEven ? const Color(0xFFFAFAFA) : Colors.white,
            ),
            cells: [
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          transaction["name"]!.split('-')[0][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      transaction["name"]!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  transaction["date"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    transaction["payIn"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ),
              DataCell(
                Text(
                  "₹${transaction["amount"]!}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: transaction["status"] == "Completed"
                        ? successColor.withOpacity(0.1)
                        : warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: transaction["status"] == "Completed"
                          ? successColor.withOpacity(0.3)
                          : warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: transaction["status"] == "Completed"
                              ? successColor
                              : warningColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        transaction["status"]!,
                        style: TextStyle(
                          color: transaction["status"] == "Completed"
                              ? successColor
                              : warningColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: accentColor,
                        onPressed: () {},
                        tooltip: 'Edit Payment',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: errorColor,
                        onPressed: () {},
                        tooltip: 'Delete Payment',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = isDesktop ? (screenWidth - 80) / 4 : screenWidth - 32;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'All Payments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {},
                tooltip: 'Filter',
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.white),
                onPressed: () {},
                tooltip: 'Export',
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
                tooltip: 'Search',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildSummaryCard(
                  "Total Payment-In",
                  "₹1,008.00",
                  Icons.account_balance_wallet,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Balance Due",
                  "₹1,008.00",
                  Icons.payment,
                  errorColor,
                  isNegative: true,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Average Payment",
                  "₹504.00",
                  Icons.trending_up,
                  successColor,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Pending Payments",
                  "2",
                  Icons.pending_actions,
                  warningColor,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildQuickActionButton(
                  "Add Payment",
                  Icons.add,
                  accentColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentInPage()),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildQuickActionButton(
                  "Filter",
                  Icons.filter_list,
                  accentColor,
                  () {},
                ),
                const SizedBox(width: 12),
                _buildQuickActionButton(
                  "Export",
                  Icons.download,
                  accentColor,
                  () {},
                ),
                const Spacer(),
                _buildDateFilter(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CardContainer(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFF1F5F9)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Records',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '2 records',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _buildTransactionTable(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

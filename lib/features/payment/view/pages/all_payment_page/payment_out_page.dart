import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/payment/controller/payment_data_providers.dart';
import 'package:green_biller/features/payment/view/pages/payment_in_page/add_payment_in_page.dart';
import 'package:green_biller/features/payment/view/pages/payment_out_page/add_payment_out_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentOutPage extends ConsumerWidget {
  const PaymentOutPage({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = isDesktop ? (screenWidth - 80) / 4 : screenWidth - 32;
    final paymentsAsync = ref.watch(paymentOutProvider(null));
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
              'All Payments out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPaymentOutPage()),
                  );
                },
                tooltip: 'Add New Payment-out',
              ),
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
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => ref.refresh(paymentOutProvider(null)),
                tooltip: 'Refresh',
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
                          builder: (context) => const AddPaymentOutPage()),
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
                  // Header with record count
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
                          'Payment out Records',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        paymentsAsync.when(
                          data: (payments) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${payments.length} records',
                              style: const TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          loading: () => const Text("..."),
                          error: (_, __) => const Text("0 records"),
                        ),
                      ],
                    ),
                  ),

                  // Payment list
                  Expanded(
                    child: paymentsAsync.when(
                      data: (payments) {
                        if (payments.isEmpty) {
                          return const Center(
                            child: Text(
                              "No payment out records found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: payments.length,
                          itemBuilder: (context, index) {
                            final payment =
                                payments[index] as Map<String, dynamic>;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: const Icon(Icons.payments,
                                    color: Colors.orange),
                                title: Text(
                                  "Payment Code: ${payment['payment_code'] ?? 'N/A'}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Supplier: ${payment['supplier_name'] ?? 'Unknown'}"),
                                    const SizedBox(height: 4),
                                    Text(
                                        "Amount: ₹${payment['payment']?.toString() ?? '0.00'}"),
                                    const SizedBox(height: 2),
                                    Text(
                                        "Type: ${payment['payment_type'] ?? 'N/A'}"),
                                    const SizedBox(height: 2),
                                    Text(
                                        "Date: ${payment['payment_date'] ?? 'N/A'}"),
                                    const SizedBox(height: 2),
                                    if (payment['purchase_ref'] != null)
                                      Text(
                                          "Purchase Ref: ${payment['purchase_ref']}"),
                                    const SizedBox(height: 2),
                                    if (payment['payment_note'] != null &&
                                        payment['payment_note']
                                            .toString()
                                            .isNotEmpty)
                                      Text("Note: ${payment['payment_note']}"),
                                    const SizedBox(height: 2),
                                    Text(
                                        "Status: ${payment['status'] == '1' ? 'Completed' : 'Pending'}"),
                                    const SizedBox(height: 2),
                                    if (payment['supplier_mobile'] != null)
                                      Text(
                                          "Mobile: ${payment['supplier_mobile']}"),
                                    if (payment['supplier_phone'] != null)
                                      Text(
                                          "Phone: ${payment['supplier_phone']}"),
                                    if (payment['supplier_email'] != null)
                                      Text(
                                          "Email: ${payment['supplier_email']}"),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹${payment['payment']?.toString() ?? '0.00'}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      payment['payment_date']
                                              ?.toString()
                                              .split(' ')[0] ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text(
                          'Error loading payments\n$err',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

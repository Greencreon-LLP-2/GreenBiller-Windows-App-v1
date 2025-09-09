import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/payment/controller/payment_controller.dart';
import 'package:greenbiller/features/payment/view/add_payment_in_page.dart';
import 'package:greenbiller/routes/app_routes.dart';

class AllPaymentInPage extends GetView<PaymentController> {
  const AllPaymentInPage({super.key});

  @override
  Widget build(BuildContext context) {

    // fetch when opened
    controller.switchPaymentType('in');
    controller.fetchPaymentsIn();

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
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'All Payments In',
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
                  // Navigate to AddPaymentInPage
                  Get.toNamed(AppRoutes.addPaymentIn);
                },
                tooltip: 'Add New Payment-In',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => controller.refreshCurrentPayments(),
                tooltip: 'Refresh',
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // 🔹 Statistics / Summary
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildSummaryCard(
                  "Total Payment-In",
                  "₹${controller.totalPaymentsIn.toStringAsFixed(2)}",
                  Icons.account_balance_wallet,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Net Cash Flow",
                  "₹${controller.netCashFlow.toStringAsFixed(2)}",
                  Icons.account_balance,
                  controller.netCashFlow >= 0 ? successColor : errorColor,
                  isNegative: controller.netCashFlow < 0,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Average Payment",
                  controller.paymentsIn.isNotEmpty
                      ? "₹${(controller.totalPaymentsIn / controller.paymentsIn.length).toStringAsFixed(2)}"
                      : "₹0.00",
                  Icons.trending_up,
                  successColor,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Pending Payments",
                  "${controller.paymentsIn.where((p) => p['status'] != '1').length}",
                  Icons.pending_actions,
                  warningColor,
                ),
              ],
            ),
          ),

          // 🔹 Search & Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by customer, amount, reference...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (query) {
                      controller.searchPayments(query, type: 'in');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () async {
                    final selected = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (selected != null) {
                      controller.paymentsIn.value =
                          controller.filterPaymentsByDate(
                        selected.start,
                        selected.end,
                        type: 'in',
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colors.white),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Payment list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingIn.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessageIn.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessageIn.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (controller.paymentsIn.isEmpty) {
                return const Center(
                  child: Text(
                    "No payment records found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshCurrentPayments(),
                child: ListView.builder(
                  itemCount: controller.paymentsIn.length,
                  itemBuilder: (context, index) {
                    final payment = controller.paymentsIn[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading:
                            const Icon(Icons.payments, color: Colors.green),
                        title: Text(
                          "Payment Code: ${payment['payment_code'] ?? 'N/A'}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Customer: ${payment['customer_name'] ?? ''}"),
                            Text("Store ID: ${payment['store_id'] ?? ''}"),
                            Text("Sale ID: ${payment['sales_id'] ?? ''}"),
                            Text("Type: ${payment['payment_type'] ?? ''}"),
                            Text("Amount: ${payment['payment'] ?? ''}"),
                            Text("Note: ${payment['payment_note'] ?? ''}"),
                            Text("Account ID: ${payment['account_id'] ?? ''}"),
                            Text("Status: ${payment['status'] ?? ''}"),
                          ],
                        ),
                        trailing: Text(
                          payment['payment_date'] ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

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
}

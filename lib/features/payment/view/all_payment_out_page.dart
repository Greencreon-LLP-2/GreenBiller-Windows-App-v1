import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/payment/controller/payment_controller.dart';
import 'package:greenbiller/routes/app_routes.dart';

class AllPaymentOutPage extends GetView<PaymentController> {
  const AllPaymentOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // fetch when opened
    controller.switchPaymentType('out');
    controller.fetchPaymentsOut();

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
              'All Payments Out',
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
                  Get.toNamed(AppRoutes.addPaymentOut);
                },
                tooltip: 'Add New Payment-Out',
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
                  "Total Payment-Out",
                  "₹${controller.totalPaymentsOut.toStringAsFixed(2)}",
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
                  controller.paymentsOut.isNotEmpty
                      ? "₹${(controller.totalPaymentsOut / controller.paymentsOut.length).toStringAsFixed(2)}"
                      : "₹0.00",
                  Icons.trending_up,
                  successColor,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  "Pending Payments",
                  "${controller.paymentsOut.where((p) => p['status'] != '1').length}",
                  Icons.pending_actions,
                  warningColor,
                ),
              ],
            ),
          ),

          // 🔹 Search & Date Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by supplier, amount, reference...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (query) {
                      controller.searchPayments(query, type: 'out');
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
                      controller.paymentsOut.value = controller
                          .filterPaymentsByDate(
                            selected.start,
                            selected.end,
                            type: 'out',
                          );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Payment list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingOut.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessageOut.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessageOut.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (controller.paymentsOut.isEmpty) {
                return const Center(
                  child: Text(
                    "No payment out records found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshCurrentPayments(),
                child: ListView.builder(
                  itemCount: controller.paymentsOut.length,
                  itemBuilder: (context, index) {
                    final payment = controller.paymentsOut[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading: const Icon(
                          Icons.payments,
                          color: Colors.orange,
                        ),
                        title: Text(
                          "Payment Code: ${payment['payment_code'] ?? 'N/A'}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Purcahse ID: ${payment['purchase_id'] ?? ''}"),
                            Text("Supplier: ${payment['supplier_name'] ?? ''}"),
                            Text("Store ID: ${payment['store_id'] ?? ''}"),
                            Text(
                              "Purchase Ref: ${payment['purchase_ref'] ?? ''}",
                            ),
                              
                            Text("Type: ${payment['payment_type'] ?? ''}"),
                            Text("Amount: ₹${payment['payment'] ?? ''}"),
                            Text("Note: ${payment['payment_note'] ?? ''}"),
                            Text("Account ID: ${payment['account_id'] ?? ''}"),
                            Text("Status: ${payment['status'] ?? ''}"),
                            if (payment['supplier_mobile'] != null)
                              Text("Mobile: ${payment['supplier_mobile']}"),
                            if (payment['supplier_phone'] != null)
                              Text("Phone: ${payment['supplier_phone']}"),
                            if (payment['supplier_email'] != null)
                              Text("Email: ${payment['supplier_email']}"),
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
                              payment['payment_date']?.toString().split(
                                    ' ',
                                  )[0] ??
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

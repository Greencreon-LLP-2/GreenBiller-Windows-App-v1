import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/sale/controller/sales_manage_controller.dart';
import 'package:greenbiller/features/sale/model/sales_view_model.dart';

class SalesViewPage extends GetView<SalesManageController> {
  SalesViewPage({super.key});

  final TextStyle _rowStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF1E293B),
    fontWeight: FontWeight.w500,
  );

  final TextStyle _tagStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: accentColor,
  );

  final TextStyle _paidStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF10B981),
    fontWeight: FontWeight.w500,
  );

  final TextStyle _totalStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1E293B),
  );
  final TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Color(0xFF475569),
  );
  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text('Sales Invoice No', style: _headerStyle),
          ),
          SizedBox(width: 120, child: Text('Date', style: _headerStyle)),
          SizedBox(width: 120, child: Text('Bill No', style: _headerStyle)),
          SizedBox(width: 120, child: Text('Customer', style: _headerStyle)),
          SizedBox(
            width: 120,
            child: Text('Sales Status', style: _headerStyle),
          ),
          SizedBox(width: 120, child: Text('Due Date', style: _headerStyle)),
          SizedBox(width: 120, child: Text('Subtotal', style: _headerStyle)),
          SizedBox(width: 120, child: Text('Paid', style: _headerStyle)),
          SizedBox(
            width: 120,
            child: Text('Payment Status', style: _headerStyle),
          ),
          SizedBox(width: 120, child: Text('Grand Total', style: _headerStyle)),
          SizedBox(width: 120, child: Text('Actions', style: _headerStyle)),
        ],
      ),
    );
  }

  Widget _buildTableRow(SingleSalesItem data, int index) {
    final isEven = index % 2 == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: isEven ? const Color(0xFFFAFAFA) : Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(data.id.toString(), style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Text(data.salesDate?.split(' ')[0] ?? '-', style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withOpacity(0.2)),
              ),
              child: Text(data.referenceNo ?? '-', style: _tagStyle),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(data.customerId ?? '-', style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Text(data.salesStatus ?? '-', style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Text(data.dueDate ?? '-', style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Text('₹${data.subtotal ?? '0.00'}', style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Text('₹${data.paidAmount ?? '0.00'}', style: _paidStyle),
          ),
          SizedBox(
            width: 120,
            child: Text(data.paymentStatus ?? '-', style: _rowStyle),
          ),
          SizedBox(
            width: 120,
            child: Text('₹${data.grandTotal ?? '0.00'}', style: _totalStyle),
          ),
          SizedBox(
            width: 120,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return CardContainer(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetView(VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: Color(0xFF64748B),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection and try again',
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onRetry,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: accentColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Retry',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Sales View',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Stats',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        if (controller.isLoading.value ||
                            controller.salesData.value == null) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: accentColor,
                            ),
                          );
                        }
                        final data = controller.salesData.value!.data ?? [];
                        final totalAmount = data.fold<double>(
                          0,
                          (sum, item) =>
                              sum +
                              (double.tryParse(item.grandTotal ?? '0') ?? 0),
                        );
                        final totalPaid = data.fold<double>(
                          0,
                          (sum, item) =>
                              sum +
                              (double.tryParse(item.paidAmount ?? '0') ?? 0),
                        );
                        final pendingAmount = totalAmount - totalPaid;

                        return Column(
                          children: [
                            _buildStatCard(
                              'Total Sales',
                              data.length.toString(),
                              Icons.shopping_cart,
                              const Color(0xFF3B82F6),
                            ),
                            const SizedBox(height: 12),
                            _buildStatCard(
                              'Total Amount',
                              '₹${totalAmount.toStringAsFixed(2)}',
                              Icons.attach_money,
                              accentColor,
                            ),
                            const SizedBox(height: 12),
                            _buildStatCard(
                              'Pending Amount',
                              '₹${pendingAmount.toStringAsFixed(2)}',
                              Icons.pending_actions,
                              warningColor,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sales Records',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${controller.salesData.value?.data?.length ?? 0} records',
                            style: const TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: CardContainer(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: accentColor,
                            ),
                          );
                        }

                        if (controller.hasError.value ||
                            controller.salesData.value == null) {
                          return _buildNoInternetView(
                            controller.fetchSalesData,
                          );
                        }

                        final data = controller.salesData.value!.data ?? [];
                        if (data.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No sales data available',
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 328,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildTableHeader(),
                                  ...data.asMap().entries.map(
                                    (entry) =>
                                        _buildTableRow(entry.value, entry.key),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
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

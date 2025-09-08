import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/purchase/controller/purchase_manage_controller.dart';
import 'package:greenbiller/features/purchase/model/purchase_view_model.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:intl/intl.dart';

class PurchaseBills extends GetView<PurchaseManageController> {
  PurchaseBills({super.key});

  final currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  final dateFormatter = DateFormat('dd MMM yyyy');

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return accentColor;
      case 'partial':
        return const Color(0xFFF59E0B);
      case 'pending':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'partial':
        return 'Partial Paid';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  void _showSuccessSnackBar(
    BuildContext context,
    String message,
    IconData icon,
  ) {
    Get.rawSnackbar(
      messageText: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: accentColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
    );
  }

  Widget _buildActionButton(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return CardContainer(
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
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
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No purchase records found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your purchase history will appear here',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection and try again',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: controller.fetchPurchases,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildModernPurchaseTable(
    List<SinglePurchaseData> data,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 90,
          horizontalMargin: 40,
          headingRowHeight: 60,
          dataRowHeight: 72,
          decoration: const BoxDecoration(color: Colors.white),
          headingTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
          columns: const [
            DataColumn(label: Text('#ID')),
            DataColumn(label: Text('Purchase Date')),
            DataColumn(label: Text('Bill No')),
            DataColumn(label: Text('Supplier')),
            DataColumn(label: Text('Subtotal')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('Paid Amount')),
            DataColumn(label: Text('Grand Total')),
            DataColumn(label: Text('Payment Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: data.asMap().entries.map<DataRow>((entry) {
            final index = entry.key;
            final purchase = entry.value;
            final isEven = index % 2 == 0;

            return DataRow(
              color: MaterialStateProperty.all(
                isEven ? const Color(0xFFFAFAFA) : Colors.white,
              ),
              cells: [
                DataCell(
                  Text(
                    purchase.id.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateFormatter.format(
                          purchase.purchaseDate ?? DateTime.now(),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'ID: ${purchase.id ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      purchase.referenceNo ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            (purchase.supplierId ?? 'S')
                                .split(' ')
                                .map((n) => n[0])
                                .take(2)
                                .join(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            purchase.supplierId ?? 'Unknown Supplier',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    currencyFormatter.format(
                      double.tryParse(purchase.subtotal ?? '0') ?? 0,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    currencyFormatter.format(
                      double.tryParse(purchase.totDiscountToAllAmt ?? '0') ?? 0,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    currencyFormatter.format(
                      double.tryParse(purchase.paidAmount ?? '0') ?? 0,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    currencyFormatter.format(
                      double.tryParse(purchase.grandTotal ?? '0') ?? 0,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getPaymentStatusColor(
                        purchase.paymentStatus ?? 'pending',
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getPaymentStatusColor(
                          purchase.paymentStatus ?? 'pending',
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _getPaymentStatusColor(
                              purchase.paymentStatus ?? 'pending',
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getPaymentStatusText(
                            purchase.paymentStatus ?? 'pending',
                          ),
                          style: TextStyle(
                            color: _getPaymentStatusColor(
                              purchase.paymentStatus ?? 'pending',
                            ),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.assignment_return, size: 20),
                      color: const Color(0xFF10B981),
                      onPressed: () {
                       Get.toNamed('/purchase/return-create/${purchase.id}');
                      },
                      tooltip: 'Return Purchase',
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase Bills',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    _buildActionButton(
                      'Refresh',
                      Icons.refresh,
                      accentColor,
                      () {
                        controller.fetchPurchases();
                        _showSuccessSnackBar(
                          context,
                          'Data refreshed successfully!',
                          Icons.refresh,
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'New Purchase',
                      Icons.add_shopping_cart,
                      secondaryColor,
                      () {
                        Get.toNamed(AppRoutes.newPurchase);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            // Summary Cards
            controller.isLoadingPurchases.value
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Expanded(
                          child: CardContainer(
                            margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildModernSummaryCard(
                            'Total Purchases',
                            controller.purchases.length.toString(),
                            const Color(0xFF3B82F6),
                            Icons.shopping_cart_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernSummaryCard(
                            'Total Amount',
                            '₹${controller.totalPurchaseAmount.value.toStringAsFixed(2)}',
                            const Color(0xFF8B5CF6),
                            Icons.payments_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernSummaryCard(
                            'Total Paid',
                            '₹${controller.totalPurchasePaid.value.toStringAsFixed(2)}',
                            const Color(0xFF10B981),
                            Icons.check_circle_outline,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildModernSummaryCard(
                            'Pending Amount',
                            '₹${controller.pendingPurchaseAmount.value.toStringAsFixed(2)}',
                            const Color(0xFFEF4444),
                            Icons.warning_amber_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
            // Modern Purchase Table
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
                            'Purchase Records',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${controller.purchases.length} records',
                              style: const TextStyle(
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
                      child: controller.isLoadingPurchases.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: accentColor,
                              ),
                            )
                          : controller.hasErrorPurchases.value
                          ? _buildNoInternetView()
                          : controller.purchases.isEmpty
                          ? _buildEmptyState()
                          : _buildModernPurchaseTable(
                              controller.purchases,
                              context,
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
}
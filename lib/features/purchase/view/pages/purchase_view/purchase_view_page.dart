import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/purchase/controllers/view_purchase_controller.dart';
import 'package:green_biller/features/purchase/models/purchase_view_model/purchase_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class PurchaseViewPage extends HookConsumerWidget {
  PurchaseViewPage({super.key});

  // Formatter for currency
  final currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  // Formatter for date
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
      BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
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
                onTap: () {},
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

  Widget _buildModernPurchaseTable(List<Datum> data, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 90,
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
                        dateFormatter
                            .format(purchase.purchaseDate ?? DateTime.now()),
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
                    currencyFormatter
                        .format(double.tryParse(purchase.subtotal ?? '0') ?? 0),
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
                        double.tryParse(purchase.totDiscountToAllAmt ?? '0') ??
                            0),
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
                        double.tryParse(purchase.paidAmount ?? '0') ?? 0),
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
                        double.tryParse(purchase.grandTotal ?? '0') ?? 0),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPaymentStatusColor(
                              purchase.paymentStatus ?? 'pending')
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getPaymentStatusColor(
                                purchase.paymentStatus ?? 'pending')
                            .withOpacity(0.3),
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
                                purchase.paymentStatus ?? 'pending'),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getPaymentStatusText(
                              purchase.paymentStatus ?? 'pending'),
                          style: TextStyle(
                            color: _getPaymentStatusColor(
                                purchase.paymentStatus ?? 'pending'),
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
                        context.go('/purchase-return/${purchase.id}');
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
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    final purchaseFuture = useState<Future<PurchaseViewModel>?>(null);
    final hasError = useState<bool>(false);

    // Load data when the page is first built
    useEffect(() {
      if (accessToken != null) {
        purchaseFuture.value =
            ViewPurchaseController().getViewPurchaseController(
          accessToken,
          DateTime.now().toString(),
          DateTime.now().toString(),
        );
      }
      return null;
    }, [accessToken]);

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
              onPressed: () => context.pop(),
            ),
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
                        if (accessToken != null) {
                          purchaseFuture.value = ViewPurchaseController()
                              .getViewPurchaseController(
                            accessToken,
                            DateTime.now().toString(),
                            DateTime.now().toString(),
                          );
                          _showSuccessSnackBar(context,
                              'Data refreshed successfully!', Icons.refresh);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'New Purchase',
                      Icons.add_shopping_cart,
                      secondaryColor,
                      () {
                        _showSuccessSnackBar(
                            context,
                            'New purchase feature coming soon!',
                            Icons.info_outline);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Summary Cards
          FutureBuilder<PurchaseViewModel>(
            future: purchaseFuture.value,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data?.data == null) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: List.generate(
                        4,
                        (index) => Expanded(
                              child: CardContainer(
                                margin:
                                    EdgeInsets.only(right: index < 3 ? 16 : 0),
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
                            )),
                  ),
                );
              }

              final data = snapshot.data!.data!;
              final totalAmount = data.fold<double>(
                  0,
                  (sum, item) =>
                      sum + (double.tryParse(item.grandTotal ?? '0') ?? 0));
              final totalPaid = data.fold<double>(
                  0,
                  (sum, item) =>
                      sum + (double.tryParse(item.paidAmount ?? '0') ?? 0));
              final totalDiscount = data.fold<double>(
                  0,
                  (sum, item) =>
                      sum +
                      (double.tryParse(item.totDiscountToAllAmt ?? '0') ?? 0));
              final pendingAmount = totalAmount - totalPaid;

              return Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Total Purchases',
                        data.length.toString(),
                        const Color(0xFF3B82F6),
                        Icons.shopping_cart_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Total Amount',
                        '₹${totalAmount.toStringAsFixed(2)}',
                        const Color(0xFF8B5CF6),
                        Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Total Paid',
                        '₹${totalPaid.toStringAsFixed(2)}',
                        const Color(0xFF10B981),
                        Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernSummaryCard(
                        'Pending Amount',
                        '₹${pendingAmount.toStringAsFixed(2)}',
                        const Color(0xFFEF4444),
                        Icons.warning_amber_outlined,
                      ),
                    ),
                  ],
                ),
              );
            },
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
                        FutureBuilder<PurchaseViewModel>(
                          future: purchaseFuture.value,
                          builder: (context, snapshot) {
                            final count = snapshot.data?.data?.length ?? 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$count records',
                                style: const TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<PurchaseViewModel>(
                      future: purchaseFuture.value,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: accentColor,
                          ));
                        }

                        if (snapshot.hasError) {
                          return _buildNoInternetView();
                        }

                        if (!snapshot.hasData ||
                            snapshot.data?.data == null ||
                            snapshot.data!.data!.isEmpty) {
                          return _buildEmptyState();
                        }

                        final data = snapshot.data!.data!;
                        return _buildModernPurchaseTable(data, context);
                      },
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

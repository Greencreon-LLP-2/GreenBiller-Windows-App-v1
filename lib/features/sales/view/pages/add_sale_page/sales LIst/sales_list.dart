import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/controllers/sales_view_controller.dart';
import 'package:green_biller/features/sales/models/sales_view_model.dart';
import 'package:green_biller/features/sales/view/pages/POS/pos_billing_page.dart';
import 'package:green_biller/features/sales/view/pages/credit_note.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// Define your providers
final salesProvider = FutureProvider.autoDispose<SalesViewModel>((ref) async {
  try {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    if (accessToken == null) throw Exception('No access token');
    return SalesViewController().getSalesViewController(accessToken);
  } catch (e, stack) {
    print(stack);
    throw Exception("error");
  }
});

final salesFilterProvider =
    StateNotifierProvider.autoDispose<SalesFilterNotifier, SalesFilterState>(
        (ref) {
  return SalesFilterNotifier();
});

class SalesFilterNotifier extends StateNotifier<SalesFilterState> {
  SalesFilterNotifier() : super(const SalesFilterState());

  void setSearchTerm(String term) {
    state = state.copyWith(searchTerm: term);
  }

  void setPaymentStatus(PaymentStatus? status) {
    state = state.copyWith(paymentStatus: status);
  }

  void setBillingType(BillingType? type) {
    state = state.copyWith(billingType: type);
  }

  void setCreatedBy(String? createdBy) {
    state = state.copyWith(createdBy: createdBy);
  }

  void setDateRange(DateTime? from, DateTime? to) {
    state = state.copyWith(fromDate: from, toDate: to);
  }

  void resetFilters() {
    state = const SalesFilterState();
  }
}

@immutable
class SalesFilterState {
  final String searchTerm;
  final PaymentStatus? paymentStatus;
  final BillingType? billingType;
  final String? createdBy;
  final DateTime? fromDate;
  final DateTime? toDate;

  const SalesFilterState({
    this.searchTerm = '',
    this.paymentStatus,
    this.billingType,
    this.createdBy,
    this.fromDate,
    this.toDate,
  });

  SalesFilterState copyWith({
    String? searchTerm,
    PaymentStatus? paymentStatus,
    BillingType? billingType,
    String? createdBy,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return SalesFilterState(
      searchTerm: searchTerm ?? this.searchTerm,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      billingType: billingType ?? this.billingType,
      createdBy: createdBy ?? this.createdBy,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}

class Sale {
  final int id;
  final DateTime salesDate;
  final DateTime dueDate;
  final String referenceNumber;
  final String customerName;
  final double totalAmount;
  final double paidAmount;
  final PaymentStatus paymentStatus;
  final BillingType billingType;
  final String createdBy;

  const Sale({
    required this.id,
    required this.salesDate,
    required this.dueDate,
    required this.referenceNumber,
    required this.customerName,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    required this.billingType,
    required this.createdBy,
  });

  double get outstandingAmount => totalAmount - paidAmount;
}

enum PaymentStatus { paid, partial, unpaid }

enum BillingType { normal, pos }

class SalesListPage extends ConsumerWidget {
  const SalesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesProvider);
    final filterState = ref.watch(salesFilterProvider);
    final filterNotifier = ref.read(salesFilterProvider.notifier);

    return salesAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                "Failed to load sales data: ${error.toString()}",
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.invalidate(salesProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (salesData) {
        // Convert SalesViewModel to List<Sale>
        final allSales = _convertToSalesList(salesData);
        final filteredSales = _applyFilters(allSales, filterState);

        return _SalesListContent(
          allSales: allSales,
          filteredSales: filteredSales,
          filterState: filterState,
          filterNotifier: filterNotifier,
        );
      },
    );
  }

  List<Sale> _convertToSalesList(SalesViewModel salesData) {
    return salesData.data?.map((datum) {
          DateTime? parseDate(String? dateString) {
            if (dateString == null || dateString.isEmpty) return null;

            try {
              // Try parsing in dd/MM/yyyy format first
              final components = dateString.split('/');
              if (components.length == 3) {
                final day = int.parse(components[0]);
                final month = int.parse(components[1]);
                final year = int.parse(components[2]);
                return DateTime(year, month, day);
              }

              // Fallback to standard DateTime.parse if format is different
              return DateTime.parse(dateString);
            } catch (e) {
              print('Error parsing date $dateString: $e');
              return null;
            }
          }

          return Sale(
            id: datum.id ?? 0,
            salesDate: parseDate(datum.salesDate) ?? DateTime.now(),
            dueDate: parseDate(datum.dueDate) ?? DateTime.now(),
            referenceNumber: datum.salesCode ?? 'N/A',
            customerName: 'Customer ${datum.customerId ?? 'Unknown'}',
            totalAmount: double.tryParse(datum.grandTotal ?? '0') ?? 0,
            paidAmount: double.tryParse(datum.paidAmount ?? '0') ?? 0,
            paymentStatus: _parsePaymentStatus(datum.paymentStatus),
            billingType:
                datum.pos == "1" ? BillingType.pos : BillingType.normal,
            createdBy: 'System',
          );
        }).toList() ??
        [];
  }

  PaymentStatus _parsePaymentStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'partial':
        return PaymentStatus.partial;
      default:
        return PaymentStatus.unpaid;
    }
  }

  List<Sale> _applyFilters(List<Sale> allSales, SalesFilterState filterState) {
    return allSales.where((sale) {
      final searchTerm = filterState.searchTerm.toLowerCase();
      if (searchTerm.isNotEmpty) {
        if (!sale.customerName.toLowerCase().contains(searchTerm) &&
            !sale.referenceNumber.toLowerCase().contains(searchTerm)) {
          return false;
        }
      }

      if (filterState.paymentStatus != null &&
          sale.paymentStatus != filterState.paymentStatus) {
        return false;
      }

      if (filterState.billingType != null &&
          sale.billingType != filterState.billingType) {
        return false;
      }

      if (filterState.createdBy != null &&
          sale.createdBy != filterState.createdBy) {
        return false;
      }

      if (filterState.fromDate != null &&
          sale.salesDate.isBefore(filterState.fromDate!)) {
        return false;
      }
      if (filterState.toDate != null &&
          sale.salesDate.isAfter(filterState.toDate!)) {
        return false;
      }

      return true;
    }).toList();
  }
}

class _SalesListContent extends ConsumerStatefulWidget {
  final List<Sale> allSales;
  final List<Sale> filteredSales;
  final SalesFilterState filterState;
  final SalesFilterNotifier filterNotifier;

  const _SalesListContent({
    required this.allSales,
    required this.filteredSales,
    required this.filterState,
    required this.filterNotifier,
  });

  @override
  _SalesListContentState createState() => _SalesListContentState();
}

class _SalesListContentState extends ConsumerState<_SalesListContent>
    with TickerProviderStateMixin {
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(() {
      widget.filterNotifier.setSearchTerm(_searchController.text);
    });
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFilters() {
    setState(() => _showFilters = !_showFilters);
    _showFilters
        ? _filterAnimationController.forward()
        : _filterAnimationController.reverse();
  }

  Future<void> _exportToCsv() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/sales_report_$timestamp.csv');

      const csvHeader = 'Sales Date,Due Date,Reference Number,Customer Name,'
          'Total Amount,Paid Amount,Payment Status,Billing Type,Created By\n';

      final csvData = widget.filteredSales.map((sale) {
        return [
          DateFormat('yyyy-MM-dd').format(sale.salesDate),
          DateFormat('yyyy-MM-dd').format(sale.dueDate),
          sale.referenceNumber,
          sale.customerName,
          sale.totalAmount.toStringAsFixed(2),
          sale.paidAmount.toStringAsFixed(2),
          _getPaymentStatusText(sale.paymentStatus),
          _getBillingTypeText(sale.billingType),
          sale.createdBy
        ].map((field) => '"${field.replaceAll('"', '""')}"').join(',');
      }).join('\n');

      await file.writeAsString(csvHeader + csvData);

      if (mounted) {
        _showSuccessSnackBar('CSV exported successfully!', Icons.download_done);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error exporting CSV: ${e.toString()}');
      }
    }
  }

  void _exportToPdf() {
    _showInfoSnackBar('PDF export feature coming soon!', Icons.picture_as_pdf);
  }

  void _showSuccessSnackBar(String message, IconData icon) {
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showInfoSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return accentColor;
      case PaymentStatus.partial:
        return const Color(0xFFF59E0B);
      case PaymentStatus.unpaid:
        return const Color(0xFFEF4444);
    }
  }

  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.partial:
        return 'Partial';
      case PaymentStatus.unpaid:
        return 'Unpaid';
    }
  }

  String _getBillingTypeText(BillingType type) {
    switch (type) {
      case BillingType.normal:
        return 'Normal';
      case BillingType.pos:
        return 'POS';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSales = widget.filteredSales.length;
    final totalAmount =
        widget.filteredSales.fold(0.0, (sum, sale) => sum + sale.totalAmount);
    final totalPaid =
        widget.filteredSales.fold(0.0, (sum, sale) => sum + sale.paidAmount);
    final totalOutstanding = totalAmount - totalPaid;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sales Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage your sales and invoices',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
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
                      'Return',
                      Icons.shopping_bag_sharp,
                      Colors.redAccent,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreditNotePage()),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'Invoice',
                      Icons.receipt_long,
                      secondaryColor,
                      () => _showCreateInvoiceDialog(context),
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'POS',
                      Icons.point_of_sale,
                      accentColor,

                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => POSBillingPage(),
                          ),
                        );
                      },

                      //_showCreatePOSDialog(context),
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'Refresh',
                      Icons.refresh,
                      Colors.white,
                      () {
                        ref.refresh(salesProvider);
                      },
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search customer or reference...',
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: _showFilters ? theme.primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _showFilters
                              ? theme.primaryColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: IconButton(
                        onPressed: _toggleFilters,
                        icon: Icon(
                          Icons.tune,
                          color: _showFilters
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                        tooltip: 'Toggle filters',
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'csv') _exportToCsv();
                        if (value == 'pdf') _exportToPdf();
                        if (value == 'reset')
                          widget.filterNotifier.resetFilters();
                      },
                      icon:
                          const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'csv',
                          child: Row(
                            children: [
                              Icon(Icons.download,
                                  size: 20, color: Color(0xFF10B981)),
                              SizedBox(width: 12),
                              Text('Export CSV'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'pdf',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  size: 20, color: Color(0xFFEF4444)),
                              SizedBox(width: 12),
                              Text('Export PDF'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reset',
                          child: Row(
                            children: [
                              Icon(Icons.refresh,
                                  size: 20, color: Color(0xFF6366F1)),
                              SizedBox(width: 12),
                              Text('Reset Filters'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Animated Filters
                SizeTransition(
                  sizeFactor: _filterAnimation,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: _buildFiltersSection(),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildModernSummaryCard(
                    'Total Sales',
                    totalSales.toString(),
                    const Color(0xFF3B82F6),
                    Icons.receipt_outlined,
                    totalSales > 0
                        ? "+${(totalSales / widget.allSales.length * 100).toStringAsFixed(0)}%"
                        : "0%",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernSummaryCard(
                    'Total Amount',
                    '\$${totalAmount.toStringAsFixed(2)}',
                    const Color(0xFF8B5CF6),
                    Icons.payments_outlined,
                    totalAmount > 0 ? '+12.5%' : '0%',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernSummaryCard(
                    'Total Paid',
                    '\$${totalPaid.toStringAsFixed(2)}',
                    const Color(0xFF10B981),
                    Icons.check_circle_outline,
                    totalPaid > 0 ? '+8.2%' : '0%',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernSummaryCard(
                    'Outstanding',
                    '\$${totalOutstanding.toStringAsFixed(2)}',
                    const Color(0xFFEF4444),
                    Icons.warning_amber_outlined,
                    totalOutstanding > 0 ? '-3.1%' : '0%',
                  ),
                ),
              ],
            ),
          ),

          // Modern Sales Table
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                          'Sales Records',
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
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.filteredSales.length} records',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: widget.filteredSales.isEmpty
                        ? _buildEmptyState()
                        : _buildModernSalesTable(),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildFiltersSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown<PaymentStatus>(
                'Payment Status',
                widget.filterState.paymentStatus,
                [
                  const DropdownMenuItem(
                      value: null, child: Text('All Status')),
                  ...PaymentStatus.values.map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(_getPaymentStatusText(status)),
                    ),
                  ),
                ],
                (value) {
                  widget.filterNotifier.setPaymentStatus(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFilterDropdown<BillingType>(
                'Billing Type',
                widget.filterState.billingType,
                [
                  const DropdownMenuItem(value: null, child: Text('All Types')),
                  ...BillingType.values.map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getBillingTypeText(type)),
                    ),
                  ),
                ],
                (value) {
                  widget.filterNotifier.setBillingType(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFilterDropdown<String>(
                'Created By',
                widget.filterState.createdBy,
                [
                  const DropdownMenuItem(
                      value: null, child: Text('All Creators')),
                  ...{'Store Admin', 'Manager', 'Cashier'}.map(
                    (creator) => DropdownMenuItem(
                      value: creator,
                      child: Text(creator),
                    ),
                  ),
                ],
                (value) {
                  widget.filterNotifier.setCreatedBy(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildDatePicker(
                    'From Date', widget.filterState.fromDate, (date) {
              widget.filterNotifier
                  .setDateRange(date, widget.filterState.toDate);
            })),
            const SizedBox(width: 16),
            Expanded(
                child: _buildDatePicker('To Date', widget.filterState.toDate,
                    (date) {
              widget.filterNotifier
                  .setDateRange(widget.filterState.fromDate, date);
            })),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterDropdown<T>(
    String label,
    T? value,
    List<DropdownMenuItem<T>> items,
    Function(T?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDatePicker(
      String label, DateTime? date, Function(DateTime?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          onChanged(selectedDate);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date != null
                          ? DateFormat('MMM dd, yyyy').format(date)
                          : 'Select date',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.calendar_today,
                  size: 20, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernSummaryCard(
      String title, String value, Color color, IconData icon, String trend) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
              Icons.receipt_long_outlined,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No sales records found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filter criteria',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSalesTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 40,
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
            DataColumn(label: Text('Sales ID')),
            DataColumn(label: Text('Sales Date')),
            DataColumn(label: Text('Customer Name')),
            DataColumn(label: Text('Sales Code')),
            DataColumn(label: Text('Total Amount')),
            DataColumn(label: Text('Paid')),
            DataColumn(label: Text('Payment Status')),
            DataColumn(label: Text('Type of Billing')),
            DataColumn(label: Text('Created By')),
            DataColumn(label: Text('Edit'))
          ],
          rows: widget.filteredSales.asMap().entries.map<DataRow>((entry) {
            final index = entry.key;
            final sale = entry.value;
            final isEven = index % 2 == 0;

            return DataRow(
              color: MaterialStateProperty.all(
                isEven ? const Color(0xFFFAFAFA) : Colors.white,
              ),
              cells: [
                DataCell(
                  Text(
                    sale.id.toString(),
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
                        DateFormat('MMM dd, yyyy').format(sale.salesDate),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Due: ${DateFormat('MMM dd').format(sale.dueDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            sale.customerName
                                .split(' ')
                                .map((n) => n[0])
                                .take(2)
                                .join(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
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
                            sale.customerName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'ID: ${sale.id}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
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
                      sale.referenceNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₹${sale.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      if (sale.outstandingAmount > 0)
                        Text(
                          'Outstanding: ₹${sale.outstandingAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    '₹${sale.paidAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPaymentStatusColor(sale.paymentStatus)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getPaymentStatusColor(sale.paymentStatus)
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
                            color: _getPaymentStatusColor(sale.paymentStatus),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getPaymentStatusText(sale.paymentStatus),
                          style: TextStyle(
                            color: _getPaymentStatusColor(sale.paymentStatus),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: sale.billingType == BillingType.pos
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getBillingTypeText(sale.billingType),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: sale.billingType == BillingType.pos
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getCreatorColor(sale.createdBy),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        sale.createdBy,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.edit_note, size: 20),
                    color: Colors.blue,
                    onPressed: () => _editSale(sale),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _editSale(Sale sale) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing sale: ${sale.referenceNumber}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Color _getCreatorColor(String creator) {
    switch (creator) {
      case 'Store Admin':
        return const Color(0xFF8B5CF6);
      case 'Manager':
        return const Color(0xFF3B82F6);
      case 'Cashier':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF64748B);
    }
  }

  void _showCreateInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF3B82F6),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create New Invoice',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Invoice creation functionality will be implemented here with customer selection, item management, and pricing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showInfoSnackBar('Invoice creation coming soon!',
                            Icons.info_outline);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Invoice',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.point_of_sale,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create POS Sale',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Point of Sale functionality will include barcode scanning, quick item selection, and instant payment processing.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showInfoSnackBar('POS sale feature coming soon!',
                            Icons.info_outline);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Sale',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

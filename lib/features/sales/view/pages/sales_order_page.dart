import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/global_providers/sales_order_provider.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/models/sales_order_model.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_order_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class SalesOrderPage extends HookConsumerWidget {
  const SalesOrderPage({super.key});

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

  Widget _buildFilterChip(String label, ValueNotifier<String> selectedFilter) {
    final bool isSelected = selectedFilter.value == label;
    return InkWell(
      onTap: () {
        selectedFilter.value = label;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.withOpacity(0.3),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _getCustomerInitials(String? customerName) {
    if (customerName == null || customerName.isEmpty) return 'NA';
    final names = customerName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  String _getItemSummary(List<OrderItem> items) {
    if (items.isEmpty) return 'No items';
    if (items.length == 1) {
      return '1 item: ${items.first.itemId}';
    }
    return '${items.length} items';
  }

  Widget _buildOrderTable(
      List<SaleOrderList> orders,
      BuildContext context,
      ValueNotifier<String> selectedFilter,
      TextEditingController searchController) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 110,
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
            DataColumn(label: Text('Order Date')),
            DataColumn(label: Text('Order No')),
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Items')),
            DataColumn(label: Text('Total Amount')),
            DataColumn(label: Text('Payment Mode')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: orders.asMap().entries.where((entry) {
            final order = entry.value;
            final orderStatus = order.orderstatusId;
            
            if (selectedFilter.value != 'All') {
              if (selectedFilter.value == 'Open Orders' && orderStatus != '1') {
                return false;
              }
              if (selectedFilter.value == 'Closed Orders' && orderStatus == '1') {
                return false;
              }
            }
            
            if (searchController.text.isNotEmpty) {
              final searchTerm = searchController.text.toLowerCase();
              final matchesOrderId = order.uniqueOrderId.toLowerCase().contains(searchTerm);
              final matchesCustomer = order.orderAddress?.toLowerCase().contains(searchTerm) ?? false;
              final matchesItems = order.items.any((item) => 
                  item.itemId.toLowerCase().contains(searchTerm));
              
              if (!matchesOrderId && !matchesCustomer && !matchesItems) {
                return false;
              }
            }
            return true;
          }).map<DataRow>((entry) {
            final index = entry.key;
            final order = entry.value;
            final isEven = index % 2 == 0;
            final dateFormat = DateFormat('dd MMM yyyy');
            final customerName = order.orderAddress ?? 'Walk-in Customer';
            final statusText = order.orderstatusId == '1' ? 'OPEN' : 'CLOSED';
            final statusColor = order.orderstatusId == '1' ? warningColor : successColor;

            return DataRow(
              color: MaterialStateProperty.all(
                isEven ? const Color(0xFFFAFAFA) : Colors.white,
              ),
              cells: [
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dateFormat.format(order.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'ID: ${order.id}',
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
                      order.uniqueOrderId,
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
                            _getCustomerInitials(customerName),
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
                            customerName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            '${order.items.length} items',
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
                  Tooltip(
                    message: order.items.map((item) => '${item.itemId} (x${item.qty})').join('\n'),
                    child: Text(
                      _getItemSummary(order.items),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${order.orderTotalamt}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    order.paymentMode.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: order.paymentMode == 'cash' 
                          ? const Color(0xFF10B981) 
                          : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
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
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      color: accentColor,
                      onPressed: () {
                        // View order details
                        _showSuccessSnackBar(context,
                            'Viewing order details...', Icons.visibility);
                      },
                      tooltip: 'View Details',
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
    final selectedFilter = useState('All');
    final searchController = useTextEditingController();
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final salesOrderAsync = ref.watch(salesOrderProvider(accessToken!));

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
            // leading: IconButton(
            //   icon: const Icon(Icons.arrow_back, color: Colors.white),
            //   onPressed: () => Navigator.pop(context),
            // ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Orders',
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
                        ref.refresh(salesOrderProvider(accessToken));
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'New Order',
                      Icons.add_shopping_cart,
                      secondaryColor,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSalesOrderPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: salesOrderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: accentColor)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading orders: $error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(salesOrderProvider(accessToken)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (salesOrderModel) {
          final orders = salesOrderModel.data;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style:
                            const TextStyle(fontSize: 16, color: textPrimaryColor),
                        decoration: InputDecoration(
                          hintText: "Search by Order ID, Customer, or Item",
                          hintStyle: const TextStyle(
                            color: textSecondaryColor,
                            fontSize: 16,
                          ),
                          prefixIcon: const Icon(Icons.search, color: accentColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                        ),
                        onChanged: (value) {
                          // Trigger rebuild to filter orders
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip("All", selectedFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip("Open Orders", selectedFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip("Closed Orders", selectedFilter),
                  ],
                ),
              ),
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
                              'Sales Order Records',
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
                              child: Text(
                                '${orders.length} records',
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
                        child: _buildOrderTable(
                            orders, context, selectedFilter, searchController),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
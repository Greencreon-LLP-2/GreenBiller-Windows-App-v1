import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/sales/view/pages/sale_order_page.dart';
import 'package:intl/intl.dart';

class SalesOrderPage extends HookWidget {
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

  Widget _buildOrderTable(
      List<Map<String, String>> orders,
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
            DataColumn(label: Text('Advance')),
            DataColumn(label: Text('Balance')),
            DataColumn(label: Text('Due Date')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: orders.asMap().entries.where((entry) {
            final order = entry.value;
            if (selectedFilter.value != 'All' &&
                !order["status"]!
                    .contains(selectedFilter.value.split(" ")[0])) {
              return false;
            }
            if (searchController.text.isNotEmpty &&
                !order["name"]!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) {
              return false;
            }
            return true;
          }).map<DataRow>((entry) {
            final index = entry.key;
            final order = entry.value;
            final isEven = index % 2 == 0;

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
                        order["date"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'ID: ${order["number"]!}',
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
                      order["number"]!,
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
                            order["name"]!
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
                            order["name"]!,
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
                    '₹${order["advance"]!}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '₹${order["balance"]!}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    order["dueDate"]!,
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
                      color: order["status"] == "OPEN"
                          ? warningColor.withOpacity(0.1)
                          : successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: order["status"] == "OPEN"
                            ? warningColor.withOpacity(0.3)
                            : successColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: order["status"] == "OPEN"
                                ? warningColor
                                : successColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order["status"]!,
                          style: TextStyle(
                            color: order["status"] == "OPEN"
                                ? warningColor
                                : successColor,
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
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      color: accentColor,
                      onPressed: order["status"] == "OPEN"
                          ? () {
                              _showSuccessSnackBar(context,
                                  'Converting to sale...', Icons.arrow_forward);
                            }
                          : null,
                      tooltip: 'Convert to Sale',
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
    final selectedFilter = useState('All');
    final searchController = useTextEditingController();
    final dateFormat = DateFormat('dd MMM yyyy');

    final orders = [
      {
        "name": "vghhv",
        "status": "OPEN",
        "number": "#1",
        "date": "01 Jan, 25",
        "advance": "0.00",
        "balance": "13,32,000.00",
        "dueDate": "02 Jan, 25"
      },
      {
        "name": "Test Order",
        "status": "CLOSED",
        "number": "#2",
        "date": "02 Jan, 25",
        "advance": "5,000.00",
        "balance": "8,000.00",
        "dueDate": "05 Jan, 25"
      },
    ];

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
                        _showSuccessSnackBar(context,
                            'Data refreshed successfully!', Icons.refresh);
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
                              builder: (context) => const AddSaleOrderPage()),
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
      body: Column(
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
                      hintText: "Search Order",
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
      ),
    );
  }
}

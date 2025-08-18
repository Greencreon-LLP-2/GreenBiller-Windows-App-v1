import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:intl/intl.dart';

class SalesByItemPage extends StatefulWidget {
  const SalesByItemPage({super.key});

  @override
  State<SalesByItemPage> createState() => _SalesByItemPageState();
}

class _SalesByItemPageState extends State<SalesByItemPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  String _selectedSortBy = 'Quantity';
  String _selectedDateRange = 'This Month';
  int? _selectedItemIndex;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/reports'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Sales by Item'),
        backgroundColor: Colors.white,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Panel - Table
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Items',
                          value: '1,234',
                          icon: Icons.inventory_2,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Sales',
                          value: '₹1,23,456',
                          icon: Icons.currency_rupee,
                          color: successColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Avg. Price',
                          value: '₹1,234',
                          icon: Icons.analytics,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filters Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: textPrimaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search by item name or code...',
                              hintStyle: TextStyle(
                                color: textSecondaryColor.withOpacity(0.6),
                                fontSize: 14,
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.search,
                                  size: 20,
                                  color: textSecondaryColor.withOpacity(0.6),
                                ),
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () {
                                            setState(() {
                                              _searchController.clear();
                                              _searchQuery = '';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                              color: textSecondaryColor
                                                  .withOpacity(0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildFilterButton(
                        icon: Icons.category,
                        label: _selectedCategory,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildCategoryDialog(),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildFilterButton(
                        icon: Icons.sort,
                        label: _selectedSortBy,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildSortDialog(),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildFilterButton(
                        icon: Icons.calendar_today,
                        label: _selectedDateRange,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildDateRangeDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Table
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Colors.grey.shade50,
                          ),
                          dataRowColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textPrimaryColor,
                          ),
                          dataTextStyle: const TextStyle(
                            color: textSecondaryColor,
                          ),
                          border: TableBorder.all(
                            color: const Color.fromARGB(255, 231, 231, 231),
                            width: 1,
                          ),
                          columnSpacing: 0,
                          horizontalMargin: 0,
                          columns: [
                            DataColumn(
                              label: Container(
                                width: 300,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: const Text(
                                  'Item Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: const Text(
                                  'Unit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: 120,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: const Text(
                                  'Sold Count',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(10, (index) {
                            final itemName = "Item ${index + 1}";
                            const unit = "PCS";
                            final soldCount = 100 + (index * 10);
                            final totalAmount = 5000 + (index * 1000);

                            // Filter logic
                            if (_searchQuery.isNotEmpty) {
                              final searchableText = [
                                itemName,
                                unit,
                                soldCount.toString(),
                                totalAmount.toString(),
                              ].join(' ').toLowerCase();

                              if (!searchableText.contains(_searchQuery)) {
                                return const DataRow(cells: []);
                              }
                            }

                            return DataRow(
                              selected: _selectedItemIndex == index,
                              onSelectChanged: (selected) {
                                setState(() {
                                  _selectedItemIndex = selected! ? index : null;
                                });
                              },
                              cells: [
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: accentColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.inventory_2,
                                            color: accentColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          itemName,
                                          style: const TextStyle(
                                            color: textPrimaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: const Text(
                                      unit,
                                      style: TextStyle(
                                        color: textSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      soldCount.toString(),
                                      style: const TextStyle(
                                        color: textSecondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      currencyFormat.format(totalAmount),
                                      style: const TextStyle(
                                        color: textPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right Panel - Item Details and Transactions
            if (_selectedItemIndex != null) ...[
              const SizedBox(width: 24),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Details Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.inventory_2,
                              color: accentColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Item ${_selectedItemIndex! + 1}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "PCS",
                                  style: TextStyle(
                                    color: textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedItemIndex = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Item Statistics
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Item Statistics",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  title: "Total Sold",
                                  value: "${100 + (_selectedItemIndex! * 10)}",
                                  icon: Icons.shopping_cart,
                                  color: successColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  title: "Total Revenue",
                                  value: currencyFormat.format(
                                      5000 + (_selectedItemIndex! * 1000)),
                                  icon: Icons.currency_rupee,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Recent Transactions
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recent Transactions",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  final invoiceNo = "INV${1000 + index}";
                                  final customerName = "Customer ${index + 1}";
                                  final amount = 1000 + (index * 200);
                                  final date = DateTime.now()
                                      .subtract(Duration(days: index));

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                successColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.receipt,
                                            color: successColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                invoiceNo,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: textPrimaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                customerName,
                                                style: const TextStyle(
                                                  color: textSecondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              currencyFormat.format(amount),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: textPrimaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormat('dd MMM yyyy')
                                                  .format(date),
                                              style: const TextStyle(
                                                color: textSecondaryColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: textSecondaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: textPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: accentColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDialog() {
    return AlertDialog(
      title: const Text('Select Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogItem(
            'All Categories',
            _selectedCategory == 'All Categories',
            () {
              setState(() {
                _selectedCategory = 'All Categories';
              });
              Navigator.pop(context);
            },
          ),
          _buildDialogItem(
            'Electronics',
            _selectedCategory == 'Electronics',
            () {
              setState(() {
                _selectedCategory = 'Electronics';
              });
              Navigator.pop(context);
            },
          ),
          _buildDialogItem(
            'Clothing',
            _selectedCategory == 'Clothing',
            () {
              setState(() {
                _selectedCategory = 'Clothing';
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSortDialog() {
    return AlertDialog(
      title: const Text('Sort By'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogItem(
            'Quantity',
            _selectedSortBy == 'Quantity',
            () {
              setState(() {
                _selectedSortBy = 'Quantity';
              });
              Navigator.pop(context);
            },
          ),
          _buildDialogItem(
            'Revenue',
            _selectedSortBy == 'Revenue',
            () {
              setState(() {
                _selectedSortBy = 'Revenue';
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeDialog() {
    return AlertDialog(
      title: const Text('Select Date Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogItem(
            'Today',
            _selectedDateRange == 'Today',
            () {
              setState(() {
                _selectedDateRange = 'Today';
              });
              Navigator.pop(context);
            },
          ),
          _buildDialogItem(
            'This Week',
            _selectedDateRange == 'This Week',
            () {
              setState(() {
                _selectedDateRange = 'This Week';
              });
              Navigator.pop(context);
            },
          ),
          _buildDialogItem(
            'This Month',
            _selectedDateRange == 'This Month',
            () {
              setState(() {
                _selectedDateRange = 'This Month';
              });
              Navigator.pop(context);
            },
          ),
          _buildDialogItem(
            'This Year',
            _selectedDateRange == 'This Year',
            () {
              setState(() {
                _selectedDateRange = 'This Year';
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDialogItem(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? accentColor : textPrimaryColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(
                  Icons.check,
                  color: accentColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

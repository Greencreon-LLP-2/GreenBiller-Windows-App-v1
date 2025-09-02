import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.go("/homepage");
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reports',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Analytics and business insights',
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
                    if (isDesktop || isTablet)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.filter_list,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Filter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isDesktop || isTablet) const SizedBox(width: 12),
                    if (isDesktop || isTablet)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.download,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Export',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isDesktop || isTablet) const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.search,
                                    color: Colors.white, size: 20),
                                if (isDesktop || isTablet) ...[
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: isDesktop
            ? _buildDesktopView(context)
            : isTablet
                ? _buildTabletView(context)
                : _buildMobileView(context),
      ),
    );
  }

  // Desktop view with side-by-side sections
  Widget _buildDesktopView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Report header with additional controls for desktop
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.analytics, size: 40, color: accentColor),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Business Analytics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                    Text(
                      "View comprehensive reports of your business performance",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date Range'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Main content in a row for desktop
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column - Sales and Purchase reports
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportSectionDesktop("Sales Reports", [
                    _ReportItem("Sales Summary", Icons.summarize, () {
                      context.go("/sales-summary");
                    }),
                    _ReportItem("Sales by Item", Icons.inventory_2, () {
                      context.go('/sale-by-item-report');
                    }),
                    _ReportItem("Sales by Customer", Icons.people, () {
                      context.go("/sales-by-customer");
                    }),
                    // _ReportItem("Payment Collection", Icons.payments, () {}),
                  ]),
                  const SizedBox(height: 24),
                  // _buildReportSectionDesktop(
                  //   "Purchase Reports",
                  //   [
                  //     _ReportItem("Purchase Summary", Icons.summarize, () {
                  //       context.go("/purchase-summary");
                  //     }),
                  //     _ReportItem("Purchase by Item", Icons.inventory_2, () {}),
                  //     _ReportItem("Purchase by Supplier", Icons.people, () {
                  //       context.go("/purchase-supplier-base-summary");
                  //     }),
                  //     _ReportItem("Payment Made", Icons.payments, () {}),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right column - Stock reports and quick actions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReportSectionDesktop(
                    "Purchase Reports",
                    [
                      _ReportItem("Purchase Summary", Icons.summarize, () {
                        context.go("/purchase-summary");
                      }),
                      _ReportItem("Purchase by Item", Icons.inventory_2, () {
                        context.go("/purchase-item-report");
                      }),
                      _ReportItem("Purchase by Supplier", Icons.people, () {
                        context.go("/purchase-supplier-base-summary");
                      }),
                      // _ReportItem("Payment Made", Icons.payments, () {}),
                    ],
                  ),
                  // _buildReportSectionDesktop("Stock Reports", [
                  //   _ReportItem("Stock Summary", Icons.analytics, () {
                  //     context.go("/stock-summary");
                  //   }),
                  //   _ReportItem("Low Stock Alert", Icons.warning, () {
                  //     context.go("/low-stock-alert");
                  //   }),
                  //   _ReportItem("Stock Movement", Icons.swap_horiz, () {
                  //     context.go("/stock-movement");
                  //   }),
                  //   _ReportItem("Stock Valuation", Icons.price_check, () {}),
                  // ]),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Tablet view with grid layout
  Widget _buildTabletView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tablet header
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: const Row(
            children: [
              Icon(Icons.analytics, size: 32, color: accentColor),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reports Dashboard",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                    Text(
                      "Analysis of business performance",
                      style: TextStyle(
                        fontSize: 13,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Filter chips for quick filtering on tablet
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip('Today'),
            _buildFilterChip('This Week'),
            _buildFilterChip('This Month'),
            _buildFilterChip('Custom Range'),
          ],
        ),

        const SizedBox(height: 16),

        // Main content for tablet - uses 3 columns
        _buildReportSectionTablet("Sales Reports", [
          _ReportItem("Sales Summary", Icons.summarize, () {}),
          _ReportItem("Sales by Item", Icons.inventory_2, () {}),
          _ReportItem("Sales by Customer", Icons.people, () {}),
          _ReportItem("Payment Collection", Icons.payments, () {}),
        ]),

        _buildReportSectionTablet("Purchase Reports", [
          _ReportItem("Purchase Summary", Icons.summarize, () {}),
          _ReportItem("Purchase by Item", Icons.inventory_2, () {}),
          _ReportItem("Purchase by Supplier", Icons.people, () {}),
          _ReportItem("Payment Made", Icons.payments, () {}),
        ]),

        _buildReportSectionTablet("Stock Reports", [
          _ReportItem("Stock Summary", Icons.analytics, () {}),
          _ReportItem("Low Stock Alert", Icons.warning, () {}),
          _ReportItem("Stock Movement", Icons.swap_horiz, () {}),
          _ReportItem("Stock Valuation", Icons.price_check, () {}),
        ]),
      ],
    );
  }

  // Original mobile view
  Widget _buildMobileView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReportSection("Sales Reports", [
          _ReportItem("Sales Summary", Icons.summarize, () {}),
          _ReportItem("Sales by Item", Icons.inventory_2, () {}),
          _ReportItem("Sales by Customer", Icons.people, () {}),
          _ReportItem("Payment Collection", Icons.payments, () {}),
        ]),
        _buildReportSection("Purchase Reports", [
          _ReportItem("Purchase Summary", Icons.summarize, () {}),
          _ReportItem("Purchase by Item", Icons.inventory_2, () {}),
          _ReportItem("Purchase by Supplier", Icons.people, () {}),
          _ReportItem("Payment Made", Icons.payments, () {}),
        ]),
        _buildReportSection("Stock Reports", [
          _ReportItem("Stock Summary", Icons.analytics, () {}),
          _ReportItem("Low Stock Alert", Icons.warning, () {}),
          _ReportItem("Stock Movement", Icons.swap_horiz, () {}),
          _ReportItem("Stock Valuation", Icons.price_check, () {}),
        ]),
      ],
    );
  }

  // Filter chip for tablet view
  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool selected) {},
      backgroundColor: Colors.white,
      selectedColor: accentColor.withOpacity(0.2),
      side: BorderSide(color: Colors.grey.shade300),
      labelStyle: const TextStyle(color: textPrimaryColor),
    );
  }

  // Original report section for mobile
  Widget _buildReportSection(String title, List<_ReportItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: items.map((item) => _buildReportCard(item)).toList(),
        ),
      ],
    );
  }

  // Report section for tablet - 3 columns
  Widget _buildReportSectionTablet(String title, List<_ReportItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3, // 3 columns for tablet
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: items.map((item) => _buildReportCardTablet(item)).toList(),
        ),
      ],
    );
  }

  // Report section for desktop with horizontal layout
  Widget _buildReportSectionDesktop(String title, List<_ReportItem> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: const Text(
              //     'View All',
              //     style: TextStyle(color: accentColor),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 2.0,
            children:
                items.map((item) => _buildReportCardDesktop(item)).toList(),
          ),
        ],
      ),
    );
  }

  // Original card for mobile
  Widget _buildReportCard(_ReportItem item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 32, color: accentColor),
            const SizedBox(height: 8),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card for tablet view
  Widget _buildReportCardTablet(_ReportItem item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 28, color: accentColor),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card for desktop view
  Widget _buildReportCardDesktop(_ReportItem item) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          item.route();
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, size: 24, color: accentColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportItem {
  final String title;
  final IconData icon;
  final Function route;
  _ReportItem(this.title, this.icon, this.route);
}

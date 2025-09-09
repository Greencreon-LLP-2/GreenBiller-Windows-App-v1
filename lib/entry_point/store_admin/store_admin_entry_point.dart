import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar.dart';
import 'package:greenbiller/entry_point/controller/store_admin_controller.dart';
import 'package:greenbiller/entry_point/model/dashboard_model.dart';
import 'package:greenbiller/entry_point/store_admin/cyber_punk_sales_chart.dart';

class StoreAdminEntryPoint extends GetView<StoreAdminController> {
  const StoreAdminEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: AdminSidebar(),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 64,
                  color: accentColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.hasError.value ||
                          controller.dashboardData.value == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load dashboard data',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: controller.fetchDashboardData,
                                child: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final dashboard = controller.dashboardData.value!;
                      final overview = dashboard.businessOverview;
                      final transactions = dashboard.recentTransactions ?? [];
                      final salesOverview =
                          dashboard.salesOverviewLast7Days ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: accentLightColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                overviewCardLarge(
                                  Icons.trending_up,
                                  "Today's Sale",
                                  '₹${overview?.totalSales.toStringAsFixed(0) ?? '0'}',
                                  overview?.salesChangeType == 'up'
                                      ? Colors.green
                                      : Colors.red,
                                  overview?.salesChange.toStringAsFixed(1) ??
                                      '0.0',
                                  overview?.salesChangeType ?? '',
                                ),
                                overviewCardLarge(
                                  Icons.warning_amber_rounded,
                                  "Due Amount",
                                  '₹${overview?.totalDue.toStringAsFixed(0) ?? '0'}',
                                  overview?.dueChangeType == 'up'
                                      ? Colors.red
                                      : Colors.green,
                                  overview?.dueChange.toStringAsFixed(1) ??
                                      '0.0',
                                  overview?.dueChangeType ?? '',
                                ),
                                overviewCardLarge(
                                  Icons.inventory_2_outlined,
                                  "Total Items",
                                  '${overview?.totalItems ?? 0}',
                                  overview?.itemsChangeType == 'up'
                                      ? Colors.green
                                      : Colors.red,
                                  overview?.itemsChange.toStringAsFixed(1) ??
                                      '0.0',
                                  overview?.itemsChangeType ?? '',
                                ),
                                overviewCardLarge(
                                  Icons.people_alt_outlined,
                                  "Customers",
                                  '${overview?.totalCustomers ?? 0}',
                                  overview?.customersChangeType == 'up'
                                      ? Colors.green
                                      : Colors.red,
                                  overview?.customersChange.toStringAsFixed(
                                        1,
                                      ) ??
                                      '0.0',
                                  overview?.customersChangeType ?? '',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sales Overview (Last 7 Days)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 350,
                                  child: Obx(() {
                                    final chartData =
                                        (controller
                                                    .dashboardData
                                                    .value
                                                    ?.salesOverviewLast7Days ??
                                                [])
                                            .map(
                                              (s) => SalesData(
                                                DateTime.parse(s.date),
                                                s.total ?? 0.0,
                                              ),
                                            )
                                            .toList();

                                    return CyberpunkSalesChart(
                                      salesData: chartData,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Quick Actions",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(
                                              '/settings',
                                            ); // Example navigation
                                          },
                                          child: Text(
                                            "View All",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    GridView.count(
                                      shrinkWrap: true,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 18,
                                      crossAxisSpacing: 18,
                                      childAspectRatio: 2.1,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: [
                                        quickActionTileGradient(
                                          Icons.add,
                                          "New Sale",
                                          Colors.green,
                                          Colors.greenAccent,
                                          () => Get.to('/new-sale'),
                                        ),
                                        quickActionTileGradient(
                                          Icons.sync_alt,
                                          "Transactions",
                                          Colors.blue,
                                          Colors.lightBlueAccent,
                                          () => Get.to('/transactions'),
                                        ),
                                        quickActionTileGradient(
                                          Icons.bar_chart,
                                          "Reports",
                                          Colors.purple,
                                          Colors.deepPurpleAccent,
                                          () => Get.to('/reports'),
                                        ),
                                        quickActionTileGradient(
                                          Icons.settings,
                                          "Settings",
                                          Colors.blueGrey,
                                          Colors.grey,
                                          () => Get.to('/settings'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Recent Transactions",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.to('/transactions');
                                          },
                                          child: Text(
                                            "View All",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: transactions.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (_, index) {
                                        final txn = transactions[index];
                                        final customer =
                                            txn.customer?.customerName ??
                                            'Unknown';
                                        final date = DateTime.parse(
                                          txn.createdAt,
                                        );
                                        final status = txn.status == "1"
                                            ? "Completed"
                                            : "Pending";

                                        Color statusColor = txn.status == "1"
                                            ? Colors.green
                                            : Colors.orange;

                                        return ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: statusColor
                                                .withOpacity(0.2),
                                            child: Text(
                                              customer[0].toUpperCase(),
                                              style: TextStyle(
                                                color: statusColor,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            customer,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "INV-${txn.id} • ${date.day}/${date.month}/${date.year}",
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '₹${txn.grandTotal.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: statusColor
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget overviewCardLarge(
    IconData icon,
    String title,
    String value,
    Color iconColor,
    String change,
    String changeType,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 8),
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
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  changeType == 'up'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: changeType == 'up' ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '$change%',
                  style: TextStyle(
                    fontSize: 12,
                    color: changeType == 'up' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'vs last period',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget quickActionTileGradient(
    IconData icon,
    String title,
    Color c1,
    Color c2,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [c1, c2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionCard(
    String customer,
    String invoice,
    String status,
    String date,
    String amount,
  ) {
    Color statusColor = successColor;
    if (status.toLowerCase().contains('pend')) statusColor = warningColor;
    if (status.toLowerCase().contains('fail')) statusColor = errorColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentLightColor.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: statusColor,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                customer.isNotEmpty ? customer[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      customer,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status.toLowerCase().contains('com')
                            ? Icons.check
                            : (status.toLowerCase().contains('pend')
                                  ? Icons.access_time
                                  : Icons.error),
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.receipt_long,
                          color: statusColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          invoice,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.black38,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

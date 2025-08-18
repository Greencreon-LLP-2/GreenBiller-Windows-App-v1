import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/core/widgets/card_container.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final isMediumScreen = constraints.maxWidth < 800;

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                "Transactions",
                style: AppTextStyles.h3,
              ),
              backgroundColor: Colors.white,
              foregroundColor: textPrimaryColor,
              actions: [
                if (!isSmallScreen) ...[
                  SizedBox(
                    width: 300,
                    child: _buildSearchBar(),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (isSmallScreen) ...[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: TabBar(
                  tabs: [
                    Tab(text: "All"),
                    Tab(text: "Sales"),
                    Tab(text: "Purchases"),
                  ],
                  indicatorColor: accentColor,
                  labelColor: accentColor,
                  unselectedLabelColor: textSecondaryColor,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  indicatorWeight: 3,
                ),
              ),
            ),
            body: Column(
              children: [
                // Summary Cards
                Container(
                  height: isSmallScreen ? 120 : 160,
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: isSmallScreen ? 16 : 24,
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildSummaryCard(
                        "Total Sales",
                        "₹1,25,450",
                        Icons.trending_up,
                        successColor,
                        isSmallScreen,
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      _buildSummaryCard(
                        "Total Purchases",
                        "₹85,120",
                        Icons.trending_down,
                        errorColor,
                        isSmallScreen,
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      _buildSummaryCard(
                        "Pending Amount",
                        "₹15,750",
                        Icons.pending_actions,
                        warningColor,
                        isSmallScreen,
                      ),
                    ],
                  ),
                ),
                if (isSmallScreen)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSearchBar(),
                  ),
                const SizedBox(height: 8),
                // Transaction List
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTransactionList(isSmallScreen),
                      _buildTransactionList(isSmallScreen),
                      _buildTransactionList(isSmallScreen),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search transactions",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.filter_list),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textLightColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textLightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color color,
    bool isSmallScreen,
  ) {
    return SizedBox(
      width: isSmallScreen ? 180 : 280,
      height: isSmallScreen ? 100 : 160,
      child: CardContainer(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: isSmallScreen ? 18 : 24),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: isSmallScreen ? 13 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: isSmallScreen ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(bool isSmallScreen) {
    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      itemCount: 10,
      itemBuilder: (context, index) {
        final bool isPaid = index % 3 == 0;
        final bool isPending = index % 3 == 1;

        return CardContainer(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.receipt_outlined,
                        color: accentColor,
                        size: isSmallScreen ? 16 : 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invoice #${1234 + index}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Customer Name",
                            style: TextStyle(
                              color: textSecondaryColor,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${25450 + (index * 1000)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildStatusBadge(isPaid, isPending, isSmallScreen),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "23 Dec, 2024",
                      style: TextStyle(
                        color: textSecondaryColor.withOpacity(0.8),
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                    Text(
                      "Due: ₹5,450",
                      style: TextStyle(
                        color: warningColor,
                        fontWeight: FontWeight.w500,
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(bool isPaid, bool isPending, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isPaid
            ? successColor.withOpacity(0.1)
            : isPending
                ? warningColor.withOpacity(0.1)
                : errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaid
            ? "Paid"
            : isPending
                ? "Pending"
                : "Failed",
        style: TextStyle(
          color: isPaid
              ? successColor
              : isPending
                  ? warningColor
                  : errorColor,
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 10 : 12,
        ),
      ),
    );
  }
}

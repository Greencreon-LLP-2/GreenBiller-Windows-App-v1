import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/enhanced_quick_actions_widget.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/enhanced_transactions_widget.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/section_title_widget.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/state_card_widget.dart';

class BuildHomeContent extends StatelessWidget {
  final bool isSmallScreen;
  final bool isMediumScreen;

  const BuildHomeContent(
      {super.key, required this.isSmallScreen, required this.isMediumScreen});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPhone = constraints.maxWidth < 600;
        final is7inch =
            constraints.maxWidth >= 600 && constraints.maxWidth < 960;
        final is10inch = constraints.maxWidth >= 960;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section with Stats
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(isPhone ? 12 : 16),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    if (is10inch)
                      // 10-inch layout: 4 cards in a row
                      const Row(
                        children: [
                          Expanded(
                            child: StateCardWidget(
                              label: "Today's Sale",
                              value: "₹ 25,450",
                              icon: Icons.trending_up,
                              color: Colors.green,
                              heroTag: "sale_card",
                              isSmallScreen: false,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: StateCardWidget(
                              label: "Due Amount",
                              value: "₹ 12,350",
                              icon: Icons.warning_outlined,
                              color: Colors.orange,
                              heroTag: "due_card",
                              isSmallScreen: false,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: StateCardWidget(
                              label: "Total Items",
                              value: "156",
                              icon: Icons.inventory,
                              color: Colors.blue,
                              heroTag: "items_card",
                              isSmallScreen: false,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: StateCardWidget(
                              label: "Customers",
                              value: "45",
                              icon: Icons.people,
                              color: Colors.purple,
                              heroTag: "customers_card",
                              isSmallScreen: false,
                            ),
                          ),
                        ],
                      )
                    else
                      // Phone and 7-inch layout: Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isPhone ? 2 : 3,
                        mainAxisSpacing: isPhone ? 12 : 16,
                        crossAxisSpacing: isPhone ? 12 : 16,
                        childAspectRatio: isPhone ? 1.5 : 1.8,
                        children: [
                          StateCardWidget(
                            heroTag: "sale_card",
                            isSmallScreen: isPhone,
                            label: "Today's Sale",
                            color: Colors.green,
                            icon: Icons.trending_up,
                            value: "₹ 25,450",
                          ),
                          StateCardWidget(
                            label: "Due Amount",
                            value: "₹ 12,350",
                            icon: Icons.warning_outlined,
                            color: Colors.orange,
                            heroTag: "due_card",
                            isSmallScreen: isPhone,
                          ),
                          if (!isPhone) ...[
                            StateCardWidget(
                              label: "Total Items",
                              value: "156",
                              icon: Icons.inventory,
                              color: Colors.blue,
                              heroTag: "items_card",
                              isSmallScreen: isPhone,
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),

              // Quick Actions and Transactions Section
              Padding(
                padding: EdgeInsets.all(isPhone ? 12 : 16),
                child: is10inch
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side: Quick Actions
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitleWidget(
                                    title: "Quick Actions"),
                                const SizedBox(height: 16),
                                EnhancedQuickActionsWidget(
                                    isPhone: isPhone,
                                    is7inch: is7inch,
                                    is10inch: is10inch),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right side: Recent Transactions
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SectionTitleWidget(
                                    title: "Recent Transactions"),
                                const SizedBox(height: 16),
                                EnhancedTransactionsWidget(
                                    isPhone: isPhone,
                                    is7inch: is7inch,
                                    is10inch: is10inch),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitleWidget(title: "Quick Actions"),
                          const SizedBox(height: 16),
                          EnhancedQuickActionsWidget(
                              isPhone: isPhone,
                              is7inch: is7inch,
                              is10inch: is10inch),
                          const SizedBox(height: 24),
                          const SectionTitleWidget(
                              title: "Recent Transactions"),
                          const SizedBox(height: 16),
                          EnhancedTransactionsWidget(
                              isPhone: isPhone,
                              is7inch: is7inch,
                              is10inch: is10inch),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

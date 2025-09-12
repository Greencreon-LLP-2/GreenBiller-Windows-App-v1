import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/alerts/app_snackbar.dart';
import 'package:greenbiller/core/utils/subscription_util.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:greenbiller/core/gloabl_widgets/cards/trial_card.dart';
import 'package:greenbiller/core/gloabl_widgets/buttons/sidebar_upgrade_button.dart';
import 'package:logger/logger.dart';

class AdminSidebar extends StatelessWidget {
  final Logger logger = Logger();
  final AuthController authController = Get.find<AuthController>();
  AdminSidebar({super.key});

  Widget _buildNavTile({
    required String title,
    required IconData icon,
    required String route,
    required String currentRoute,
    required VoidCallback onTap,
    Color? color,
    double indent = 0,
  }) {
    final isSelected = currentRoute == route;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.only(left: indent + 8, right: 8, top: 4, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.green : (color ?? Colors.grey[700]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.green[800] : Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTrialOrSubscriptionCard(UserModel user) {
    if (user.subscriptionId == null) {
      // Trial user → 30 days from createdAt
      final trialEnds = user.createdAt?.add(const Duration(days: 30));
      if (trialEnds != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: TrialCard(trialEnds: trialEnds, isTrial: true),
        );
      }
    } else if (user.subscriptionEnd != null) {
      // Paid plan → show subscription expiry
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: TrialCard(
          trialEnds: DateTime.parse(user.subscriptionEnd!),
          isTrial: false,
        ),
      );
    }
    return const SizedBox.shrink(); // nothing if no data
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final currentRoute = Get.currentRoute;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // -------------------- User Header --------------------
            Obx(() {
              final user = controller.user.value;
              final profileImage = user?.profileImage;

              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: Text(
                  user?.username ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(user?.email ?? 'N/A'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: profileImage == null || profileImage.isEmpty
                      ? Text(
                          (user?.username ?? 'U').substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                            "$publicUrl/$profileImage",
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // fallback if network image fails
                              return Center(
                                child: Text(
                                  (user?.username ?? 'U')
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              );
            }),

            // -------------------- Trial / Subscription Card --------------------
            Obx(() {
              final user = authController.user.value;
              if (user != null) {
                final trialEnds = user.createdAt?.add(const Duration(days: 30));
                final now = DateTime.now();

                // Check if trial expired
                final isTrialExpired =
                    (user.subscriptionId == null) &&
                    (trialEnds != null && now.isAfter(trialEnds));

                if (isTrialExpired) {
                  // Trial ended → show message + upgrade button only
                  return Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4,
                        ),
                        child: TrialCard(
                          trialEnds: null,
                          isTrial: true,
                          trialEnded:
                              true, // custom flag in your TrialCard widget
                        ),
                      ),
                    ],
                  );
                }

                // Trial ongoing or subscription active → show normal card
                return _buildTrialOrSubscriptionCard(user);
              }
              return const SizedBox.shrink();
            }),

            // -------------------- Main Menu --------------------
            Expanded(
              child: Obx(() {
                final user = authController.user.value;
                final trialEnds = user?.createdAt?.add(
                  const Duration(days: 30),
                );
                final now = DateTime.now();
                final isTrialExpired =
                    (user?.subscriptionId == null) &&
                    (trialEnds != null && now.isAfter(trialEnds));

                // If trial expired → hide all menus except logout + upgrade
                if (isTrialExpired) {
                  return const SizedBox.shrink();
                }

                return ListView(
                  children: [
                    // -------------------- Quick Link --------------------
                    _buildSectionHeader("Quick Link"),
                    _buildNavTile(
                      title: "New Sales",
                      icon: Icons.sell_outlined,
                      route: AppRoutes.newSales,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.newSales),
                    ),
                    _buildNavTile(
                      title: "New Purchase",
                      icon: Icons.add_shopping_cart_outlined,
                      route: AppRoutes.newPurchase,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.newPurchase),
                    ),
                    Obx(() {
                      final user = authController.user.value;
                      if (SubscriptionUtil.hasValidSubscription(user)) {
                        return _buildNavTile(
                          title: "POS",
                          icon: Icons.point_of_sale_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // -------------------- Parties --------------------
                    _buildSectionHeader("Parties"),
                    _buildNavTile(
                      title: "Customer",
                      icon: Icons.person_outlined,
                      route: AppRoutes.parties,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.parties),
                    ),
                    _buildNavTile(
                      title: "Supplier",
                      icon: Icons.group_outlined,
                      route: AppRoutes.parties,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.parties),
                    ),

                    // -------------------- My Business --------------------
                    _buildSectionHeader("My Business"),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.point_of_sale_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Sales",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.viewAllsales,
                        AppRoutes.allPaymentInView,
                        AppRoutes.viewAllsalesReturns,
                        AppRoutes.viewQuotation,
                        AppRoutes.viewAllsalesOrders,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Sale Invoice",
                          icon: Icons.receipt_long_outlined,
                          route: AppRoutes.viewAllsales,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.viewAllsales),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Payment In",
                          icon: Icons.payments_outlined,
                          route: AppRoutes.allPaymentInView,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.allPaymentInView),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Sale Return",
                          icon: Icons.swap_horiz_outlined,
                          route: AppRoutes.viewAllsalesReturns,
                          currentRoute: currentRoute,
                          onTap: () =>
                              Get.toNamed(AppRoutes.viewAllsalesReturns),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Estimate/Quotation",
                          icon: Icons.description_outlined,
                          route: AppRoutes.viewQuotation,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.viewQuotation),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Sales Order",
                          icon: Icons.shopping_cart_outlined,
                          route: AppRoutes.viewAllsalesOrders,
                          currentRoute: currentRoute,
                          onTap: () =>
                              Get.toNamed(AppRoutes.viewAllsalesOrders),
                          indent: 16,
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.receipt_long_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Purchase",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.viewPurchaseBills,
                        AppRoutes.allPaymentOutView,
                        AppRoutes.purchaseReturnView,
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Purchase Bills",
                          icon: Icons.receipt_outlined,
                          route: AppRoutes.viewPurchaseBills,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.viewPurchaseBills),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Payment Out",
                          icon: Icons.payments_outlined,
                          route: AppRoutes.allPaymentOutView,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.allPaymentOutView),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Purchase Return",
                          icon: Icons.swap_horiz_outlined,
                          route: AppRoutes.purchaseReturnView,
                          currentRoute: currentRoute,
                          onTap: () =>
                              Get.toNamed(AppRoutes.purchaseReturnView),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Purchase Order",
                          icon: Icons.shopping_bag_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Inventory",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.addItems,
                        AppRoutes.viewItems,
                        AppRoutes.categories,
                        AppRoutes.brands,
                        AppRoutes.units,
                        AppRoutes.itemsDashboard,
                        AppRoutes.stockAdjustment,
                        AppRoutes.stockTransfer,
                      ].contains(currentRoute),
                      children: [
                        ExpansionTile(
                          title: const Text(
                            "Item Management",
                            style: TextStyle(fontSize: 15),
                          ),
                          childrenPadding: const EdgeInsets.only(left: 16),
                          initiallyExpanded: [
                            AppRoutes.addItems,
                            AppRoutes.viewItems,
                            AppRoutes.categories,
                            AppRoutes.brands,
                            AppRoutes.units,
                            AppRoutes.itemsDashboard,
                          ].contains(currentRoute),
                          children: [
                            _buildNavTile(
                              title: "Add Item",
                              icon: Icons.add_circle_outline,
                              route: AppRoutes.addItems,
                              currentRoute: currentRoute,
                              onTap: () => Get.toNamed(AppRoutes.addItems),
                              indent: 16,
                            ),
                            _buildNavTile(
                              title: "View Items",
                              icon: Icons.list_alt_outlined,
                              route: AppRoutes.viewItems,
                              currentRoute: currentRoute,
                              onTap: () => Get.toNamed(AppRoutes.viewItems),
                              indent: 16,
                            ),
                            _buildNavTile(
                              title: "Categories",
                              icon: Icons.category_outlined,
                              route: AppRoutes.categories,
                              currentRoute: currentRoute,
                              onTap: () => Get.toNamed(AppRoutes.categories),
                              indent: 16,
                            ),
                            _buildNavTile(
                              title: "Brands",
                              icon: Icons.branding_watermark_outlined,
                              route: AppRoutes.brands,
                              currentRoute: currentRoute,
                              onTap: () => Get.toNamed(AppRoutes.brands),
                              indent: 16,
                            ),
                            _buildNavTile(
                              title: "Units",
                              icon: Icons.straighten_outlined,
                              route: AppRoutes.units,
                              currentRoute: currentRoute,
                              onTap: () => Get.toNamed(AppRoutes.units),
                              indent: 16,
                            ),
                            _buildNavTile(
                              title: "Insights",
                              icon: Icons.insights_outlined,
                              route: AppRoutes.itemsDashboard,
                              currentRoute: currentRoute,
                              onTap: () =>
                                  Get.toNamed(AppRoutes.itemsDashboard),
                              indent: 16,
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            "Stock Management",
                            style: TextStyle(fontSize: 15),
                          ),
                          childrenPadding: const EdgeInsets.only(left: 16),
                          initiallyExpanded: [
                            AppRoutes.stockAdjustment,
                            AppRoutes.stockTransfer,
                          ].contains(currentRoute),
                          children: [
                            _buildNavTile(
                              title: "Stock Adjustment",
                              icon: Icons.tune_outlined,
                              route: AppRoutes.stockAdjustment,
                              currentRoute: currentRoute,
                              onTap: () =>
                                  Get.toNamed(AppRoutes.stockAdjustment),
                              indent: 16,
                            ),
                            _buildNavTile(
                              title: "Stock Transfer",
                              icon: Icons.swap_horiz_outlined,
                              route: AppRoutes.stockTransfer,
                              currentRoute: currentRoute,
                              onTap: () => Get.toNamed(AppRoutes.stockTransfer),
                              indent: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Expense",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Expenses",
                          icon: Icons.money_off_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Expense Categories",
                          icon: Icons.category_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                      ],
                    ),

                    // -------------------- Report --------------------
                    _buildSectionHeader("Report"),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.analytics_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Transaction",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Sale Report",
                          icon: Icons.bar_chart_outlined,
                          route: AppRoutes.reports,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.reports),
                          indent: 16,
                        ),

                        _buildNavTile(
                          title: "Purchase Report",
                          icon: Icons.bar_chart_outlined,
                          route: AppRoutes.reports,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.reports),
                          indent: 16,
                        ),
                        Obx(() {
                          final user = authController.user.value;
                          if (SubscriptionUtil.hasValidSubscription(user)) {
                            return Column(
                              children: [
                                _buildNavTile(
                                  title: "Day Book",
                                  icon: Icons.book_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                                _buildNavTile(
                                  title: "Profit & Loss",
                                  icon: Icons.trending_up_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                                _buildNavTile(
                                  title: "All Transaction Report",
                                  icon: Icons.receipt_long_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                                _buildNavTile(
                                  title: "Cash Flow",
                                  icon: Icons.account_balance_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                                _buildNavTile(
                                  title: "Balance Sheet",
                                  icon: Icons.account_balance_wallet_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.people_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Party Reports",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Party Statement",
                          icon: Icons.description_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                        Obx(() {
                          final user = authController.user.value;
                          if (SubscriptionUtil.hasValidSubscription(user)) {
                            return Column(
                              children: [
                                _buildNavTile(
                                  title: "Party Wise Profit & Loss",
                                  icon: Icons.trending_up_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                                _buildNavTile(
                                  title: "All Parties Report",
                                  icon: Icons.group_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Item/Stock Reports",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                   
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Stock Summary Report",
                          icon: Icons.summarize_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                        Obx(() {
                          final user = authController.user.value;
                          if (SubscriptionUtil.hasValidSubscription(user)) {
                            return Column(
                              children: [
                                _buildNavTile(
                                  title: "Item Wise Profit & Loss",
                                  icon: Icons.trending_up_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                                _buildNavTile(
                                  title: "Stock Details Report",
                                  icon: Icons.description_outlined,
                                  route: AppRoutes.nullroute,
                                  currentRoute: currentRoute,
                                  onTap: () => AppSnackbar.show(),
                                  indent: 16,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.account_balance_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "GST Reports",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "GSTR-1",
                          icon: Icons.description_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.money_off_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Expense Reports",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Expense Transaction Report",
                          icon: Icons.description_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                      ],
                    ),

                    // -------------------- Cash & Bank --------------------
                    _buildSectionHeader("Cash & Bank"),
                    _buildNavTile(
                      title: "Bank Account",
                      icon: Icons.account_balance_wallet_outlined,
                      route: AppRoutes.bankAccountSettings,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.bankAccountSettings),
                    ),
                    _buildNavTile(
                      title: "Cash in Hand",
                      icon: Icons.money_outlined,
                      route: AppRoutes.nullroute,
                      currentRoute: currentRoute,
                      onTap: () => AppSnackbar.show(),
                    ),

                    // -------------------- Utilities --------------------
                    _buildSectionHeader("Utilities"),
                    _buildNavTile(
                      title: "Store Management",
                      icon: Icons.store_outlined,
                      route: AppRoutes.storesSettings,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.storesSettings),
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Utilities",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        Obx(() {
                          final user = authController.user.value;
                          if (SubscriptionUtil.hasValidSubscription(user)) {
                            return _buildNavTile(
                              title: "Close Financial Year",
                              icon: Icons.lock_outlined,
                              route: AppRoutes.nullroute,
                              currentRoute: currentRoute,
                              onTap: () => AppSnackbar.show(),
                              indent: 16,
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),

                    // -------------------- Settings --------------------
                    _buildSectionHeader("Settings"),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Account Settings",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.nullroute,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Subscription",
                          icon: Icons.subscriptions_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                      ],
                    ),
                    _buildNavTile(
                      title: "Business Profile",
                      icon: Icons.business_outlined,
                      route: AppRoutes.businessProfile,
                      currentRoute: currentRoute,
                      onTap: () => Get.toNamed(AppRoutes.businessProfile),
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.group_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "User Management",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.usersSettings,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Add User",
                          icon: Icons.person_add_outlined,
                          route: AppRoutes.usersSettings,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.usersSettings),
                          indent: 16,
                        ),
                        Obx(() {
                          final user = authController.user.value;
                          if (SubscriptionUtil.hasValidSubscription(user)) {
                            return _buildNavTile(
                              title: "User Role Management",
                              icon: Icons.admin_panel_settings_outlined,
                              route: AppRoutes.nullroute,
                              currentRoute: currentRoute,
                              onTap: () => AppSnackbar.show(),
                              indent: 16,
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(
                        Icons.store_outlined,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Store Settings",
                        style: TextStyle(fontSize: 15),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 16),
                      initiallyExpanded: [
                        AppRoutes.invoiceSettings,
                      ].contains(currentRoute),
                      children: [
                        _buildNavTile(
                          title: "Invoice Settings",
                          icon: Icons.receipt_outlined,
                          route: AppRoutes.invoiceSettings,
                          currentRoute: currentRoute,
                          onTap: () => Get.toNamed(AppRoutes.invoiceSettings),
                          indent: 16,
                        ),
                        _buildNavTile(
                          title: "Purchase Settings",
                          icon: Icons.settings_outlined,
                          route: AppRoutes.nullroute,
                          currentRoute: currentRoute,
                          onTap: () => AppSnackbar.show(),
                          indent: 16,
                        ),
                        Obx(() {
                          final user = authController.user.value;
                          if (SubscriptionUtil.hasValidSubscription(user)) {
                            return _buildNavTile(
                              title: "POS Settings",
                              icon: Icons.point_of_sale_outlined,
                              route: AppRoutes.nullroute,
                              currentRoute: currentRoute,
                              onTap: () => AppSnackbar.show(),
                              indent: 16,
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),

                    // -------------------- Subscription Check --------------------
                    Obx(() {
                      final user = authController.user.value;
                      if (!SubscriptionUtil.hasValidSubscription(user)) {
                        return SidebarUpgradeButton();
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                );
              }),
            ),

            // -------------------- Logout Button --------------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildNavTile(
                title: "Logout",
                icon: Icons.logout,
                route: "",
                currentRoute: "",
                color: Colors.red,
                onTap: () async {
                  logger.i('Initiating logout');
                  await controller.logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

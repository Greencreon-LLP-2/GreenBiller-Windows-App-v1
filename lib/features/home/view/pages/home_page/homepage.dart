import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/GoRouterNavigationService.dart';
import 'package:green_biller/features/auth/login/services/snackbar_service.dart';
import 'package:green_biller/features/home/view/pages/darshboard_page.dart';
import 'package:green_biller/features/home/view/pages/home_page/utils/trail_version_container.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/build_home_content.dart';

import 'package:green_biller/features/home/view/pages/menu_page/widgets/payment_out.dart';
import 'package:green_biller/features/item/view/pages/add_items_page/add_items_page.dart';
import 'package:green_biller/features/item/view/pages/all_items_page/all_items.dart';
import 'package:green_biller/features/item/view/pages/brand/brand_page.dart';
import 'package:green_biller/features/item/view/pages/categories/categories_page.dart';
import 'package:green_biller/features/item/view/pages/items_page.dart';
import 'package:green_biller/features/item/view/pages/units/units_page.dart';
import 'package:green_biller/features/notifications/views/notification_page.dart';
import 'package:green_biller/features/payment/view/pages/payment_in_page/add_payment_in_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/purchase_page.dart';

import 'package:green_biller/features/purchase/view/pages/purchase_returns_view/purchase_return_view_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_view/purchase_bills.dart';
import 'package:green_biller/features/reports/purchase_report/view/pages/purchase_item_report.dart';
import 'package:green_biller/features/reports/purchase_report/view/pages/purchase_summary.dart';
import 'package:green_biller/features/reports/purchase_report/view/pages/purchase_supplier_base_summary.dart';
import 'package:green_biller/features/reports/sales_report/sales_by_item_page.dart';
import 'package:green_biller/features/reports/sales_report/view/pages/sales_by_customer.dart';
import 'package:green_biller/features/reports/sales_report/view/pages/sales_summary_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_order_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/new_sale_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/sales%20LIst/sales_list.dart';
import 'package:green_biller/features/sales/view/pages/credit_note.dart';
import 'package:green_biller/features/sales/view/pages/sales_order_page.dart';
import 'package:green_biller/features/sales/view/pages/sales_return_page.dart';
import 'package:green_biller/features/sales/view/pages/stock_adjustment_item.dart';
import 'package:green_biller/features/sales/view/pages/stock_transfer_item.dart';
import 'package:green_biller/features/settings/view/pages/Activity%20Log/active_log_page.dart';
import 'package:green_biller/features/settings/view/pages/account_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/business_profile_page/business_profile_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/invoice_settings.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/sales_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/users_setting_page/users_settings.page.dart';
import 'package:green_biller/features/store/view/parties_page/parties_page.dart';
import 'package:green_biller/features/store/view/store_page/store_page.dart';
import 'package:green_biller/features/user/user_creation_page/user_creation_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isMediumScreen = constraints.maxWidth < 800;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Row(
            children: [
              if (!isSmallScreen)
                Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: accentColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Green Biller",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TrialVersionContainer(),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          children: [
                            _buildNavItem(
                              title: 'Dashboard',
                              icon: Icons.home_outlined,
                              selectedIcon: Icons.home,
                              index: 0,
                              selectedIndex: selectedIndex.value,
                              onTap: () => selectedIndex.value = 0,
                            ),
                            _buildNavItem(
                              title: 'Stores',
                              icon: Icons.store,
                              selectedIcon: Icons.store,
                              index: 2,
                              selectedIndex: selectedIndex.value,
                              onTap: () => selectedIndex.value = 2,
                            ),
                            _buildNavItem(
                              title: 'New Sale',
                              icon: Icons.add_circle_outline,
                              selectedIcon: Icons.add_circle,
                              index: 4,
                              selectedIndex: selectedIndex.value,
                              onTap: () => selectedIndex.value = 4,
                            ),
                            _buildNavItem(
                              title: 'Purchase',
                              icon: Icons.shopping_cart_outlined,
                              selectedIcon: Icons.shopping_cart,
                              index: 5,
                              selectedIndex: selectedIndex.value,
                              onTap: () => selectedIndex.value = 5,
                            ),
                            _buildNavItem(
                              title: 'Parties',
                              icon: Icons.person_2_outlined,
                              selectedIcon: Icons.person_2,
                              index: 7,
                              selectedIndex: selectedIndex.value,
                              onTap: () => selectedIndex.value = 7,
                            ),
                            _buildNavItem(
                              title: 'Users',
                              icon: Icons.person_outline,
                              selectedIcon: Icons.person,
                              index: 8,
                              selectedIndex: selectedIndex.value,
                              onTap: () => selectedIndex.value = 8,
                            ),
                            const Divider(height: 32),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              child: Text(
                                "QUICK ACTIONS",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: textSecondaryColor,
                                ),
                              ),
                            ),
                            _buildNavDropdown(
                                title: 'Items',
                                icon: Icons.inventory_2_outlined,
                                selectedIcon: Icons.inventory_2,
                                selectedIndex: selectedIndex.value,
                                subItems: [
                                  _buildNavSubItem(
                                      title: 'Add Items',
                                      icon: Icons.add,
                                      index: 25,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 25),
                                  _buildNavSubItem(
                                      title: 'All Items',
                                      icon: Icons.all_inclusive,
                                      index: 26,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 26),
                                  _buildNavSubItem(
                                      title: 'Categories',
                                      icon: Icons.category_outlined,
                                      index: 22,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 27),
                                  _buildNavSubItem(
                                      title: 'Brands',
                                      icon: Icons.branding_watermark,
                                      index: 28,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 28),
                                  _buildNavSubItem(
                                      title: 'Units',
                                      icon: Icons.scale_outlined,
                                      index: 29,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 29),
                                ]),
                            _buildNavDropdown(
                              title: 'Sales Details',
                              icon: Icons.sell_outlined,
                              selectedIcon: Icons.sell,
                              selectedIndex: selectedIndex.value,
                              subItems: [
                                _buildNavSubItem(
                                  title: 'Sale List',
                                  icon: Icons.list_alt,
                                  index: 6,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 6,
                                ),
                                _buildNavSubItem(
                                  title: 'Payment In',
                                  icon: Icons.payment,
                                  index: 9,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 9,
                                ),
                                _buildNavSubItem(
                                  title: 'Sales Return',
                                  icon: Icons.undo,
                                  index: 10,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 10,
                                ),
                                _buildNavSubItem(
                                  title: 'Sale Order',
                                  icon: Icons.shopping_bag,
                                  index: 11,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 11,
                                ),
                                _buildNavSubItem(
                                  title: 'Stock Adjustment',
                                  icon: Icons.tune,
                                  index: 12,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 12,
                                ),
                                _buildNavSubItem(
                                  title: 'Add Sale Return',
                                  icon: Icons.add_circle,
                                  index: 14,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 14,
                                ),
                                _buildNavSubItem(
                                  title: 'Add Sale Order',
                                  icon: Icons.add_shopping_cart,
                                  index: 15,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 15,
                                ),
                              ],
                            ),
                            _buildNavDropdown(
                              title: 'Stock Details',
                              icon: Icons.inventory_outlined,
                              selectedIcon: Icons.inventory,
                              selectedIndex: selectedIndex.value,
                              subItems: [
                                _buildNavSubItem(
                                  title: 'Stock Adjustment',
                                  icon: Icons.tune,
                                  index: 14,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 12,
                                ),
                                _buildNavSubItem(
                                  title: 'Stock Transfer',
                                  icon: Icons.swap_horiz,
                                  index: 15,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 13,
                                ),
                              ],
                            ),
                            _buildNavDropdown(
                              title: 'Purchase Details',
                              icon: Icons.shopping_cart_outlined,
                              selectedIcon: Icons.shopping_cart,
                              selectedIndex: selectedIndex.value,
                              subItems: [
                                _buildNavSubItem(
                                  title: 'Purchase Bills',
                                  icon: Icons.receipt,
                                  index: 16,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 16,
                                ),
                                _buildNavSubItem(
                                  title: 'Purchase Return',
                                  icon: Icons.undo,
                                  index: 19,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 17,
                                ),
                                _buildNavSubItem(
                                  title: 'Payment Out',
                                  icon: Icons.payment,
                                  index: 18,
                                  selectedIndex: selectedIndex.value,
                                  onTap: () => selectedIndex.value = 18,
                                ),
                              ],
                            ),
                            _buildNavDropdown(
                              title: 'Reports',
                              icon: Icons.bar_chart_outlined,
                              selectedIcon: Icons.bar_chart,
                              selectedIndex: selectedIndex.value,
                              subItems: [
                                _buildNestedNavDropdown(
                                  title: 'Sales Report',
                                  icon: Icons.sell_outlined,
                                  selectedIndex: selectedIndex.value,
                                  subItems: [
                                    _buildNavSubItem(
                                      title: 'Sales\nSummary',
                                      icon: Icons.summarize,
                                      index: 19,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 19,
                                    ),
                                    // _buildNavSubItem(
                                    //   title: 'Sales\nby Item',
                                    //   icon: Icons.inventory_2,
                                    //   index: 20,
                                    //   selectedIndex: selectedIndex.value,
                                    //   onTap: () => selectedIndex.value = 20,
                                    // ),
                                    _buildNavSubItem(
                                      title: 'Sales\nby Customer',
                                      icon: Icons.person,
                                      index: 21,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 21,
                                    ),
                                  ],
                                ),
                                _buildNestedNavDropdown(
                                  title: 'Purchase Report',
                                  icon: Icons.shopping_cart_outlined,
                                  selectedIndex: selectedIndex.value,
                                  subItems: [
                                    _buildNavSubItem(
                                      title: 'Purchase\nSummary',
                                      icon: Icons.summarize,
                                      index: 22,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 22,
                                    ),
                                    _buildNavSubItem(
                                      title: 'Purchase Item\nReport',
                                      icon: Icons.inventory_2,
                                      index: 23,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 23,
                                    ),
                                    _buildNavSubItem(
                                      title: 'Purchase\nSupplier\nSummary',
                                      icon: Icons.person,
                                      index: 24,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 24,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            _buildNavDropdown(
                                title: 'Settings',
                                icon: Icons.settings,
                                selectedIcon: Icons.settings,
                                selectedIndex: selectedIndex.value,
                                subItems: [
                                  _buildNavSubItem(
                                      title: 'Business Settings',
                                      icon: Icons.business,
                                      index: 30,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 30),
                                  _buildNavSubItem(
                                      title: 'Accounts Settings',
                                      icon: Icons.account_box_sharp,
                                      index: 31,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 31),
                                  _buildNavSubItem(
                                      title: 'Sales Settings',
                                      icon: Icons.sell,
                                      index: 32,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 32),
                                  _buildNavSubItem(
                                      title: 'Invoice Settings',
                                      icon: Icons.file_open,
                                      index: 33,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 33),
                                  _buildNavSubItem(
                                      title: 'Users Settings',
                                      icon: Icons.person_2,
                                      index: 34,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 34),
                                  _buildNavSubItem(
                                      title: 'Activity Log',
                                      icon: Icons.local_activity,
                                      index: 35,
                                      selectedIndex: selectedIndex.value,
                                      onTap: () => selectedIndex.value = 35),
                                ]),

                            // _buildNavItem(
                            //   title: 'Logout',
                            //   icon: Icons.logout_outlined,
                            //   selectedIcon: Icons.logout,
                            //   index: -1,
                            //   selectedIndex: selectedIndex.value,
                            //   onTap: () async {
                            //     try {
                            //       final prefs =
                            //           await SharedPreferences.getInstance();
                            //       await prefs.clear();
                            //       ref.read(userProvider.notifier).state = null;
                            //       GoRouterNavigationService.goWithDelay('/',
                            //           replace: true);
                            //       SnackBarService.showSuccess(
                            //           'Successfully logged out');
                            //     } catch (e) {
                            //       SnackBarService.showError(
                            //           'Logout failed: $e');
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.push('/packages');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 0, 0, 0),
                                    accentColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "Upgrade to Pro",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: accentColor,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userModel?.user?.name ?? "Admin",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: textPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              icon: const Icon(
                                Icons.logout_sharp,
                              ),
                              label: const Text("Logout"),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                overlayColor: accentColor.withOpacity(0.3),
                              ),
                              onPressed: () async {
                                try {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  ref.read(userProvider.notifier).state = null;
                                  GoRouterNavigationService.goWithDelay('/',
                                      replace: true);
                                  SnackBarService.showSuccess(
                                      'Successfully logged out');
                                } catch (e) {
                                  SnackBarService.showError(
                                      'Logout failed: $e');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    if (!isSmallScreen && selectedIndex.value == 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              _getPageTitle(selectedIndex.value),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                              ),
                            ),
                            // const Spacer(),
                            // IconButton(
                            //   icon: const Icon(Icons.search),
                            //   onPressed: () {},
                            //   color: textSecondaryColor,
                            // ),
                            // IconButton(
                            //   icon: const Badge(
                            //     label: Text("2"),
                            //     child: Icon(Icons.notifications_outlined),
                            //   ),
                            //   onPressed: () {
                            //     showNotificationOverlay(context);
                            //   },
                            //   color: textSecondaryColor,
                            // ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex.value,
                        children: [
                          BuildHomeContent(
                            isSmallScreen: isSmallScreen,
                            isMediumScreen: isMediumScreen,
                          ),
                          const DashboardPage(), //0
                          const StorePageCustom(), //1
                          const ItemsPage(), //2
                          const AddNewSalePage(), //3
                          const PurchasePage(), //4
                          const SalesListPage(), //5
                          const PartiesPage(), //6
                          const UserCreationPage(), //7
                          const AddPaymentInPage(), //8
                          const SalesReturnPage(), //9
                          const SalesOrderPage(), //10
                          StockAdjustmentItem(), //11
                          StockTransferItem(), //12
                          CreditNotePage(), //13
                          AddSalesOrderPage(), //14
                          PurchaseBills(), //15
                          PurchaseReturnViewPage(), //16
                          const PaymentOutPage(), //17
                          const SalesSummaryPage(), //18
                          const SalesByItemPage(), //19
                          const SalesByCustomerPage(), //20
                          const PurchaseSummary(), //21
                          const PurchaseItemReportPage(), //22
                          const PurchaseSupplierBaseSummary(), //23
                          const AddItemsPage(), //25
                          const AllItemsPage(), //26
                          const CategoriesPage(), //27
                          const BrandPage(), //28
                          const UnitsPage(), //29
                          const BusinessProfilePage(), //30
                          const AccountSettingsPage(), //31
                          const SalesSettingsPage(), //32
                          InvoiceSettingsPage(
                            accessToken: accessToken!,
                          ), //33
                          const UserSettingsPage(), //34
                          const ActiveLogPage(), //35
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: isSmallScreen
              ? Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard_outlined),
                        activeIcon: Icon(Icons.dashboard),
                        label: 'Dashboard',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.store),
                        activeIcon: Icon(Icons.store),
                        label: 'Stores',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.inventory_2_outlined),
                        activeIcon: Icon(Icons.inventory_2),
                        label: 'Items',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu),
                        activeIcon: Icon(Icons.menu),
                        label: 'Menu',
                      ),
                    ],
                    currentIndex: selectedIndex.value,
                    selectedItemColor: accentColor,
                    unselectedItemColor: textLightColor,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    onTap: (index) {
                      selectedIndex.value = index;
                    },
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required IconData selectedIcon,
    required int index,
    required int selectedIndex,
    VoidCallback? onTap,
  }) {
    final isSelected = index == selectedIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? accentColor : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? accentColor : textSecondaryColor,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? accentColor : textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavDropdown({
    required String title,
    required IconData icon,
    required IconData selectedIcon,
    required int selectedIndex,
    required List<Widget> subItems,
  }) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: textSecondaryColor, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: textSecondaryColor,
          ),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 40),
        children: subItems,
      ),
    );
  }

  Widget _buildNestedNavDropdown({
    required String title,
    required IconData icon,
    required int selectedIndex,
    required List<Widget> subItems,
  }) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: textSecondaryColor, size: 20),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textSecondaryColor,
          ),
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 50),
        children: subItems,
      ),
    );
  }

  Widget _buildNavSubItem({
    required String title,
    required IconData icon,
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withOpacity(0.1)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? accentColor : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? accentColor : textSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? accentColor : textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Dashboard';
      case 2:
        return 'Stores';
      case 3:
        return 'Items';
      case 4:
        return 'Menu';
      case 5:
        return 'New Sale';
      case 6:
        return 'Sale List';
      case 7:
        return 'Purchase';
      case 8:
        return 'Parties';
      case 10:
        return 'Users';
      case 11:
        return 'Payment In';
      case 12:
        return 'Sales Return';
      case 13:
        return 'Sale Order';
      case 14:
        return 'Stock Adjustment';
      case 15:
        return 'Stock Transfer';
      case 16:
        return 'Add Sale Return';
      case 17:
        return 'Add Sale Order';
      case 18:
        return 'Purchase Bills';
      case 19:
        return 'Purchase Return';
      case 20:
        return 'Payment Out';
      case 21:
        return 'Sales Summary';
      case 22:
        return 'Sales by Item';
      case 23:
        return 'Sales by Customer';
      case 24:
        return 'Purchase Summary';
      case 25:
        return 'Purchase Item Report';
      case 26:
        return 'Purchase Supplier Base Summary';
      default:
        return '';
    }
  }
}

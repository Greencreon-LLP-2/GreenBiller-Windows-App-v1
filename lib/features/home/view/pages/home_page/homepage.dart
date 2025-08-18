import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/home/view/pages/darshboard_page.dart';
import 'package:green_biller/features/home/view/pages/home_page/utils/trail_version_container.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/build_home_content.dart';
import 'package:green_biller/features/home/view/pages/menu_page/menu_page.dart';
import 'package:green_biller/features/item/view/pages/items_page.dart';
import 'package:green_biller/features/notifications/views/notification_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/purchase_page.dart';
import 'package:green_biller/features/reports/report_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/new_sale_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/sales%20LIst/sales_list.dart';
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
                  width: 240, // Wider navigation panel
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
                              'Home',
                              Icons.home_outlined,
                              Icons.home,
                              0,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 0,
                            ),
                            _buildNavItem(
                              'Dashboard',
                              Icons.dashboard_outlined,
                              Icons.dashboard,
                              1,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 1,
                            ),
                            _buildNavItem(
                              'Stores',
                              Icons.store,
                              Icons.store,
                              2,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 2,
                            ),
                            _buildNavItem(
                              'Items',
                              Icons.inventory_2_outlined,
                              Icons.inventory_2,
                              3,
                              selectedIndex.value,
                              onTap: () {
                                selectedIndex.value = 3;
                              },
                            ),
                            _buildNavItem(
                            'My Business',
                              Icons.business,
                              Icons.business,
                              4,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 4,
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
                            _buildNavItem('New Sale', Icons.add_circle_outline,
                                Icons.add_circle, -1, selectedIndex.value,
                                onTap: () => selectedIndex.value = 5),
                            _buildNavItem(
                              'Sale List',
                              Icons.list_alt_rounded,
                              Icons.list_alt,
                              -1,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 6,
                            ),
                            _buildNavItem(
                              'Purchase',
                              Icons.shopping_cart_outlined,
                              Icons.shopping_cart,
                              -1,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 7,
                            ),
                            _buildNavItem(
                              'Parties',
                              Icons.person_2_outlined,
                              Icons.person_2,
                              -1,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 8,
                            ),
                            _buildNavItem(
                              'Reports',
                              Icons.bar_chart,
                              Icons.bar_chart,
                              -1,
                              -2,
                              onTap: () {
                                context.push('/reports');
                              },
                            ),
                            _buildNavItem(
                              'Users',
                              Icons.bar_chart,
                              Icons.bar_chart,
                              -1,
                              selectedIndex.value,
                              onTap: () => selectedIndex.value = 10,
                            ),
                            _buildNavItem(
                              'Logout',
                              Icons.logout_outlined,
                              Icons.logout_outlined,
                              -1,
                              -2,
                              onTap: () async {
                                try {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();

                                  final container =
                                      ProviderScope.containerOf(context);
                                  container.read(userProvider.notifier).state =
                                      null; // or however you clear the user state

                                  if (context.mounted) {
                                    context.go('/');
                                  }

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Successfully logged out'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Logout failed: $e')),
                                    );
                                  }
                                }
                              },
                            )
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
                                  horizontal: 8, vertical: 16),
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
                                  // Text(
                                  //   "Admin",
                                  //   style: TextStyle(
                                  //     fontSize: 12,
                                  //     color:
                                  //         textSecondaryColor.withOpacity(0.8),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings_outlined),
                              onPressed: () {
                                context.push('/settings');
                              },
                              color: textSecondaryColor,
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
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                              color: textSecondaryColor,
                            ),
                            IconButton(
                              icon: const Badge(
                                label: Text("2"),
                                child: Icon(Icons.notifications_outlined),
                              ),
                              onPressed: () {
                                showNotificationOverlay(context);
                              },
                              color: textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: IndexedStack(
                        index: selectedIndex.value,
                        children: [
                          BuildHomeContent(
                              isSmallScreen: isSmallScreen,
                              isMediumScreen: isMediumScreen),
                          const DashboardPage(),
                          const StorePageCustom(),
                          const ItemsPage(),
                          const MenuPage(),
                          const AddNewSalePage(),
                          const SalesListPage(),
                          const PurchasePage(),
                          const PartiesPage(),
                          const ReportsPage(),
                          const UserCreationPage(),
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

  Widget _buildNavItem(
    String title,
    IconData icon,
    IconData selectedIcon,
    int index,
    int selectedIndex, {
    VoidCallback? onTap,
  }) {
    final isSelected = index == selectedIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color:
                isSelected ? accentColor.withOpacity(0.1) : Colors.transparent,
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
      default:
        return '';
    }
  }
}

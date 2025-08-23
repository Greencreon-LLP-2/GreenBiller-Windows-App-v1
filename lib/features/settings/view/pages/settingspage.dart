import 'package:flutter/material.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/settings/view/pages/Activity%20Log/active_log_page.dart';
import 'package:green_biller/features/settings/view/pages/account_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/business_profile_page/business_profile_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/invoice_settings.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/sales_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/users_setting_page/users_settings.page.dart';
import 'package:hooks_riverpod/legacy.dart';

// StateProvider for managing the selected index
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access userProvider to get accessToken
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;

    // Watch the selected index
    final selectedIndex = ref.watch(selectedIndexProvider);

    // Define settings pages, passing accessToken to InvoiceSettingsPage
    final List<Widget> settingsPages = [
      const BusinessProfilePage(),
      const AccountSettingsPage(),
      const SalesSettingsPage(),
      accessToken != null
          ? InvoiceSettingsPage(accessToken: accessToken)
          : const Center(
              child: Text('Please log in to access invoice settings')),
      const UserSettingsPage(),
      const ActiveLogPage(),
      const Placeholder(), // Theme
      const Placeholder(), // About
    ];

    // Ensure index is safe for settingsPages
    int safeIndex = selectedIndex;
    if (safeIndex >= settingsPages.length) {
      safeIndex = 0;
      ref.read(selectedIndexProvider.notifier).state =
          0; // Reset to 0 if invalid
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          // Sidebar
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
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: accentColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Settings Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title
                      const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      _buildSectionHeader("BUSINESS SETTINGS"),
                      _buildNavItem(ref, 0, "Business Profile", Icons.business),
                      _buildNavItem(ref, 1, "Accounts", Icons.account_circle),
                      _buildNavItem(
                          ref, 2, "Sales Setting", Icons.receipt_long),
                      _buildNavItem(
                          ref, 3, "Invoice Settings", Icons.description),
                      _buildSectionHeader("USER MANAGEMENT"),
                      _buildNavItem(ref, 4, "Users", Icons.people_outline),
                      _buildNavItem(ref, 5, "Activity Log", Icons.history),
                      // _buildSectionHeader("APP SETTINGS"),
                      // _buildNavItem(ref, 6, "Language", Icons.language),
                      // _buildNavItem(ref, 7, "Theme", Icons.palette_outlined),
                      // _buildNavItem(ref, 8, "About", Icons.info_outline),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
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
                ),

                // Content Area
                Expanded(
                  child: settingsPages[safeIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: 8,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildNavItem(WidgetRef ref, int index, String title, IconData icon) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final isSelected = selectedIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(selectedIndexProvider.notifier).state = index;
        },
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
                icon,
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
}

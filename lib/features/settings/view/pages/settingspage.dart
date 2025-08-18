import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/settings/view/pages/Activity%20Log/active_log_page.dart';
import 'package:green_biller/features/settings/view/pages/account_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/business_profile_page/business_profile_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/invoice_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/sales_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/users_setting_page/users_settings.page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;

  static final List<Widget> _settingsPages = [
    const BusinessProfilePage(),
    const AccountSettingsPage(),
    const SalesSettingsPage(),
    const InvoiceSettingsPage(),
    const UserSettingsPage(),
    const ActiveLogPage(),
    const Placeholder(), // Theme
    const Placeholder(), // About
  ];

  // static const List<String> _pageTitles = [
  //   "Business Profile",
  //   "Accounts",
  //   "Sales Settings",
  //   "Invoice Settings",
  //   "Users",
  //   "Activity Log",
  //   "Language",
  //   "Theme",
  //   "About",
  // ];

  @override
  Widget build(BuildContext context) {
    // ✅ Ensure index is safe for _settingsPages
    int safeIndex = _selectedIndex;
    if (safeIndex >= _settingsPages.length) {
      safeIndex = 0; // fallback to first page
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
                      _buildNavItem(0, "Business Profile", Icons.business),
                      _buildNavItem(1, "Accounts", Icons.account_circle),
                      _buildNavItem(2, "Sales Setting", Icons.receipt_long),
                      _buildNavItem(3, "Invoice Settings", Icons.description),
                      _buildSectionHeader("USER MANAGEMENT"),
                      _buildNavItem(4, "Users", Icons.people_outline),
                      _buildNavItem(5, "Activity Log", Icons.history),
                      _buildSectionHeader("APP SETTINGS"),
                      _buildNavItem(6, "Language", Icons.language),
                      _buildNavItem(7, "Theme", Icons.palette_outlined),
                      _buildNavItem(8, "About", Icons.info_outline),
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
                  // child: Row(
                  //   children: [
                  //     Text(
                  //       _pageTitles[_selectedIndex], // safe for titles
                  //       style: const TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.bold,
                  //         color: textPrimaryColor,
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //     IconButton(
                  //       icon: const Icon(Icons.search),
                  //       onPressed: () {},
                  //       color: textSecondaryColor,
                  //     ),
                  //     IconButton(
                  //       icon: const Badge(
                  //         label: Text("2"),
                  //         child: Icon(Icons.notifications_outlined),
                  //       ),
                  //       onPressed: () {},
                  //       color: textSecondaryColor,
                  //     ),
                  //   ],
                  // ),
                ),

                // Content Area
                Expanded(
                  child: _settingsPages[safeIndex], // ✅ Safe index used
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

  Widget _buildNavItem(int index, String title, IconData icon) {
    final isSelected = _selectedIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
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

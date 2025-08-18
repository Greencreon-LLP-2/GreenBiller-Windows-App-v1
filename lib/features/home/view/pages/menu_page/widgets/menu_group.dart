import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/home/view/pages/menu_page/models/menu_item_model.dart';
import 'package:green_biller/features/home/view/pages/menu_page/widgets/menu_item_tile.dart';

/// Displays a group of menu items with an expandable header
class MenuGroup extends StatelessWidget {
  final String title;
  final List<MenuItemModel> items;
  final ValueNotifier<String?> expandedGroup;
  final BuildContext context;

  const MenuGroup({
    super.key,
    required this.title,
    required this.items,
    required this.expandedGroup,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentLightColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIconForGroup(title),
            color: accentColor,
            size: 20,
          ),
        ),
        initiallyExpanded: expandedGroup.value == title,
        onExpansionChanged: (isExpanded) {
          expandedGroup.value = isExpanded ? title : null;
        },
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: items.map((item) => MenuItemTile(item: item)).toList(),
      ),
    );
  }

  /// Returns the appropriate icon for a given group title
  IconData _getIconForGroup(String title) {
    switch (title) {
      case 'Sales':
        return Icons.point_of_sale;
      case 'Purchase':
        return Icons.shopping_cart;
      case 'Expenses':
        return Icons.money_off;
      case 'Store Management':
        return Icons.store;
      case 'Financial':
        return Icons.account_balance_wallet;
      default:
        return Icons.category;
    }
  }
}

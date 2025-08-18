import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';
import 'package:green_biller/features/home/view/pages/menu_page/models/menu_item_model.dart';

/// Displays a single menu item with icon and title
class MenuItemTile extends ConsumerWidget {
  final MenuItemModel item;

  const MenuItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: accentLightColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(item.icon, color: accentColor, size: 20),
      ),
      title: Text(
        item.title,
        style: AppTextStyles.bodyMedium,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: textLightColor,
      ),
      onTap: () => item.onTap(context, ref),
    );
  }
}

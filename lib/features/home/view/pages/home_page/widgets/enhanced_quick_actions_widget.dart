import 'package:flutter/material.dart';
import 'package:green_biller/features/home/view/pages/home_page/widgets/action_card_widget.dart';

class EnhancedQuickActionsWidget extends StatelessWidget {
  final bool isPhone;
  final bool is7inch;
  final bool is10inch;

  const EnhancedQuickActionsWidget({
    super.key,
    required this.isPhone,
    required this.is7inch,
    required this.is10inch,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isPhone
          ? 2
          : is7inch
              ? 3
              : 2, // 2 columns for 10-inch in the left panel
      mainAxisSpacing: isPhone ? 12 : 16,
      crossAxisSpacing: isPhone ? 12 : 16,
      childAspectRatio: isPhone
          ? 1.2
          : is7inch
              ? 1.4
              : 1.8, // Wider cards for 10-inch
      children: const [
        ActionCardWidget(
          icon: Icons.add_circle_outline,
          label: "New Sale",
          route: '/new-sale',
          gradient: LinearGradient(
            colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
          ),
        ),
        ActionCardWidget(
          icon: Icons.history,
          label: "Transactions",
          route: '/transactions',
          gradient: LinearGradient(
            colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
          ),
        ),
        ActionCardWidget(
          icon: Icons.assessment_outlined,
          label: "Reports",
          route: '/reports',
          gradient: LinearGradient(
            colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
          ),
        ),
        ActionCardWidget(
          icon: Icons.settings_outlined,
          label: "Settings",
          route: '/settings',
          gradient: LinearGradient(
            colors: [Color(0xFF34495E), Color(0xFF2C3E50)],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Define MenuItemModel class
class MenuItemModel {
  final String title;
  final IconData icon;
  final Future<void> Function(BuildContext, WidgetRef) onTap;

  MenuItemModel(this.title, this.icon, this.onTap);
}

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  static final List<MenuItemModel> salesItems = [
    MenuItemModel("Payment-In", Icons.payment, (context, ref) async {
      context.push('/payment-in');
      return;
    }),
    MenuItemModel("Sale Return", Icons.assignment_return, (context, ref) async {
      context.push('/sales-return');
      return;
    }),
    MenuItemModel("Sale Order", Icons.shopping_cart, (context, ref) async {
      context.push('/sales-order');
      return;
    }),
    MenuItemModel("Stock Adjustment", Icons.receipt_long, (context, ref) async {
      context.push('/stock-adjustment');
      return;
    }),
    MenuItemModel("Stock Transfer", Icons.receipt_long, (context, ref) async {
      context.push('/stock-transfer');
      return;
    }),
  ];

  // Purchase menu items
  static final List<MenuItemModel> purchaseItems = [
    MenuItemModel("Purchase Bills", Icons.receipt, (context, ref) async {
      context.push('/purchase-view');
      return;
    }),
    MenuItemModel("Purchase Returns", Icons.exit_to_app, (context, ref) async {
      context.push('/purchase-returns-view');
      return;
    }),
    MenuItemModel("Payment Out", Icons.assignment_return, (context, ref) async {
      context.push('/payment-out');
      return;
    }),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentColor, accentColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
            ),
            title: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sales Section
            const Text(
              'Sales',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedGridView(
              items: salesItems,
              color: accentColor,
              crossAxisCount: _getCrossAxisCount(context),
              ref: ref,
            ),
            const SizedBox(height: 40),
            // Purchase Section
            const Text(
              'Purchase',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedGridView(
              items: purchaseItems,
              color: secondaryColor,
              crossAxisCount: _getCrossAxisCount(context),
              ref: ref,
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }
}

class AnimatedGridView extends StatelessWidget {
  final List<MenuItemModel> items;
  final Color color;
  final int crossAxisCount;
  final WidgetRef ref;

  const AnimatedGridView({
    super.key,
    required this.items,
    required this.color,
    required this.crossAxisCount,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: items.asMap().entries.map((entry) {
        final item = entry.value;
        return AnimatedMenuCard(
          title: item.title,
          description: 'Access ${item.title.toLowerCase()} features',
          icon: item.icon,
          color: color,
          onTap: item.onTap,
          ref: ref,
        );
      }).toList(),
    );
  }
}

class AnimatedMenuCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Future<void> Function(BuildContext, WidgetRef) onTap;
  final WidgetRef ref;

  const AnimatedMenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.ref,
  });

  @override
  _AnimatedMenuCardState createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: () => widget.onTap(context, widget.ref),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.color.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(0.1),
                            widget.color.withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF64748B).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

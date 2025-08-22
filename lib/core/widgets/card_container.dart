import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? elevation;

  const CardContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final defaultShadow = [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ];

    final effectiveShadow = elevation != null
        ? [
            BoxShadow(
              color: Colors.grey
                  .withOpacity(0.1 + (elevation! * 0.05).clamp(0.1, 0.3)),
              spreadRadius: (elevation! * 0.5).clamp(1.0, 3.0),
              blurRadius: (elevation! * 2.5).clamp(5.0, 15.0),
              offset: Offset(0, elevation! * 0.5),
            ),
          ]
        : boxShadow ?? defaultShadow;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: effectiveShadow,
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class StateCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String heroTag;
  final bool isSmallScreen;

  const StateCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.heroTag,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
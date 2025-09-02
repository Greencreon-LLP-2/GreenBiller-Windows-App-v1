// lib/features/store/view/shared/store_card.dart
import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class StoreCard extends StatelessWidget {
  final dynamic store;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const StoreCard({
    super.key,
    required this.store,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: accentColor),
                      onPressed: onEdit,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                store.address ?? 'No address provided',
                style: const TextStyle(color: textSecondaryColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: textSecondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    store.phone ?? 'No phone provided',
                    style: const TextStyle(color: textSecondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

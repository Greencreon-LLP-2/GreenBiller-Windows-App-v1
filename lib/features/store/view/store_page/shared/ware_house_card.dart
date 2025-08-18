// lib/features/store/view/shared/warehouse_card.dart
import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class WarehouseCard extends StatelessWidget {
  final dynamic warehouse;
  final VoidCallback? onTap;
  final bool canEdit;

  const WarehouseCard({
    super.key,
    required this.warehouse,
    this.onTap,
    this.canEdit = false,
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
                    warehouse.name ?? 'Unnamed Warehouse',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  if (canEdit)
                    IconButton(
                      icon: const Icon(Icons.edit, color: accentColor),
                      onPressed: () {
                        // Navigate to edit warehouse
                      },
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.store, size: 16, color: textSecondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    warehouse.storeName ?? 'No store assigned',
                    style: const TextStyle(color: textSecondaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: textSecondaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warehouse.address ?? 'No address provided',
                      style: const TextStyle(color: textSecondaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: warehouse.status == 'active'
                          ? successColor.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      warehouse.status?.toUpperCase() ?? 'UNKNOWN',
                      style: TextStyle(
                        color: warehouse.status == 'active'
                            ? successColor
                            : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (warehouse.capacity != null)
                    Text(
                      'Capacity: ${warehouse.capacity}',
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

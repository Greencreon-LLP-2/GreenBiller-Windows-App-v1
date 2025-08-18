import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class SupplierRow extends StatelessWidget {
  final String name;
  final String contact;
  final String store;
  final bool isActive;

  const SupplierRow({
    super.key,
    required this.name,
    required this.contact,
    required this.store,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: textLightColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.business,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              contact,
              style: const TextStyle(
                color: textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              store,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: isActive ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
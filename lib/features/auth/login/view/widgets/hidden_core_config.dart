import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/theme/text_styles.dart';

class HiddenCoreConfig extends StatelessWidget {
  const HiddenCoreConfig({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      
      onPressed: () {
        log('pressed');
        showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.settings, color: accentColor),
            const SizedBox(width: 12),
            Text(
              "Settings",
              style: AppTextStyles.h3.copyWith(
                color: textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Core Configuration",
                style: AppTextStyles.bodyLarge.copyWith(
                  color: textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Configure the base URL for API connections",
                style: AppTextStyles.bodySmall.copyWith(
                  color: textSecondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Base URL',
                  hintText: 'https://api.example.com',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: accentColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:const BorderSide(
                      color: accentColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Port Number',
                  hintText: '8080',
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: accentColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:const BorderSide(
                      color: accentColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'License Key',
                  hintText: 'SDGDXXXXXXXXXX456',
                  prefixIcon: const Icon(Icons.key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: accentColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:const BorderSide(
                      color: accentColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cancel",
              style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondaryColor,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // TODO: Save the base URL
              Navigator.of(context).pop();
            },
            child: Text(
              "Save Changes",
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      );
    },
        );
    
      },
      backgroundColor: Colors.transparent, // Makes background transparent
      elevation: 0, // Removes shadow
      highlightElevation: 0, // Removes shadow when pressed
      hoverElevation: 0, // Removes shadow when hovered
      focusElevation: 0,
      splashColor: Colors.transparent, // Removes ripple effect
      child: const Icon(Icons.settings, color: accentColor), // Or your custom child
    );
  }
}

class CompactLogoHeader extends StatelessWidget {
  const CompactLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentColor.withOpacity(0.8), accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_cart,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Green Biller',
          style: AppTextStyles.h2.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your complete billing solution',
          style: AppTextStyles.bodyMedium.copyWith(
            color: textSecondaryColor,
          ),
        ),
      ],
    );
  }
}

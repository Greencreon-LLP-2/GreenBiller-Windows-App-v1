import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/app_management/app_status_provider.dart';

class MaintenancePage extends ConsumerWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenance = ref.watch(appStatusProvider).maintenanceData;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(87, 199, 173, 1), // 8%
              Color.fromRGBO(87, 199, 133, 1), // 43%
              Color.fromRGBO(237, 221, 83, 1), // 98%
            ],
            stops: [0.08, 0.43, 0.98], // matches your CSS stops
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Image.asset(
                  'assets/images/logo_image.png', // Make sure this exists in your assets folder and declared in pubspec.yaml
                  width: 120,
                ),
              ),

              // Error icon
              Icon(
                maintenance!.icon,
                size: 72,
                color: Colors.white,
              ),
              const SizedBox(height: 16),

              // Error code
              Text(
                'Error Code: ${maintenance.code}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 10),

              // Message
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  maintenance.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Retry button (if provided)
              if (maintenance.onTap != null)
                ElevatedButton.icon(
                  onPressed: maintenance.onTap,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

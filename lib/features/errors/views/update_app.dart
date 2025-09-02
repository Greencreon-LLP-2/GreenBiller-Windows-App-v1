import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/app_management/app_status_provider.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';

class UpdateApp extends ConsumerWidget {
  const UpdateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStatusSettings = ref.read(appStatusProvider);
    final userData = ref.read(userProvider);
    Future.microtask(() async {
      final user = userData;
      if (user != null) {
        final token = user.accessToken ?? '';
        final userId = user.user?.id.toString() ?? '';
        ref.read(appStatusProvider.notifier).startPolling(token, userId);
      }
    });
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
              const Icon(
                Icons.system_update,
                size: 72,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),

              // Error code
              const Text(
                'OutDated App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 10),

              // Message
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Please Update your App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Retry button (if provided)

              ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green[800],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

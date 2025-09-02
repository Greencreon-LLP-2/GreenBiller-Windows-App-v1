import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';

class TrialVersionContainer extends StatelessWidget {
  final AuthService authService = AuthService();

  TrialVersionContainer({super.key});

  Future<Map<String, dynamic>> getTrialInfo() async {
    final userData = await authService.getUserData();
    DateTime trialEndDate;
    if (userData?.user?.createdAt != null) {
      trialEndDate = userData!.user!.createdAt!.add(const Duration(days: 30));
    } else {
      // Fallback: 30 days from now
      trialEndDate = DateTime.now().add(const Duration(days: 30));
    }

    final daysLeft = trialEndDate.difference(DateTime.now()).inDays;
    final formattedEndDate = DateFormat('d MMM yyyy').format(trialEndDate);

    return {
      'trialEndDate': trialEndDate,
      'daysLeft': daysLeft,
      'formattedEndDate': formattedEndDate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getTrialInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 10),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 10),
            child: Text('Error loading trial status',
                style: TextStyle(color: Colors.red)),
          );
        }

        final trialInfo = snapshot.data!;
        final trialEndDate = trialInfo['trialEndDate'] as DateTime;
        final daysLeft = trialInfo['daysLeft'] as int;
        final formattedEndDate = trialInfo['formattedEndDate'] as String;
        final isTrialEnded = daysLeft <= 0;

        return Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.access_time,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTrialEnded ? "Trial Version Ended" : "Trial Version",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isTrialEnded
                          ? "Upgrade to Pro to continue"
                          : "Ends on $formattedEndDate",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    if (!isTrialEnded) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$daysLeft days left',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

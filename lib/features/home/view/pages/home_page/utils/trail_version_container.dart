import 'package:flutter/material.dart';

class TrialVersionContainer extends StatelessWidget {
  final DateTime trialEndDate = DateTime.now().add(const Duration(days: 1));

  TrialVersionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTrialEnded = DateTime.now().isAfter(trialEndDate);

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
              child:
                  const Icon(Icons.access_time, color: Colors.white, size: 20),
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
                      : "Ends on ${trialEndDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

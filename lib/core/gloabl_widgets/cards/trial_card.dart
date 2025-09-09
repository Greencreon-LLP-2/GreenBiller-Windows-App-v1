import 'package:flutter/material.dart';


class TrialCard extends StatelessWidget {
  final DateTime trialEnds;
  const TrialCard({super.key, required this.trialEnds});

  int getDaysLeft() {
    final days = trialEnds.difference(DateTime.now()).inDays;
    return days > 0 ? days : 0;
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysLeft();

    return GestureDetector(

      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFF5B3A1A), Color(0xFFFFA726)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Trial Version',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
               
                  Text(
                    'Ends on ${trialEnds.day} ${_monthName(trialEnds.month)} ${trialEnds.year}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$days days left',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _monthName(int m) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return (m >= 1 && m <= 12) ? names[m] : '';
  }
}

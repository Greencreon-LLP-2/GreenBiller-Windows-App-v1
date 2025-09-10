import 'package:flutter/material.dart';

class TrialCard extends StatelessWidget {
  final DateTime? trialEnds;
  final bool isTrial;
  final bool trialEnded; // new field

  const TrialCard({
    super.key,
    this.trialEnds,
    this.isTrial = true,
    this.trialEnded = false,
  });

  int getDaysLeft() {
    if (trialEnds == null) return 0;
    final days = trialEnds!.difference(DateTime.now()).inDays;
    return days > 0 ? days : 0;
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysLeft();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: isTrial
              ? [const Color(0xFF5B3A1A), const Color(0xFFFFA726)]
              : [Colors.blue.shade700, Colors.blue.shade400],
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
            child: Icon(
              trialEnded
                  ? Icons.block
                  : (isTrial ? Icons.access_time : Icons.verified),
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
                Text(
                  trialEnded
                      ? 'Trial Ended'
                      : (isTrial ? 'Trial Version' : 'Active Subscription'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!trialEnded && trialEnds != null)
                  Text(
                    'Ends on ${trialEnds!.day} ${_monthName(trialEnds!.month)} ${trialEnds!.year}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                if (!trialEnded)
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

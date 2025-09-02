import 'package:flutter/material.dart';

class QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;

  const QuickLink({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[100],
          child: Icon(icon, size: 30, color: Colors.green[800]),
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.green[800])),
      ],
    );
  }
}

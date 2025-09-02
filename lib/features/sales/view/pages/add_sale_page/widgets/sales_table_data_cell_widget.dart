import 'package:flutter/material.dart';

class DataCellWidget extends StatelessWidget {
  const DataCellWidget({
    super.key,
    required this.child,
    required this.width,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.green.shade100),
        ),
      ),
      child: child,
    );
  }
}

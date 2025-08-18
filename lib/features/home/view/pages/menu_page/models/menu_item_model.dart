import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model class for menu items
class MenuItemModel {
  final String title;
  final IconData icon;
  final Future<void> Function(BuildContext, WidgetRef) onTap;

  MenuItemModel(this.title, this.icon, this.onTap);
}

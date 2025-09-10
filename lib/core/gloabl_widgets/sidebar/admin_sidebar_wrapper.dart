import 'package:flutter/material.dart';
import 'package:greenbiller/core/app_theme.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_topbar.dart';

class AdminSidebarWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showSidebar;

  const AdminSidebarWrapper({
    super.key,
    required this.child,
    required this.title,
    this.showSidebar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        appBar: AdminTopbar(title: title),
        drawer: showSidebar ? AdminSidebar() : null,
        body: child,
      ),
    );
  }
}

// lib/features/store/view/store_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/constants/gloabl_utils.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/model/user_role_model.dart';
import 'package:green_biller/features/store/view/store_page/admin/admin_store_page.dart';
import 'package:green_biller/features/store/view/store_page/user/user_store_page.dart';

class StorePageCustom extends ConsumerWidget {
  const StorePageCustom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);

    // userLevel is a string but actually a number; parse it
    final role = GloablUtils.determineUserRole(
      user!.user!.userLevelId.toString(),
      user.user?.storeId,
    );

    // Example: show role in AppBar
    Widget body;
    if (_isAdminFlow(role)) {
      body = const AdminStorePage();
    } else if (_isUserFlow(role)) {
      body = const UserStorePage();
    } else {
      body = const Scaffold(
        body: Center(child: Text('You don\'t have access to this section')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Store - ${role.name}'), centerTitle: true),
      body: body,
    );
  }

  bool _isAdminFlow(UserRoleModel role) {
    return [
      UserRoleModel.superAdmin,
      UserRoleModel.manager,
      UserRoleModel.storeAdmin,
      UserRoleModel.storeManager,
      UserRoleModel.storeAccountant,
    ].contains(role);
  }

  bool _isUserFlow(UserRoleModel role) {
    return [
      UserRoleModel.staff,
      UserRoleModel.storeStaff,
      UserRoleModel.biller,
      UserRoleModel.executive,
    ].contains(role);
  }
}

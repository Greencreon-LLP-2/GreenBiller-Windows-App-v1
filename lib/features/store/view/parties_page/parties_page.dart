// lib/features/store/view/store_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/constants/gloabl_utils.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/model/user_role_model.dart';
import 'package:green_biller/features/store/view/parties_page/admin/admin_parties_page.dart';

class PartiesPage extends ConsumerWidget {
  const PartiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final role = GloablUtils.determineUserRole(
      user.user!.userLevelId.toString(),
      user.user?.storeId,
    );

    return _buildBody(role);
  }

  Widget _buildBody(UserRoleModel role) {
    if (_isAdminFlow(role)) return const AdminPartiesPage();
    // if (_isUserFlow(role)) return const UserStorePage();
    return Scaffold(
      appBar: AppBar(title: Text('Parties - ${role.name}')),
      body: const Center(child: Text('Access Denied')),
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

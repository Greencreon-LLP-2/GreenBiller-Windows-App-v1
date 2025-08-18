import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';

class UserPermissionDialog extends StatefulWidget {
  final User user;

  const UserPermissionDialog({super.key, required this.user});

  @override
  State<UserPermissionDialog> createState() => _UserPermissionDialogState();
}

class _UserPermissionDialogState extends State<UserPermissionDialog> {
  late bool isActive;
  late bool canEditBills;
  late bool canViewReports;

  @override
  void initState() {
    // need what is the permissions for the user by unni sir
    // Initialize permissions based on the user Model
    // waiting for the user data to be available,
    super.initState();
    isActive = widget.user.status == true;
    canEditBills = widget.user.userCard == true;
    canViewReports = widget.user.mobileVerify == true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permissions For: ${widget.user.name ?? 'Unknown'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildSwitch('User Active', isActive,
                (val) => setState(() => isActive = val)),
            _buildSwitch('Can Edit Bills', canEditBills,
                (val) => setState(() => canEditBills = val)),
            _buildSwitch('Can View Reports', canViewReports,
                (val) => setState(() => canViewReports = val)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  final updatedUser = widget.user.copyWith(
                    status: isActive,
                    userCard: canEditBills,
                    mobileVerify: canViewReports,
                  );
                  Navigator.pop(context, updatedUser);
                },
                child: const Text('Save Changes',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: accentColor,
    );
  }
}

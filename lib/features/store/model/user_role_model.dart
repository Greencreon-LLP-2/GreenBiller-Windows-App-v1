// lib/features/store/model/user_role_model.dart
class UserRoleModel {
  final int id;
  final String name;
  final String level; // slug / canonical string

  const UserRoleModel._(this.id, this.name, this.level);

  static const superAdmin = UserRoleModel._(1, 'Superadmin', 'super_admin');
  static const manager = UserRoleModel._(2, 'Manager', 'manager');
  static const staff = UserRoleModel._(3, 'Staff', 'staff');
  static const storeAdmin = UserRoleModel._(4, 'Store Admin', 'store_admin');
  static const storeManager =
      UserRoleModel._(5, 'Store Manager', 'store_manager');
  static const storeAccountant =
      UserRoleModel._(6, 'Store Accountant', 'store_accountant');
  static const storeStaff = UserRoleModel._(7, 'Store Staff', 'store_staff');
  static const biller = UserRoleModel._(8, 'Biller', 'biller');
  static const executive = UserRoleModel._(9, 'Executive', 'executive');
  static const customer = UserRoleModel._(10, 'Customer', 'customer');
  static const reseller = UserRoleModel._(11, 'Reseller', 'reseller');
  static const none = UserRoleModel._(0, 'None', 'none');

  static List<UserRoleModel> get values => [
        superAdmin,
        manager,
        staff,
        storeAdmin,
        storeManager,
        storeAccountant,
        storeStaff,
        biller,
        executive,
        customer,
        reseller,
        none,
      ];

  /// Lookup by integer ID
  static UserRoleModel fromId(int? id) {
    if (id == null) return none;
    return values.firstWhere(
      (r) => r.id == id,
      orElse: () => none,
    );
  }

  /// Parse from a string that is actually a numeric ID (e.g., "4")
  static UserRoleModel fromIdString(String? idStr) {
    if (idStr == null) return none;
    final parsed = int.tryParse(idStr.trim());
    if (parsed == null) return none;
    return fromId(parsed);
  }

  /// (Legacy) Lookup by level string
  static UserRoleModel fromLevel(String? level) {
    switch (level) {
      case 'super_admin':
        return superAdmin;
      case 'manager':
        return manager;
      case 'staff':
        return staff;
      case 'store_admin':
        return storeAdmin;
      case 'store_manager':
        return storeManager;
      case 'store_accountant':
        return storeAccountant;
      case 'store_staff':
        return storeStaff;
      case 'biller':
        return biller;
      case 'executive':
        return executive;
      case 'customer':
        return customer;
      case 'reseller':
        return reseller;
      default:
        return none;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserRoleModel(id: $id, name: $name, level: $level)';
}

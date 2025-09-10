// lib/features/store/model/user_role_model.dart
class UserRoleDetrmine {
  final int id;
  final String name;
  final String level; // slug / canonical string

  const UserRoleDetrmine._(this.id, this.name, this.level);

  static const superAdmin = UserRoleDetrmine._(1, 'Superadmin', 'super_admin');
  static const manager = UserRoleDetrmine._(2, 'Manager', 'manager');
  static const staff = UserRoleDetrmine._(3, 'Staff', 'staff');
  static const storeAdmin = UserRoleDetrmine._(4, 'Store Admin', 'store_admin');
  static const storeManager =
      UserRoleDetrmine._(5, 'Store Manager', 'store_manager');
  static const storeAccountant =
      UserRoleDetrmine._(6, 'Store Accountant', 'store_accountant');
  static const storeStaff = UserRoleDetrmine._(7, 'Store Staff', 'store_staff');
  static const biller = UserRoleDetrmine._(8, 'Biller', 'biller');
  static const executive = UserRoleDetrmine._(9, 'Executive', 'executive');
  static const customer = UserRoleDetrmine._(10, 'Customer', 'customer');
  static const reseller = UserRoleDetrmine._(11, 'Reseller', 'reseller');
  static const none = UserRoleDetrmine._(0, 'None', 'none');

  static List<UserRoleDetrmine> get values => [
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
  static UserRoleDetrmine fromId(int? id) {
    if (id == null) return none;
    return values.firstWhere(
      (r) => r.id == id,
      orElse: () => none,
    );
  }

  /// Parse from a string that is actually a numeric ID (e.g., "4")
  static UserRoleDetrmine fromIdString(String? idStr) {
    if (idStr == null) return none;
    final parsed = int.tryParse(idStr.trim());
    if (parsed == null) return none;
    return fromId(parsed);
  }

  /// (Legacy) Lookup by level string
  static UserRoleDetrmine fromLevel(String? level) {
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
      other is UserRoleDetrmine &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserRoleDetrmine(id: $id, name: $name, level: $level)';
}

import 'package:green_biller/features/store/model/user_role_model.dart';

class GloablUtils {
  static UserRoleModel determineUserRole(String? rawLevel, String? storeId) {
    final role = UserRoleModel.fromIdString(rawLevel);

    // Additional guardrails: e.g., certain roles need storeId
    if ((role == UserRoleModel.staff ||
            role == UserRoleModel.storeStaff ||
            role == UserRoleModel.biller ||
            role == UserRoleModel.executive) &&
        storeId == null) {
      return UserRoleModel.none;
    }
    return role;
  }
}

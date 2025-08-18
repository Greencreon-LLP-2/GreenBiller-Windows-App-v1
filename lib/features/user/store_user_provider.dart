import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/user/models/store_users.dart';
import 'package:green_biller/features/user/services/user_creation_services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeUsersProvider = FutureProvider<StoreUsersResponse>((ref) async {
  final user = ref.watch(userProvider);
  final accessToken = user?.accessToken;

  if (accessToken == null) {
    throw Exception("Access token is missing");
  }

  return UserCreationServices().getStoreUsersList(accessToken, null);
});

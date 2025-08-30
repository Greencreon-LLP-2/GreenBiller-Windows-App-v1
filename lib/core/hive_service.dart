import 'package:greenbiller/features/auth/model/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:logger/logger.dart';

class HiveService {
  static const String authBoxName = 'authBox';
  static const String userKey = 'currentUser';
  final logger = Logger();

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      // Check if adapter is already registered to avoid duplicate registration
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
        logger.i('Hive adapter registered for UserModel (typeId: 0)');
      } else {
        logger.i('Hive adapter for UserModel (typeId: 0) already registered');
      }

      final box = await Hive.openBox<UserModel>(authBoxName);
      logger.i('Hive box opened successfully');

      // Clear box to avoid type mismatches from old data (remove after first successful run)
      await box.clear();
      logger.i('Hive box cleared to ensure compatibility');
    } catch (e, stackTrace) {
      logger.e('Hive initialization failed: $e', e, stackTrace);
      rethrow;
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      final box = Hive.box<UserModel>(authBoxName);
      await box.put(userKey, user);
      logger.i('User saved to Hive: ${user.toJson()}');
    } catch (e, stackTrace) {
      logger.e('Failed to save user: $e', e, stackTrace);
      rethrow;
    }
  }

  UserModel? getUser() {
    try {
      final box = Hive.box<UserModel>(authBoxName);
      final user = box.get(userKey);
      logger.i('User retrieved from Hive: ${user?.toJson()}');
      return user;
    } catch (e, stackTrace) {
      logger.e('Failed to get user: $e', e, stackTrace);
      return null;
    }
  }

  Future<void> clearUser() async {
    try {
      final box = Hive.box<UserModel>(authBoxName);
      await box.delete(userKey);
      logger.i('User cleared from Hive');
    } catch (e, stackTrace) {
      logger.e('Failed to clear user: $e', e, stackTrace);
      rethrow;
    }
  }
}
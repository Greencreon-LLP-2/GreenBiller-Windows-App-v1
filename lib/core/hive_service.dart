import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';

class HiveService {
  final Logger logger = Logger();
  static const String _userBoxName = 'userBox';
  static const String _userKey = 'currentUser';
  Box<UserModel>? _userBox;
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      if (_isInitialized) {
        logger.i('Hive already initialized, skipping');
        return;
      }
      logger.i('Initializing Hive');
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
        logger.i('Hive adapter registered for UserModel (typeId: 0)');
      } else {
        logger.i('Hive adapter for UserModel (typeId: 0) already registered');
      }
      _userBox = await Hive.openBox<UserModel>(_userBoxName);
      logger.i('Hive box opened: $_userBoxName, keys: ${_userBox?.keys.toList()}');
      _isInitialized = true;
    } catch (e, stackTrace) {
      logger.e('Hive initialization error: $e', e, stackTrace);
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized || _userBox == null) {
      await init();
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await ensureInitialized();
      if (_userBox == null) {
        throw Exception('User box is null, cannot save user');
      }
      logger.i('Attempting to save user: ${user.toJson()}');
      await _userBox!.put(_userKey, user);
      logger.i('User saved to Hive: ${_userBox!.get(_userKey)?.toJson()}');
    } catch (e, stackTrace) {
      logger.e('Error saving user to Hive: $e', e, stackTrace);
      rethrow;
    }
  }

  UserModel? getUser() {
    try {
      if (_userBox == null) {
        logger.w('User box is null, Hive not initialized');
        return null;
      }
      final user = _userBox!.get(_userKey);
      logger.i('Retrieved user from Hive: ${user?.toJson() ?? 'null'}');
      logger.i('Box contents: ${_userBox!.keys.toList()}');
      return user;
    } catch (e, stackTrace) {
      logger.e('Error retrieving user from Hive: $e', e, stackTrace);
      return null;
    }
  }

  Future<void> clearUser() async {
    try {
      await ensureInitialized();
      if (_userBox == null) {
        throw Exception('User box is null, cannot clear user');
      }
      logger.i('Clearing user from Hive');
      await _userBox!.delete(_userKey);
      logger.i('User data cleared, box keys: ${_userBox!.keys.toList()}');
    } catch (e, stackTrace) {
      logger.e('Error clearing user from Hive: $e', e, stackTrace);
      rethrow;
    }
  }
}
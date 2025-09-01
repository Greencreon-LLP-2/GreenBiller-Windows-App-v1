import 'dart:io';
import 'package:greenbiller/features/settings/models/business_profile_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HiveService {
  final Logger logger = Logger();
  static const String _userBoxName = 'userbox';
  static const String _userKey = 'currentUser';
  static const String _businessProfileBoxName = 'businessProfileBox';
  static const String _businessProfileKey = 'currentBusinessProfile';
  Box<UserModel>? _userBox;
  Box<BusinessProfile>? _businessProfileBox;
  bool _isInitialized = false;
  bool _useMemoryFallback = false;
  String? _customStoragePath;

  void setCustomStoragePath(String path) {
    _customStoragePath = path;
    logger.i('Custom storage path set to: $path');
  }

  Future<bool> _requestStoragePermissions() async {
    if (Platform.isWindows) {
      try {
        final tempDir = Directory.systemTemp;
        final testFile = File('${tempDir.path}/permission_test.txt');
        await testFile.writeAsString('test');
        await testFile.delete();
        return true;
      } catch (e) {
        logger.w('Storage permission test failed: $e');
        return false;
      }
    } else {
      try {
        final status = await Permission.storage.status;
        if (status.isGranted) return true;
        final result = await Permission.storage.request();
        return result.isGranted;
      } catch (e) {
        logger.w('Permission request failed: $e');
        return false;
      }
    }
  }

  Future<Directory> _getStorageDirectory() async {
    if (_customStoragePath != null) {
      final customDir = Directory(_customStoragePath!);
      if (!customDir.existsSync()) {
        customDir.createSync(recursive: true);
      }
      return customDir;
    }
    try {
      if (Platform.isWindows) {
        final documentsDir = await getApplicationDocumentsDirectory();
        final greenBillerDir = Directory('${documentsDir.path}\\GreenBiller');
        if (!greenBillerDir.existsSync()) {
          greenBillerDir.createSync(recursive: true);
          logger.i('Created GreenBiller directory: ${greenBillerDir.path}');
        }
        return greenBillerDir;
      } else {
        return await getApplicationSupportDirectory();
      }
    } catch (e) {
      logger.w('Failed to get preferred storage directory: $e');
      final tempDir = Directory.systemTemp;
      final fallbackDir = Directory('${tempDir.path}\\GreenBiller');
      if (!fallbackDir.existsSync()) {
        fallbackDir.createSync(recursive: true);
      }
      logger.w('Using fallback directory: ${fallbackDir.path}');
      return fallbackDir;
    }
  }

  Future<void> init() async {
    try {
      if (_isInitialized) {
        logger.i('Hive already initialized, skipping');
        return;
      }
      logger.i('Initializing Hive');
      final hasPermission = await _requestStoragePermissions();
      if (!hasPermission) {
        logger.w('Storage permissions not granted, using memory fallback');
        _useMemoryFallback = true;
        _isInitialized = true;
        return;
      }
      final storageDir = await _getStorageDirectory();
      logger.i('Using storage directory: ${storageDir.path}');
      await Hive.initFlutter(storageDir.path);
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
        logger.i('Hive adapter registered for UserModel (typeId: 0)');
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(BusinessProfileAdapter());
        logger.i('Hive adapter registered for BusinessProfile (typeId: 1)');
      }
      try {
        _userBox = await Hive.openBox<UserModel>(_userBoxName);
        _businessProfileBox = await Hive.openBox<BusinessProfile>(_businessProfileBoxName);
        logger.i('Hive boxes opened successfully: $_userBoxName, $_businessProfileBoxName');
      } catch (e) {
        logger.w('Error opening boxes: $e');
        try {
          _userBox = await Hive.openBox<UserModel>(_userBoxName, crashRecovery: false);
          _businessProfileBox = await Hive.openBox<BusinessProfile>(_businessProfileBoxName, crashRecovery: false);
          logger.i('Hive boxes opened with crashRecovery: false');
        } catch (e2) {
          logger.w('Failed with crashRecovery false: $e2');
          try {
            await Hive.deleteBoxFromDisk(_userBoxName);
            await Hive.deleteBoxFromDisk(_businessProfileBoxName);
            _userBox = await Hive.openBox<UserModel>(_userBoxName);
            _businessProfileBox = await Hive.openBox<BusinessProfile>(_businessProfileBoxName);
            logger.i('Hive boxes recreated after deletion');
          } catch (e3) {
            logger.w('Failed to recreate boxes: $e3');
            _useMemoryFallback = true;
            logger.w('Using memory fallback storage');
          }
        }
      }
      _isInitialized = true;
      logger.i('Hive initialization completed successfully');
    } catch (e, stackTrace) {
      logger.e('Hive initialization failed: $e',  e,  stackTrace);
      _isInitialized = false;
      _useMemoryFallback = true;
      logger.w('App will run with memory fallback storage');
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized && !_useMemoryFallback) {
      await init();
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await ensureInitialized();
      if (_userBox == null && !_useMemoryFallback) {
        logger.w('Cannot save user: Hive not available');
        return;
      }
      if (_useMemoryFallback) {
        logger.w('Using memory fallback for user storage - data will not persist');
        logger.i('User data (not persisted): ${user.toJson()}');
        return;
      }
      logger.i('Saving user to Hive: ${user.toJson()}');
      await _userBox!.put(_userKey, user);
      logger.i('User saved successfully');
    } catch (e, stackTrace) {
      logger.e('Error saving user: $e',  e,  stackTrace);
    }
  }

  UserModel? getUser() {
    try {
      if (_userBox == null && !_useMemoryFallback) {
        logger.w('Cannot get user: Hive not available');
        return null;
      }
      if (_useMemoryFallback) {
        logger.w('Using memory fallback - no persisted user data available');
        return null;
      }
      final user = _userBox!.get(_userKey);
      logger.i('Retrieved user from Hive: ${user?.toJson() ?? 'null'}');
      return user;
    } catch (e, stackTrace) {
      logger.e('Error retrieving user: $e',  e,  stackTrace);
      return null;
    }
  }

  Future<void> saveBusinessProfile(BusinessProfile profile) async {
    try {
      await ensureInitialized();
      if (_businessProfileBox == null && !_useMemoryFallback) {
        logger.w('Cannot save business profile: Hive not available');
        return;
      }
      if (_useMemoryFallback) {
        logger.w('Using memory fallback for business profile - data will not persist');
        logger.i('Business profile data (not persisted): ${profile.toJson()}');
        return;
      }
      logger.i('Saving business profile to Hive: ${profile.toJson()}');
      await _businessProfileBox!.put(_businessProfileKey, profile);
      logger.i('Business profile saved successfully');
    } catch (e, stackTrace) {
      logger.e('Error saving business profile: $e',  e,  stackTrace);
    }
  }

  BusinessProfile? getBusinessProfile() {
    try {
      if (_businessProfileBox == null && !_useMemoryFallback) {
        logger.w('Cannot get business profile: Hive not available');
        return null;
      }
      if (_useMemoryFallback) {
        logger.w('Using memory fallback - no persisted business profile available');
        return null;
      }
      final profile = _businessProfileBox!.get(_businessProfileKey);
      logger.i('Retrieved business profile from Hive: ${profile?.toJson() ?? 'null'}');
      return profile;
    } catch (e, stackTrace) {
      logger.e('Error retrieving business profile: $e',  e,  stackTrace);
      return null;
    }
  }

  Future<void> clearBusinessProfile() async {
    try {
      await ensureInitialized();
      if (_businessProfileBox == null && !_useMemoryFallback) {
        logger.w('Cannot clear business profile: Hive not available');
        return;
      }
      if (_useMemoryFallback) {
        logger.w('Memory fallback - no business profile data to clear');
        return;
      }
      logger.i('Clearing business profile from Hive');
      await _businessProfileBox!.delete(_businessProfileKey);
      logger.i('Business profile data cleared');
    } catch (e, stackTrace) {
      logger.e('Error clearing business profile: $e',  e,  stackTrace);
    }
  }

  Future<void> clearUser() async {
    try {
      await ensureInitialized();
      if (_userBox == null && !_useMemoryFallback) {
        logger.w('Cannot clear user: Hive not available');
        return;
      }
      if (_useMemoryFallback) {
        logger.w('Memory fallback - no user data to clear');
        return;
      }
      logger.i('Clearing user from Hive');
      await _userBox!.delete(_userKey);
      logger.i('User data cleared');
    } catch (e, stackTrace) {
      logger.e('Error clearing user: $e',  e,  stackTrace);
    }
  }

  bool get isStorageAvailable => _isInitialized && !_useMemoryFallback;
  bool get isUsingMemoryFallback => _useMemoryFallback;

  String? get storagePath {
    if (_customStoragePath != null) return _customStoragePath;
    if (Platform.isWindows) {
      final documentsDir = getApplicationDocumentsDirectory();
      return '${documentsDir}\\GreenBiller';
    }
    return null;
  }
}
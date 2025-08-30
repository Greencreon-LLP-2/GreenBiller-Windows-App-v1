import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:greenbiller/features/auth/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HiveService {
  final Logger logger = Logger();
  static const String _userBoxName = 'userbox';
  static const String _userKey = 'currentUser';
  Box<UserModel>? _userBox;
  bool _isInitialized = false;
  bool _useMemoryFallback = false;
  String? _customStoragePath;

  // Set a custom storage path - Updated for your specific location
  void setCustomStoragePath(String path) {
    _customStoragePath = path;
    logger.i('Custom storage path set to: $path');
  }

  // Request storage permissions
  Future<bool> _requestStoragePermissions() async {
    if (Platform.isWindows) {
      try {
        // Try to create a test file to check permissions
        final tempDir = Directory.systemTemp;
        print(
          "Temp directory path: ${tempDir.path}",
        ); // Fixed the print statement
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

  // Get the storage directory - Updated for your specific location
  Future<Directory> _getStorageDirectory() async {
    // Use custom path if specified
    if (_customStoragePath != null) {
      final customDir = Directory(_customStoragePath!);
      if (!customDir.existsSync()) {
        customDir.createSync(recursive: true);
      }
      return customDir;
    }

    // Use the specific location you want: C:/Documents/GreenBiller
    try {
      if (Platform.isWindows) {
        // Get the user's documents directory
        final documentsDir = await getApplicationDocumentsDirectory();

        // Create the specific path: C:/Users/Username/Documents/GreenBiller
        final greenBillerDir = Directory('${documentsDir.path}\\GreenBiller');
        if (!greenBillerDir.existsSync()) {
          greenBillerDir.createSync(recursive: true);
          logger.i('Created GreenBiller directory: ${greenBillerDir.path}');
        }
        return greenBillerDir;
      } else {
        // For other platforms, use application support directory
        return await getApplicationSupportDirectory();
      }
    } catch (e) {
      logger.w('Failed to get preferred storage directory: $e');

      // Fallback: Use temporary directory
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

      // Request storage permissions
      final hasPermission = await _requestStoragePermissions();
      if (!hasPermission) {
        logger.w('Storage permissions not granted, using memory fallback');
        _useMemoryFallback = true;
        _isInitialized = true;
        return;
      }

      // Get the storage directory
      final storageDir = await _getStorageDirectory();
      logger.i('Using storage directory: ${storageDir.path}');

      // Initialize Hive with the chosen path
      await Hive.initFlutter(storageDir.path);

      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserModelAdapter());
        logger.i('Hive adapter registered for UserModel (typeId: 0)');
      } else {
        logger.i('Hive adapter for UserModel (typeId: 0) already registered');
      }

      // Try to open the box
      try {
        _userBox = await Hive.openBox<UserModel>(_userBoxName);
        logger.i('Hive box opened successfully: $_userBoxName');
      } catch (e) {
        logger.w('Error opening box: $e');

        // Try with crash recovery disabled
        try {
          _userBox = await Hive.openBox<UserModel>(
            _userBoxName,
            crashRecovery: false,
          );
          logger.i('Hive box opened with crashRecovery: false');
        } catch (e2) {
          logger.w('Failed with crashRecovery false: $e2');

          // Try to delete and recreate the box
          try {
            await Hive.deleteBoxFromDisk(_userBoxName);
            _userBox = await Hive.openBox<UserModel>(_userBoxName);
            logger.i('Hive box recreated after deletion');
          } catch (e3) {
            logger.w('Failed to recreate box: $e3');
            _useMemoryFallback = true;
            logger.w('Using memory fallback storage');
          }
        }
      }

      _isInitialized = true;
      logger.i('Hive initialization completed successfully');
    } catch (e, stackTrace) {
      logger.e('Hive initialization failed: $e', e, stackTrace);
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
        logger.w(
          'Using memory fallback for user storage - data will not persist',
        );
        logger.i('User data (not persisted): ${user.toJson()}');
        return;
      }

      logger.i('Saving user to Hive: ${user.toJson()}');
      await _userBox!.put(_userKey, user);
      logger.i('User saved successfully');
    } catch (e, stackTrace) {
      logger.e('Error saving user: $e', e, stackTrace);
      // Don't rethrow - we want the app to continue working even if saving fails
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
      logger.e('Error retrieving user: $e', e, stackTrace);
      return null;
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
      logger.e('Error clearing user: $e', e, stackTrace);
      // Don't rethrow - continue operation
    }
  }

  bool get isStorageAvailable => _isInitialized && !_useMemoryFallback;
  bool get isUsingMemoryFallback => _useMemoryFallback;

  // Add method to get the current storage path
  String? get storagePath {
    if (_customStoragePath != null) return _customStoragePath;
    if (Platform.isWindows) {
      final documentsDir = getApplicationDocumentsDirectory();
      return '${documentsDir}\\GreenBiller';
    }
    return null;
  }
}

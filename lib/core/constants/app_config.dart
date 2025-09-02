import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  static late final String appName;
  static late final String packageName;
  static late final String version;
  static late final String buildNumber;

  /// Call this once before `runApp()` to initialize the app config
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    final packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}

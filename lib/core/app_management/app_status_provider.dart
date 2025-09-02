// app_status_provider.dart or app_status_service.dart
import 'package:green_biller/core/app_management/AppStatusNotifier.dart';
import 'package:green_biller/core/app_management/app_status_model.dart';
import 'package:hooks_riverpod/legacy.dart';

final appStatusProvider =
    StateNotifierProvider<AppStatusNotifier, AppStatusModel>((ref) {
  return AppStatusNotifier(ref);
});

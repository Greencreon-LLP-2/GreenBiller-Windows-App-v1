// app_status_provider.dart or app_status_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/app_management/AppStatusNotifier.dart';
import 'package:green_biller/core/app_management/app_status_model.dart';

final appStatusProvider =
    StateNotifierProvider<AppStatusNotifier, AppStatusModel>((ref) {
  return AppStatusNotifier(ref);
});

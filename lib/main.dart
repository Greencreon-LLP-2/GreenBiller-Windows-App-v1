import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/app_management/app_status_model.dart';
import 'package:green_biller/core/app_management/app_status_provider.dart';
import 'package:green_biller/core/constants/app_config.dart';
import 'package:green_biller/core/routes/routes.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';
import 'package:logger/logger.dart';

final logger = Logger();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  UserModel? userData;
  await AppConfig.init();
  try {
    userData = await authService.getUserData();
    logger.i('User data loaded: ${userData != null}');
  } catch (e) {
    logger.e('Error loading user data: $e');
  }

  runApp(
    ProviderScope(
      overrides: [
        if (userData != null) userProvider.overrideWith((ref) => userData),
      ],
      child: MyApp(userData: userData),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final UserModel? userData;

  const MyApp({super.key, required this.userData});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late ProviderSubscription<AppStatusModel> _statusSubscription;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = widget.userData;
      if (user != null) {
        final token = user.accessToken ?? '';
        final userId = user.user?.id.toString() ?? '';
        ref.read(appStatusProvider.notifier).startPolling(token, userId);
      }
    });
  }

  @override
  void dispose() {
    _statusSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Green Biller',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

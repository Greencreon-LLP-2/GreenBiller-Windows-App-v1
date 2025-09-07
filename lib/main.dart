import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/app_handler/push_notification_service.dart';
import 'package:greenbiller/core/app_handler/hive_service.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/auth/view/login_page.dart';
import 'package:greenbiller/features/auth/view/maintenance.dart';
import 'package:greenbiller/features/auth/view/notification_page.dart';
import 'package:greenbiller/features/auth/view/otp_verify_page.dart';
import 'package:greenbiller/features/auth/view/signup_page.dart';
import 'package:greenbiller/features/items/controller/add_items_controller.dart';
import 'package:greenbiller/features/items/controller/all_items_controller.dart';
import 'package:greenbiller/features/items/controller/brand_controller.dart';
import 'package:greenbiller/features/items/controller/category_controller.dart';
import 'package:greenbiller/features/items/controller/category_items_controller.dart';
import 'package:greenbiller/features/items/controller/edit_item_controller.dart';
import 'package:greenbiller/features/items/controller/unit_controller.dart';
import 'package:greenbiller/features/items/views/brands/brand_page.dart';
import 'package:greenbiller/features/items/views/category/categories_page.dart';
import 'package:greenbiller/features/items/views/items/add_items_page.dart';
import 'package:greenbiller/features/items/views/items/all_items_page.dart';
import 'package:greenbiller/features/items/views/units/units_page.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/features/parties/view/parties_page.dart';
import 'package:greenbiller/features/purchase/controller/new_purchase_controller.dart';
import 'package:greenbiller/features/purchase/view/new_purchase_page.dart';
import 'package:greenbiller/features/settings/controller/bussiness_profile_controller.dart';
import 'package:greenbiller/features/settings/controller/invoice_settings_controller.dart';
import 'package:greenbiller/features/settings/view/account_setttings_page.dart';
import 'package:greenbiller/features/settings/controller/account_settings_controller.dart';
import 'package:greenbiller/features/settings/controller/store_user_creation_controller.dart';
import 'package:greenbiller/features/settings/view/business_profile_page.dart';
import 'package:greenbiller/features/settings/view/invoice_settings_page.dart';
import 'package:greenbiller/features/settings/view/store_users.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';
import 'package:greenbiller/features/store/controller/store_warehouse_details_controller.dart';
import 'package:greenbiller/features/store/view/store_page.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:greenbiller/screens/dashboards.dart';
import 'package:greenbiller/screens/store_admin/store_admin_entry_point.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = Logger();

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized(); // ✅ Now in same zone

      try {
        logger.i('Initializing Hive');
        final documentsDir = await getApplicationDocumentsDirectory();
        final hiveService = HiveService();
        Get.put(hiveService);
        hiveService.setCustomStoragePath('${documentsDir.path}\\GreenBiller');

        await hiveService.init();

        if (!Platform.isLinux) {
          logger.i(
            'Initializing PushNotificationService on ${Platform.operatingSystem}',
          );
          Get.put(PushNotificationService());
          await Get.find<PushNotificationService>().init(
            'your-onesignal-app-id',
          );
        } else {
          logger.w('PushNotificationService skipped on Linux');
        }
      } catch (e, stackTrace) {
        logger.e('Initialization error: $e', e, stackTrace);
        // Continue running the app even if initialization fails
      }

      runApp(const MyApp()); // ✅ Same zone as ensureInitialized
    },
    (error, stackTrace) {
      logger.e('Uncaught error: $error', error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GreenBiller',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      // initialRoute: AppRoutes.accountSettings,
      // initialRoute: AppRoutes.addItems,
      getPages: [
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.otpVerify, page: () => const OtpVerifyPage()),
        GetPage(name: AppRoutes.signUp, page: () => const SignUpPage()),
        GetPage(
          name: AppRoutes.adminDashboard,
          page: () => const StoreAdminEntryPoint(),
        ),
        GetPage(
          name: AppRoutes.managerDashboard,
          page: () => const ManagerDashboard(),
        ),
        GetPage(
          name: AppRoutes.staffDashboard,
          page: () => const StaffDashboard(),
        ),
        GetPage(
          name: AppRoutes.customerDashboard,
          page: () => const CustomerDashboard(),
        ),
        GetPage(
          name: AppRoutes.homepage,
          page: () => const CustomerDashboard(),
        ),
        GetPage(name: AppRoutes.maintenance, page: () => const Maintenance()),
        GetPage(
          name: AppRoutes.oneSignalNotificationPage,
          page: () => const NotificationDetailsPage(),
        ),
        GetPage(
          name: AppRoutes.accountSettings,
          page: () => AccountSetttingsPage(),
          binding: BindingsBuilder(() {
            Get.put(AccountController());
          }),
        ),
        GetPage(
          name: AppRoutes.usersSettings,
          page: () => const StoreUsers(),
          binding: BindingsBuilder(() {
            Get.put(UserCreationController());
          }),
        ),
        GetPage(
          name: AppRoutes.businessProfile,
          page: () => const BusinessProfilePage(),
          binding: BindingsBuilder(() {
            Get.put(BusinessProfileController());
          }),
        ),
        GetPage(
          name: AppRoutes.invoiceSettings,
          page: () => InvoiceSettingsPage(),
          binding: BindingsBuilder(() {
            Get.put(InvoiceSettingsController());
          }),
        ),
        GetPage(
          name: AppRoutes.newPurchase,
          page: () => NewPurchasePage(),
          binding: BindingsBuilder(() {
            Get.put(NewPurchaseController());
          }),
        ),
        GetPage(
          name: AppRoutes.parties,
          page: () => PartiesPage(),
          binding: BindingsBuilder(() {
            Get.put(PartiesController());
          }),
        ),
        GetPage(
          name: AppRoutes.categoryView,
          page: () => CategoriesPage(),
          binding: BindingsBuilder(() {
            Get.put(CategoryController());
            Get.put(CategoryItemsController());
          }),
        ),
        GetPage(
          name: AppRoutes.brands,
          page: () => BrandPage(),
          binding: BindingsBuilder(() {
            Get.put(BrandController());
          }),
        ),
        GetPage(
          name: AppRoutes.units,
          page: () => UnitsPage(),
          binding: BindingsBuilder(() {
            Get.put(UnitController());
          }),
        ),
        GetPage(
          name: AppRoutes.addItems,
          page: () => AddItemsPage(),
          binding: BindingsBuilder(() {
            Get.put(AddItemController());
          }),
        ),
        GetPage(
          name: AppRoutes.viewItems,
          page: () => AllItemsPage(),
          binding: BindingsBuilder(() {
            Get.put(AllItemsController());
            Get.put(AddItemController());
            Get.put(EditItemController());
          }),
        ),
        GetPage(
          name: AppRoutes.viewStore,
          page: () => StorePage(),
          binding: BindingsBuilder(() {
            Get.put(StoreController());
          }),
        ),
        GetPage(
          name: AppRoutes.singleStoreView,
          page: () => StorePage(),
          binding: BindingsBuilder(() {
            Get.put(StoreWarehouseDetailsController);
          }),
        ),
      ],
      builder: (context, child) {
        // ✅ Always-available global controllers
        Get.put(AuthController(), permanent: true);
        Get.put(CommonApiFunctionsController(), permanent: true);
        Get.put(DropdownController(), permanent: true);

        return child!;
      },
    );
  }
}

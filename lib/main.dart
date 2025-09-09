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
import 'package:greenbiller/features/notifications/view/notification_settings_page.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/features/parties/view/parties_page.dart';
import 'package:greenbiller/features/payment/controller/add_payment_controller.dart';
import 'package:greenbiller/features/payment/controller/payment_controller.dart';
import 'package:greenbiller/features/payment/view/add_payment_in_page.dart';
import 'package:greenbiller/features/payment/view/add_payment_out_page.dart';
import 'package:greenbiller/features/payment/view/all_payment_in_page.dart';
import 'package:greenbiller/features/payment/view/all_payment_out_page.dart';
import 'package:greenbiller/features/purchase/controller/new_purchase_controller.dart';
import 'package:greenbiller/features/purchase/controller/purchase_manage_controller.dart';
import 'package:greenbiller/features/purchase/view/new_purchase_page.dart';
import 'package:greenbiller/features/purchase/view/purchase_bills.dart';
import 'package:greenbiller/features/purchase/view/purchase_return_page.dart';
import 'package:greenbiller/features/purchase/view/purchase_return_view_page.dart';
import 'package:greenbiller/features/sale/controller/sales_create_controller.dart';
import 'package:greenbiller/features/sale/controller/sales_manage_controller.dart';
import 'package:greenbiller/features/sale/controller/sales_order_controller.dart';
import 'package:greenbiller/features/sale/view/add_sales_order_page.dart';
import 'package:greenbiller/features/sale/view/credit_note_page.dart';
import 'package:greenbiller/features/sale/view/new_sale_page.dart';
import 'package:greenbiller/features/sale/view/sales_order_page.dart';
import 'package:greenbiller/features/sale/view/sales_returns_view_page.dart';
import 'package:greenbiller/features/sale/view/sales_view_page.dart';
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
import 'package:greenbiller/features/store/view/edit_store_page.dart';
import 'package:greenbiller/features/store/view/store_detail_page.dart';
import 'package:greenbiller/features/store/view/store_page.dart';
import 'package:greenbiller/features/store/view/warehouse_detail_page.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:greenbiller/screens/dashboards.dart';
import 'package:greenbiller/screens/store_admin/store_admin_entry_point.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = Logger();

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

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

      runApp(const MyApp());
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
      getPages: [
        // Authentication Routes
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.otpVerify, page: () => const OtpVerifyPage()),
        GetPage(name: AppRoutes.signUp, page: () => const SignUpPage()),

        // Dashboard Routes
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

        // Settings Routes
        GetPage(
          name: AppRoutes.bankAccountSettings,
          page: () => AccountSetttingsPage(),
          binding: BindingsBuilder(() {
            Get.put(AccountController());
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
          name: AppRoutes.usersSettings,
          page: () => const StoreUsers(),
          binding: BindingsBuilder(() {
            Get.put(UserCreationController());
          }),
        ),
        GetPage(
          name: AppRoutes.notificationSettings,
          page: () => const NotificationSettingsPage(),
        ),

        // Notification Routes
        GetPage(
          name: AppRoutes.notificationDetails,
          page: () => const NotificationDetailsPage(),
        ),

        // Inventory Management Routes
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
          name: AppRoutes.brands,
          page: () => BrandPage(),
          binding: BindingsBuilder(() {
            Get.put(BrandController());
          }),
        ),
        GetPage(
          name: AppRoutes.categories,
          page: () => CategoriesPage(),
          binding: BindingsBuilder(() {
            Get.put(CategoryController());
            Get.put(CategoryItemsController());
          }),
        ),
        GetPage(
          name: AppRoutes.units,
          page: () => UnitsPage(),
          binding: BindingsBuilder(() {
            Get.put(UnitController());
          }),
        ),

        // Purchase Routes
        GetPage(
          name: AppRoutes.newPurchase,
          page: () => NewPurchasePage(),
          binding: BindingsBuilder(() {
            Get.put(NewPurchaseController());
          }),
        ),
        GetPage(
          name: AppRoutes.viewPurchaseBills,
          page: () => PurchaseBills(),
          binding: BindingsBuilder(() {
            Get.put(PurchaseManageController());
          }),
        ),
        GetPage(
          name: AppRoutes.purchaseReturnView,
          page: () => PurchaseReturnViewPage(),
          binding: BindingsBuilder(() {
            Get.put(PurchaseManageController());
          }),
        ),
        GetPage(
          name: AppRoutes.purchaseReturnCreate,
          page: () {
            final purchaseId = Get.parameters['purchaseId'] ?? '';
            return PurchaseReturnPage(purchaseId: purchaseId);
          },
          binding: BindingsBuilder(() {
            final purchaseId = Get.parameters['purchaseId'] ?? '';
            Get.put(PurchaseManageController(purchaseId: purchaseId));
          }),
        ),

        // Store and Warehouse Routes
        GetPage(
          name: AppRoutes.viewStore,
          page: () => StorePage(),
          binding: BindingsBuilder(() {
            Get.put(StoreController());
          }),
        ),
        GetPage(
          name: AppRoutes.singleStoreView,
          page: () => const StoreDetailScreen(),
          binding: BindingsBuilder(() {
            Get.put(StoreWarehouseDetailsController());
          }),
        ),
        GetPage(
          name: AppRoutes.editStoreView,
          page: () => EditStorePage(),
          binding: BindingsBuilder(() {
            Get.put(StoreController());
          }),
        ),
        GetPage(
          name: AppRoutes.singleWarehouseView,
          page: () => const WarehouseDetailScreen(),
          binding: BindingsBuilder(() {
            Get.put(StoreWarehouseDetailsController());
          }),
        ),

        // Other Routes
        GetPage(name: AppRoutes.maintenance, page: () => const Maintenance()),
        GetPage(
          name: AppRoutes.parties,
          page: () => PartiesPage(),
          binding: BindingsBuilder(() {
            Get.put(PartiesController());
          }),
        ),
        GetPage(
          name: AppRoutes.newSales,
          page: () => NewSalePage(),
          binding: BindingsBuilder(() {
            Get.put(SalesController());
            Get.put(PartiesController());
          }),
        ),
        GetPage(
          name: AppRoutes.viewAllsales,
          page: () => SalesViewPage(),
          binding: BindingsBuilder(() {
            Get.put(SalesManageController());
          }),
        ),
        GetPage(
          name: AppRoutes.creditNote,
          page: () => CreditNotePage(),
          binding: BindingsBuilder(() {
            Get.put(SalesManageController());
          }),
        ),
        GetPage(
          name: AppRoutes.viewAllsalesReturns,
          page: () => SalesReturnPage(),
          binding: BindingsBuilder(() {
            Get.put(SalesManageController());
          }),
        ),
        GetPage(
          name: AppRoutes.viewAllsalesOrders,
          page: () => const SalesOrderPage(),
          binding: BindingsBuilder(() {
            Get.put(SalesManageController());
          }),
        ),
        GetPage(
          name: AppRoutes.createsaleOrder,
          page: () => AddSalesOrderPage(),
          binding: BindingsBuilder(() {
            Get.put(SalesOrderController());
          }),
        ),
        GetPage(
          name: AppRoutes.allPaymentInView,
          page: () => AllPaymentInPage(),
          binding: BindingsBuilder(() {
            Get.put(PaymentController());
          }),
        ),
        GetPage(
          name: AppRoutes.allPaymentOutView,
          page: () => AllPaymentOutPage(),
          binding: BindingsBuilder(() {
            Get.put(PaymentController());
          }),
        ),
        GetPage(
          name: AppRoutes.addPaymentIn,
          page: () => AddPaymentInPage(),
          binding: BindingsBuilder(() {
            Get.put(AddPaymentController());
          }),
        ),
        GetPage(
          name: AppRoutes.addPaymentOut,
          page: () => AddPaymentOutPage(),
          binding: BindingsBuilder(() {
            Get.put(AddPaymentController());
          }),
        ),
      ],
      builder: (context, child) {
        // Global controllers
        Get.put(AuthController(), permanent: true);
        Get.put(CommonApiFunctionsController(), permanent: true);
        Get.put(DropdownController(), permanent: true);
        return child!;
      },
    );
  }
}

import 'package:go_router/go_router.dart';
import 'package:green_biller/core/app_management/app_status_model.dart';
import 'package:green_biller/core/app_management/app_status_provider.dart';
import 'package:green_biller/core/constants/app_config.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/view/login_page.dart';
import 'package:green_biller/features/errors/views/maintenance_page.dart';
import 'package:green_biller/features/errors/views/update_app.dart';
import 'package:green_biller/features/home/view/pages/darshboard_page.dart';
import 'package:green_biller/features/home/view/pages/home_page/homepage.dart';
import 'package:green_biller/features/home/view/pages/menu_page/menu_page.dart';
import 'package:green_biller/features/home/view/pages/quick_actions/transactions.dart';
import 'package:green_biller/features/item/view/pages/items_page.dart';
import 'package:green_biller/features/item/view/pages/units/units_page.dart';
import 'package:green_biller/features/packages/view/pages/packages_page.dart';
import 'package:green_biller/features/payment/view/pages/all_payment_page/all_payment_page.dart';
import 'package:green_biller/features/payment/view/pages/payment_out_page/payment_out_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/purchase_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_return_page/purchase_return_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_returns_view/purchase_return_view_page.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_view/purchase_view_page.dart';
import 'package:green_biller/features/reports/purchase_report/view/pages/purchase_item_report.dart';
import 'package:green_biller/features/reports/purchase_report/view/pages/purchase_summary.dart';
import 'package:green_biller/features/reports/purchase_report/view/pages/purchase_supplier_base_summary.dart';
import 'package:green_biller/features/reports/report_page.dart';
import 'package:green_biller/features/reports/sales_report/sales_by_item_page.dart';
import 'package:green_biller/features/reports/sales_report/view/pages/sale_by_item_report.dart';
import 'package:green_biller/features/reports/sales_report/view/pages/sales_by_customer.dart';
import 'package:green_biller/features/reports/sales_report/view/pages/sales_summary_page.dart';
import 'package:green_biller/features/reports/stock_report/low_stock_alert_page.dart';
import 'package:green_biller/features/reports/stock_report/stock_movement_page.dart';
import 'package:green_biller/features/reports/stock_report/stock_summary_page.dart';
import 'package:green_biller/features/sales/view/pages/POS/pos_billing_page.dart';
import 'package:green_biller/features/sales/view/pages/add_credit_note_items_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_order_items_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/new_sale_page.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/sales%20LIst/sales_list.dart';
import 'package:green_biller/features/sales/view/pages/sales_order_page.dart';
import 'package:green_biller/features/sales/view/pages/sales_return_page.dart';
import 'package:green_biller/features/sales/view/pages/sales_view/sales_view_page.dart';
import 'package:green_biller/features/sales/view/pages/stock_adjustment_item.dart';
import 'package:green_biller/features/sales/view/pages/stock_transfer_item.dart';
import 'package:green_biller/features/settings/view/pages/Activity%20Log/active_log_page.dart';
import 'package:green_biller/features/settings/view/pages/account_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/business_profile_page/business_profile_page.dart';
import 'package:green_biller/features/settings/view/pages/business_setting/invoice_settings_page.dart';
import 'package:green_biller/features/settings/view/pages/settingspage.dart'
    hide BusinessProfilePage, InvoiceSettingsPage;
import 'package:green_biller/features/settings/view/pages/users_setting_page/users_settings.page.dart';
import 'package:green_biller/features/store/view/parties_page/parties_page.dart';
import 'package:green_biller/features/user/user_creation_page/user_creation_page.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  String? lastRedirectResult;
  AppStatusModel? lastStatus;
  UserModel? lastUser;

  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: navigatorKey,
    redirect: (context, state) {
      final user = ref.read(userProvider);
      final appStatus = ref.watch(appStatusProvider);

      // Check if anything actually changed since last time
      final userChanged = user != lastUser;
      final statusChanged = appStatus != lastStatus;

      if (!userChanged && !statusChanged) {
        return lastRedirectResult;
      }

      lastUser = user;
      lastStatus = appStatus;

      final isLoggedIn = user?.accessToken != null;
      final isLoginRoute = state.matchedLocation == '/';
      final isMaintenanceRoute = state.matchedLocation == '/maintanance';
      final isUpdateRoute = state.matchedLocation == '/update-app';
      final appStatusNotLoaded =
          appStatus.settings == null || appStatus == AppStatusModel.initial();

      // // 1. First check maintenance mode (highest priority)
      // final isInMaintenance = appStatus.shutdown == true ||
      //     appStatus.settings?.appMaintenanceMode == true;

      // if (isInMaintenance && !isMaintenanceRoute) {
      //   return '/maintanance';
      // }

      // if (isInMaintenance &&
      //     !isMaintenanceRoute &&
      //     appStatus.maintenanceData?.code == 302) {
      //   return '/';
      // }
      // 2. Check for forced update
      print(appStatus.settings?.appVersion.toString());
      print(AppConfig.version.toString());
      if (appStatus.settings?.appVersion.toString() !=
              AppConfig.version.toString() &&
          !isUpdateRoute) {
        return '/update-app';
      }

      // 3. Handle initial state before status loaded
      if (appStatusNotLoaded) {
        return isLoggedIn ? '/homepage' : '/';
      }

      // 4. Handle user invalidation
      final shouldLogout = appStatus.userExists != true ||
          appStatus.isLoggedIn != true ||
          appStatus.userBlocked == true;

      if (shouldLogout && isLoggedIn) {
        return '/';
      }

      // 5. Prevent logged-in users from seeing login page
      if (isLoggedIn && isLoginRoute) {
        return '/homepage';
      }

      // 6. All clear - no redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/homepage',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/maintanance',
        builder: (context, state) => const MaintenancePage(),
      ),
      GoRoute(
        path: '/update-app',
        builder: (context, state) => const UpdateApp(),
      ),
      GoRoute(
        path: '/items',
        builder: (context, state) => const ItemsPage(),
      ),
      GoRoute(
        path: '/units',
        builder: (context, state) => const UnitsPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/packages',
        builder: (context, state) => const PackagesPage(),
      ),
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuPage(),
      ),
      GoRoute(
        path: '/user-creation',
        builder: (context, state) => const UserCreationPage(),
      ),
      GoRoute(
        path: '/purchasepage',
        builder: (context, state) => const PurchasePage(),
      ),
      GoRoute(
        path: '/purchase-return/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']; // Get the ID
          return PurchaseReturnPage(purcahseId: id!);
        },
      ),
      GoRoute(
        path: '/purchase-returns-view',
        builder: (context, state) => PurchaseReturnViewPage(),
      ),
      GoRoute(
        path: '/new-sale',
        builder: (context, state) => const AddNewSalePage(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/sales-summary',
        builder: (context, state) => const SalesSummaryPage(),
      ),
      GoRoute(
        path: '/sales-by-item',
        builder: (context, state) => const SalesByItemPage(),
      ),
      GoRoute(
        path: '/sales-by-customer',
        builder: (context, state) => const SalesByCustomerPage(),
      ),
      GoRoute(
        path: '/add-credit-note-items/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? ''; // Get the ID
          return AddCreditNoteItemsPage(storeId: id);
        },
      ),
      GoRoute(
        path: '/add-credit-note-items/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? ''; // Get the ID
          return AddCreditNoteItemsPage(storeId: id);
        },
      ),
      GoRoute(
        path: '/add-sales-oder-items/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? ''; // Get the ID
          return AddSaleOrderItemsPage(storeId: id);
        },
      ),
      GoRoute(
        path: '/payment-out',
        builder: (context, state) => const PaymentOutPage(),
      ),
      GoRoute(
        path: '/stock-summary',
        builder: (context, state) => const StockSummaryPage(),
      ),
      GoRoute(
        path: '/low-stock-alert',
        builder: (context, state) => const LowStockAlertPage(),
      ),
      GoRoute(
        path: '/stock-movement',
        builder: (context, state) => const StockMovementPage(),
      ),
      GoRoute(
        path: '/stock-adjustment',
        builder: (context, state) => StockAdjustmentItem(),
      ),
      GoRoute(
        path: '/stock-transfer',
        builder: (context, state) => StockTransferItem(),
      ),
      GoRoute(
        path: '/parties',
        builder: (context, state) => const PartiesPage(),
      ),
      GoRoute(
        path: '/account-settings',
        builder: (context, state) => const AccountSettingsPage(),
      ),
      GoRoute(
        path: '/purchase-summary',
        builder: (context, state) => const PurchaseSummary(),
      ),
      GoRoute(
        path: '/purchase-supplier-base-summary',
        builder: (context, state) => const PurchaseSupplierBaseSummary(),
      ),
      GoRoute(
        path: '/purchase-view',
        builder: (context, state) => PurchaseViewPage(),
      ),
      GoRoute(
        path: '/sales-view',
        builder: (context, state) => const SalesViewPage(),
      ),
      GoRoute(
        path: '/purchase-item-report',
        builder: (context, state) => const PurchaseItemReportPage(),
      ),
      GoRoute(
        path: '/sale-by-item-report',
        builder: (context, state) => const SaleByItemReport(),
      ),
      GoRoute(
        path: '/business-profile',
        builder: (context, state) => const BusinessProfilePage(),
      ),
      GoRoute(
        path: '/users-settings',
        builder: (context, state) => const UserSettingsPage(),
      ),
      GoRoute(
        path: '/active-log',
        builder: (context, state) => const ActiveLogPage(),
      ),
      GoRoute(
        path: '/invoice-settings',
        builder: (context, state) => const InvoiceSettingsPage(),
      ),
      GoRoute(
        path: '/sale-list',
        builder: (context, state) => const SalesListPage(),
      ),
      GoRoute(
        path: '/payment-in',
        builder: (context, state) => const PaymentIn(),
      ),
      GoRoute(
        path: '/payment-out',
        builder: (context, state) => const PaymentOutPage(),
      ),
      GoRoute(
        path: '/sales-return',
        builder: (context, state) => const SalesReturnPage(),
      ),
      GoRoute(
        path: '/sales-order',
        builder: (context, state) => const SalesOrderPage(),
      ),
      GoRoute(
        path: '/pose-billing-page',
        builder: (context, state) => const POSBillingPage(),
      ),
    ],
  );
});

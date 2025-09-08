// Authentication Routes
class AppRoutes {
  static const String login = '/login';
  static const String otpVerify = '/otp-verify';
  static const String signUp = '/sign-up';

  // Dashboard Routes
  static const String adminDashboard = '/admin-dashboard';
  static const String managerDashboard = '/manager-dashboard';
  static const String staffDashboard = '/staff-dashboard';
  static const String customerDashboard = '/customer-dashboard';
  static const String homepage = '/homepage';

  // Settings Routes
  static const String bankAccountSettings = '/bank-account-settings';
  static const String businessProfile = '/business-profile';
  static const String invoiceSettings = '/invoice-settings';
  static const String notificationSettings = '/notification-settings';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String usersSettings = '/users-settings';

  // Notification Routes
  static const String notificationDetails = '/notification-details';

  // Inventory Management Routes
  static const String addItems = '/items/add';
  static const String viewItems = '/items/view';
  static const String brands = '/brands';
  static const String categories = '/categories';
  static const String units = '/units';

  // Purchase Routes
  static const String newPurchase = '/purchase/create';
  static const String viewPurchaseBills = '/purchase/bills';
  static const String purchaseReturnView = '/purchase/return-view';
  static const String purchaseReturnCreate =
      '/purchase/return-create/:purchaseId';

  // Sales Routes
  static const String newSales = '/sales/create';

  // Store and Warehouse Routes
  static const String viewStore = '/stores/view';
  static const String singleStoreView = '/stores/view/:storeId';
  static const String editStoreView = '/stores/edit/:storeId';
  static const String singleWarehouseView = '/warehouses/view/:warehouseId';

  // Other Routes
  static const String maintenance = '/maintenance';
  static const String overview = '/overview';
  static const String parties = '/parties';
  static const String reports = '/reports';
}

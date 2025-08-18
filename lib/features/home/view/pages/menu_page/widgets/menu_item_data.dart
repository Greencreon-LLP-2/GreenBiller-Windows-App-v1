import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/auth/login/services/auth_service.dart';
import 'package:green_biller/features/home/view/pages/menu_page/models/menu_item_model.dart';
import 'package:green_biller/features/payment/view/pages/all_payment_page/all_payment_page.dart';
import 'package:green_biller/features/sales/view/pages/sales_order_page.dart';
import 'package:green_biller/features/sales/view/pages/sales_return_page.dart';

//!-------------------------------------------------------- Contains all menu item definitions for the menu page
class MenuItemData {
  //!-------------------------------------------------------- Define menu items for the Sales group
  static final List<MenuItemModel> salesItems = [
    MenuItemModel("Sale Invoice", Icons.receipt_long, (context, ref) async {
      context.push('/sales-view');
      return;
    }),
    MenuItemModel("Payment-In", Icons.payment, (context, ref) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PaymentIn()));
      return;
    }),
    MenuItemModel("Sale Return", Icons.assignment_return, (context, ref) async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SalesReturnPage()));
      return;
    }),
    // MenuItemModel("Estimate/Quotation", Icons.description,
    //     (context, ref) async {
    //   return;
    // }),
    MenuItemModel("Sale Order", Icons.shopping_cart, (context, ref) async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SalesOrderPage()));
      return;
    }),
    MenuItemModel("Delivery Challan", Icons.local_shipping,
        (context, ref) async {
      return;
    }),
  ];

  // !========================================================Define menu items for the Purchase group
  static final List<MenuItemModel> purchaseItems = [
    MenuItemModel("Purchase Bills", Icons.receipt, (context, ref) async {
      context.push('/purchase-view');
      return;
    }),
    // MenuItemModel("Payment-Out", Icons.payments, (context, ref) async {
    //   context.push('/payment-out');
    //   return;
    // }),
    MenuItemModel("Purchase Returns", Icons.assignment_return,
        (context, ref) async {
      context.push('/purchase-returns-view');
      return;
    }),
    // MenuItemModel("Purchase Order", Icons.shopping_basket,
    //     (context, ref) async {
    //   return;
    // }),
  ];



  //!--------------------------------------------------------  Define menu items for the Other group
  static final List<MenuItemModel> otherItems = [
    MenuItemModel("Premium Features", Icons.star, (context, ref) async {
      return;
    }),
    MenuItemModel("Other Products", Icons.apps, (context, ref) async {
      return;
    }),
    MenuItemModel("Desktop Software", Icons.computer, (context, ref) async {
      return;
    }),
    MenuItemModel("Settings", Icons.settings, (context, ref) async {
      return;
    }),
    MenuItemModel("Help & Support", Icons.help_outline, (context, ref) async {
      return;
    }),
    MenuItemModel("Rate this App", Icons.star_rate, (context, ref) async {
      return;
    }),
    MenuItemModel("Logout", Icons.logout, (context, ref) async {
      await AuthService().clearUserData();
      ref.read(userProvider.notifier).state = null;
      context.go('/');
      return;
    }),
  ];
}

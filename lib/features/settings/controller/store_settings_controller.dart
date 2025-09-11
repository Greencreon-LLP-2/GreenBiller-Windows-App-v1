// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:greenbiller/core/api_constants.dart';
// import 'package:greenbiller/core/app_handler/dio_client.dart';
// import 'package:greenbiller/features/auth/controller/auth_controller.dart';

// class EditStoreController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   final DioClient dioClient = Get.find<DioClient>();
//   final AuthController authController = Get.find<AuthController>();
//   late TabController tabController;

//   final RxBool isLoading = true.obs;
//   final RxInt storeId = 0.obs;
//   final RxString userId = ''.obs;
//   final RxBool showSignature = false.obs;

//   // Text controllers for additional fields
//   final emailController = TextEditingController();
//   final mobileController = TextEditingController();
//   final phoneController = TextEditingController();
//   final gstController = TextEditingController();
//   final panController = TextEditingController();
//   final vatController = TextEditingController();
//   final websiteController = TextEditingController();
//   final bankDetailsController = TextEditingController();
//   final addressController = TextEditingController();
//   final cityController = TextEditingController();
//   final stateController = TextEditingController();
//   final postcodeController = TextEditingController();
//   final countryController = TextEditingController();
//   final signatureController = TextEditingController();
//   final storeLogoController = TextEditingController();
//   final timezoneController = TextEditingController();
//   final currencyController = TextEditingController();
//   final decimalsController = TextEditingController();
//   final decimalsQtyController = TextEditingController();
//   final languageController = TextEditingController();
//   final defaultAccountController = TextEditingController();
//   final salesInvoiceFormatController = TextEditingController();
//   final posInvoiceFormatController = TextEditingController();

//   // Prefix controllers
//   final Map<String, TextEditingController> prefixControllers = {
//     'Category': TextEditingController(),
//     'Item': TextEditingController(),
//     'Supplier': TextEditingController(),
//     'Purchase': TextEditingController(),
//     'Purchase Return': TextEditingController(),
//     'Customer': TextEditingController(),
//     'Sales': TextEditingController(),
//     'Sales Return': TextEditingController(),
//     'Expense': TextEditingController(),
//     'Accounts': TextEditingController(),
//     'Quotation': TextEditingController(),
//     'Money Transfer': TextEditingController(),
//     'Sales Payment': TextEditingController(),
//     'Sales Return Payment': TextEditingController(),
//     'Purchase Payment': TextEditingController(),
//     'Purchase Return Payment': TextEditingController(),
//     'Expense Payment': TextEditingController(),
//     'Customers Advance Payments': TextEditingController(),
//   };

//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(length: 4, vsync: this);
//     storeId.value = int.parse(Get.parameters['storeEditId'] ?? '0');
//     userId.value = authController.user.value?.userId?.toString() ?? '0';
//     fetchStoreData();
//   }

//   @override
//   void onClose() {
//     tabController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     phoneController.dispose();
//     gstController.dispose();
//     panController.dispose();
//     vatController.dispose();
//     websiteController.dispose();
//     bankDetailsController.dispose();
//     addressController.dispose();
//     cityController.dispose();
//     stateController.dispose();
//     postcodeController.dispose();
//     countryController.dispose();
//     signatureController.dispose();
//     storeLogoController.dispose();
//     timezoneController.dispose();
//     currencyController.dispose();
//     decimalsController.dispose();
//     decimalsQtyController.dispose();
//     languageController.dispose();
//     defaultAccountController.dispose();
//     salesInvoiceFormatController.dispose();
//     posInvoiceFormatController.dispose();
//     prefixControllers.forEach((_, controller) => controller.dispose());
//     super.onClose();
//   }

//   Future<void> fetchStoreData() async {
//     try {
//       isLoading.value = true;
//       final response = await dioClient.dio.get(
//         '$viewStoreUrl/${storeId.value}',
//       );

//       if (response.statusCode == 200 &&
//           response.data['data'] != null &&
//           response.data['data'].isNotEmpty) {
//         final store = StoreModelById.fromJson(response.data['data'][0]);
//         emailController.text = store.email ?? '0';
//         mobileController.text = store.mobile ?? '0';
//         phoneController.text = store.phone ?? '0';
//         gstController.text = store.gstNo ?? '0';
//         panController.text = store.panNo ?? '0';
//         vatController.text = store.vatNo ?? '0';
//         websiteController.text = store.storeWebsite ?? '0';
//         bankDetailsController.text = store.bankDetails ?? '0';
//         addressController.text = store.address ?? '0';
//         cityController.text = store.city ?? '0';
//         stateController.text = store.state?.toString() ?? '0';
//         postcodeController.text = store.postcode?.toString() ?? '0';
//         countryController.text = store.country ?? '0';
//         signatureController.text = store.signature ?? '0';
//         storeLogoController.text = store.storeLogo ?? '0';
//         showSignature.value = store.showSignature == 1;
//         timezoneController.text = store.timezone ?? 'UTC';
//         currencyController.text = store.currencyId?.toString() ?? '1';
//         decimalsController.text = store.decimals?.toString() ?? '2';
//         decimalsQtyController.text = store.qtyDecimals?.toString() ?? '2';
//         languageController.text = store.languageId?.toString() ?? '1';
//         defaultAccountController.text =
//             store.defaultAccountId?.toString() ?? '1';
//         salesInvoiceFormatController.text =
//             store.salesInvoiceFormatId?.toString() ?? '1';
//         posInvoiceFormatController.text =
//             store.posInvoiceFormatId?.toString() ?? '1';

//         prefixControllers['Category']!.text = store.categoryInit ?? '0';
//         prefixControllers['Item']!.text = store.itemInit ?? '0';
//         prefixControllers['Supplier']!.text = store.supplierInit ?? '0';
//         prefixControllers['Purchase']!.text = store.purchaseInit ?? '0';
//         prefixControllers['Purchase Return']!.text =
//             store.purchaseReturnInit ?? '0';
//         prefixControllers['Customer']!.text = store.customerInit ?? '0';
//         prefixControllers['Sales']!.text = store.salesInit ?? '0';
//         prefixControllers['Sales Return']!.text = store.salesReturnInit ?? '0';
//         prefixControllers['Expense']!.text = store.expenseInit ?? '0';
//         prefixControllers['Accounts']!.text = store.accountsInit ?? '0';
//         prefixControllers['Quotation']!.text = store.quotationInit ?? '0';
//         prefixControllers['Money Transfer']!.text =
//             store.moneyTransferInit ?? '0';
//         prefixControllers['Sales Payment']!.text =
//             store.salesPaymentInit ?? '0';
//         prefixControllers['Sales Return Payment']!.text =
//             store.salesReturnPaymentInit ?? '0';
//         prefixControllers['Purchase Payment']!.text =
//             store.purchasePaymentInit ?? '0';
//         prefixControllers['Purchase Return Payment']!.text =
//             store.purchaseReturnPaymentInit ?? '0';
//         prefixControllers['Expense Payment']!.text =
//             store.expensePaymentInit ?? '0';
//         prefixControllers['Customers Advance Payments']!.text =
//             store.custAdvanceInit ?? '0';
//       } else {
//         Get.snackbar(
//           'Error',
//           'No store found for id ${storeId.value}',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to load store data: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> saveChanges() async {
//     try {
//       final payload = {
//         'user_id': userId.value,
//         'email': emailController.text.isEmpty ? '0' : emailController.text,
//         'mobile': mobileController.text.isEmpty ? '0' : mobileController.text,
//         'phone': phoneController.text.isEmpty ? '0' : phoneController.text,
//         'gst_no': gstController.text.isEmpty ? '0' : gstController.text,
//         'pan_no': panController.text.isEmpty ? '0' : panController.text,
//         'vat_no': vatController.text.isEmpty ? '0' : vatController.text,
//         'store_website': websiteController.text.isEmpty
//             ? '0'
//             : websiteController.text,
//         'bank_details': bankDetailsController.text.isEmpty
//             ? '0'
//             : bankDetailsController.text,
//         'address': addressController.text.isEmpty
//             ? '0'
//             : addressController.text,
//         'city': cityController.text.isEmpty ? '0' : cityController.text,
//         'state': stateController.text.isEmpty ? '0' : stateController.text,
//         'postcode': postcodeController.text.isEmpty
//             ? '0'
//             : postcodeController.text,
//         'country': countryController.text.isEmpty
//             ? '0'
//             : countryController.text,
//         'signature': signatureController.text.isEmpty
//             ? '0'
//             : signatureController.text,
//         'store_logo': storeLogoController.text.isEmpty
//             ? '0'
//             : storeLogoController.text,
//         'show_signature': showSignature.value ? '1' : '0',
//         'timezone': timezoneController.text.isEmpty
//             ? 'UTC'
//             : timezoneController.text,
//         'currency_id': currencyController.text.isEmpty
//             ? '1'
//             : currencyController.text,
//         'decimals': decimalsController.text.isEmpty
//             ? '2'
//             : decimalsController.text,
//         'qty_decimals': decimalsQtyController.text.isEmpty
//             ? '2'
//             : decimalsQtyController.text,
//         'language_id': languageController.text.isEmpty
//             ? '1'
//             : languageController.text,
//         'default_account_id': defaultAccountController.text.isEmpty
//             ? '1'
//             : defaultAccountController.text,
//         'sales_invoice_format_id': salesInvoiceFormatController.text.isEmpty
//             ? '1'
//             : salesInvoiceFormatController.text,
//         'pos_invoice_format_id': posInvoiceFormatController.text.isEmpty
//             ? '1'
//             : posInvoiceFormatController.text,
//         'category_init': prefixControllers['Category']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Category']!.text,
//         'item_init': prefixControllers['Item']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Item']!.text,
//         'supplier_init': prefixControllers['Supplier']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Supplier']!.text,
//         'purchase_init': prefixControllers['Purchase']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Purchase']!.text,
//         'purchase_return_init':
//             prefixControllers['Purchase Return']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Purchase Return']!.text,
//         'customer_init': prefixControllers['Customer']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Customer']!.text,
//         'sales_init': prefixControllers['Sales']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Sales']!.text,
//         'sales_return_init': prefixControllers['Sales Return']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Sales Return']!.text,
//         'expense_init': prefixControllers['Expense']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Expense']!.text,
//         'accounts_init': prefixControllers['Accounts']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Accounts']!.text,
//         'quotation_init': prefixControllers['Quotation']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Quotation']!.text,
//         'money_transfer_init': prefixControllers['Money Transfer']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Money Transfer']!.text,
//         'sales_payment_init': prefixControllers['Sales Payment']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Sales Payment']!.text,
//         'sales_return_payment_init':
//             prefixControllers['Sales Return Payment']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Sales Return Payment']!.text,
//         'purchase_payment_init':
//             prefixControllers['Purchase Payment']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Purchase Payment']!.text,
//         'purchase_return_payment_init':
//             prefixControllers['Purchase Return Payment']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Purchase Return Payment']!.text,
//         'expense_payment_init':
//             prefixControllers['Expense Payment']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Expense Payment']!.text,
//         'cust_advance_init':
//             prefixControllers['Customers Advance Payments']!.text.isEmpty
//             ? '0'
//             : prefixControllers['Customers Advance Payments']!.text,
//         'journal_init': '0',
//         'upi_id': '0',
//         'upi_code': '0',
//         'cid': '1',
//         'sms_status': '0',
//         'currency_placement': 'before',
//         'date_format': 'Y-m-d',
//         'time_format': 'H:i',
//         'default_sales_discount': '0',
//         'currencywsymbol_id': '0',
//         'regno_key': '0',
//         'fav_icon': '0',
//         'purchase_code': '0',
//         'change_return': '0',
//         'sales_invoice_footer_text': '0',
//         'round_off': '0',
//         'smtp_host': '0',
//         'smtp_port': '0',
//         'smtp_user': '0',
//         'smtp_pass': '0',
//         'smtp_status': '0',
//         'sms_url': '0',
//         'if_msg91': '0',
//         'msg91_apikey': '0',
//         'sms_senderid': '0',
//         'sms_dltid': '0',
//         'sms_msg': '0',
//         'if_model_no': '1',
//         'if_serialno': '1',
//         'if_cod': '0',
//         'if_pickupatestore': '0',
//         'if_fixeddelivery': '0',
//         'delivery_charge': '0',
//         'if_handlingcharge': '0',
//         'handling_charge': '0',
//         't_and_c_status': '0',
//         't_and_c_status_pos': '0',
//         'number_to_words': '0',
//         'if_customerapp': '1',
//         'if_deliveryapp': '1',
//         'if_onesignal': '1',
//         'onesignal_id': '0',
//         'onesignal_key': '0',
//         'if_otp': '0',
//         'current_subscription_id': '1',
//         'invoice_view': '0',
//         'previous_balancebit': '0',
//       };

//       final response = await dioClient.dio.put(
//         '$editStoreUrl/${storeId.value}',
//         data: payload,
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'Store updated successfully',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         Get.back();
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['message'] ?? 'Store update failed',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Unexpected error: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }

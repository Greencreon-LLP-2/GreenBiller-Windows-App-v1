import 'dart:convert';
import 'dart:developer';

import 'package:green_biller/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class EditStoreService {
  final String storeId;
  final String accesToken;

  final String address;
  final String phone;
  final String email;

  final String country;
  final String city;
  final String postcode;
  final String gstNo;
  final String panNo;
  final String userId;
  final String storeCode;
  final String slug;
  final String storeName;
  final String storeWebsite;
  final String mobile;
  final String storeLogo;

  final String vatNo;
  final String upiId;
  final String upiCode;
  final String bankDetails;
  final String cid;
  final String categoryInit;
  final String itemInit;
  final String supplierInit;
  final String purchaseInit;
  final String purchaseReturnInit;
  final String customerInit;
  final String salesInit;
  final String salesReturnInit;
  final String expenseInit;
  final String accountsInit;
  final String journalInit;
  final String custAdvanceInit;
  final String quotationInit;
  final String moneyTransferInit;
  final String salesPaymentInit;
  final String salesReturnPaymentInit;
  final String purchasePaymentInit;
  final String purchaseReturnPaymentInit;
  final String expensePaymentInit;
  final String smsStatus;
  final String languageId;
  final String currencyId;
  final String currencyPlacement;
  final String timezone;
  final String dateFormat;
  final String timeFormat;
  final String defaultSalesDiscount;
  final String currencywsymbolId;
  final String regnoKey;
  final String favIcon;
  final String purchaseCode;
  final String changeReturn;
  final String salesInvoiceFormatId;
  final String posInvoiceFormatId;
  final String salesInvoiceFooterText;
  final String roundOff;
  final String decimals;
  final String qtyDecimals;
  final String smtpHost;
  final String smtpPort;
  final String smtpUser;
  final String smtpPass;
  final String smtpStatus;
  final String smsUrl;
  final String ifMsg91;
  final String msg91Apikey;
  final String smsSenderid;
  final String smsDltid;
  final String smsMsg;
  final String ifModelNo;
  final String ifSerialno;
  final String ifCod;
  final String ifPickupatestore;
  final String ifFixeddelivery;
  final String deliveryCharge;
  final String ifHandlingcharge;
  final String handlingCharge;
  final String signature;
  final String showSignature;
  final String tAndCStatus;
  final String tAndCStatusPos;
  final String numberToWords;
  final String ifCustomerapp;
  final String ifDeliveryapp;
  final String ifOnesignal;
  final String onesignalId;
  final String onesignalKey;
  final String ifOtp;
  final String currentSubscriptionId;
  final String invoiceView;
  final String previousBalancebit;
  final String defaultAccountId;

  EditStoreService({
    required this.accesToken,
    required this.storeId,
    required this.address,
    required this.phone,
    required this.email,
    required this.country,
    required this.city,
    required this.postcode,
    required this.gstNo,
    required this.panNo,
    required this.userId,
    required this.storeCode,
    required this.slug,
    required this.storeName,
    required this.storeWebsite,
    required this.mobile,
    required this.storeLogo,
    required this.vatNo,
    required this.upiId,
    required this.upiCode,
    required this.bankDetails,
    required this.cid,
    required this.categoryInit,
    required this.itemInit,
    required this.supplierInit,
    required this.purchaseInit,
    required this.purchaseReturnInit,
    required this.customerInit,
    required this.salesInit,
    required this.salesReturnInit,
    required this.expenseInit,
    required this.accountsInit,
    required this.journalInit,
    required this.custAdvanceInit,
    required this.quotationInit,
    required this.moneyTransferInit,
    required this.salesPaymentInit,
    required this.salesReturnPaymentInit,
    required this.purchasePaymentInit,
    required this.purchaseReturnPaymentInit,
    required this.expensePaymentInit,
    required this.smsStatus,
    required this.languageId,
    required this.currencyId,
    required this.currencyPlacement,
    required this.timezone,
    required this.dateFormat,
    required this.timeFormat,
    required this.defaultSalesDiscount,
    required this.currencywsymbolId,
    required this.regnoKey,
    required this.favIcon,
    required this.purchaseCode,
    required this.changeReturn,
    required this.salesInvoiceFormatId,
    required this.posInvoiceFormatId,
    required this.salesInvoiceFooterText,
    required this.roundOff,
    required this.decimals,
    required this.qtyDecimals,
    required this.smtpHost,
    required this.smtpPort,
    required this.smtpUser,
    required this.smtpPass,
    required this.smtpStatus,
    required this.smsUrl,
    required this.ifMsg91,
    required this.msg91Apikey,
    required this.smsSenderid,
    required this.smsDltid,
    required this.smsMsg,
    required this.ifModelNo,
    required this.ifSerialno,
    required this.ifCod,
    required this.ifPickupatestore,
    required this.ifFixeddelivery,
    required this.deliveryCharge,
    required this.ifHandlingcharge,
    required this.handlingCharge,
    required this.signature,
    required this.showSignature,
    required this.tAndCStatus,
    required this.tAndCStatusPos,
    required this.numberToWords,
    required this.ifCustomerapp,
    required this.ifDeliveryapp,
    required this.ifOnesignal,
    required this.onesignalId,
    required this.onesignalKey,
    required this.ifOtp,
    required this.currentSubscriptionId,
    required this.invoiceView,
    required this.previousBalancebit,
    required this.defaultAccountId,
  });

  Future<String> editStoreService() async {
    final url = '$editStoreUrl/$storeId';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accesToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'store_code': storeCode,
          'slug': slug,
          'store_name': storeName,
          'store_website': storeWebsite,
          'email': email,
          'mobile': mobile,
          'phone': phone,
          'store_logo': storeLogo,
          'country': country,
          'city': city,
          'address': address,
          'postcode': postcode,
          'gst_no': gstNo,
          'vat_no': vatNo,
          'pan_no': panNo,
          'upi_id': upiId,
          'upi_code': upiCode,
          'bank_details': bankDetails,
          'cid': cid,
          'category_init': categoryInit,
          'item_init': itemInit,
          'supplier_init': supplierInit,
          'purchase_init': purchaseInit,
          'purchase_return_init': purchaseReturnInit,
          'customer_init': customerInit,
          'sales_init': salesInit,
          'sales_return_init': salesReturnInit,
          'expense_init': expenseInit,
          'accounts_init': accountsInit,
          'journal_init': journalInit,
          'cust_advance_init': custAdvanceInit,
          'quotation_init': quotationInit,
          'money_transfer_init': moneyTransferInit,
          'sales_payment_init': salesPaymentInit,
          'sales_return_payment_init': salesReturnPaymentInit,
          'purchase_payment_init': purchasePaymentInit,
          'purchase_return_payment_init': purchaseReturnPaymentInit,
          'expense_payment_init': expensePaymentInit,
          'sms_status': smsStatus,
          'language_id': languageId,
          'currency_id': currencyId,
          'currency_placement': currencyPlacement,
          'timezone': timezone,
          'date_format': dateFormat,
          'time_format': timeFormat,
          'default_sales_discount': defaultSalesDiscount,
          'currencywsymbol_id': currencywsymbolId,
          'regno_key': regnoKey,
          'fav_icon': favIcon,
          'purchase_code': purchaseCode,
          'change_return': changeReturn,
          'sales_invoice_format_id': salesInvoiceFormatId,
          'pos_invoice_format_id': posInvoiceFormatId,
          'sales_invoice_footer_text': salesInvoiceFooterText,
          'round_off': roundOff,
          'decimals': decimals,
          'qty_decimals': qtyDecimals,
          'smtp_host': smtpHost,
          'smtp_port': smtpPort,
          'smtp_user': smtpUser,
          'smtp_pass': smtpPass,
          'smtp_status': smtpStatus,
          'sms_url': smsUrl,
          'if_msg91': ifMsg91,
          'msg91_apikey': msg91Apikey,
          'sms_senderid': smsSenderid,
          'sms_dltid': smsDltid,
          'sms_msg': smsMsg,
          'if_model_no': ifModelNo,
          'if_serialno': ifSerialno,
          'if_cod': ifCod,
          'if_pickupatestore': ifPickupatestore,
          'if_fixeddelivery': ifFixeddelivery,
          'delivery_charge': deliveryCharge,
          'if_handlingcharge': ifHandlingcharge,
          'handling_charge': handlingCharge,
          'signature': signature,
          'show_signature': showSignature,
          't_and_c_status': tAndCStatus,
          't_and_c_status_pos': tAndCStatusPos,
          'number_to_words': numberToWords,
          'if_customerapp': ifCustomerapp,
          'if_deliveryapp': ifDeliveryapp,
          'if_onesignal': ifOnesignal,
          'onesignal_id': onesignalId,
          'onesignal_key': onesignalKey,
          'if_otp': ifOtp,
          'current_subscription_id': currentSubscriptionId,
          'invoice_view': invoiceView,
          'previous_balancebit': previousBalancebit,
          'default_account_id': defaultAccountId,
        }),
      );

      log('URL: $url');
      log('Response Body: ${response.body}');

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseBody['message'] ?? "Store Updated Successfully";
      } else {
        return responseBody['message'] ?? "Store Update Failed";
      }
    } catch (e) {
      log('Error in editStoreService: $e');
      throw Exception(e);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:green_biller/features/store/services/edit_store_service.dart';

class EditStoreController {
  final String storeId;
  final String accesToken;
  final String name;
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

  EditStoreController({
    required this.storeId,
    required this.accesToken,
    required this.name,
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

  Future<String> editStoreController(context) async {
    final editStoreService = EditStoreService(
      accesToken: accesToken,
      storeId: storeId,
      userId: userId,
      storeCode: storeCode,
      slug: slug,
      storeName: storeName,
      storeWebsite: storeWebsite,
      email: email,
      mobile: mobile,
      phone: phone,
      storeLogo: storeLogo,
      country: country,
      city: city,
      address: address,
      postcode: postcode,
      gstNo: gstNo,
      vatNo: vatNo,
      panNo: panNo,
      upiId: upiCode,
      upiCode: upiCode,
      bankDetails: bankDetails,
      cid: cid,
      categoryInit: categoryInit,
      itemInit: itemInit,
      supplierInit: supplierInit,
      purchaseInit: purchaseInit,
      purchaseReturnInit: purchaseReturnInit,
      customerInit: customerInit,
      salesInit: salesInit,
      salesReturnPaymentInit: salesReturnInit,
      expenseInit: expenseInit,
      accountsInit: accountsInit,
      journalInit: journalInit,
      custAdvanceInit: custAdvanceInit,
      quotationInit: quotationInit,
      moneyTransferInit: moneyTransferInit,
      salesPaymentInit: salesPaymentInit,
      salesReturnInit: salesReturnInit,
      purchasePaymentInit: purchasePaymentInit,
      purchaseReturnPaymentInit: purchaseReturnPaymentInit,
      expensePaymentInit: expensePaymentInit,
      smsStatus: smsStatus,
      languageId: languageId,
      currencyId: currencyId,
      currencyPlacement: currencyPlacement,
      timezone: timezone,
      dateFormat: dateFormat,
      timeFormat: timeFormat,
      defaultSalesDiscount: defaultSalesDiscount,
      currencywsymbolId: currencywsymbolId,
      regnoKey: regnoKey,
      favIcon: favIcon,
      purchaseCode: purchaseCode,
      changeReturn: changeReturn,
      salesInvoiceFormatId: salesInvoiceFormatId,
      posInvoiceFormatId: posInvoiceFormatId,
      roundOff: roundOff,
      decimals: decimals,
      qtyDecimals: qtyDecimals,
      smtpHost: smtpHost,
      smtpPort: smtpPort,
      smtpUser: smtpUser,
      smtpPass: smtpPass,
      smtpStatus: smtpStatus,
      smsUrl: smsUrl,
      ifMsg91: ifMsg91,
      msg91Apikey: msg91Apikey,
      smsSenderid: smsSenderid,
      smsDltid: smsDltid,
      smsMsg: smsMsg,
      ifModelNo: ifModelNo,
      ifSerialno: ifSerialno,
      ifCod: ifCod,
      ifPickupatestore: ifPickupatestore,
      ifFixeddelivery: ifFixeddelivery,
      deliveryCharge: deliveryCharge,
      ifHandlingcharge: ifHandlingcharge,
      handlingCharge: handlingCharge,
      signature: signature,
      showSignature: showSignature,
      tAndCStatus: tAndCStatus,
      tAndCStatusPos: tAndCStatusPos,
      numberToWords: numberToWords,
      ifCustomerapp: ifCustomerapp,
      ifOnesignal: ifOnesignal,
      onesignalId: onesignalId,
      onesignalKey: onesignalKey,
      ifOtp: ifOtp,
      currentSubscriptionId: currentSubscriptionId,
      invoiceView: invoiceView,
      previousBalancebit: previousBalancebit,
      defaultAccountId: defaultAccountId,
      salesInvoiceFooterText: salesInvoiceFooterText,
      ifDeliveryapp: ifDeliveryapp,
    );

    try {
      final response = await editStoreService.editStoreService();
      if (response == "Store Updated Successfully" ||
          response == "Store Details updated successfully") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Store Updated Successfully"),
          backgroundColor: Colors.green,
        ));
        return "Store Updated Successfully";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Store Updated Failed"),
          backgroundColor: Colors.red,
        ));
        return "Store Updated Failed";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Store Updated Failed"),
        backgroundColor: Colors.red,
      ));
      return e.toString();
    }
  }
}

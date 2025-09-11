class SingleStoreDetailedModel {
  final int? id;
  final int? userId;
  final String? storeCode;
  final String? slug;
  final String? storeName;
  final String? storeWebsite;
  final String? email;
  final String? mobile;
  final String? phone;
  final String? website;
  final String? storeLogo;
  final String? logo;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? postcode;
  final int? ifGst;
  final String? gstNo;
  final int? ifVat;
  final String? vatNo;
  final String? panNo;
  final String? upiId;
  final String? upiCode;
  final String? bankDetails;
  final String? cid;
  final String? categoryInit;
  final String? itemInit;
  final String? supplierInit;
  final String? purchaseInit;
  final String? purchaseReturnInit;
  final String? customerInit;
  final String? salesInit;
  final String? salesReturnInit;
  final String? expenseInit;
  final String? accountsInit;
  final String? journalInit;
  final String? custAdvanceInit;
  final String? quotationInit;
  final String? moneyTransferInit;
  final String? salesPaymentInit;
  final String? salesReturnPaymentInit;
  final String? purchasePaymentInit;
  final String? purchaseReturnPaymentInit;
  final String? expensePaymentInit;
  final int? smsStatus;
  final int? languageId;
  final int? currencyId;
  final String? currencyPlacement;
  final String? timezone;
  final String? dateFormat;
  final String? timeFormat;
  final String? defaultSalesDiscount;
  final int? currencyWithSymbolId;
  final String? regnoKey;
  final String? favIcon;
  final String? purchaseCode;
  final int? changeReturn;
  final int? salesInvoiceFormatId;
  final int? posInvoiceFormatId;
  final String? salesInvoiceFooterText;
  final int? ifSerialNo;
  final int? ifModelNo;
  final int? ifExpiry;
  final int? ifBatchNo;
  final int? roundOff;
  final int? decimals;
  final int? qtyDecimals;
  final String? smtpHost;
  final String? smtpPort;
  final String? smtpUser;
  final String? smtpPass;
  final int? smtpStatus;
  final int? ifOtp;
  final String? smsUrl;
  final int? ifMsg91;
  final String? msg91ApiKey;
  final String? smsSenderId;
  final String? smsDltId;
  final String? smsMsg;
  final int? ifCod;
  final int? ifPickupAtStore;
  final int? ifFixedDelivery;
  final String? deliveryCharge;
  final int? ifHandlingCharge;
  final String? handlingCharge;
  final String? signature;
  final int? showSignature;
  final int? tAndCStatus;
  final int? tAndCStatusPos;
  final int? numberToWords;
  final int? ifExecutiveApp;
  final int? ifCustomerApp;
  final int? ifDeliveryApp;
  final int? ifOneSignal;
  final String? oneSignalId;
  final String? oneSignalKey;
  final int? currentSubscriptionId;
  final String? invoiceView;
  final int? previousBalanceBit;
  final int? defaultAccountId;
  final String? status;
  final String? defaultPrinter;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  SingleStoreDetailedModel({
    this.id,
    this.userId,
    this.storeCode,
    this.slug,
    this.storeName,
    this.storeWebsite,
    this.email,
    this.mobile,
    this.phone,
    this.website,
    this.storeLogo,
    this.logo,
    this.country,
    this.state,
    this.city,
    this.address,
    this.postcode,
    this.ifGst,
    this.gstNo,
    this.ifVat,
    this.vatNo,
    this.panNo,
    this.upiId,
    this.upiCode,
    this.bankDetails,
    this.cid,
    this.categoryInit,
    this.itemInit,
    this.supplierInit,
    this.purchaseInit,
    this.purchaseReturnInit,
    this.customerInit,
    this.salesInit,
    this.salesReturnInit,
    this.expenseInit,
    this.accountsInit,
    this.journalInit,
    this.custAdvanceInit,
    this.quotationInit,
    this.moneyTransferInit,
    this.salesPaymentInit,
    this.salesReturnPaymentInit,
    this.purchasePaymentInit,
    this.purchaseReturnPaymentInit,
    this.expensePaymentInit,
    this.smsStatus,
    this.languageId,
    this.currencyId,
    this.currencyPlacement,
    this.timezone,
    this.dateFormat,
    this.timeFormat,
    this.defaultSalesDiscount,
    this.currencyWithSymbolId,
    this.regnoKey,
    this.favIcon,
    this.purchaseCode,
    this.changeReturn,
    this.salesInvoiceFormatId,
    this.posInvoiceFormatId,
    this.salesInvoiceFooterText,
    this.ifSerialNo,
    this.ifModelNo,
    this.ifExpiry,
    this.ifBatchNo,
    this.roundOff,
    this.decimals,
    this.qtyDecimals,
    this.smtpHost,
    this.smtpPort,
    this.smtpUser,
    this.smtpPass,
    this.smtpStatus,
    this.ifOtp,
    this.smsUrl,
    this.ifMsg91,
    this.msg91ApiKey,
    this.smsSenderId,
    this.smsDltId,
    this.smsMsg,
    this.ifCod,
    this.ifPickupAtStore,
    this.ifFixedDelivery,
    this.deliveryCharge,
    this.ifHandlingCharge,
    this.handlingCharge,
    this.signature,
    this.showSignature,
    this.tAndCStatus,
    this.tAndCStatusPos,
    this.numberToWords,
    this.ifExecutiveApp,
    this.ifCustomerApp,
    this.ifDeliveryApp,
    this.ifOneSignal,
    this.oneSignalId,
    this.oneSignalKey,
    this.currentSubscriptionId,
    this.invoiceView,
    this.previousBalanceBit,
    this.defaultAccountId,
    this.status,
    this.defaultPrinter,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleStoreDetailedModel.fromJson(Map<String, dynamic> json) {
    return SingleStoreDetailedModel(
      id: json['id'],
      userId: json['user_id'],
      storeCode: json['store_code'],
      slug: json['slug'],
      storeName: json['store_name'],
      storeWebsite: json['store_website'],
      email: json['email'],
      mobile: json['mobile'],
      phone: json['phone'],
      website: json['website'],
      storeLogo: json['store_logo'],
      logo: json['logo'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
      postcode: json['postcode'],
      ifGst: json['if_gst'],
      gstNo: json['gst_no'],
      ifVat: json['if_vat'],
      vatNo: json['vat_no'],
      panNo: json['pan_no'],
      upiId: json['upi_id'],
      upiCode: json['upi_code'],
      bankDetails: json['bank_details'],
      cid: json['cid'],
      categoryInit: json['category_init'],
      itemInit: json['item_init'],
      supplierInit: json['supplier_init'],
      purchaseInit: json['purchase_init'],
      purchaseReturnInit: json['purchase_return_init'],
      customerInit: json['customer_init'],
      salesInit: json['sales_init'],
      salesReturnInit: json['sales_return_init'],
      expenseInit: json['expense_init'],
      accountsInit: json['accounts_init'],
      journalInit: json['journal_init'],
      custAdvanceInit: json['cust_advance_init'],
      quotationInit: json['quotation_init'],
      moneyTransferInit: json['money_transfer_init'],
      salesPaymentInit: json['sales_payment_init'],
      salesReturnPaymentInit: json['sales_return_payment_init'],
      purchasePaymentInit: json['purchase_payment_init'],
      purchaseReturnPaymentInit: json['purchase_return_payment_init'],
      expensePaymentInit: json['expense_payment_init'],
      smsStatus: json['sms_status'],
      languageId: json['language_id'],
      currencyId: json['currency_id'],
      currencyPlacement: json['currency_placement'],
      timezone: json['timezone'],
      dateFormat: json['date_format'],
      timeFormat: json['time_format'],
      defaultSalesDiscount: json['default_sales_discount'],
      currencyWithSymbolId: json['currencywsymbol_id'],
      regnoKey: json['regno_key'],
      favIcon: json['fav_icon'],
      purchaseCode: json['purchase_code'],
      changeReturn: json['change_return'],
      salesInvoiceFormatId: json['sales_invoice_format_id'],
      posInvoiceFormatId: json['pos_invoice_format_id'],
      salesInvoiceFooterText: json['sales_invoice_footer_text'],
      ifSerialNo: json['if_serialno'],
      ifModelNo: json['if_modelno'],
      ifExpiry: json['if_expiry'],
      ifBatchNo: json['if_batchno'],
      roundOff: json['round_off'],
      decimals: json['decimals'],
      qtyDecimals: json['qty_decimals'],
      smtpHost: json['smtp_host'],
      smtpPort: json['smtp_port'],
      smtpUser: json['smtp_user'],
      smtpPass: json['smtp_pass'],
      smtpStatus: json['smtp_status'],
      ifOtp: json['if_otp'],
      smsUrl: json['sms_url'],
      ifMsg91: json['if_msg91'],
      msg91ApiKey: json['msg91_apikey'],
      smsSenderId: json['sms_senderid'],
      smsDltId: json['sms_dltid'],
      smsMsg: json['sms_msg'],
      ifCod: json['if_cod'],
      ifPickupAtStore: json['if_pickupatestore'],
      ifFixedDelivery: json['if_fixeddelivery'],
      deliveryCharge: json['delivery_charge'],
      ifHandlingCharge: json['if_handlingcharge'],
      handlingCharge: json['handling_charge'],
      signature: json['signature'],
      showSignature: json['show_signature'],
      tAndCStatus: json['t_and_c_status'],
      tAndCStatusPos: json['t_and_c_status_pos'],
      numberToWords: json['number_to_words'],
      ifExecutiveApp: json['if_exictiveapp'],
      ifCustomerApp: json['if_customerapp'],
      ifDeliveryApp: json['if_deliveryapp'],
      ifOneSignal: json['if_onesignal'],
      oneSignalId: json['onesignal_id'],
      oneSignalKey: json['onesignal_key'],
      currentSubscriptionId: json['current_subscription_id'],
      invoiceView: json['invoice_view'],
      previousBalanceBit: json['previous_balancebit'],
      defaultAccountId: json['default_account_id'],
      status: json['status'],
      defaultPrinter: json['default_printer'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_code': storeCode,
      'slug': slug,
      'store_name': storeName,
      'store_website': storeWebsite,
      'email': email,
      'mobile': mobile,
      'phone': phone,
      'website': website,
      'store_logo': storeLogo,
      'logo': logo,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'postcode': postcode,
      'if_gst': ifGst,
      'gst_no': gstNo,
      'if_vat': ifVat,
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
      'currencywsymbol_id': currencyWithSymbolId,
      'regno_key': regnoKey,
      'fav_icon': favIcon,
      'purchase_code': purchaseCode,
      'change_return': changeReturn,
      'sales_invoice_format_id': salesInvoiceFormatId,
      'pos_invoice_format_id': posInvoiceFormatId,
      'sales_invoice_footer_text': salesInvoiceFooterText,
      'if_serialno': ifSerialNo,
      'if_modelno': ifModelNo,
      'if_expiry': ifExpiry,
      'if_batchno': ifBatchNo,
      'round_off': roundOff,
      'decimals': decimals,
      'qty_decimals': qtyDecimals,
      'smtp_host': smtpHost,
      'smtp_port': smtpPort,
      'smtp_user': smtpUser,
      'smtp_pass': smtpPass,
      'smtp_status': smtpStatus,
      'if_otp': ifOtp,
      'sms_url': smsUrl,
      'if_msg91': ifMsg91,
      'msg91_apikey': msg91ApiKey,
      'sms_senderid': smsSenderId,
      'sms_dltid': smsDltId,
      'sms_msg': smsMsg,
      'if_cod': ifCod,
      'if_pickupatestore': ifPickupAtStore,
      'if_fixeddelivery': ifFixedDelivery,
      'delivery_charge': deliveryCharge,
      'if_handlingcharge': ifHandlingCharge,
      'handling_charge': handlingCharge,
      'signature': signature,
      'show_signature': showSignature,
      't_and_c_status': tAndCStatus,
      't_and_c_status_pos': tAndCStatusPos,
      'number_to_words': numberToWords,
      'if_exictiveapp': ifExecutiveApp,
      'if_customerapp': ifCustomerApp,
      'if_deliveryapp': ifDeliveryApp,
      'if_onesignal': ifOneSignal,
      'onesignal_id': oneSignalId,
      'onesignal_key': oneSignalKey,
      'current_subscription_id': currentSubscriptionId,
      'invoice_view': invoiceView,
      'previous_balancebit': previousBalanceBit,
      'default_account_id': defaultAccountId,
      'status': status,
      'default_printer': defaultPrinter,
      'created_by': createdBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

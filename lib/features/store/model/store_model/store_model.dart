class StoreModel {
  final String? message;
  final List<StoreData>? data;
  final int? totalstore;
  final int? status;

  StoreModel({
    this.message,
    this.data,
    this.totalstore,
    this.status,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      message: json['message'],
      data: (json['data'] as List?)?.map((e) => StoreData.fromJson(e)).toList(),
      totalstore: json['totalstore'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'totalstore': totalstore,
      'status': status,
    };
  }
}

class StoreData {
  final int? id;
  final int? userId;
  final String? storeCode;
  final String? slug;
  final String? storeName;
  final String? storeWebsite;
  final String? email;
  final String? mobile;
  final dynamic phone;
  final dynamic website;
  final String? storeLogo;
  final dynamic logo;
  final dynamic country;
  final dynamic state;
  final dynamic city;
  final String? address;
  final dynamic postcode;
  final dynamic ifGst;
  final dynamic gstNo;
  final dynamic ifVat;
  final dynamic vatNo;
  final dynamic panNo;
  final dynamic upiId;
  final dynamic upiCode;
  final dynamic bankDetails;
  final dynamic cid;
  final dynamic categoryInit;
  final dynamic itemInit;
  final dynamic supplierInit;
  final dynamic purchaseInit;
  final dynamic purchaseReturnInit;
  final dynamic customerInit;
  final dynamic salesInit;
  final dynamic salesReturnInit;
  final dynamic expenseInit;
  final dynamic accountsInit;
  final dynamic journalInit;
  final dynamic custAdvanceInit;
  final dynamic quotationInit;
  final dynamic moneyTransferInit;
  final dynamic salesPaymentInit;
  final dynamic salesReturnPaymentInit;
  final dynamic purchasePaymentInit;
  final dynamic purchaseReturnPaymentInit;
  final dynamic expensePaymentInit;
  final int? smsStatus;
  final dynamic languageId;
  final dynamic currencyId;
  final String? currencyPlacement;
  final dynamic timezone;
  final String? dateFormat;
  final String? timeFormat;
  final String? defaultSalesDiscount;
  final dynamic currencywsymbolId;
  final dynamic regnoKey;
  final dynamic favIcon;
  final dynamic purchaseCode;
  final int? changeReturn;
  final dynamic salesInvoiceFormatId;
  final dynamic posInvoiceFormatId;
  final dynamic salesInvoiceFooterText;
  final dynamic ifSerialno;
  final dynamic ifModelno;
  final dynamic ifExpiry;
  final dynamic ifBatchno;
  final int? roundOff;
  final int? decimals;
  final int? qtyDecimals;
  final dynamic smtpHost;
  final dynamic smtpPort;
  final dynamic smtpUser;
  final dynamic smtpPass;
  final int? smtpStatus;
  final int? ifOtp;
  final dynamic smsUrl;
  final int? ifMsg91;
  final dynamic msg91Apikey;
  final dynamic smsSenderid;
  final dynamic smsDltid;
  final dynamic smsMsg;
  final int? ifCod;
  final int? ifPickupatestore;
  final int? ifFixeddelivery;
  final String? deliveryCharge;
  final int? ifHandlingcharge;
  final String? handlingCharge;
  final dynamic signature;
  final int? showSignature;
  final int? tAndCStatus;
  final int? tAndCStatusPos;
  final int? numberToWords;
  final int? ifExictiveapp;
  final int? ifCustomerapp;
  final int? ifDeliveryapp;
  final int? ifOnesignal;
  final dynamic onesignalId;
  final dynamic onesignalKey;
  final dynamic currentSubscriptionId;
  final dynamic invoiceView;
  final int? previousBalancebit;
  final dynamic defaultAccountId;
  final String? status;
  final dynamic createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? categoryCount;
  final int? warehouseCount;

  StoreData({
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
    this.currencywsymbolId,
    this.regnoKey,
    this.favIcon,
    this.purchaseCode,
    this.changeReturn,
    this.salesInvoiceFormatId,
    this.posInvoiceFormatId,
    this.salesInvoiceFooterText,
    this.ifSerialno,
    this.ifModelno,
    this.ifExpiry,
    this.ifBatchno,
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
    this.msg91Apikey,
    this.smsSenderid,
    this.smsDltid,
    this.smsMsg,
    this.ifCod,
    this.ifPickupatestore,
    this.ifFixeddelivery,
    this.deliveryCharge,
    this.ifHandlingcharge,
    this.handlingCharge,
    this.signature,
    this.showSignature,
    this.tAndCStatus,
    this.tAndCStatusPos,
    this.numberToWords,
    this.ifExictiveapp,
    this.ifCustomerapp,
    this.ifDeliveryapp,
    this.ifOnesignal,
    this.onesignalId,
    this.onesignalKey,
    this.currentSubscriptionId,
    this.invoiceView,
    this.previousBalancebit,
    this.defaultAccountId,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.categoryCount,
    this.warehouseCount,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
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
      currencywsymbolId: json['currencywsymbol_id'],
      regnoKey: json['regno_key'],
      favIcon: json['fav_icon'],
      purchaseCode: json['purchase_code'],
      changeReturn: json['change_return'],
      salesInvoiceFormatId: json['sales_invoice_format_id'],
      posInvoiceFormatId: json['pos_invoice_format_id'],
      salesInvoiceFooterText: json['sales_invoice_footer_text'],
      ifSerialno: json['if_serialno'],
      ifModelno: json['if_modelno'],
      ifExpiry: json['if_expiry'],
      ifBatchno: json['if_batchno'],
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
      msg91Apikey: json['msg91_apikey'],
      smsSenderid: json['sms_senderid'],
      smsDltid: json['sms_dltid'],
      smsMsg: json['sms_msg'],
      ifCod: json['if_cod'],
      ifPickupatestore: json['if_pickupatestore'],
      ifFixeddelivery: json['if_fixeddelivery'],
      deliveryCharge: json['delivery_charge'],
      ifHandlingcharge: json['if_handlingcharge'],
      handlingCharge: json['handling_charge'],
      signature: json['signature'],
      showSignature: json['show_signature'],
      tAndCStatus: json['t_and_c_status'],
      tAndCStatusPos: json['t_and_c_status_pos'],
      numberToWords: json['number_to_words'],
      ifExictiveapp: json['if_exictiveapp'],
      ifCustomerapp: json['if_customerapp'],
      ifDeliveryapp: json['if_deliveryapp'],
      ifOnesignal: json['if_onesignal'],
      onesignalId: json['onesignal_id'],
      onesignalKey: json['onesignal_key'],
      currentSubscriptionId: json['current_subscription_id'],
      invoiceView: json['invoice_view'],
      previousBalancebit: json['previous_balancebit'],
      defaultAccountId: json['default_account_id'],
      status: json['status'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      categoryCount: json['category_count'],
      warehouseCount: json['warehouse_count'],
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
      'currencywsymbol_id': currencywsymbolId,
      'regno_key': regnoKey,
      'fav_icon': favIcon,
      'purchase_code': purchaseCode,
      'change_return': changeReturn,
      'sales_invoice_format_id': salesInvoiceFormatId,
      'pos_invoice_format_id': posInvoiceFormatId,
      'sales_invoice_footer_text': salesInvoiceFooterText,
      'if_serialno': ifSerialno,
      'if_modelno': ifModelno,
      'if_expiry': ifExpiry,
      'if_batchno': ifBatchno,
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
      'msg91_apikey': msg91Apikey,
      'sms_senderid': smsSenderid,
      'sms_dltid': smsDltid,
      'sms_msg': smsMsg,
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
      'if_exictiveapp': ifExictiveapp,
      'if_customerapp': ifCustomerapp,
      'if_deliveryapp': ifDeliveryapp,
      'if_onesignal': ifOnesignal,
      'onesignal_id': onesignalId,
      'onesignal_key': onesignalKey,
      'current_subscription_id': currentSubscriptionId,
      'invoice_view': invoiceView,
      'previous_balancebit': previousBalancebit,
      'default_account_id': defaultAccountId,
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category_count': categoryCount,
      'warehouse_count': warehouseCount,
    };
  }
}

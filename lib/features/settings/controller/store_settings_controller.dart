import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/store/model/single_store_model.dart';
import 'package:dio/dio.dart' as dio;

class StoreSettingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final DioClient dioClient = DioClient();
  final AuthController authController = Get.find<AuthController>();
  late TabController tabController;

  final RxBool isLoading = true.obs;
  final RxInt storeId = 0.obs;
  final RxString userId = ''.obs;
  SingleStoreDetailedModel? originalStore;

  // Boolean fields (int in model, 0 or 1)
  final RxBool showSignature = false.obs;
  final RxBool ifGst = false.obs;
  final RxBool ifVat = false.obs;
  final RxBool smsStatus = false.obs;
  final RxBool smtpStatus = false.obs;
  final RxBool ifMsg91 = false.obs;
  final RxBool ifOtp = false.obs;
  final RxBool ifCod = false.obs;
  final RxBool ifPickupAtStore = false.obs;
  final RxBool ifFixedDelivery = false.obs;
  final RxBool ifHandlingCharge = false.obs;
  final RxBool tAndCStatus = false.obs;
  final RxBool tAndCStatusPos = false.obs;
  final RxBool numberToWords = false.obs;
  final RxBool ifExecutiveApp = false.obs;
  final RxBool ifCustomerApp = false.obs;
  final RxBool ifDeliveryApp = false.obs;
  final RxBool ifOneSignal = false.obs;
  final RxBool ifModelNo = false.obs;
  final RxBool ifSerialNo = false.obs;
  final RxBool ifExpiry = false.obs;
  final RxBool ifBatchNo = false.obs;
  final RxBool previousBalanceBit = false.obs;

  // Text controllers for string and numeric fields
  final mobileController = TextEditingController();
  final gstController = TextEditingController();
  final panController = TextEditingController();
  final vatController = TextEditingController();
  final bankDetailsController = TextEditingController();
  final signatureController = TextEditingController();
  final decimalsController = TextEditingController();
  final decimalsQtyController = TextEditingController();
  final defaultAccountController = TextEditingController();
  final salesInvoiceFormatController = TextEditingController();
  final posInvoiceFormatController = TextEditingController();
  final slugController = TextEditingController();
  final upiIdController = TextEditingController();
  final upiCodeController = TextEditingController();
  final cidController = TextEditingController();
  final defaultSalesDiscountController = TextEditingController();
  final currencywsymbolIdController = TextEditingController();
  final regnoKeyController = TextEditingController();
  final favIconController = TextEditingController();
  final purchaseCodeController = TextEditingController();
  final changeReturnController = TextEditingController();
  final salesInvoiceFooterTextController = TextEditingController();
  final roundOffController = TextEditingController();
  final smtpHostController = TextEditingController();
  final smtpPortController = TextEditingController();
  final smtpUserController = TextEditingController();
  final smtpPassController = TextEditingController();
  final smsUrlController = TextEditingController();
  final msg91ApikeyController = TextEditingController();
  final smsSenderidController = TextEditingController();
  final smsDltidController = TextEditingController();
  final smsMsgController = TextEditingController();
  final deliveryChargeController = TextEditingController();
  final handlingChargeController = TextEditingController();
  final onesignalIdController = TextEditingController();
  final onesignalKeyController = TextEditingController();
  final currentSubscriptionIdController = TextEditingController();
  final statusController = TextEditingController();
  final createdByController = TextEditingController();
  final defaultPrinterController = TextEditingController();

  // Prefix controllers
  final Map<String, TextEditingController> prefixControllers = {
    'Category': TextEditingController(),
    'Item': TextEditingController(),
    'Supplier': TextEditingController(),
    'Purchase': TextEditingController(),
    'Purchase Return': TextEditingController(),
    'Customer': TextEditingController(),
    'Sales': TextEditingController(),
    'Sales Return': TextEditingController(),
    'Expense': TextEditingController(),
    'Accounts': TextEditingController(),
    'Quotation': TextEditingController(),
    'Money Transfer': TextEditingController(),
    'Sales Payment': TextEditingController(),
    'Sales Return Payment': TextEditingController(),
    'Purchase Payment': TextEditingController(),
    'Purchase Return Payment': TextEditingController(),
    'Expense Payment': TextEditingController(),
    'Customers Advance Payments': TextEditingController(),
  };

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    storeId.value = int.parse(Get.parameters['storeEditId'] ?? '0');
    userId.value = authController.user.value?.userId?.toString() ?? '0';
    fetchStoreData();
  }

  @override
  void onClose() {
    tabController.dispose();
    mobileController.dispose();
    gstController.dispose();
    panController.dispose();
    vatController.dispose();
    bankDetailsController.dispose();
    signatureController.dispose();
    decimalsController.dispose();
    decimalsQtyController.dispose();
    defaultAccountController.dispose();
    salesInvoiceFormatController.dispose();
    posInvoiceFormatController.dispose();
    slugController.dispose();
    upiIdController.dispose();
    upiCodeController.dispose();
    cidController.dispose();
    defaultSalesDiscountController.dispose();
    currencywsymbolIdController.dispose();
    regnoKeyController.dispose();
    favIconController.dispose();
    purchaseCodeController.dispose();
    changeReturnController.dispose();
    salesInvoiceFooterTextController.dispose();
    roundOffController.dispose();
    smtpHostController.dispose();
    smtpPortController.dispose();
    smtpUserController.dispose();
    smtpPassController.dispose();
    smsUrlController.dispose();
    msg91ApikeyController.dispose();
    smsSenderidController.dispose();
    smsDltidController.dispose();
    smsMsgController.dispose();
    deliveryChargeController.dispose();
    handlingChargeController.dispose();
    onesignalIdController.dispose();
    onesignalKeyController.dispose();
    currentSubscriptionIdController.dispose();
    statusController.dispose();
    createdByController.dispose();
    defaultPrinterController.dispose();
    prefixControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }

  Future<void> fetchStoreData() async {
    try {
      isLoading.value = true;
      final response = await dioClient.dio.get(
        '$viewStoreUrl/${storeId.value}',
        options: dio.Options(
          headers: {
            'Authorization':
                'Bearer ${authController.user.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 || response.data['data'] == null) {
        throw Exception('No data returned for store ${storeId.value}');
      }

      final store = originalStore = SingleStoreDetailedModel.fromJson(
        response.data,
      );

      // Set boolean fields
      showSignature.value = store.showSignature == 1;
      ifGst.value = store.ifGst == 1;
      ifVat.value = store.ifVat == 1;
      smsStatus.value = store.smsStatus == 1;
      smtpStatus.value = store.smtpStatus == 1;
      ifMsg91.value = store.ifMsg91 == 1;
      ifOtp.value = store.ifOtp == 1;
      ifCod.value = store.ifCod == 1;
      ifPickupAtStore.value = store.ifPickupAtStore == 1;
      ifFixedDelivery.value = store.ifFixedDelivery == 1;
      ifHandlingCharge.value = store.ifHandlingCharge == 1;
      tAndCStatus.value = store.tAndCStatus == 1;
      tAndCStatusPos.value = store.tAndCStatusPos == 1;
      numberToWords.value = store.numberToWords == 1;
      ifExecutiveApp.value = store.ifExecutiveApp == 1;
      ifCustomerApp.value = store.ifCustomerApp == 1;
      ifDeliveryApp.value = store.ifDeliveryApp == 1;
      ifOneSignal.value = store.ifOneSignal == 1;
      ifModelNo.value = store.ifModelNo == 1;
      ifSerialNo.value = store.ifSerialNo == 1;
      ifExpiry.value = store.ifExpiry == 1;
      ifBatchNo.value = store.ifBatchNo == 1;
      previousBalanceBit.value = store.previousBalanceBit == 1;

      // Set text controllers
      void set(
        TextEditingController controller,
        dynamic value, {
        String fallback = '0',
      }) {
        controller.text = (value?.toString().isNotEmpty ?? false)
            ? value.toString()
            : fallback;
      }

      set(mobileController, store.mobile);
      set(gstController, store.gstNo);
      set(panController, store.panNo);
      set(vatController, store.vatNo);
      set(bankDetailsController, store.bankDetails);
      set(signatureController, store.signature);
      set(decimalsController, store.decimals, fallback: '2');
      set(decimalsQtyController, store.qtyDecimals, fallback: '2');
      set(defaultAccountController, store.defaultAccountId, fallback: '1');
      set(
        salesInvoiceFormatController,
        store.salesInvoiceFormatId,
        fallback: '1',
      );
      set(posInvoiceFormatController, store.posInvoiceFormatId, fallback: '1');
      set(slugController, store.slug);
      set(upiIdController, store.upiId);
      set(upiCodeController, store.upiCode);
      set(cidController, store.cid, fallback: '1');
      set(defaultSalesDiscountController, store.defaultSalesDiscount);
      set(currencywsymbolIdController, store.currencyWithSymbolId);
      set(regnoKeyController, store.regnoKey);
      set(favIconController, store.favIcon);
      set(purchaseCodeController, store.purchaseCode);
      set(changeReturnController, store.changeReturn);
      set(salesInvoiceFooterTextController, store.salesInvoiceFooterText);
      set(roundOffController, store.roundOff);
      set(smtpHostController, store.smtpHost);
      set(smtpPortController, store.smtpPort);
      set(smtpUserController, store.smtpUser);
      set(smtpPassController, store.smtpPass);
      set(smsUrlController, store.smsUrl);
      set(msg91ApikeyController, store.msg91ApiKey);
      set(smsSenderidController, store.smsSenderId);
      set(smsDltidController, store.smsDltId);
      set(smsMsgController, store.smsMsg);
      set(deliveryChargeController, store.deliveryCharge);
      set(handlingChargeController, store.handlingCharge);
      set(onesignalIdController, store.oneSignalId);
      set(onesignalKeyController, store.oneSignalKey);
      set(
        currentSubscriptionIdController,
        store.currentSubscriptionId,
        fallback: '1',
      );
      set(statusController, store.status, fallback: 'active');
      set(createdByController, store.createdBy);
      set(defaultPrinterController, store.defaultPrinter);

      // Set prefix controllers
      final prefixFields = {
        'Category': store.categoryInit,
        'Item': store.itemInit,
        'Supplier': store.supplierInit,
        'Purchase': store.purchaseInit,
        'Purchase Return': store.purchaseReturnInit,
        'Customer': store.customerInit,
        'Sales': store.salesInit,
        'Sales Return': store.salesReturnInit,
        'Expense': store.expenseInit,
        'Accounts': store.accountsInit,
        'Quotation': store.quotationInit,
        'Money Transfer': store.moneyTransferInit,
        'Sales Payment': store.salesPaymentInit,
        'Sales Return Payment': store.salesReturnPaymentInit,
        'Purchase Payment': store.purchasePaymentInit,
        'Purchase Return Payment': store.purchaseReturnPaymentInit,
        'Expense Payment': store.expensePaymentInit,
        'Customers Advance Payments': store.custAdvanceInit,
      };
      prefixFields.forEach((key, value) => set(prefixControllers[key]!, value));
    } catch (e, stack) {
      print(e);
      print(stack);
      Get.snackbar(
        'Error',
        'Failed to load store data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    try {
      if (originalStore == null) {
        Get.snackbar(
          'Error',
          'No store data available to update',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final payload = {'user_id': userId.value};

      // Compare and add changed boolean fields
      if (showSignature.value != (originalStore!.showSignature == 1))
        payload['show_signature'] = showSignature.value ? '1' : '0';
      if (ifGst.value != (originalStore!.ifGst == 1))
        payload['if_gst'] = ifGst.value ? '1' : '0';
      if (ifVat.value != (originalStore!.ifVat == 1))
        payload['if_vat'] = ifVat.value ? '1' : '0';
      if (smsStatus.value != (originalStore!.smsStatus == 1))
        payload['sms_status'] = smsStatus.value ? '1' : '0';
      if (smtpStatus.value != (originalStore!.smtpStatus == 1))
        payload['smtp_status'] = smtpStatus.value ? '1' : '0';
      if (ifMsg91.value != (originalStore!.ifMsg91 == 1))
        payload['if_msg91'] = ifMsg91.value ? '1' : '0';
      if (ifOtp.value != (originalStore!.ifOtp == 1))
        payload['if_otp'] = ifOtp.value ? '1' : '0';
      if (ifCod.value != (originalStore!.ifCod == 1))
        payload['if_cod'] = ifCod.value ? '1' : '0';
      if (ifPickupAtStore.value != (originalStore!.ifPickupAtStore == 1))
        payload['if_pickupatestore'] = ifPickupAtStore.value ? '1' : '0';
      if (ifFixedDelivery.value != (originalStore!.ifFixedDelivery == 1))
        payload['if_fixeddelivery'] = ifFixedDelivery.value ? '1' : '0';
      if (ifHandlingCharge.value != (originalStore!.ifHandlingCharge == 1))
        payload['if_handlingcharge'] = ifHandlingCharge.value ? '1' : '0';
      if (tAndCStatus.value != (originalStore!.tAndCStatus == 1))
        payload['t_and_c_status'] = tAndCStatus.value ? '1' : '0';
      if (tAndCStatusPos.value != (originalStore!.tAndCStatusPos == 1))
        payload['t_and_c_status_pos'] = tAndCStatusPos.value ? '1' : '0';
      if (numberToWords.value != (originalStore!.numberToWords == 1))
        payload['number_to_words'] = numberToWords.value ? '1' : '0';
      if (ifExecutiveApp.value != (originalStore!.ifExecutiveApp == 1))
        payload['if_executiveapp'] = ifExecutiveApp.value ? '1' : '0';
      if (ifCustomerApp.value != (originalStore!.ifCustomerApp == 1))
        payload['if_customerapp'] = ifCustomerApp.value ? '1' : '0';
      if (ifDeliveryApp.value != (originalStore!.ifDeliveryApp == 1))
        payload['if_deliveryapp'] = ifDeliveryApp.value ? '1' : '0';
      if (ifOneSignal.value != (originalStore!.ifOneSignal == 1))
        payload['if_onesignal'] = ifOneSignal.value ? '1' : '0';
      if (ifModelNo.value != (originalStore!.ifModelNo == 1))
        payload['if_modelno'] = ifModelNo.value ? '1' : '0';
      if (ifSerialNo.value != (originalStore!.ifSerialNo == 1))
        payload['if_serialno'] = ifSerialNo.value ? '1' : '0';
      if (ifExpiry.value != (originalStore!.ifExpiry == 1))
        payload['if_expiry'] = ifExpiry.value ? '1' : '0';
      if (ifBatchNo.value != (originalStore!.ifBatchNo == 1))
        payload['if_batchno'] = ifBatchNo.value ? '1' : '0';
      if (previousBalanceBit.value != (originalStore!.previousBalanceBit == 1))
        payload['previous_balancebit'] = previousBalanceBit.value ? '1' : '0';

      // Compare and add changed text fields
      void addIfChanged(
        TextEditingController controller,
        String? original,
        String key, {
        String fallback = '0',
      }) {
        final value = controller.text.isEmpty ? fallback : controller.text;
        if (value != (original ?? fallback)) payload[key] = value;
      }

      addIfChanged(mobileController, originalStore!.mobile, 'mobile');
      addIfChanged(gstController, originalStore!.gstNo, 'gst_no');
      addIfChanged(panController, originalStore!.panNo, 'pan_no');
      addIfChanged(vatController, originalStore!.vatNo, 'vat_no');
      addIfChanged(
        bankDetailsController,
        originalStore!.bankDetails,
        'bank_details',
      );
      addIfChanged(signatureController, originalStore!.signature, 'signature');
      addIfChanged(
        decimalsController,
        originalStore!.decimals?.toString(),
        'decimals',
        fallback: '2',
      );
      addIfChanged(
        decimalsQtyController,
        originalStore!.qtyDecimals?.toString(),
        'qty_decimals',
        fallback: '2',
      );
      addIfChanged(
        defaultAccountController,
        originalStore!.defaultAccountId?.toString(),
        'default_account_id',
        fallback: '1',
      );
      addIfChanged(
        salesInvoiceFormatController,
        originalStore!.salesInvoiceFormatId?.toString(),
        'sales_invoice_format_id',
        fallback: '1',
      );
      addIfChanged(
        posInvoiceFormatController,
        originalStore!.posInvoiceFormatId?.toString(),
        'pos_invoice_format_id',
        fallback: '1',
      );
      addIfChanged(slugController, originalStore!.slug, 'slug');
      addIfChanged(upiIdController, originalStore!.upiId, 'upi_id');
      addIfChanged(upiCodeController, originalStore!.upiCode, 'upi_code');
      addIfChanged(cidController, originalStore!.cid, 'cid', fallback: '1');
      addIfChanged(
        defaultSalesDiscountController,
        originalStore!.defaultSalesDiscount,
        'default_sales_discount',
      );
      addIfChanged(
        currencywsymbolIdController,
        originalStore!.currencyWithSymbolId?.toString(),
        'currencywsymbol_id',
      );
      addIfChanged(regnoKeyController, originalStore!.regnoKey, 'regno_key');
      addIfChanged(favIconController, originalStore!.favIcon, 'fav_icon');
      addIfChanged(
        purchaseCodeController,
        originalStore!.purchaseCode,
        'purchase_code',
      );
      addIfChanged(
        changeReturnController,
        originalStore!.changeReturn?.toString(),
        'change_return',
      );
      addIfChanged(
        salesInvoiceFooterTextController,
        originalStore!.salesInvoiceFooterText,
        'sales_invoice_footer_text',
      );
      addIfChanged(
        roundOffController,
        originalStore!.roundOff?.toString(),
        'round_off',
      );
      addIfChanged(smtpHostController, originalStore!.smtpHost, 'smtp_host');
      addIfChanged(smtpPortController, originalStore!.smtpPort, 'smtp_port');
      addIfChanged(smtpUserController, originalStore!.smtpUser, 'smtp_user');
      addIfChanged(smtpPassController, originalStore!.smtpPass, 'smtp_pass');
      addIfChanged(smsUrlController, originalStore!.smsUrl, 'sms_url');
      addIfChanged(
        msg91ApikeyController,
        originalStore!.msg91ApiKey,
        'msg91_apikey',
      );
      addIfChanged(
        smsSenderidController,
        originalStore!.smsSenderId,
        'sms_senderid',
      );
      addIfChanged(smsDltidController, originalStore!.smsDltId, 'sms_dltid');
      addIfChanged(smsMsgController, originalStore!.smsMsg, 'sms_msg');
      addIfChanged(
        deliveryChargeController,
        originalStore!.deliveryCharge,
        'delivery_charge',
      );
      addIfChanged(
        handlingChargeController,
        originalStore!.handlingCharge,
        'handling_charge',
      );
      addIfChanged(
        onesignalIdController,
        originalStore!.oneSignalId,
        'onesignal_id',
      );
      addIfChanged(
        onesignalKeyController,
        originalStore!.oneSignalKey,
        'onesignal_key',
      );
      addIfChanged(
        currentSubscriptionIdController,
        originalStore!.currentSubscriptionId?.toString(),
        'current_subscription_id',
        fallback: '1',
      );
      addIfChanged(
        statusController,
        originalStore!.status,
        'status',
        fallback: 'active',
      );
      addIfChanged(createdByController, originalStore!.createdBy, 'created_by');
      addIfChanged(
        defaultPrinterController,
        originalStore!.defaultPrinter,
        'default_printer',
      );

      // Prefix fields
      prefixControllers.forEach((key, controller) {
        final original = {
          'Category': originalStore!.categoryInit,
          'Item': originalStore!.itemInit,
          'Supplier': originalStore!.supplierInit,
          'Purchase': originalStore!.purchaseInit,
          'Purchase Return': originalStore!.purchaseReturnInit,
          'Customer': originalStore!.customerInit,
          'Sales': originalStore!.salesInit,
          'Sales Return': originalStore!.salesReturnInit,
          'Expense': originalStore!.expenseInit,
          'Accounts': originalStore!.accountsInit,
          'Quotation': originalStore!.quotationInit,
          'Money Transfer': originalStore!.moneyTransferInit,
          'Sales Payment': originalStore!.salesPaymentInit,
          'Sales Return Payment': originalStore!.salesReturnPaymentInit,
          'Purchase Payment': originalStore!.purchasePaymentInit,
          'Purchase Return Payment': originalStore!.purchaseReturnPaymentInit,
          'Expense Payment': originalStore!.expensePaymentInit,
          'Customers Advance Payments': originalStore!.custAdvanceInit,
        }[key];
        addIfChanged(
          controller,
          original,
          key.toLowerCase().replaceAll(' ', '_') + '_init',
        );
      });

      payload['journal_init'] = '0'; // Static default

      if (payload.length <= 1) {
        Get.snackbar(
          'No Changes',
          'No fields were modified',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final response = await dioClient.dio.put(
        '$editStoreUrl/${storeId.value}',
        data: payload,
        options: dio.Options(
          headers: {
            'Authorization':
                'Bearer ${authController.user.value?.accessToken ?? ''}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Store updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Store update failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on dio.DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to update store: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

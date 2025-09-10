import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/purchase/model/purchase_view_model.dart';
import 'package:greenbiller/features/purchase/model/purchase_single_all_details_model.dart';
import 'package:greenbiller/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class PurchaseManageController extends GetxController {
  // Dependencies
  late DioClient dioClient;
  late AuthController authController;
  late Logger logger;
  final RxInt purchaseId = 0.obs;

  // Purchase Bills State
  final RxBool isLoadingPurchases = false.obs;
  final RxBool isLoadingPurchaseById = false.obs;
  final RxBool hasErrorPurchases = false.obs;
  final RxList<SinglePurchaseData> purchases = <SinglePurchaseData>[].obs;
  final RxDouble totalPurchaseAmount = 0.0.obs;
  final RxDouble totalPurchasePaid = 0.0.obs;
  final RxDouble totalPurchaseDiscount = 0.0.obs;
  final RxDouble pendingPurchaseAmount = 0.0.obs;

  // Purchase Returns State
  final RxBool isLoadingReturns = false.obs;
  final RxBool hasErrorReturns = false.obs;
  final RxList<SinglePurchaseData> purchaseReturns = <SinglePurchaseData>[].obs;
  final RxDouble totalReturnAmount = 0.0.obs;
  final RxDouble totalReturnPaid = 0.0.obs;
  final RxDouble totalReturnDiscount = 0.0.obs;
  final RxDouble pendingReturnAmount = 0.0.obs;

  // Specific Purchase Return Creation State
  final Rx<PurchaseSingleAllDetails?> currentPurchaseData =
      Rx<PurchaseSingleAllDetails?>(null);
  final RxList<PurchaseItem> itemsList = <PurchaseItem>[].obs;
  final RxDouble tempSubTotal = 0.0.obs;
  final RxMap<int, TextEditingController> returnQtyControllers =
      <int, TextEditingController>{}.obs;
  final returnDateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  final returnNoController = TextEditingController();
  final purchaseNoteController = TextEditingController();
  final otherChargesController = TextEditingController();
  final RxDouble otherCharges = 0.0.obs;
  final RxDouble paidAmount = 0.0.obs;
  final RxBool isLoadingStores = false.obs;
  final RxBool isLoadingWarehouses = false.obs;
  final RxBool isLoadingSuppliers = false.obs;
  final RxBool isLoadingSave = false.obs;
  final RxInt userId = 0.obs;

  PurchaseManageController({String? purchaseId}) {
    if (purchaseId != null) {
      this.purchaseId.value = int.parse(purchaseId);
    }
  }

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    authController = Get.find<AuthController>();
    logger = Logger();

    userId.value = authController.user.value?.userId ?? 0;
    fetchPurchases();
    fetchPurchaseReturns();

    // Initialize listeners for other charges
    otherChargesController.addListener(() {
      otherCharges.value = double.tryParse(otherChargesController.text) ?? 0.0;
      recalculateGrandTotal();
    });
    // Watch itemsList for return quantity controllers
    ever(itemsList, (_) => _initializeReturnQtyControllers());
  }

  void generateReturnNo() {
    final now = DateTime.now();
    final datePart = DateFormat('yyyyMMdd').format(now);
    final randomPart = (1000 + (now.millisecondsSinceEpoch % 9000)).toString();
    returnNoController.text = 'RET-$datePart-$randomPart';
  }

  @override
  void onClose() {
    otherChargesController.removeListener(() {});
    otherChargesController.dispose();
    returnDateController.dispose();
    returnNoController.dispose();
    purchaseNoteController.dispose();
    returnQtyControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }

  // --- Purchase Bills Methods ---
  Future<void> fetchPurchases() async {
    isLoadingPurchases.value = true;
    hasErrorPurchases.value = false;
    try {
      final response = await dioClient.dio.get(viewPurchaseUrl);

      if (response.statusCode == 200) {
        final purchaseViewModel = PurchaseViewModel.fromJson(response.data);
        purchases.value = purchaseViewModel.data ?? [];
        _calculatePurchaseTotals();
      } else {
        throw Exception('Failed to fetch purchases: ${response.data}');
      }
    } catch (e) {
      logger.e('Error fetching purchases: $e');
      hasErrorPurchases.value = true;
      Get.snackbar(
        'Error',
        'Failed to fetch purchases: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingPurchases.value = false;
    }
  }

  void _calculatePurchaseTotals() {
    totalPurchaseAmount.value = purchases.fold(
      0,
      (sum, item) => sum + (double.tryParse(item.grandTotal ?? '0') ?? 0),
    );
    totalPurchasePaid.value = purchases.fold(
      0,
      (sum, item) => sum + (double.tryParse(item.paidAmount ?? '0') ?? 0),
    );
    totalPurchaseDiscount.value = purchases.fold(
      0,
      (sum, item) =>
          sum + (double.tryParse(item.totDiscountToAllAmt ?? '0') ?? 0),
    );
    pendingPurchaseAmount.value =
        totalPurchaseAmount.value - totalPurchasePaid.value;
  }

  // --- Purchase Returns Methods ---
  Future<void> fetchPurchaseReturns() async {
    isLoadingReturns.value = true;
    hasErrorReturns.value = false;
    try {
      final response = await dioClient.dio.get(purchaseReturnViewUrl);

      if (response.statusCode == 200) {
        final purchaseViewModel = PurchaseViewModel.fromJson(response.data);
        purchaseReturns.value = purchaseViewModel.data ?? [];
        _calculateReturnTotals();
      } else {
        throw Exception('Failed to fetch purchase returns: ${response.data}');
      }
    } catch (e) {
      logger.e('Error fetching purchase returns: $e');
      hasErrorReturns.value = true;
      Get.snackbar(
        'Error',
        'Failed to fetch purchase returns: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingReturns.value = false;
    }
  }

  void _calculateReturnTotals() {
    totalReturnAmount.value = purchaseReturns.fold(
      0,
      (sum, item) => sum + (double.tryParse(item.grandTotal ?? '0') ?? 0),
    );
    totalReturnPaid.value = purchaseReturns.fold(
      0,
      (sum, item) => sum + (double.tryParse(item.paidAmount ?? '0') ?? 0),
    );
    totalReturnDiscount.value = purchaseReturns.fold(
      0,
      (sum, item) =>
          sum + (double.tryParse(item.totDiscountToAllAmt ?? '0') ?? 0),
    );
    pendingReturnAmount.value = totalReturnAmount.value - totalReturnPaid.value;
  }

  // --- Specific Purchase Return Creation Methods ---
  void _initializeReturnQtyControllers() {
    for (var i = 0; i < itemsList.length; i++) {
      if (!returnQtyControllers.containsKey(i)) {
        returnQtyControllers[i] = TextEditingController(text: '0');
      }
    }
  }

  Future<void> fetchPurchaseById() async {
    if (purchaseId.value == 0) return;
    isLoadingPurchaseById.value = true;
    try {
      final response = await dioClient.dio.get('$viewPurchaseUrl/$purchaseId');

      if (response.statusCode == 200) {
        currentPurchaseData.value = PurchaseSingleAllDetails.fromJson(
          response.data,
        );
        itemsList.value = currentPurchaseData.value?.items ?? [];
      } else {
        throw Exception('Failed to fetch purchase: ${response.data}');
      }
    } catch (e) {
      logger.e('Error fetching purchase: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch purchase: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingPurchaseById.value = false;
    }
  }

  double recalculateGrandTotal() {
    double sum = 0.0;
    for (int i = 0; i < itemsList.length; i++) {
      final item = itemsList[i];
      final returnQty =
          double.tryParse(returnQtyControllers[i]?.text ?? '0') ?? 0;
      final price = double.tryParse(item.pricePerUnit ?? '0') ?? 0;
      final amount = returnQty * price;
      sum += amount;
    }
    tempSubTotal.value = sum;
    return sum + otherCharges.value;
  }

  Future<void> handleSave() async {
    isLoadingSave.value = true;
    try {
      final returnItems = <Map<String, dynamic>>[];
      final purchase = currentPurchaseData.value!;
      double totalReturnAmount = 0.0;

      for (int i = 0; i < itemsList.length; i++) {
        final returnQty =
            double.tryParse(returnQtyControllers[i]?.text ?? '0') ?? 0;
        if (returnQty > 0) {
          final item = itemsList[i];
          final price = double.tryParse(item.pricePerUnit ?? '0') ?? 0;
          final itemAmount = returnQty * price;
          totalReturnAmount += itemAmount;
          returnItems.add({
            'store_id': purchase.storeId,
            'purchase_id': purchase.id,
            'item_id': item.itemId,
            'return_qty': returnQty.toString(),
            'price_per_unit': item.pricePerUnit,
            'tax_type': item.taxType,
            'tax_id': item.taxId,
            'tax_amt': item.taxAmt,
            'discount_type': item.discountType,
            'discount_input': item.discountInput,
            'discount_amt': item.discountAmt,
            'unit_total_cost': item.unitTotalCost,
            'total_cost': itemAmount.toString(),
            'profit_margin_per': item.profitMarginPer,
            'unit_sales_price': item.unitSalesPrice,
            'stock': item.stock,
            'if_batch': item.ifBatch,
            'batch_no': item.batchNo,
            'if_expirydate': item.ifExpiryDate,
            'expire_date': item.expireDate,
            'description': item.description,
            'status': 'active',
          });
        }
      }

      if (returnItems.isEmpty) {
        Get.snackbar(
          'Error',
          'Please add at least 1 return quantity to proceed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final grandTotal = totalReturnAmount + otherCharges.value;

      final returnData = {
        'store_id': purchase.storeId,
        'warehouse_id': purchase.warehouseId,
        'purchase_id': purchase.id,
        'return_code': 'RTN-${DateTime.now().millisecondsSinceEpoch}',
        'reference_no': returnNoController.text.isNotEmpty
            ? returnNoController.text
            : 'RTN-REF-${DateTime.now().millisecondsSinceEpoch}',
        'return_date': returnDateController.text,
        'supplier_id': purchase.supplierId,
        'subtotal': totalReturnAmount.toString(),
        'grand_total': grandTotal.toString(),
        'return_note': purchaseNoteController.text,
        'payment_status': grandTotal > 0 ? 'pending' : 'completed',
        'paid_amount': '0',
        'created_by': userId.value,
      };

      final returnResponse = await dioClient.dio.post(
        '$baseUrl/purchasereturn-create',
        data: returnData,
      );

      if (returnResponse.statusCode == 200 ||
          returnResponse.statusCode == 201) {
        final returnId =
            returnResponse.data['data']['id'] ?? returnResponse.data['id'];

        for (final item in returnItems) {
          final itemData = {...item, 'return_id': returnId};
          try {
            await dioClient.dio.post(
              '$baseUrl/purchaseitemreturn-create',
              data: itemData,
            );
          } catch (e) {
            logger.e('Error creating item return: $e');
          }
        }

        if (grandTotal > 0) {
          String paymentType = 'Cash';
          if (purchase.payments.isNotEmpty) {
            paymentType = purchase.payments.first.paymentType ?? 'Cash';
          }

          final paymentData = {
            'store_id': purchase.storeId,
            'purchase_id': purchase.id,
            'return_id': returnId,
            'payment_code': 'PAY-RTN-${DateTime.now().millisecondsSinceEpoch}',
            'payment_date': returnDateController.text,
            'payment_type': paymentType,
            'payment': grandTotal.toString(),
            'payment_note': 'Return payment for purchase #${purchase.id}',
            'status': 'completed',
            'supplier_id': purchase.supplierId,
            'created_by': userId.value,
            'account_id': 0,
          };

          try {
            await dioClient.dio.post(
              '$baseUrl/purchasepaymentreturn-create',
              data: paymentData,
            );
          } catch (e) {
            logger.e('Error creating payment return: $e');
          }
        }

        Get.snackbar(
          'Success',
          'Purchase return created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(
          const Duration(seconds: 1),
          () => Get.toNamed(AppRoutes.purchaseReturnView),
        );
      } else {
        throw Exception(
          'Failed to create purchase return: ${returnResponse.data}',
        );
      }
    } catch (e) {
      logger.e('Error creating purchase return: $e');
      Get.snackbar(
        'Error',
        'Error creating purchase return: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingSave.value = false;
    }
  }
}

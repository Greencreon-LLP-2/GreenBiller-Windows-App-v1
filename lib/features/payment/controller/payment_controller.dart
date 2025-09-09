import 'package:get/get.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';

import 'package:logger/logger.dart';

class PaymentController extends GetxController {
  late final DioClient dioClient;
  late final Logger logger;

  PaymentController();

  // State for both payment in and out
  var isLoadingIn = false.obs;
  var isLoadingOut = false.obs;
  var paymentsIn = <Map<String, dynamic>>[].obs;
  var paymentsOut = <Map<String, dynamic>>[].obs;
  var errorMessageIn = ''.obs;
  var errorMessageOut = ''.obs;

  // Payment type selection
  final selectedPaymentType = 'in'.obs; // 'in' or 'out'

  // Combined getters for convenience
  bool get isLoading => selectedPaymentType.value == 'in'
      ? isLoadingIn.value
      : isLoadingOut.value;
  List<Map<String, dynamic>> get payments =>
      selectedPaymentType.value == 'in' ? paymentsIn : paymentsOut;
  String get errorMessage => selectedPaymentType.value == 'in'
      ? errorMessageIn.value
      : errorMessageOut.value;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    logger = Logger();
  }

  // Switch between payment types
  void switchPaymentType(String type) {
    if (type == 'in' || type == 'out') {
      selectedPaymentType.value = type;
    }
  }

  // Fetch both payment types simultaneously
  Future<void> fetchAllPayments({String? storeId}) async {
    await Future.wait([
      fetchPaymentsIn(storeId: storeId),
      fetchPaymentsOut(storeId: storeId),
    ]);
  }

  // Fetch payment in (sales payments)
  Future<void> fetchPaymentsIn({String? storeId}) async {
    try {
      isLoadingIn.value = true;
      errorMessageIn.value = '';

      final response = await dioClient.dio.get(
        storeId != null && storeId.isNotEmpty
            ? "/salespayment-in?store_id=$storeId"
            : "/salespayment-in",
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        paymentsIn.assignAll(List<Map<String, dynamic>>.from(data));
      } else {
        errorMessageIn.value =
            "Failed to fetch payments in: ${response.statusMessage}";
      }
    } catch (e, stack) {
      logger.e("Error fetching payments in", e, stack);
      errorMessageIn.value = e.toString();
    } finally {
      isLoadingIn.value = false;
    }
  }

  // Fetch payment out (purchase payments)
  Future<void> fetchPaymentsOut({String? storeId}) async {
    try {
      isLoadingOut.value = true;
      errorMessageOut.value = '';

      final response = await dioClient.dio.get(
        storeId != null && storeId.isNotEmpty
            ? "/purchasepayment-out?store_id=$storeId"
            : "/purchasepayment-out",
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List? ?? [];
        paymentsOut.assignAll(List<Map<String, dynamic>>.from(data));
      } else {
        errorMessageOut.value =
            "Failed to fetch payments out: ${response.statusMessage}";
      }
    } catch (e, stack) {
      logger.e("Error fetching payments out", e, stack);
      errorMessageOut.value = e.toString();
    } finally {
      isLoadingOut.value = false;
    }
  }

  // Refresh current payment type
  Future<void> refreshCurrentPayments({String? storeId}) async {
    if (selectedPaymentType.value == 'in') {
      await fetchPaymentsIn(storeId: storeId);
    } else {
      await fetchPaymentsOut(storeId: storeId);
    }
  }

  // Get statistics
  double get totalPaymentsIn {
    return paymentsIn.fold(0.0, (sum, payment) {
      final amount = double.tryParse(payment['amount']?.toString() ?? '0') ?? 0;
      return sum + amount;
    });
  }

  double get totalPaymentsOut {
    return paymentsOut.fold(0.0, (sum, payment) {
      final amount = double.tryParse(payment['amount']?.toString() ?? '0') ?? 0;
      return sum + amount;
    });
  }

  double get netCashFlow {
    return totalPaymentsIn - totalPaymentsOut;
  }

  // Filter methods
  List<Map<String, dynamic>> filterPaymentsByDate(
    DateTime startDate,
    DateTime endDate, {
    String type = 'current',
  }) {
    final paymentsToFilter = type == 'in' ? paymentsIn : paymentsOut;

    return paymentsToFilter.where((payment) {
      final paymentDate = DateTime.tryParse(
        payment['created_at']?.toString() ?? '',
      );
      if (paymentDate == null) return false;

      return paymentDate.isAfter(startDate) && paymentDate.isBefore(endDate);
    }).toList();
  }

  // Search methods
  List<Map<String, dynamic>> searchPayments(
    String query, {
    String type = 'current',
  }) {
    final paymentsToSearch = type == 'in'
        ? paymentsIn
        : type == 'out'
        ? paymentsOut
        : payments;

    return paymentsToSearch.where((payment) {
      final customer = payment['customer_name']?.toString().toLowerCase() ?? '';
      final supplier = payment['supplier_name']?.toString().toLowerCase() ?? '';
      final amount = payment['amount']?.toString().toLowerCase() ?? '';
      final reference = payment['reference_no']?.toString().toLowerCase() ?? '';

      final searchQuery = query.toLowerCase();

      return customer.contains(searchQuery) ||
          supplier.contains(searchQuery) ||
          amount.contains(searchQuery) ||
          reference.contains(searchQuery);
    }).toList();
  }

  // Clear all data
  void clearAllData() {
    paymentsIn.clear();
    paymentsOut.clear();
    errorMessageIn.value = '';
    errorMessageOut.value = '';
  }

  @override
  void onClose() {
    clearAllData();
    super.onClose();
  }
}

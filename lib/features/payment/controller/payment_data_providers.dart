import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/payment/services/payment_in_out_service.dart';

// Access token should come from your auth provider
final accessTokenProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider);
  return user?.accessToken ?? '';
});

final paymentServiceProvider = Provider<PaymentInOutService>((ref) {
  final token = ref.watch(accessTokenProvider);
  return PaymentInOutService(token);
});

final paymentInProvider =
    FutureProvider.family<List<dynamic>, String?>((ref, storeId) async {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentIn(storeId: storeId);
});

final paymentOutProvider =
    FutureProvider.family<List<dynamic>, String?>((ref, storeId) async {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentOut(storeId: storeId);
});

import 'package:green_biller/features/sales/service/sales_payment_create_service.dart';
import 'package:green_biller/main.dart';

class SalesPaymentCreateController {
  //
  // Creates a sales payment.

  Future<bool> salesPaymentCreateController({
    required String accessToken,
  
    required String storeId,
    required String salesId,
    required String customerId,
    required String paymentMethod,
    required String paymentAmount,
    required String paymentDate,
    required String paymentNote,
    required String accountId,
  }) async {
    try {
      final response =
          await SalesPaymentCreateService().salesPaymentCreateService(
        accessToken: accessToken,
       
        storeId: storeId,
        salesId: salesId,
        customerId: customerId,
        paymentMethod: paymentMethod,
        paymentAmount: paymentAmount,
        paymentDate: paymentDate,
        paymentNote: paymentNote,
        accountId: accountId,
      );

      if (response != true) {
        logger.i("Failed to create sales payment: $response");
        return false; // Return false if the response is not successful
      } else {
        logger.i("Sales payment created successfully: $response");
        return true; // Return true if the operation is successful
      }
    } catch (e) {
      logger.e("Error in sales payment create service: $e");
      return false; // Return false if an error occurs
    }
  }
}

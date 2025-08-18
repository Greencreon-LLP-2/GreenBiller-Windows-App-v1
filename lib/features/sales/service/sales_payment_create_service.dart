import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/main.dart';
import 'package:http/http.dart' as http;

class SalesPaymentCreateService {
  //
  // Creates a sales payment.

  Future<bool> salesPaymentCreateService({
    required String accessToken,
    required String userId,
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
      final response = await http.post(
        Uri.parse(salesPaymentCreateUrl),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
        body: {
          "store_id": storeId,
          "sales_id": salesId,
          "payment_date": paymentDate,
          "payment_type": paymentMethod,
          "payment": paymentAmount,
          "payment_note": paymentNote,
          "account_id": accountId,
          "customer_id": customerId,
        },
      );

      if (response.statusCode != 201) {
        logger.i("Failed to create sales payment: ${response.body}");
        return false; // Return false if the response is not successful
      } else {
        logger.i("Sales payment created successfully: ${response.body}");
        return true; // Return true if the operation is successful
      }
    } catch (e) {
      logger.e("Error in sales payment create service: $e");
      return false; // Return false if an error occurs
    }
  }
}

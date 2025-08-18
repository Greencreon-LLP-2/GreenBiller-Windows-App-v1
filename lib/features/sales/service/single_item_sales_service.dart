import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/main.dart';
import 'package:http/http.dart' as http;

class SingleItemSaleService {
  Future<bool> singleItemSalesService({
    required String accessToken,
    required String userId,
    required String storeId,
    required String salesId,
    required String customerId,
    required String itemName,
    required String description,
    required String itemId,
    required String salesQty,
    required String pricePerUnit,
    required String taxName,
    required String taxId,
    required String taxAmount,
    required String discountType,
    required String discountAmount,
    required String totalCost,
  }) async {
    try {
      final response = await http.post(Uri.parse(salesItemCreateUrl), headers: {
        "Authorization": "Bearer $accessToken",
      }, body: {
        "store_id": storeId,
        "sales_id": salesId,
        "customer_id": customerId,
        "sales_status": "1",
        "item_id": itemId,
        "item_name": itemName,
        "description": description,
        "sales_qty": salesQty,
        "price_per_unit": pricePerUnit,
        "tax_type": taxName,
        "tax_id": taxId,
        "tax_amt": taxAmount,
        "discount_type": "1",
        "discount_input": discountType,
        "discount_amt": discountAmount,
        "unit_total_cost": "",
        "total_cost": totalCost,
        "status": "1",
        "seller_points": "",
        "purchase_price": "",
      });
      if (response.statusCode != 201) {
        logger.i("Failed to sales item: ${response.body}");

        return false; // Return false if the response is not successful
      } else {
        logger.i("Item sales successfully: ${response.body}");
        return true; // Return true if the operation is successful
      }
    } catch (e) {
      logger.e("Error in single item sales service: $e");
      return false; // Return false if an error occurs
    }
  }
}

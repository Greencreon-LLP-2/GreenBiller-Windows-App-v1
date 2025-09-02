import 'package:green_biller/core/constants/api_constants.dart';
import 'package:green_biller/main.dart';
import 'package:http/http.dart' as http;

class SingleItemPurchaseService {
  Future<bool> singleItemPurchaseService({
    required String accessToken,
    required String purchaseId,
    required String itemName,
    required String itemId,
    required String storeId,
    required String purchaseQty,
    required String pricePerUnit,
    required String taxName,
    required String taxId,
    required String taxAmount,
    required String discountType,
    required String discountAmount,
    required String totalCost,
    required String batchNo,
    required String barcode,
    required String unitSalesPrice,
    required String unit,
    required String warehouseId,
  }) async {
    try {
      final response =
          await http.post(Uri.parse(purchaseItemCreateUrl), headers: {
        "Authorization": "Bearer $accessToken",
      }, body: {
        "store_id": storeId,
        "purchase_id": purchaseId,
        "purchase_status": "1",
        "item_name": itemName,
        "item_id": itemId,
        "purchase_qty": purchaseQty,
        "price_per_unit": pricePerUnit,
        "tax_type": taxName,
        "tax_id": taxId,
        "tax_amt": taxAmount,
        "discount_type": "1",
        "discount_input": discountType,
        "discount_amt": discountAmount,
        "unit_total_cost": "",
        "total_cost": totalCost,
        "profit_margin_per": "",
        "unit_sales_price": unitSalesPrice,
        "stock": "1",
        "if_batch": '0',
        "batch_no": batchNo,
        "if_expirydate": "1",
        "expiry_date": "1",
        "warehouse_id": warehouseId,
        "description": "",
        "status": "1",
        "bar_code": barcode,
        "unit": unit,
      });
      if (response.statusCode != 201) {
        logger.i("Failed to purchase item: ${response.body}");
        return false; // Return false if the response is not successful
      } else {
        logger.i("Item purchased successfully: ${response.body}");
        return true; // Return true if the operation is successful
      }
    } catch (e) {
      logger.e("Error in single item purchase service: $e");
      return false; // Return false if an error occurs
    }
  }
}

import 'package:green_biller/features/item/services/brand/add_brand_service.dart';

Future<bool> addBrandController(
    String accessToken, String brandName, String storeId, String userId) async {
  final response =
      await addBrandService(accessToken, brandName, storeId, userId);
  if (response == "Brand added successfully") {
    return true;
  } else {
    return false;
  }
}

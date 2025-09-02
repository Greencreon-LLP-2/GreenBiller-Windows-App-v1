import 'package:green_biller/features/item/services/brand/view_brand_service.dart';

class ViewBrandController {
  final String accessToken;
  ViewBrandController({required this.accessToken});

  Future<List<Map<String?, String?>>> viewBrandController() async {
    try {
      final viewBrandService = ViewBrandService(accessToken: accessToken);
      final brandModel = await viewBrandService.viewBrand();
      final List<Map<String?, String?>> brandList = [];
      if (brandModel.data != null) {
        for (var brand in brandModel.data!) {
          brandList.add({
            brand.brandName: brand.storeId,
          });
        }
      }
      return brandList;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Map<String?, String?>>> viewBrandByIdController(
      int storeId) async {
    try {
      final viewBrandService = ViewBrandService(accessToken: accessToken);
      final brandModel = await viewBrandService.viewBrandById(storeId);
      final List<Map<String?, String?>> brandList = [];

      if (brandModel.data != null) {
        for (var brand in brandModel.data!) {
          if (brand.brandName != null && brand.id != null) {
            brandList.add({
              brand.brandName: brand.id.toString(),
            });
          }
        }
      }

      return brandList;
    } catch (e) {
      throw Exception(e);
    }
  }
}

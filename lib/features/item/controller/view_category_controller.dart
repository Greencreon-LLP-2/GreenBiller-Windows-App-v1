import 'package:green_biller/features/item/services/category/view_categories_service.dart';

class ViewWarehouseController {
  List<String> _warehouseList = [];

  List<String> get warehouseList => _warehouseList;

  Future<void> fetchWarehouseList(String accessToken, int storeId) async {
    final response =
        await viewCategoriesService(accessToken, storeId.toString());
    _warehouseList = response.categories?.map((e) => e.name!).toList() ?? [];
  }
}

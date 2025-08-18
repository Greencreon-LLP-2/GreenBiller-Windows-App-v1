import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/item/services/item/view_all_item_services.dart';

class ViewAllItemsController {
  final String accessToken;
  ViewAllItemsController({required this.accessToken});

  Future<ItemModel> getAllItems(
    String? storeId,
  ) async {
    try {
      final itemModelObject = await getAllItemService(
        accessToken: accessToken,
        storeId: storeId,
      );
      return itemModelObject;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}

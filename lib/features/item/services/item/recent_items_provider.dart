import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recentItemsProvider = FutureProvider<List<Item>>(
  (ref) async {
    final accessToken = ref.watch(userProvider)?.accessToken;
    if (accessToken == null) return [];

    final controller = ViewAllItemsController(accessToken: accessToken);
    final response = await controller.getAllItems(null);

    if (response.status == 1) {
      final sortedList = List<Item>.from(response.data);
      sortedList.sort((a, b) => b.id.compareTo(a.id));

      return sortedList.take(6).toList();
    }

    return [];
  },
);

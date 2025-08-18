// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/add_category_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreDropdown extends HookConsumerWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final ValueChanged<int?>? onStoreIdChanged;

  const StoreDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.onStoreIdChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeMap = useState<Map<String, int>>({});
    final isLoading = useState(false);
    final userModel = ref.watch(userProvider);
    final isMounted = useIsMounted();

    // Load stores when widget is built
    useEffect(() {
      Future<void> loadStores() async {
        if (userModel?.accessToken == null) return;

        isLoading.value = true;
        try {
          final storeList = await AddCategoryController()
              .getStoreList(userModel!.accessToken!);
          final newMap = <String, int>{};

          for (var store in storeList) {
            store.forEach((id, name) {
              newMap[name] = id;
            });
          }
          if (!isMounted()) return;
          storeMap.value = newMap;
        } catch (e) {
          debugPrint('Error loading stores: $e');
        } finally {
          if (!isMounted()) {}
          isLoading.value = false;
        }
      }

      loadStores();
      return null;
    }, [userModel?.accessToken]);

    // Helper function to get store name by ID
    String? getStoreNameById(String? storeId) {
      if (storeId == null || storeId == 'Select Store') return 'Select Store';
      for (var entry in storeMap.value.entries) {
        if (entry.value.toString() == storeId) {
          return entry.key;
        }
      }
      return 'Select Store';
    }

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textLightColor,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value == 'Select Store'
              ? 'Select Store'
              : storeMap.value.entries
                  .firstWhere((entry) => entry.value.toString() == value,
                      orElse: () => const MapEntry('Select Store', 0))
                  .value
                  .toString(),
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          icon: isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                )
              : const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(
            color: textPrimaryColor,
            fontSize: 14,
          ),
          items: [
            const DropdownMenuItem(
              value: 'Select Store',
              child: Text('Select Store'),
            ),
            ...storeMap.value.entries.map((entry) => DropdownMenuItem<String>(
                  value: entry.value.toString(), // Store ID as string
                  child: Text(entry.key), // Store name for display
                )),
          ],
          onChanged: (newValue) {
            onChanged(newValue); // This will now pass the store ID as string
            if (onStoreIdChanged != null) {
              onStoreIdChanged!(newValue != null && newValue != 'Select Store'
                  ? int.parse(newValue)
                  : null);
            }
          },
        ),
      ),
    );
  }
}

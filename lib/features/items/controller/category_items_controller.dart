import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';

import 'package:logger/logger.dart';

class CategoryItemsController extends GetxController {
  // Services
  late DioClient dioClient;
  late AuthController authController;
  late Logger logger;

  // Reactive
  RxList<Item> items = <Item>[].obs;
  RxList<Item> filteredItems = <Item>[].obs;
  RxBool isLoading = true.obs;
  RxString selectedFilter = 'All'.obs;

  // Controllers
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    authController = Get.find<AuthController>();
    logger = Logger();

    searchController = TextEditingController();
    searchController.addListener(_filterItems);
  }

  Future<void> loadItems(String categoryId) async {
    try {
      isLoading.value = true;
      final accessToken = authController.user.value?.accessToken ?? '';
      dioClient.setAuthToken(accessToken);
      final response = await dioClient.dio.get(
        '$baseUrl/category/$categoryId/items',
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> dataList = response.data['data'];
        items.value = dataList.map((e) => Item.fromJson(e)).toList();
        _filterItems();
      } else {
        items.clear();
        filteredItems.clear();
      }
    } catch (e, stackTrace) {
      logger.e('Error loading items: $e', stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load items: $e',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _filterItems() {
    final query = searchController.text.toLowerCase();
    filteredItems.value = items.where((item) {
      final name = item.itemName.toLowerCase();
      if (selectedFilter.value == 'All') return name.contains(query);
      if (selectedFilter.value == 'Active') {
        return name.contains(query) && item.status == '1';
      }
      if (selectedFilter.value == 'Inactive') {
        return name.contains(query) && item.status != '1';
      }
      if (selectedFilter.value == 'In Stock') {
        final stock =
            int.tryParse(item.quantity ?? item.openingStock ?? '0') ?? 0;
        return name.contains(query) && stock > 0;
      }

      if (selectedFilter.value == 'Out of Stock') {
        final stock =
            int.tryParse(item.quantity ?? item.openingStock ?? '0') ?? 0;
        return name.contains(query) && stock == 0;
      }

      return true;
    }).toList();
  }

  void showItemDetails(Item item) {
    Get.dialog(
      AlertDialog(
        title: Text(item.itemName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${item.sku}'),
            Text('Price: ₹${item.salesPrice}'),
            Text('Stock: ${item.quantity ?? item.openingStock ?? "0"}'),
            Text('Status: ${item.status == 1 ? "Active" : "Inactive"}'),
            if ((item.description ?? '').toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Description: ${item.description}'),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void handleItemAction(String action, Item item) {
    switch (action) {
      case 'view':
        showItemDetails(item);
        break;
      case 'edit':
        Get.back();
        // Navigate to edit item page
        break;
      case 'activate':
      case 'deactivate':
        // Toggle item status (implement if needed)
        break;
      case 'delete':
        showDeleteConfirmation(item);
        break;
    }
  }

  void showDeleteConfirmation(Item item) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.itemName}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              items.remove(item);
              filteredItems.remove(item);
              Get.back();
              Get.snackbar(
                'Success',
                'Item deleted locally',
                backgroundColor: Colors.green,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

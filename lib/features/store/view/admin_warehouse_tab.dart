import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/services/delete_warehouse_service.dart';
import 'package:green_biller/features/store/view/store_page/shared/single_warehouse_details.dart';
import 'package:green_biller/features/store/view/store_page/widgets/edit_warehouse_widget.dart';

class AdminWarehousesTab extends GetView<AdminWarehousesController> {
  const AdminWarehousesTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.user.value?.accessToken == null) {
      return const Scaffold(
        body: Center(child: Text('User not found. Please login again.')),
      );
    }

    return Obx(() => Stack(
          children: [
            if (controller.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Processing...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: textLightColor.withOpacity(0.3)),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search warehouses...',
                              hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.7)),
                              prefixIcon: const Icon(Icons.search, color: textSecondaryColor),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            onChanged: (value) => controller.searchQuery.value = value.toLowerCase(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.filter_list, color: accentColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'all',
                              child: Row(
                                children: [
                                  Icon(Icons.list_alt, size: 18),
                                  SizedBox(width: 8),
                                  Text('All Warehouses'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'active',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 18, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Active'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'inactive',
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Inactive'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) => controller.selectedFilter.value = value,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Get.find<ViewWarehouseController>().fetchWarehouses(),
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Loading warehouses...'),
                            ],
                          ),
                        )
                      : controller.warehouses.isEmpty
                          ? RefreshIndicator(
                              onRefresh: () async {
                                await Get.find<ViewWarehouseController>().fetchWarehouses();
                              },
                              child: ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 100),
                                  Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 64,
                                          color: textSecondaryColor.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No warehouses found',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: textSecondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Pull down to refresh',
                                          style: TextStyle(
                                            color: textSecondaryColor.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await Get.find<ViewWarehouseController>().fetchWarehouses();
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: controller.filteredWarehouses.length,
                                itemBuilder: (context, index) {
                                  final warehouse = controller.filteredWarehouses[index];
                                  final isActive = warehouse.status == 'active';
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          if (warehouse.storeId != null) {
                                            Get.to(() => WarehouseDetailScreen(
                                                  accessToken: controller.user.value?.accessToken ?? '',
                                                  storeId: warehouse.storeId!,
                                                ));
                                          } else {
                                            Get.snackbar(
                                              'Error',
                                              'Please connect with support, something wrong with this warehouse',
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 56,
                                                width: 56,
                                                decoration: BoxDecoration(
                                                  color: accentColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: const Icon(
                                                  Icons.warehouse,
                                                  color: accentColor,
                                                  size: 28,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      warehouse.warehouseName ?? 'Unnamed Warehouse',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w600,
                                                        color: textPrimaryColor,
                                                        letterSpacing: -0.5,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    if (warehouse.address != null && warehouse.address!.isNotEmpty)
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.location_on_outlined,
                                                            size: 16,
                                                            color: textSecondaryColor,
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Expanded(
                                                            child: Text(
                                                              warehouse.address!,
                                                              style: const TextStyle(
                                                                color: textSecondaryColor,
                                                                fontSize: 14,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.category_outlined,
                                                          size: 16,
                                                          color: textSecondaryColor,
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.blue.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            warehouse.warehouseType ?? 'Unknown type',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.blue.shade700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text("Items Count :"),
                                                        const SizedBox(width: 6),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.blue.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            warehouse.itemsCount.toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.blue.shade700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: 6,
                                                          width: 6,
                                                          decoration: BoxDecoration(
                                                            color: isActive ? Colors.green : Colors.red,
                                                            borderRadius: BorderRadius.circular(3),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          isActive ? 'Active' : 'Inactive',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w600,
                                                            color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.blue.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: IconButton(
                                                          tooltip: 'Edit',
                                                          icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.blue),
                                                          onPressed: () {
                                                            Get.dialog(
                                                              EditWarehouseWidget(
                                                                accessToken: controller.user.value?.accessToken ?? '',
                                                                warehouseId: warehouse.id.toString(),
                                                                currentName: warehouse.warehouseName ?? '',
                                                                warehouseEmail: warehouse.email,
                                                                warehousephone: warehouse.mobile,
                                                                currentLocation: warehouse.address ?? '',
                                                                warehouseType: warehouse.warehouseType ?? "",
                                                                ref: null, // Not needed with GetX
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: IconButton(
                                                          tooltip: 'View Details',
                                                          icon: const Icon(Icons.visibility_outlined, size: 20, color: Colors.grey),
                                                          onPressed: () {
                                                            Get.to(() => WarehouseDetailScreen(
                                                                  accessToken: controller.user.value?.accessToken ?? '',
                                                                  storeId: warehouse.storeId!,
                                                                ));
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.red.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(50),
                                                        ),
                                                        child: IconButton(
                                                          tooltip: 'Delete',
                                                          icon: vansh
                                                              size: 20,
                                                              color: Colors.red),
                                                          onPressed: () => controller.deleteWarehouse(context, warehouse),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ],
        ));
  }
}

class AdminWarehousesController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'all'.obs;
  final isLoading = false.obs;
  final user = Rxn<UserModel>();
  final warehouses = <dynamic>[].obs;
  final filteredWarehouses = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    user.value = Get.find<UserController>().user.value;
    fetchWarehouses();
    ever(searchQuery, (_) => _filterWarehouses());
    ever(selectedFilter, (_) => _filterWarehouses());
  }

  void fetchWarehouses() async {
    isLoading.value = true;
    try {
      final warehouseController = Get.find<ViewWarehouseController>();
      final warehouseModel = await warehouseController.fetchWarehouses();
      warehouses.assignAll(warehouseModel?.data ?? []);
      _filterWarehouses();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load warehouses: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _filterWarehouses() {
    final query = searchQuery.value;
    final filter = selectedFilter.value;
    filteredWarehouses.assignAll(warehouses.where((warehouse) {
      if (query.isNotEmpty) {
        final searchableText = [
          warehouse.warehouseName,
          warehouse.address,
          warehouse.warehouseType,
        ].join(' ').toLowerCase();
        if (!searchableText.contains(query)) return false;
      }
      if (filter != 'all') {
        final isActive = warehouse.status == 'active';
        if (filter == 'active' && !isActive) return false;
        if (filter == 'inactive' && isActive) return false;
      }
      return true;
    }).toList());
  }

  void deleteWarehouse(BuildContext context, dynamic warehouse) async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Warehouse'),
        content: Text('Are you sure you want to delete "${warehouse.warehouseName}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      isLoading.value = true;
      try {
        final response = await deleteWareHouseSerivce(user.value?.accessToken ?? '', warehouse.id.toString());
        if (response == 200) {
          fetchWarehouses();
          Get.snackbar(
            'Success',
            'Warehouse deleted successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 10,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to delete warehouse',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 10,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
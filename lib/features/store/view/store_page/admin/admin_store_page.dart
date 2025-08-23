import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/model/user_role_model.dart';
import 'package:green_biller/features/store/view/store_page/admin/admin_stores_tab.dart';
import 'package:green_biller/features/store/view/store_page/admin/admin_warehouses_tab.dart';
import 'package:green_biller/features/store/view/store_page/shared/add_store_dialog.dart';
import 'package:green_biller/features/store/view/store_page/shared/add_warehouse_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminStorePage extends HookConsumerWidget {
  const AdminStorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final user = ref.watch(userProvider);
    final currentTabIndex = useState(0);
    final warehouseNameController = useTextEditingController();
    final warehouseTypeController = useTextEditingController();
    final warehouseAddressController = useTextEditingController();
    final warehouseEmailController = useTextEditingController();
    final warehousePhoneController = useTextEditingController();

    final accessToken = user?.accessToken;
    final userId = user?.user?.id.toString();
    // Removed unused storeAsync variable
    // final storeAsync = ref.read(storesProvider);

    // Listen to tab changes
    useEffect(() {
      void listener() {
        currentTabIndex.value = tabController.index;
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    // Additional protection in case this page is accessed directly
    if (user == null || user.user?.userLevel == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to access this page')),
      );
    }

    final role = UserRoleModel.fromLevel(user.user?.userLevel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Store Management (${role.name})'),
        backgroundColor: cardColor,
        foregroundColor: textPrimaryColor,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Stores'),
            Tab(text: 'Warehouses'),
          ],
          labelColor: accentColor,
          unselectedLabelColor: textSecondaryColor,
          indicatorColor: accentColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Super admin specific actions
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          AdminStoresTab(),
          AdminWarehousesTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(
        currentTabIndex.value,
        role,
        context,
        accessToken,
        warehouseNameController,
        warehouseAddressController,
        warehouseTypeController,
        warehouseEmailController,
        warehousePhoneController,
        ref,
        userId,
      ),
    );
  }

  Widget? _buildFloatingActionButton(
    int currentTabIndex,
    UserRoleModel role,
    BuildContext context,
    String? accessToken,
    TextEditingController warehouseNameController,
    TextEditingController warehouseAddressController,
    TextEditingController warehouseTypeController,
    TextEditingController warehouseEmailController,
    TextEditingController warehousePhoneController,
    WidgetRef ref,
    String? userId,
  ) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (currentTabIndex == 0) {
          showDialog(
            context: context,
            builder: (context) => AddStoreDialog(
              callback: () {
                ref.refresh(storesProvider);
              },
            ),
          );
        } else {
          _showAddWarehouseDialog(
            context,
            accessToken,
            userId,
            () {
              ref.refresh(warehouseListProvider);
            },
            ref,
          );
        }
      },
      backgroundColor: accentColor,
      heroTag: currentTabIndex == 0 ? 'Add Store' : 'Add Warehouse',
      icon: Icon(
        currentTabIndex == 0 ? Icons.store : Icons.warehouse,
        color: Colors.white,
      ),
      label: Text(
        currentTabIndex == 0 ? 'Add Store' : 'Add Warehouse',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _showAddWarehouseDialog(
    BuildContext context,
    String? accessToken,
    String? userId,
    VoidCallback? callback,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddWarehouseDialog(
        userId: userId,
        accessToken: accessToken,
        onSuccess: callback,
        parentContext: context, // Pass the parent context
      ),
    );
  }
}
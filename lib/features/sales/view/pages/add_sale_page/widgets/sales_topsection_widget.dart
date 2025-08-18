import 'package:flutter/material.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/add_customer_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesPageTopSectionwidget extends HookConsumerWidget {
  final ValueNotifier<List<Item>> itemsList;
  final ValueNotifier<Map<String, String>> supplierMap;
  final ValueNotifier<Map<String, String>> warehouseMap;
  final ValueNotifier<Map<String, String>> storeMap;
  final ValueNotifier<String?> selectedWarehouse;
  final ValueNotifier<String?> selectedCustomer;
  final ValueNotifier<String?> selectedStore;
  final ValueNotifier<String?> billNo;
  final VoidCallback onCustomerAddSucess;
  final String accessToken;

  SalesPageTopSectionwidget({
    super.key,
    required this.itemsList,
    required this.supplierMap,
    required this.warehouseMap,
    required this.storeMap,
    required this.billNo,
    required this.onCustomerAddSucess,
    required this.selectedWarehouse,
    required this.selectedCustomer,
    required this.selectedStore,
    required this.accessToken,
  });

  final isLoadingWarehouses = ValueNotifier<bool>(false);
  final isLoadingCustomers = ValueNotifier<bool>(false);

  Future<void> _showEditModal(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        child: _EditSettingsModal(
          storeMap: storeMap,
          warehouseMap: warehouseMap,
          supplierMap: supplierMap,
          selectedStore: selectedStore,
          selectedWarehouse: selectedWarehouse,
          selectedCustomer: selectedCustomer,
          billNo: billNo,
          accessToken: accessToken,
          onCustomerAddSuccess: () {
            onCustomerAddSucess();
            _fetchCustomers(storeMap.value[selectedStore.value]!, context)
                .then((customers) {
              supplierMap.value = customers;
            });
          },
        ),
      ),
    );

    if (result == true) {
      await _saveCurrentState();
      await _fetchAndUpdateData(context);
    }
  }

  Future<void> _fetchAndUpdateData(BuildContext context) async {
    if (selectedStore.value == null) return;

    final storeId = storeMap.value[selectedStore.value] ?? '';
    if (storeId.isEmpty) return;

    isLoadingWarehouses.value = true;
    warehouseMap.value = await _fetchWarehouses(storeId, context);
    isLoadingWarehouses.value = false;

    isLoadingCustomers.value = true;
    supplierMap.value = await _fetchCustomers(storeId, context);
    isLoadingCustomers.value = false;

    itemsList.value = await fetchItems(storeId, context);
  }

  Future<Map<String, String>> fetchStores(BuildContext context) async {
    try {
      final map =
          await ViewStoreController(accessToken: accessToken, storeId: 0)
              .getStoreList();
      storeMap.value = map;
      return map;
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      return {};
    }
  }

  Future<Map<String, String>> _fetchWarehouses(
      String storeId, BuildContext context) async {
    try {
      return await ViewWarehouseController(accessToken: accessToken)
          .warehouseListByIdController(storeId);
    } catch (e) {
      debugPrint('Error fetching warehouses: $e');
      return {};
    }
  }

  Future<Map<String, String>> _fetchCustomers(
      String storeId, BuildContext context) async {
    try {
      return await ViewPartiesController().customerList(accessToken, storeId);
    } catch (e) {
      debugPrint('Error fetching customers: $e');
      return {};
    }
  }

  Future<List<Item>> fetchItems(String storeId, BuildContext context) async {
    try {
      final items = await ViewAllItemsController(accessToken: accessToken)
          .getAllItems(storeId);
      return items.data ?? [];
    } catch (e) {
      debugPrint('Error fetching items: $e');
      return [];
    }
  }

  Future<void> _saveCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('storeId', storeMap.value[selectedStore.value] ?? '');
    await prefs.setString(
      'customerId',
      selectedCustomer.value == "Walk-in Customer"
          ? "Walk-in Customer"
          : supplierMap.value[selectedCustomer.value] ?? '',
    );
    await prefs.setString(
      'warehouseId',
      warehouseMap.value[selectedWarehouse.value] ?? '',
    );
    await prefs.setString('billNo', billNo.value ?? '');
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStoreId = prefs.getString('storeId');
    final savedCustomerId = prefs.getString('customerId');
    final savedWarehouseId = prefs.getString('warehouseId');
    billNo.value = prefs.getString('billNo');

    // Restore store selection
    if (savedStoreId != null && storeMap.value.containsValue(savedStoreId)) {
      selectedStore.value = storeMap.value.entries
          .firstWhere((entry) => entry.value == savedStoreId)
          .key;
    }

    // Restore warehouse selection - must happen AFTER store is loaded
    if (savedWarehouseId != null &&
        warehouseMap.value.containsValue(savedWarehouseId)) {
      selectedWarehouse.value = warehouseMap.value.entries
          .firstWhere((entry) => entry.value == savedWarehouseId)
          .key;
    }

    // Restore customer selection - must happen AFTER store is loaded
    if (savedCustomerId != null) {
      if (savedCustomerId == "Walk-in Customer") {
        selectedCustomer.value = "Walk-in Customer";
      } else if (supplierMap.value.containsValue(savedCustomerId)) {
        selectedCustomer.value = supplierMap.value.entries
            .firstWhere((entry) => entry.value == savedCustomerId)
            .key;
      }
    }
  }

  Future<void> _resetToDefaults(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Only remove the session-specific keys, not the whole storage
    await prefs.remove('storeId');
    await prefs.remove('customerId');
    await prefs.remove('warehouseId');
    await prefs.remove('billNo');

    // Reset in-memory values
    if (storeMap.value.isNotEmpty) {
      selectedStore.value = storeMap.value.keys.first;
    }
    selectedCustomer.value = "Walk-in Customer";
    selectedWarehouse.value = null;
    billNo.value = null;

    // Save defaults back
    await _saveCurrentState();

    // Refresh UI/data
    await _fetchAndUpdateData(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (storeMap.value.isEmpty) {
        await fetchStores(context);
        await _loadSavedState();

        // If no store selected but stores exist, select first one
        if (selectedStore.value == null && storeMap.value.isNotEmpty) {
          selectedStore.value = storeMap.value.keys.first;
          await _saveCurrentState(); // Save the initial selection
        }

        // Fetch related data if store is selected
        if (selectedStore.value != null) {
          await _fetchAndUpdateData(context);
          // Reload saved state again to ensure warehouse/customer selections are applied
          await _loadSavedState();
        }
      } else {
        fetchItems(selectedStore.value!, context);
      }
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context),
          const SizedBox(height: 20),
          _buildInfoDisplay(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.receipt_long, color: Colors.green.shade700),
            const SizedBox(width: 8),
            Text("Sale Information",
                style: TextStyle(color: Colors.green.shade700)),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () => _showEditModal(context),
            ),
            IconButton(
              icon: const Icon(Icons.restore, color: Colors.green),
              onPressed: () => _resetToDefaults(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoDisplay(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildInfoTile(
              "Store", selectedStore.value ?? "Not selected", Icons.store),
          const SizedBox(width: 8),
          _buildInfoTile("Warehouse", selectedWarehouse.value ?? "Not selected",
              Icons.warehouse),
          const SizedBox(width: 8),
          _buildInfoTile("Customer",
              selectedCustomer.value ?? "Walk-in Customer", Icons.person),
          const SizedBox(width: 8),
          _buildInfoTile(
              "Bill Number Prefix", billNo.value ?? "Not set", Icons.receipt),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      width: 180, // Fixed width for each tile
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.green.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _EditSettingsModal extends StatefulWidget {
  final ValueNotifier<Map<String, String>> storeMap;
  final ValueNotifier<Map<String, String>> warehouseMap;
  final ValueNotifier<Map<String, String>> supplierMap;
  final ValueNotifier<String?> selectedStore;
  final ValueNotifier<String?> selectedWarehouse;
  final ValueNotifier<String?> selectedCustomer;
  final ValueNotifier<String?> billNo;
  final String accessToken;
  final VoidCallback onCustomerAddSuccess;

  const _EditSettingsModal({
    required this.storeMap,
    required this.warehouseMap,
    required this.supplierMap,
    required this.selectedStore,
    required this.selectedWarehouse,
    required this.selectedCustomer,
    required this.billNo,
    required this.accessToken,
    required this.onCustomerAddSuccess,
  });

  @override
  State<_EditSettingsModal> createState() => _EditSettingsModalState();
}

class _EditSettingsModalState extends State<_EditSettingsModal> {
  late String? _tempStore;
  late String? _tempWarehouse;
  late String? _tempCustomer;
  late String _tempBillNo;
  bool _loadingWarehouses = false;
  bool _loadingCustomers = false;

  @override
  void initState() {
    super.initState();
    _tempStore = widget.selectedStore.value;
    _tempWarehouse = widget.selectedWarehouse.value;
    _tempCustomer = widget.selectedCustomer.value;
    _tempBillNo = widget.billNo.value ?? '';
    _fetchWarehousesAndCustomers();
  }

  Future<void> _fetchWarehousesAndCustomers() async {
    if (_tempStore == null) return;

    setState(() {
      _loadingWarehouses = true;
      _loadingCustomers = true;
    });

    final storeId = widget.storeMap.value[_tempStore];
    if (storeId != null) {
      try {
        widget.warehouseMap.value =
            await ViewWarehouseController(accessToken: widget.accessToken)
                .warehouseListByIdController(storeId);

        widget.supplierMap.value = await ViewPartiesController()
            .customerList(widget.accessToken, storeId);
      } catch (e) {
        debugPrint('Error fetching data: $e');
      }
    }

    setState(() {
      _loadingWarehouses = false;
      _loadingCustomers = false;
    });
  }

  Future<void> _showAddCustomerDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddCustomerDialog(
        onSuccess: () {
          widget.onCustomerAddSuccess();
          _fetchWarehousesAndCustomers();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Edit Sale Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStoreDropdown(),
            const SizedBox(height: 16),
            _buildWarehouseDropdown(),
            const SizedBox(height: 16),
            _buildCustomerDropdown(),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Bill Number Prefix (#BILL-, #TRANS_ID)",
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: _tempBillNo),
              onChanged: (value) => _tempBillNo = value,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // Update all selected values before closing
                      widget.selectedStore.value = _tempStore;
                      widget.selectedWarehouse.value = _tempWarehouse;
                      widget.selectedCustomer.value = _tempCustomer;
                      widget.billNo.value = _tempBillNo;

                      // Save to shared preferences immediately
                      _saveCurrentState(widget).then((_) {
                        Navigator.pop(context, true);
                      });
                    },
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCurrentState(_EditSettingsModal widget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'storeId', widget.storeMap.value[widget.selectedStore.value] ?? '');
    await prefs.setString(
      'customerId',
      widget.selectedCustomer.value == "Walk-in Customer"
          ? "Walk-in Customer"
          : widget.supplierMap.value[widget.selectedCustomer.value] ?? '',
    );
    await prefs.setString(
      'warehouseId',
      widget.warehouseMap.value[widget.selectedWarehouse.value] ?? '',
    );
    await prefs.setString('billNo', widget.billNo.value ?? '');
  }

  Widget _buildStoreDropdown() {
    return DropdownButtonFormField<String>(
      value: _tempStore,
      items: widget.storeMap.value.keys
          .map((store) => DropdownMenuItem(
                value: store,
                child: Text(store),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _tempStore = value;
          _tempWarehouse = null;
          _tempCustomer = null;
        });
        _fetchWarehousesAndCustomers();
      },
      decoration: const InputDecoration(
        labelText: "Store",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildWarehouseDropdown() {
    return DropdownButtonFormField<String>(
      value: _tempWarehouse,
      items: [
        const DropdownMenuItem(value: null, child: Text("Select Warehouse")),
        ...widget.warehouseMap.value.keys.map((warehouse) => DropdownMenuItem(
              value: warehouse,
              child: Text(warehouse),
            ))
      ],
      onChanged: _loadingWarehouses
          ? null
          : (value) {
              setState(() => _tempWarehouse = value);
            },
      decoration: InputDecoration(
        labelText: "Warehouse",
        border: const OutlineInputBorder(),
        suffixIcon:
            _loadingWarehouses ? const CircularProgressIndicator() : null,
      ),
    );
  }

  Widget _buildCustomerDropdown() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _tempCustomer,
                items: [
                  const DropdownMenuItem(
                    value: "Walk-in Customer",
                    child: Text("Walk-in Customer"),
                  ),
                  ...widget.supplierMap.value.keys
                      .map((customer) => DropdownMenuItem(
                            value: customer,
                            child: Text(customer),
                          ))
                ],
                onChanged: _loadingCustomers
                    ? null
                    : (value) {
                        setState(() => _tempCustomer = value);
                      },
                decoration: InputDecoration(
                  labelText: "Customer",
                  border: const OutlineInputBorder(),
                  suffixIcon: _loadingCustomers
                      ? const CircularProgressIndicator()
                      : null,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddCustomerDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_loadingCustomers) const LinearProgressIndicator(),
      ],
    );
  }
}

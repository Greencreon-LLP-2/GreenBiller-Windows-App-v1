import 'package:flutter/material.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/add_customer_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesPageTopSectionwidget extends StatefulHookConsumerWidget {
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

  const SalesPageTopSectionwidget({
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

  @override
  ConsumerState<SalesPageTopSectionwidget> createState() =>
      _SalesPageTopSectionwidgetState();
}

class _SalesPageTopSectionwidgetState
    extends ConsumerState<SalesPageTopSectionwidget> {
  final isLoadingWarehouses = ValueNotifier<bool>(false);
  final isLoadingCustomers = ValueNotifier<bool>(false);
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isMounted) {
        _initializeData();
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    isLoadingWarehouses.dispose();
    isLoadingCustomers.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (!_isMounted) return;

    if (widget.storeMap.value.isEmpty) {
      await _fetchStores(context);
      await _loadSavedState();

      if (_isMounted && widget.selectedStore.value == null && widget.storeMap.value.isNotEmpty) {
        widget.selectedStore.value = widget.storeMap.value.keys.first;
        await _saveCurrentState();
      }

      if (_isMounted && widget.selectedStore.value != null) {
        await _fetchAndUpdateData(context);
        await _loadSavedState();
      }
    } else if (_isMounted && widget.selectedStore.value != null) {
      // Load items if store is already selected
      final items = await _fetchItems(widget.selectedStore.value!, context);
      if (_isMounted) {
        widget.itemsList.value = items;
      }
    }
  }

  Future<void> _showEditModal(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        child: _EditSettingsModal(
          storeMap: widget.storeMap,
          warehouseMap: widget.warehouseMap,
          supplierMap: widget.supplierMap,
          selectedStore: widget.selectedStore,
          selectedWarehouse: widget.selectedWarehouse,
          selectedCustomer: widget.selectedCustomer,
          billNo: widget.billNo,
          accessToken: widget.accessToken,
          onCustomerAddSuccess: () {
            widget.onCustomerAddSucess();
            if (widget.selectedStore.value != null) {
              _fetchCustomers(widget.storeMap.value[widget.selectedStore.value]!, context)
                  .then((customers) {
                if (_isMounted) {
                  widget.supplierMap.value = customers;
                }
              });
            }
          },
        ),
      ),
    );

    if (result == true && _isMounted) {
      await _saveCurrentState();
      await _fetchAndUpdateData(context);
    }
  }

  Future<void> _fetchAndUpdateData(BuildContext context) async {
    if (widget.selectedStore.value == null || !_isMounted) return;

    final storeId = widget.storeMap.value[widget.selectedStore.value] ?? '';
    if (storeId.isEmpty) return;

    if (_isMounted) isLoadingWarehouses.value = true;
    final warehouses = await _fetchWarehouses(storeId, context);
    if (_isMounted) {
      widget.warehouseMap.value = warehouses;
      isLoadingWarehouses.value = false;
    }

    if (_isMounted) isLoadingCustomers.value = true;
    final customers = await _fetchCustomers(storeId, context);
    if (_isMounted) {
      widget.supplierMap.value = customers;
      isLoadingCustomers.value = false;
    }

    final items = await _fetchItems(storeId, context);
    if (_isMounted) {
      widget.itemsList.value = items;
    }
  }

  Future<Map<String, String>> _fetchStores(BuildContext context) async {
    try {
      final map =
          await ViewStoreController(accessToken: widget.accessToken, storeId: 0)
              .getStoreList();
      if (_isMounted) {
        widget.storeMap.value = map;
      }
      return map;
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      return {};
    }
  }

  Future<Map<String, String>> _fetchWarehouses(
      String storeId, BuildContext context) async {
    try {
      return await ViewWarehouseController(accessToken: widget.accessToken)
          .warehouseListByIdController(storeId);
    } catch (e) {
      debugPrint('Error fetching warehouses: $e');
      return {};
    }
  }

  Future<Map<String, String>> _fetchCustomers(
      String storeId, BuildContext context) async {
    try {
      return await ViewPartiesController()
          .customerList(widget.accessToken, storeId);
    } catch (e) {
      debugPrint('Error fetching customers: $e');
      return {};
    }
  }

  Future<List<Item>> _fetchItems(String storeId, BuildContext context) async {
    try {
      final items = await ViewAllItemsController(accessToken: widget.accessToken)
          .getAllItems(storeId);
      return items.data ?? [];
    } catch (e) {
      debugPrint('Error fetching items: $e');
      return [];
    }
  }

  Future<void> _saveCurrentState() async {
    if (!_isMounted) return;

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

  Future<void> _loadSavedState() async {
    if (!_isMounted) return;

    final prefs = await SharedPreferences.getInstance();
    final savedStoreId = prefs.getString('storeId');
    final savedCustomerId = prefs.getString('customerId');
    final savedWarehouseId = prefs.getString('warehouseId');
    final savedBillNo = prefs.getString('billNo');

    if (_isMounted) {
      widget.billNo.value = savedBillNo;
    }

    // Restore store selection
    if (savedStoreId != null &&
        widget.storeMap.value.containsValue(savedStoreId) &&
        _isMounted) {
      widget.selectedStore.value = widget.storeMap.value.entries
          .firstWhere((entry) => entry.value == savedStoreId)
          .key;
    }

    // Restore warehouse selection
    if (savedWarehouseId != null &&
        widget.warehouseMap.value.containsValue(savedWarehouseId) &&
        _isMounted) {
      widget.selectedWarehouse.value = widget.warehouseMap.value.entries
          .firstWhere((entry) => entry.value == savedWarehouseId)
          .key;
    }

    // Restore customer selection
    if (savedCustomerId != null && _isMounted) {
      if (savedCustomerId == "Walk-in Customer") {
        widget.selectedCustomer.value = "Walk-in Customer";
      } else if (widget.supplierMap.value.containsValue(savedCustomerId)) {
        widget.selectedCustomer.value = widget.supplierMap.value.entries
            .firstWhere((entry) => entry.value == savedCustomerId)
            .key;
      }
    }
  }

  Future<void> _resetToDefaults(BuildContext context) async {
    if (!_isMounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('storeId');
    await prefs.remove('customerId');
    await prefs.remove('warehouseId');
    await prefs.remove('billNo');

    // Reset in-memory values
    if (_isMounted && widget.storeMap.value.isNotEmpty) {
      widget.selectedStore.value = widget.storeMap.value.keys.first;
    }

    if (_isMounted) {
      widget.selectedCustomer.value = "Walk-in Customer";
      widget.selectedWarehouse.value = null;
      widget.billNo.value = null;
    }

    // Save defaults back
    await _saveCurrentState();

    // Refresh UI/data
    await _fetchAndUpdateData(context);
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
          _buildInfoTile("Store", widget.selectedStore.value ?? "Not selected",
              Icons.store),
          const SizedBox(width: 8),
          _buildInfoTile(
              "Warehouse",
              widget.selectedWarehouse.value ?? "Not selected",
              Icons.warehouse),
          const SizedBox(width: 8),
          _buildInfoTile(
              "Customer",
              widget.selectedCustomer.value ?? "Walk-in Customer",
              Icons.person),
          const SizedBox(width: 8),
          _buildInfoTile("Bill Number Prefix",
              widget.billNo.value ?? "Not set", Icons.receipt),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      width: 180,
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

  @override
  Widget build(BuildContext context) {
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
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _tempStore = widget.selectedStore.value;
    _tempWarehouse = widget.selectedWarehouse.value;
    _tempCustomer = widget.selectedCustomer.value;
    _tempBillNo = widget.billNo.value ?? '';
    _fetchWarehousesAndCustomers();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _fetchWarehousesAndCustomers() async {
    if (_tempStore == null || !_isMounted) return;

    if (_isMounted) {
      setState(() {
        _loadingWarehouses = true;
        _loadingCustomers = true;
      });
    }

    final storeId = widget.storeMap.value[_tempStore];
    if (storeId != null) {
      try {
        final warehouses =
            await ViewWarehouseController(accessToken: widget.accessToken)
                .warehouseListByIdController(storeId);

        final customers = await ViewPartiesController()
            .customerList(widget.accessToken, storeId);

        if (_isMounted) {
          widget.warehouseMap.value = warehouses;
          widget.supplierMap.value = customers;
        }
      } catch (e) {
        debugPrint('Error fetching data: $e');
      }
    }

    if (_isMounted) {
      setState(() {
        _loadingWarehouses = false;
        _loadingCustomers = false;
      });
    }
  }

  Future<void> _showAddCustomerDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AddCustomerDialog(
        onSuccess: () {
          widget.onCustomerAddSuccess();
          if (_isMounted) {
            _fetchWarehousesAndCustomers();
          }
        },
      ),
    );
  }

  Future<void> _saveCurrentState() async {
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
                      _saveCurrentState().then((_) {
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
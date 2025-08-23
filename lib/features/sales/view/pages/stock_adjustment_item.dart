
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/service/sales_view_service.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class StockAdjustmentItem extends HookConsumerWidget {
  StockAdjustmentItem({super.key});

  final currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  void _showSuccessSnackBar(
      BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ]),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ]),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label, {
    bool isRequired = false,
    Widget? suffix,
    TextEditingController? controller,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          if (isRequired)
            const Text(" *", style: TextStyle(color: accentColor)),
        ]),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: onTap != null,
          onTap: onTap,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: textLightColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: textLightColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: accentColor)),
            fillColor: cardColor,
            filled: true,
            suffixIcon: suffix,
          ),
          style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String? value,
      List<DropdownMenuItem<String>> items, ValueChanged<String?>? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: textLightColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: textLightColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: accentColor)),
            fillColor: cardColor,
            filled: true,
          ),
          style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildWarehouseDropdown(Map<String, String> warehouseMap,
      String? selectedValue, ValueChanged<String?> onChanged, bool isLoading) {
    return _buildDropdownField(
      "Warehouse",
      selectedValue,
      [
        const DropdownMenuItem(value: null, child: Text("Select Warehouse")),
        ...warehouseMap.keys.map((warehouse) =>
            DropdownMenuItem(value: warehouse, child: Text(warehouse)))
      ],
      onChanged,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final storeMap = useState<Map<String, String>>({});
    final selectedStore = useState<String?>(null);
    final warehouseMap = useState<Map<String, String>>({});
    final selectedWarehouse = useState<String?>(null);
    final itemIdController = useTextEditingController();
    final adjustmentQtyController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isLoading = useState(false);

    Future<void> fetchStores() async {
      if (accessToken == null) return;
      try {
        final map =
            await ViewStoreController(accessToken: accessToken, storeId: 0)
                .getStoreList();
        storeMap.value = map;
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to fetch stores: $e');
      }
    }

    Future<void> fetchWarehouses(String? storeId) async {
      if (storeId == null || accessToken == null) return;
      isLoading.value = true;
      try {
        warehouseMap.value =
            await ViewWarehouseController(accessToken: accessToken)
                .warehouseListByIdController(storeId);
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to fetch warehouses: $e');
      } finally {
        isLoading.value = false;
      }
    }

    void preparePayload(String accessToken) async {
      if (selectedStore.value == null || selectedWarehouse.value == null) {
        _showErrorSnackBar(context, 'Please select store and warehouse');
        return;
      }
      try {
        final service = SalesViewService(accessToken);
        final payload = {
          'store_id': storeMap.value[selectedStore.value] ?? '',
          'warehouse_id': warehouseMap.value[selectedWarehouse.value] ?? '',
          'item_id': itemIdController.text,
          'adjustment_qty': adjustmentQtyController.text,
          'status': '1',
          'description': descriptionController.text,
        };
        await service.createStockAdjustmentItem(payload);
        _showSuccessSnackBar(
            context, 'Stock Adjusted successfully!', Icons.check_circle);
      } catch (e) {
        _showErrorSnackBar(context, 'Error: ${e.toString()}');
      }
    }

    useEffect(() {
      fetchStores();
      return null;
    }, [accessToken]);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                  color: accentColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2))
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            // leading: IconButton(
            //     icon: const Icon(Icons.arrow_back, color: Colors.white),
            //     onPressed: () => Navigator.pop(context)),
            title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stock Adjustment',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ]),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: _buildActionButton('Save', Icons.save, accentColor,
                      () => preparePayload(accessToken!))),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: CardContainer(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4))
          ],
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Stock Adjustment Details',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569))),
            const SizedBox(height: 20),
            _buildDropdownField("Store", selectedStore.value, [
              const DropdownMenuItem(value: null, child: Text("Select Store")),
              ...storeMap.value.keys.map(
                  (store) => DropdownMenuItem(value: store, child: Text(store)))
            ], (value) {
              selectedStore.value = value;
              selectedWarehouse.value = null;
              fetchWarehouses(storeMap.value[value]);
            }),
            const SizedBox(height: 16),
            _buildWarehouseDropdown(warehouseMap.value, selectedWarehouse.value,
                (value) => selectedWarehouse.value = value, isLoading.value),
            const SizedBox(height: 16),
            _buildInputField("Item ID",
                controller: itemIdController, isRequired: true),
            const SizedBox(height: 16),
            _buildInputField("Adjustment Quantity",
                controller: adjustmentQtyController,
                keyboardType: TextInputType.number,
                isRequired: true),
            const SizedBox(height: 16),
            _buildInputField("Description", controller: descriptionController),
          ]),
        ),
      ),
    );
  }
}

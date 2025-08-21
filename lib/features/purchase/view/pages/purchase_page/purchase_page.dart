import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/funtions/pdf_second_design.dart' as pdf2;
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/home/controllers/tax_controller.dart';
import 'package:green_biller/features/home/model/tax_model.dart' as tax;
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/model/item/item_model.dart' as item;
import 'package:green_biller/features/purchase/controllers/payment_create_controller.dart';
import 'package:green_biller/features/purchase/controllers/purchase_controller.dart';
import 'package:green_biller/features/purchase/controllers/single_item_purchase_controller.dart';
import 'package:green_biller/features/purchase/controllers/temp_purchse_item.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/prucahse_widgets/purchase_bottom_section.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/prucahse_widgets/purchase_table_data_cell_widget.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/prucahse_widgets/purchase_table_header_widget.dart';
import 'package:green_biller/features/purchase/view/pages/purchase_page/prucahse_widgets/purchase_topsection_widget.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:green_biller/features/store/services/view_store_service.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:printing/printing.dart';

class PurchasePage extends HookConsumerWidget {
  const PurchasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnterKeyPressed = useState(false);
    final user = ref.watch(userProvider);
    final userId = user?.user?.id?.toString();
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('User not found. Please login again.')),
      );
    }

    final isLoadingStores = useState(false);
    final isLoadingWarehouses = useState(false);
    final isLoadingSuppliers = useState(false);
    final storeId = useState<String?>(null);
    final newSalesPrices = useState<Map<int, String>>({});
    final priceOldValues = useState<Map<int, String>>({});
    final priceFocusNodes = useState<Map<int, FocusNode>>({});
    final tempPurchaseItems = useState<List<TempPurchaseItem>>([]);
    final tempSubTotal = useState<double>(0.0);
    final tempTotalDiscount = useState<double>(0.0);
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final taxModel = useState<tax.TaxModel?>(null);
    final taxRate = useState<String?>('');
    final billNoController = useTextEditingController();
    final billDateController = useTextEditingController(
        text: DateTime.now().toIso8601String().split('T').first);
    final supplierMap = useState<Map<String, String>>({});
    final warehouseMap = useState<Map<String, String>>({});
    final storeMap = useState<Map<String, String>>({});
    final isLoading = useState(false);
    final quantityControllers = useRef(<int, TextEditingController>{});
    final priceControllers = useRef(<int, TextEditingController>{});
    final purchasePriceControllers = useRef(<int, TextEditingController>{});
    final discountPercentControllers = useRef(<int, TextEditingController>{});
    final discountAmountControllers = useRef(<int, TextEditingController>{});
    final batchNoControllers = useRef(<int, TextEditingController>{});
    final unitControllers = useState<List<TextEditingController>>(
        List.generate(10, (_) => TextEditingController()));
    final showDropdownRows = useState<Set<int>>({});
    final itemsList = useState<List<item.Item>>([]);
    final selectedItem = useState<item.Item?>(null);
    final rowFields = useState<Map<int, Map<String, String>>>({});
    final selectedSupplier = useState<String?>(null);
    final selectedWarehouse = useState<String?>(null);
    final otherChargesController = useTextEditingController();
    final paidAmountController = useTextEditingController();
    final purchaseNoteController = useTextEditingController();
    final purchaseType = useState<String?>(null);
    final isLoadingSave = useState<bool>(false);
    final isLoadingSavePrint = useState<bool>(false);
    final cancelCompleter = useMemoized(() => Completer<void>(), const []);
    void onPurchaseTypeChanged(String? value) {
      purchaseType.value = value;
    }

    void onSupplierSelected(String? id) {
      if (id != null) {
        selectedSupplier.value = supplierMap.value[id];
      }
      log('supplier id is ${selectedSupplier.value}');
    }

    void onWarehouseSelected(String? warehouseName) {
      if (warehouseName != null) {
        selectedWarehouse.value = warehouseMap.value[warehouseName];
      }
      log('Selected warehouse ID: ${selectedWarehouse.value}');
    }

    Future<void> fetchItems(String storeId) async {
      if (accessToken == null) return;
      isLoading.value = true;
      try {
        final item.ItemModel items = await ViewAllItemsController(
          accessToken: accessToken,
        ).getAllItems(storeId);
        itemsList.value = items.data;
      } catch (e) {
        debugPrint('Error fetching items: $e');
      } finally {
        isLoading.value = false;
      }
    }

    String purchaseCode(String storeId, String user) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      return 'G_B_${storeId}_${timestamp}_$user';
    }

    Future<void> fetchWarehouses(String storeId) async {
      if (accessToken == null) return;
      isLoadingWarehouses.value = true;
      try {
        final map = await ViewWarehouseController(accessToken: accessToken)
            .warehouseListByIdController(storeId);
        warehouseMap.value = map;
      } catch (e) {
        debugPrint('Error fetching warehouses: $e');
      } finally {
        isLoadingWarehouses.value = false;
      }
    }

    Future<void> fetchSuppliers(String storeId) async {
      if (accessToken == null) return;
      isLoadingSuppliers.value = true;
      try {
        final map = await ViewPartiesController().supplierList(
          accessToken,
          storeId,
        );

        supplierMap.value = map;
      } catch (e) {
        print('Error fetching suppliers: $e');
      } finally {
        isLoadingSuppliers.value = false;
        print(supplierMap.value);
      }
    }

    useEffect(() {
      Future<void> fetchStores() async {
        if (accessToken == null) return;
        isLoadingStores.value = true;
        try {
          final map =
              await ViewStoreController(accessToken: accessToken, storeId: 0)
                  .getStoreList();

          storeMap.value = map;
          if (cancelCompleter.isCompleted) return;
        } catch (e) {
          debugPrint('Error fetching stores: $e');
        } finally {
          if (!cancelCompleter.isCompleted) {
            isLoadingStores.value = false;
          }
        }
      }

      Future<void> fetchTax() async {
        if (accessToken == null) return;
        isLoading.value = true;
        try {
          taxModel.value = await TaxController().getTaxController();
        } catch (e) {
          debugPrint('Error fetching tax: $e');
        } finally {
          isLoading.value = false;
        }
      }

      fetchStores();
      fetchTax();
      return () {
        if (!cancelCompleter.isCompleted) {
          cancelCompleter.complete();
        }
      };
    }, [accessToken]);

    void onStoreSelected(String? storeName) async {
      if (storeName != null) {
        storeId.value = storeMap.value[storeName];
        selectedWarehouse.value = null;
        selectedSupplier.value = null;
        warehouseMap.value = {};
        supplierMap.value = {};
        await fetchWarehouses(storeId.value!);
        await fetchSuppliers(storeId.value!);
        await fetchItems(storeId.value!);
      }
    }

    void initControllers(int index) {
      quantityControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['quantity'] ?? ''));
      priceControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['price'] ?? ''));
      purchasePriceControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['purchasePrice'] ?? ''));
      discountPercentControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['discountPercent'] ?? ''));
      discountAmountControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['discountAmount'] ?? ''));
      batchNoControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['batchNo'] ?? ''));
      unitControllers.value[index].text = rowFields.value[index]?['unit'] ?? '';
      priceFocusNodes.value.putIfAbsent(index, () => FocusNode());
    }

    double recalculateGrandTotal() {
      double sum = 0.0;
      for (int i = 0; i < 10; i++) {
        final fields = rowFields.value[i];
        if (fields != null) {
          final purchasePrice =
              double.tryParse(fields['purchasePrice'] ?? '0') ?? 0;
          final discountAmount =
              double.tryParse(fields['discountAmount'] ?? '0') ?? 0;
          final taxRate = double.tryParse(fields['taxRate'] ?? '0') ?? 0;
          final taxAmount = purchasePrice * taxRate / 100;
          final amount = purchasePrice + taxAmount - discountAmount;
          if (amount > 0) sum += amount;
        }
      }
      tempSubTotal.value = sum;
      return sum;
    }

    double recalculateTotalDiscount() {
      double discountSum = 0.0;
      for (int i = 0; i < 10; i++) {
        final fields = rowFields.value[i];
        if (fields != null) {
          final quantity = double.tryParse(fields['quantity'] ?? '0') ?? 0;
          final price = double.tryParse(fields['price'] ?? '0') ?? 0;
          final purchasePrice = quantity * price;
          double discountAmount =
              double.tryParse(fields['discountAmount'] ?? '0') ?? 0;
          final percent =
              double.tryParse(fields['discountPercent'] ?? '0') ?? 0;
          if (percent > 0 && purchasePrice > 0) {
            discountAmount = (purchasePrice * percent) / 100;
            discountAmountControllers.value[i]?.text =
                discountAmount.toStringAsFixed(2);
            rowFields.value = {
              ...rowFields.value,
              i: {
                ...?rowFields.value[i],
                'discountAmount': discountAmount.toStringAsFixed(2)
              }
            };
          }
          if (discountAmount > 0) discountSum += discountAmount;
        }
      }
      tempTotalDiscount.value = discountSum;
      return discountSum;
    }

    Widget input({int? rowIndex}) {
      return Autocomplete<item.Item>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<item.Item>.empty();
          }
          final query = textEditingValue.text.toLowerCase();
          return itemsList.value.where((item) {
            return item.itemName.toLowerCase().contains(query) ||
                item.barcode.toLowerCase().contains(query);
          });
        },
        displayStringForOption: (item.Item item) => item.itemName,
        onSelected: (item.Item item) {
          selectedItem.value = item;
          if (rowIndex != null) {
            const quantity = 1.0;
            final price = double.tryParse(item.purchasePrice) ?? 0;
            final purchasePrice = quantity * price;
            final taxRate = double.tryParse(item.taxRate ?? '0') ?? 0;
            final taxAmount = purchasePrice * taxRate / 100;
            final discountPercent = double.tryParse(item.discount ?? '0') ?? 0;
            final discountAmount = discountPercent > 0
                ? (purchasePrice * discountPercent) / 100
                : 0;

            rowFields.value = {
              ...rowFields.value,
              rowIndex: {
                'itemName': item.itemName,
                'barcode': item.barcode,
                'unit': item.unit,
                'price': item.purchasePrice,
                'taxRate': item.taxRate ?? '0',
                'taxName': item.taxType ?? '',
                'discount': item.discount ?? '0',
                'discountPercent': item.discount ?? '0',
                'discountAmount': discountAmount.toStringAsFixed(2),
                'quantity': '1',
                'purchasePrice': purchasePrice.toStringAsFixed(2),
                'salesPrice': item.salesPrice,
                'itemId': item.id.toString(),
                'taxAmount': taxAmount.toStringAsFixed(2),
                'batchNo': item.sku,
              }
            };

            priceControllers.value[rowIndex]?.text = item.purchasePrice;
            quantityControllers.value[rowIndex]?.text = '1';
            purchasePriceControllers.value[rowIndex]?.text =
                purchasePrice.toStringAsFixed(2);
            unitControllers.value[rowIndex].text = item.unit;
            discountPercentControllers.value[rowIndex]?.text =
                item.discount ?? '0';
            discountAmountControllers.value[rowIndex]?.text =
                discountAmount.toStringAsFixed(2);
            batchNoControllers.value[rowIndex]?.text = item.sku;

            recalculateGrandTotal();
            recalculateTotalDiscount();
          }
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) {
              onFieldSubmitted();
            },
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: InputBorder.none,
            ),
          );
        },
        optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<item.Item> onSelected,
          Iterable<item.Item> options,
        ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item.Item option = options.elementAt(index);
                    return ListTile(
                      title: Text(option.itemName),
                      subtitle: Text('Price: ₹${option.purchasePrice}'),
                      onTap: () {
                        onSelected(option);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    final rowCount = useState<int>(5);

    bool rowHasData(int index) {
      final row = rowFields.value[index] ?? {};
      return row.values.any((v) => v.toString().trim().isNotEmpty);
    }

    useEffect(() {
      for (int i = 0; i < rowCount.value; i++) {
        if (rowHasData(i)) {
          if (rowCount.value == i + 1) {
            rowCount.value = rowCount.value + 1;
            break;
          }
        }
      }
      return null;
    }, [rowFields.value]);

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                title: const Text(
                  'Purchase Items',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // leading: IconButton(
                //   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                //   onPressed: () => Navigator.of(context).pop(),
                // ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.list, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PurchasePageTopSectionwidget(
                    supplierMap: supplierMap,
                    onSupplierSelected: onSupplierSelected,
                    warehouseMap: warehouseMap,
                    onWarehouseSelected: onWarehouseSelected,
                    storeMap: storeMap,
                    onStoreSelected: onStoreSelected,
                    billDateController: billDateController,
                    billNoController: billNoController,
                    isLoadingStores: isLoadingStores,
                    isLoadingWarehouses: isLoadingWarehouses,
                    isLoadingSuppliers: isLoadingSuppliers,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Purchase Items",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 400,
                    child: LayoutBuilder(builder: (context, constraints) {
                      const columnCount = 10;
                      const itemFlex = 3;
                      const otherFlex = 1;
                      const totalFlex =
                          itemFlex + (columnCount - 1) * otherFlex;
                      final baseColumnWidth = constraints.maxWidth / totalFlex;
                      final itemColumnWidth = baseColumnWidth * itemFlex;

                      return ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.green.shade200,
                                child: Row(
                                  children: [
                                    HeaderCellWidget(
                                        text: "S.No",
                                        width: baseColumnWidth * 0.5),
                                    HeaderCellWidget(
                                        text: "Item",
                                        width: itemColumnWidth * 0.97),
                                    HeaderCellWidget(
                                        text: "Serial No",
                                        width: baseColumnWidth * 0.55),
                                    HeaderCellWidget(
                                        text: "Qty",
                                        width: baseColumnWidth * 0.5),
                                    HeaderCellWidget(
                                        text: "Unit", width: baseColumnWidth),
                                    HeaderCellWidget(
                                        text: "PRICE/UNIT",
                                        width: baseColumnWidth),
                                    HeaderCellWidget(
                                        text: "PURCHASE PRICE",
                                        width: baseColumnWidth),
                                    HeaderCellWidget(
                                        text: "SKU",
                                        width: baseColumnWidth * 0.5),
                                    Container(
                                      width: baseColumnWidth,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.green.shade100),
                                        ),
                                      ),
                                      child: const Column(
                                        children: [
                                          Text(
                                            "Discount",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    "%",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    "Amount",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    HeaderCellWidget(
                                        text: "TAX %", width: baseColumnWidth),
                                    HeaderCellWidget(
                                        text: "Tax Amt",
                                        width: baseColumnWidth),
                                    HeaderCellWidget(
                                        text: "Amount", width: baseColumnWidth),
                                  ],
                                ),
                              ),
                              ...List.generate(
                                rowCount.value,
                                (index) {
                                  initControllers(index);
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.green.shade100),
                                        left: BorderSide(
                                            color: Colors.green.shade100),
                                        right: BorderSide(
                                            color: Colors.green.shade100),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        DataCellWidget(
                                          width: baseColumnWidth * 0.5,
                                          child: Text("${index + 1}"),
                                        ),
                                        DataCellWidget(
                                          width: itemColumnWidth * 0.97,
                                          child: input(rowIndex: index),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth * 0.55,
                                          child: TextField(
                                            controller:
                                                batchNoControllers.value[index],
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              rowFields.value = {
                                                ...rowFields.value,
                                                index: {
                                                  ...?rowFields.value[index],
                                                  'batchNo': value,
                                                }
                                              };
                                            },
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth * 0.5,
                                          child: TextField(
                                            controller: quantityControllers
                                                .value[index],
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              final quantity =
                                                  double.tryParse(value) ?? 0;
                                              final price = double.tryParse(
                                                      priceControllers
                                                              .value[index]
                                                              ?.text ??
                                                          '0') ??
                                                  0;
                                              final purchasePrice =
                                                  quantity * price;
                                              purchasePriceControllers
                                                      .value[index]?.text =
                                                  purchasePrice == 0
                                                      ? ''
                                                      : purchasePrice
                                                          .toStringAsFixed(2);
                                              final percent = double.tryParse(
                                                      discountPercentControllers
                                                              .value[index]
                                                              ?.text ??
                                                          '0') ??
                                                  0;
                                              double discountAmount = 0;
                                              if (percent > 0 &&
                                                  purchasePrice > 0) {
                                                discountAmount =
                                                    (purchasePrice * percent) /
                                                        100;
                                                discountAmountControllers
                                                        .value[index]?.text =
                                                    discountAmount
                                                        .toStringAsFixed(2);
                                              }
                                              final taxRate = double.tryParse(
                                                      rowFields.value[index]
                                                              ?['taxRate'] ??
                                                          '0') ??
                                                  0;
                                              final taxAmount =
                                                  purchasePrice * taxRate / 100;

                                              rowFields.value = {
                                                ...rowFields.value,
                                                index: {
                                                  ...?rowFields.value[index],
                                                  'quantity': value,
                                                  'purchasePrice':
                                                      purchasePrice == 0
                                                          ? ''
                                                          : purchasePrice
                                                              .toStringAsFixed(
                                                                  2),
                                                  'taxAmount': taxAmount == 0
                                                      ? ''
                                                      : taxAmount
                                                          .toStringAsFixed(2),
                                                  'discountAmount':
                                                      discountAmount == 0
                                                          ? ''
                                                          : discountAmount
                                                              .toStringAsFixed(
                                                                  2),
                                                }
                                              };
                                              recalculateGrandTotal();
                                              recalculateTotalDiscount();
                                            },
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth,
                                          child: TextField(
                                            controller:
                                                unitControllers.value[index],
                                            onChanged: (value) {
                                              rowFields.value = {
                                                ...rowFields.value,
                                                index: {
                                                  ...?rowFields.value[index],
                                                  'unit': value,
                                                }
                                              };
                                            },
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth,
                                          child: Focus(
                                            focusNode:
                                                priceFocusNodes.value[index],
                                            onFocusChange: (hasFocus) async {
                                              if (!hasFocus) {
                                                final oldValue = priceOldValues
                                                        .value[index] ??
                                                    '';
                                                final newValue =
                                                    priceControllers
                                                            .value[index]
                                                            ?.text ??
                                                        '';
                                                // if (oldValue != newValue) {
                                                //   final result =
                                                //       await showBatchSelectionDialog(
                                                //     context: context,
                                                //     batchList: itemsList.value
                                                //         .map((e) => e.sku)
                                                //         .toList(),
                                                //     oldPrice: oldValue,
                                                //     priceController:
                                                //         priceControllers
                                                //             .value[index]!,
                                                //     onUpdate: (batch, newBatch,
                                                //         salesPrice) {
                                                //       if (salesPrice != null &&
                                                //           salesPrice
                                                //               .isNotEmpty) {
                                                //         newSalesPrices.value = {
                                                //           ...newSalesPrices
                                                //               .value,
                                                //           index: salesPrice,
                                                //         };
                                                //         rowFields.value = {
                                                //           ...rowFields.value,
                                                //           index: {
                                                //             ...?rowFields
                                                //                 .value[index],
                                                //             'salesPrice':
                                                //                 salesPrice,
                                                //             'price': newValue,
                                                //             'batchNo':
                                                //                 newBatch ??
                                                //                     batch ??
                                                //                     '',
                                                //           }
                                                //         };
                                                //         final quantity = double.tryParse(
                                                //                 quantityControllers
                                                //                         .value[
                                                //                             index]
                                                //                         ?.text ??
                                                //                     '0') ??
                                                //             0;
                                                //         final price =
                                                //             double.tryParse(
                                                //                     newValue) ??
                                                //                 0;
                                                //         final purchasePrice =
                                                //             quantity * price;
                                                //         purchasePriceControllers
                                                //                 .value[index]
                                                //                 ?.text =
                                                //             purchasePrice
                                                //                 .toStringAsFixed(
                                                //                     2);
                                                //         recalculateGrandTotal();
                                                //         recalculateTotalDiscount();
                                                //       } else {
                                                //         priceControllers
                                                //             .value[index]
                                                //             ?.text = oldValue;
                                                //         final quantity = double.tryParse(
                                                //                 quantityControllers
                                                //                         .value[
                                                //                             index]
                                                //                         ?.text ??
                                                //                     '0') ??
                                                //             0;
                                                //         final price =
                                                //             double.tryParse(
                                                //                     oldValue) ??
                                                //                 0;
                                                //         final purchasePrice =
                                                //             quantity * price;
                                                //         purchasePriceControllers
                                                //                 .value[index]
                                                //                 ?.text =
                                                //             purchasePrice
                                                //                 .toStringAsFixed(
                                                //                     2);
                                                //         rowFields.value = {
                                                //           ...rowFields.value,
                                                //           index: {
                                                //             ...?rowFields
                                                //                 .value[index],
                                                //             'price': oldValue,
                                                //             'purchasePrice':
                                                //                 purchasePrice
                                                //                     .toStringAsFixed(
                                                //                         2),
                                                //           }
                                                //         };
                                                //         recalculateGrandTotal();
                                                //       }
                                                //     },
                                                //   );
                                                //   if (result != true) {
                                                //     priceControllers
                                                //         .value[index]
                                                //         ?.text = oldValue;
                                                //     final quantity = double.tryParse(
                                                //             quantityControllers
                                                //                     .value[
                                                //                         index]
                                                //                     ?.text ??
                                                //                 '0') ??
                                                //         0;
                                                //     final price =
                                                //         double.tryParse(
                                                //                 oldValue) ??
                                                //             0;
                                                //     final purchasePrice =
                                                //         quantity * price;
                                                //     purchasePriceControllers
                                                //             .value[index]
                                                //             ?.text =
                                                //         purchasePrice
                                                //             .toStringAsFixed(2);
                                                //     rowFields.value = {
                                                //       ...rowFields.value,
                                                //       index: {
                                                //         ...?rowFields
                                                //             .value[index],
                                                //         'price': oldValue,
                                                //         'purchasePrice':
                                                //             purchasePrice
                                                //                 .toStringAsFixed(
                                                //                     2),
                                                //       }
                                                //     };
                                                //     recalculateGrandTotal();
                                                //   }
                                                // }
                                              }
                                            },
                                            child: TextField(
                                              controller:
                                                  priceControllers.value[index],
                                              keyboardType:
                                                  TextInputType.number,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 6),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                final quantity =
                                                    double.tryParse(
                                                            quantityControllers
                                                                    .value[
                                                                        index]
                                                                    ?.text ??
                                                                '0') ??
                                                        0;
                                                final price =
                                                    double.tryParse(value) ?? 0;
                                                final purchasePrice =
                                                    quantity * price;
                                                purchasePriceControllers
                                                        .value[index]?.text =
                                                    purchasePrice == 0
                                                        ? ''
                                                        : purchasePrice
                                                            .toStringAsFixed(2);
                                                rowFields.value = {
                                                  ...rowFields.value,
                                                  index: {
                                                    ...?rowFields.value[index],
                                                    'price': value,
                                                    'purchasePrice':
                                                        purchasePrice == 0
                                                            ? ''
                                                            : purchasePrice
                                                                .toStringAsFixed(
                                                                    2),
                                                  }
                                                };
                                                recalculateGrandTotal();
                                              },
                                              onTap: () {
                                                priceOldValues.value = {
                                                  ...priceOldValues.value,
                                                  index: priceControllers
                                                          .value[index]?.text ??
                                                      '',
                                                };
                                              },
                                            ),
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth,
                                          child: TextField(
                                            controller: purchasePriceControllers
                                                .value[index],
                                            readOnly: true,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth * 0.5,
                                          child: TextField(
                                            controller:
                                                batchNoControllers.value[index],
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                              hintText: '',
                                            ),
                                            onChanged: (value) {
                                              rowFields.value = {
                                                ...rowFields.value,
                                                index: {
                                                  ...?rowFields.value[index],
                                                  'batchNo': value,
                                                }
                                              };
                                            },
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth * 0.5,
                                          child: TextField(
                                            controller:
                                                discountPercentControllers
                                                    .value[index],
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                              hintText: '',
                                            ),
                                            onChanged: (value) {
                                              final percent =
                                                  double.tryParse(value) ?? 0;
                                              final purchasePrice =
                                                  double.tryParse(
                                                          purchasePriceControllers
                                                                  .value[index]
                                                                  ?.text ??
                                                              '0') ??
                                                      0;
                                              if (purchasePrice > 0) {
                                                final amount =
                                                    (purchasePrice * percent) /
                                                        100;
                                                discountAmountControllers
                                                        .value[index]?.text =
                                                    amount.toStringAsFixed(2);
                                                rowFields.value = {
                                                  ...rowFields.value,
                                                  index: {
                                                    ...?rowFields.value[index],
                                                    'discountPercent': value,
                                                    'discountAmount': amount
                                                        .toStringAsFixed(2),
                                                  }
                                                };
                                              }
                                              recalculateGrandTotal();
                                              recalculateTotalDiscount();
                                            },
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth * 0.5,
                                          child: TextField(
                                            controller:
                                                discountAmountControllers
                                                    .value[index],
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                              hintText: '',
                                            ),
                                            onChanged: (value) {
                                              final amount =
                                                  double.tryParse(value) ?? 0;
                                              final purchasePrice =
                                                  double.tryParse(
                                                          purchasePriceControllers
                                                                  .value[index]
                                                                  ?.text ??
                                                              '0') ??
                                                      0;
                                              if (purchasePrice > 0) {
                                                final percent =
                                                    (amount / purchasePrice) *
                                                        100;
                                                discountPercentControllers
                                                        .value[index]?.text =
                                                    percent.toStringAsFixed(2);
                                                rowFields.value = {
                                                  ...rowFields.value,
                                                  index: {
                                                    ...?rowFields.value[index],
                                                    'discountPercent': percent
                                                        .toStringAsFixed(2),
                                                    'discountAmount': value,
                                                  }
                                                };
                                              }
                                              recalculateGrandTotal();
                                              recalculateTotalDiscount();
                                            },
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth,
                                          child: GestureDetector(
                                            onTap: () =>
                                                showDropdownRows.value = {
                                              ...showDropdownRows.value,
                                              index
                                            },
                                            child: showDropdownRows.value
                                                    .contains(index)
                                                ? DropdownButtonFormField<
                                                    String>(
                                                    value: rowFields
                                                                .value[index]
                                                            ?['taxName'] ??
                                                        (taxModel.value?.data
                                                                    ?.isNotEmpty ==
                                                                true
                                                            ? taxModel
                                                                .value!
                                                                .data!
                                                                .first
                                                                .taxName
                                                            : null),
                                                    isExpanded: true,
                                                    decoration:
                                                        const InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 6),
                                                      border: InputBorder.none,
                                                    ),
                                                    items: taxModel.value?.data
                                                        ?.map((tax) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: tax.taxName,
                                                        child: Text(
                                                          tax.taxName ?? '',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      final selectedTax =
                                                          taxModel.value?.data
                                                              ?.firstWhere(
                                                        (e) =>
                                                            e.taxName == value,
                                                        orElse: () => taxModel
                                                            .value!.data!.first,
                                                      );
                                                      final purchasePrice = double.tryParse(
                                                              purchasePriceControllers
                                                                      .value[
                                                                          index]
                                                                      ?.text ??
                                                                  '0') ??
                                                          0;
                                                      final newTaxRate =
                                                          double.tryParse(
                                                                  selectedTax
                                                                          ?.tax ??
                                                                      '0') ??
                                                              0;
                                                      final taxAmount =
                                                          purchasePrice *
                                                              newTaxRate /
                                                              100;
                                                      rowFields.value = {
                                                        ...rowFields.value,
                                                        index: {
                                                          ...?rowFields
                                                              .value[index],
                                                          'taxName':
                                                              value ?? '',
                                                          'taxRate': selectedTax
                                                                  ?.tax ??
                                                              '0',
                                                          'taxAmount': taxAmount ==
                                                                  0
                                                              ? ''
                                                              : taxAmount
                                                                  .toStringAsFixed(
                                                                      2),
                                                        }
                                                      };
                                                      recalculateGrandTotal();
                                                    },
                                                  )
                                                : Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 10),
                                                    child: Text(
                                                      rowFields.value[index]
                                                              ?['taxRate'] ??
                                                          '',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth,
                                          child: TextField(
                                            controller: TextEditingController(
                                              text: rowFields.value[index]
                                                      ?['taxAmount'] ??
                                                  '',
                                            ),
                                            readOnly: true,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        DataCellWidget(
                                          width: baseColumnWidth,
                                          child: TextField(
                                            controller: TextEditingController(
                                              text: (() {
                                                final purchasePrice =
                                                    double.tryParse(
                                                            purchasePriceControllers
                                                                    .value[
                                                                        index]
                                                                    ?.text ??
                                                                '0') ??
                                                        0;
                                                final discountAmount =
                                                    double.tryParse(
                                                            discountAmountControllers
                                                                    .value[
                                                                        index]
                                                                    ?.text ??
                                                                '0') ??
                                                        0;
                                                final taxAmount =
                                                    double.tryParse(rowFields
                                                                        .value[
                                                                    index]?[
                                                                'taxAmount'] ??
                                                            '0') ??
                                                        0;
                                                final amount = purchasePrice +
                                                    taxAmount -
                                                    discountAmount;
                                                return amount == 0
                                                    ? ''
                                                    : amount.toStringAsFixed(2);
                                              })(),
                                            ),
                                            readOnly: true,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  PurchasePageBottomSectionWidget(
                    subTotal: tempSubTotal.value,
                    totalDiscount: tempTotalDiscount.value,
                    otherChargesController: otherChargesController,
                    paidAmountController: paidAmountController,
                    purchaseNoteController: purchaseNoteController,
                    onPurchaseTypeChanged: onPurchaseTypeChanged,
                    purchaseType: purchaseType.value,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 8),
                    ),
                  ],
                ),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 177, 104),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                  ),
                  onPressed: () async {
                    if (isLoadingSavePrint.value) return;
                    isLoadingSavePrint.value = true;
                    try {
                      tempPurchaseItems.value.clear();
                      for (int i = 0; i < 10; i++) {
                        final fields = rowFields.value[i];
                        if (fields != null &&
                            (fields['price'] != null ||
                                fields['quantity'] != null)) {
                          tempPurchaseItems.value.add(
                            TempPurchaseItem(
                              userId: userId,
                              barcode: fields['barcode'] ?? '',
                              batchNo: fields['batchNo'] ?? 'GB2025',
                              itemName: fields['itemName'] ?? '',
                              purchaseId: '8',
                              itemId: fields['itemId'] ?? '',
                              purchaseQty: fields['quantity'] ?? '',
                              pricePerUnit: fields['price'] ?? '',
                              taxName: fields['taxName'] ?? '',
                              taxId: fields['taxId'] ?? '',
                              taxAmount: fields['taxAmount'] ?? '',
                              discountType: fields['discount'] ?? '',
                              discountAmount: fields['discountAmount'] ?? '',
                              totalCost: fields['purchasePrice'] ?? '',
                              unitSalesPrice: fields['salesPrice'] ?? '',
                              unit: fields['unit'] ?? '',
                            ),
                          );
                        }
                      }

                      if (accessToken == null ||
                          storeId.value == null ||
                          selectedWarehouse.value == null ||
                          billNoController.text.isEmpty ||
                          billDateController.text.isEmpty ||
                          purchaseType.value == null ||
                          selectedSupplier.value == null ||
                          tempSubTotal.value <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required fields."),
                            backgroundColor: Color.fromARGB(255, 255, 96, 4),
                          ),
                        );
                        return;
                      }

                      final purchaseId = await PurchaseController(
                        accessToken: accessToken,
                        userId: userId,
                        storeId: storeId.value!,
                        warehouseId: selectedWarehouse.value!,
                        purchaseCode: purchaseCode(storeId.value!, userId),
                        referenceNo: billNoController.text,
                        purchaseDate: billDateController.text,
                        supplierId: selectedSupplier.value!,
                        otherHrgeAmt: otherChargesController.text,
                        totDiscountToAllAmt: tempTotalDiscount.value.toString(),
                        subtotal: tempSubTotal.value.toString(),
                        grandTotal:
                            (tempSubTotal.value - tempTotalDiscount.value)
                                .toString(),
                        purchaseNote: purchaseNoteController.text,
                        paidAmount: paidAmountController.text,
                      ).purchaseController();

                      for (var item in tempPurchaseItems.value) {
                        final response = await SingleItemPurchase(
                          itemId: item.itemId,
                          accessToken: accessToken,
                          barcode: item.barcode,
                          batchNo: item.batchNo,
                          itemName: item.itemName,
                          storeId: storeId.value!,
                          purchaseId: purchaseId,
                          purchaseQty: item.purchaseQty,
                          pricePerUnit: item.pricePerUnit,
                          taxName: item.taxName,
                          taxId: item.taxId,
                          taxAmount: item.taxAmount,
                          discountType: item.discountType,
                          discountAmount: item.discountAmount,
                          totalCost: item.totalCost,
                          unitSalesPrice: item.unitSalesPrice,
                          unit: item.unit,
                          warehouseId: selectedWarehouse.value!,
                        ).singleItemPurchaseController();
                      }

                      final paymentResponse = await PaymentCreateController(
                        accessToken: accessToken,
                        userId: userId,
                        purchaseId: purchaseId,
                        storeId: storeId.value!,
                        paymentMethod: purchaseType.value!,
                        paymentAmount: paidAmountController.text,
                        paymentDate: billDateController.text,
                        supplierId: selectedSupplier.value!,
                        paymentNote: purchaseNoteController.text,
                      ).purchasePaymentCroller(context);

                      final List<pdf2.InvoiceItem> pdfItems =
                          tempPurchaseItems.value.map((item) {
                        final actualItem = itemsList.value.firstWhere(
                          (i) => i.id.toString() == item.itemId,
                          orElse: () => itemsList.value.first,
                        );
                        return pdf2.InvoiceItem(
                          name: actualItem.itemName,
                          qty: int.tryParse(item.purchaseQty) ?? 0,
                          unit: actualItem.unit,
                          price: double.tryParse(item.pricePerUnit) ?? 0,
                          total: (double.tryParse(item.totalCost) ?? 0) +
                              (double.tryParse(item.taxAmount) ?? 0) -
                              (double.tryParse(item.discountAmount) ?? 0),
                        );
                      }).toList();

                      final supplierName = supplierMap.value.entries
                          .firstWhere(
                            (entry) => entry.value == selectedSupplier.value,
                            orElse: () => const MapEntry('', ''),
                          )
                          .key;

                      final storeName = storeMap.value.entries
                          .firstWhere(
                            (entry) => entry.value == storeId.value,
                            orElse: () => const MapEntry('', ''),
                          )
                          .key;
                      final storemodel = await viewStoreService(accessToken);
                      String? storeAddress;
                      for (var store in storemodel.data!) {
                        if (store.id.toString() == storeId.value.toString()) {
                          storeAddress = store.storeAddress ?? "Nill";
                        }
                      }
                      final file = await pdf2.pdfFormatSecond(
                        shopName: storeName,
                        shopAddress: storeAddress ?? "",
                        shopContact: userModel?.user?.mobile ?? "",
                        shopEmail: userModel?.user?.email ?? "",
                        shopState: "",
                        invoiceNo: billNoController.text,
                        invoiceDate: DateTime.parse(billDateController.text),
                        website: "www.greenbiller.com",
                        amountInWords: "",
                        terms: purchaseNoteController.text,
                        received:
                            double.tryParse(paidAmountController.text) ?? 0,
                        subtotal: tempSubTotal.value,
                        total: tempSubTotal.value +
                            (double.tryParse(otherChargesController.text) ??
                                0) -
                            tempTotalDiscount.value,
                        balance: (tempSubTotal.value -
                                tempTotalDiscount.value) -
                            (double.tryParse(paidAmountController.text) ?? 0) +
                            (double.tryParse(otherChargesController.text) ?? 0),
                        customerName: supplierName,
                        paymentMode: purchaseType.value ?? "",
                        items: pdfItems,
                        print: true,
                        totalDiscount: tempTotalDiscount.value,
                        otherCharges:
                            double.tryParse(otherChargesController.text) ?? 0,
                      );
                      context.pop();
                      try {
                        await Printing.layoutPdf(
                          onLayout: (_) => file.readAsBytes(),
                          name: 'Purchase_invoice',
                        );
                      } catch (e) {
                        logger.e("Error printing: $e");
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Something went wrong"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      isLoadingSavePrint.value = false;
                    }
                  },
                  child: isLoadingSavePrint.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save & Print",
                          style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 30),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 8),
                    ),
                  ],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                  ),
                  onPressed: () async {
                    if (isLoadingSave.value) return;
                    isLoadingSave.value = true;
                    try {
                      tempPurchaseItems.value.clear();
                      for (int i = 0; i < 10; i++) {
                        final fields = rowFields.value[i];
                        if (fields != null &&
                            (fields['price'] != null ||
                                fields['quantity'] != null)) {
                          tempPurchaseItems.value.add(
                            TempPurchaseItem(
                              barcode: fields['barcode'] ?? "",
                              batchNo: fields['batchNo'] ?? "",
                              itemName: fields['itemName'] ?? "",
                              userId: userId,
                              purchaseId: '8',
                              itemId: fields['itemId'] ?? '',
                              purchaseQty: fields['quantity'] ?? '',
                              pricePerUnit: fields['price'] ?? '',
                              taxName: fields['taxName'] ?? '',
                              taxId: fields['taxId'] ?? '',
                              taxAmount: fields['taxAmount'] ?? '',
                              discountType: fields['discount'] ?? '',
                              discountAmount: fields['discountAmount'] ?? '',
                              totalCost: fields['purchasePrice'] ?? '',
                              unitSalesPrice: fields['salesPrice'] ?? "",
                              unit: fields['unit'] ?? '',
                            ),
                          );
                        }
                      }

                      if (accessToken == null ||
                          storeId.value == null ||
                          selectedWarehouse.value == null ||
                          billNoController.text.isEmpty ||
                          purchaseType.value == null ||
                          billDateController.text.isEmpty ||
                          selectedSupplier.value == null ||
                          tempSubTotal.value <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required fields."),
                            backgroundColor: Color.fromARGB(255, 255, 96, 4),
                          ),
                        );
                        return;
                      }

                      final purchaseId = await PurchaseController(
                        accessToken: accessToken,
                        userId: userId,
                        storeId: storeId.value!,
                        warehouseId: selectedWarehouse.value!,
                        purchaseCode: purchaseCode(storeId.value!, userId),
                        referenceNo: billNoController.text,
                        purchaseDate: billDateController.text,
                        supplierId: selectedSupplier.value!,
                        otherHrgeAmt: otherChargesController.text,
                        totDiscountToAllAmt: tempTotalDiscount.value.toString(),
                        subtotal: tempSubTotal.value.toString(),
                        grandTotal:
                            (tempSubTotal.value - tempTotalDiscount.value)
                                .toString(),
                        purchaseNote: purchaseNoteController.text,
                        paidAmount: paidAmountController.text,
                      ).purchaseController();

                      for (var item in tempPurchaseItems.value) {
                        final response = await SingleItemPurchase(
                          itemId: item.itemId,
                          accessToken: accessToken,
                          barcode: item.barcode,
                          batchNo: item.batchNo,
                          itemName: item.itemName,
                          warehouseId: selectedWarehouse.value!,
                          storeId: storeId.value!,
                          purchaseId: purchaseId,
                          purchaseQty: item.purchaseQty,
                          pricePerUnit: item.pricePerUnit,
                          taxName: item.taxName,
                          taxId: item.taxId,
                          taxAmount: item.taxAmount,
                          discountType: item.discountType,
                          discountAmount: item.discountAmount,
                          totalCost: item.totalCost,
                          unitSalesPrice: item.unitSalesPrice,
                          unit: item.unit,
                        ).singleItemPurchaseController();
                      }

                      final paymentResponse = await PaymentCreateController(
                        accessToken: accessToken,
                        userId: userId,
                        purchaseId: purchaseId,
                        storeId: storeId.value!,
                        paymentMethod: purchaseType.value!,
                        paymentAmount: paidAmountController.text,
                        paymentDate: billDateController.text,
                        supplierId: selectedSupplier.value!,
                        paymentNote: purchaseNoteController.text,
                      ).purchasePaymentCroller(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Item Added Successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Something went wrong"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      isLoadingSave.value = false;
                    }
                  },
                  child: isLoadingSave.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save",
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

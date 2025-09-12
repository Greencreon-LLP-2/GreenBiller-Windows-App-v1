import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/controller/quatation_controller.dart';
import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';
import 'package:greenbiller/features/sale/view/widgets/quotation_bottom_section_widget.dart';
import 'package:greenbiller/features/sale/view/widgets/quotation_top_section_widget.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HeaderRowWidget extends StatelessWidget {
  final Map<String, double> columnWidths;

  const HeaderRowWidget({super.key, required this.columnWidths});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: accentColor.withOpacity(0.1)),
          left: BorderSide(color: accentColor.withOpacity(0.1)),
          right: BorderSide(color: accentColor.withOpacity(0.1)),
        ),
      ),
      child: Table(
        columnWidths: {
          for (int i = 0; i < columnWidths.length; i++)
            i: FixedColumnWidth(columnWidths.values.elementAt(i)),
        },
        children: [
          TableRow(
            children: [
              DataCellWidget(
                width: columnWidths['#']!,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Center(
                    child: Text(
                      '#',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              DataCellWidget(
                width: columnWidths['Item']!,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Text(
                    'Item',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataCellWidget(
                width: columnWidths['Qty']!,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Center(
                    child: Text(
                      'Qty',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              DataCellWidget(
                width: columnWidths['Unit']!,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Center(
                    child: Text(
                      'Unit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              DataCellWidget(
                width: columnWidths['Price/Unit']!,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Center(
                    child: Text(
                      'Price/Unit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              DataCellWidget(
                width: columnWidths['Subtotal']!,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Center(
                    child: Text(
                      'Subtotal',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DataCellWidget extends StatelessWidget {
  final double width;
  final Widget child;

  const DataCellWidget({super.key, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: accentColor.withOpacity(0.1))),
      ),
      child: child,
    );
  }
}

class DataRowWidget extends StatelessWidget {
  final int index;
  final Map<String, double> columnWidths;
  final QuotationController controller;
  final Widget inputWidget;

  const DataRowWidget({
    super.key,
    required this.index,
    required this.columnWidths,
    required this.controller,
    required this.inputWidget,
  });

  @override
  Widget build(BuildContext context) {
    print(columnWidths['Item']);
    final itemName = '';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: accentColor.withOpacity(0.1)),
          left: BorderSide(color: accentColor.withOpacity(0.1)),
          right: BorderSide(color: accentColor.withOpacity(0.1)),
        ),
      ),
      child: Table(
        columnWidths: {
          for (int i = 0; i < columnWidths.length; i++)
            i: FixedColumnWidth(columnWidths.values.elementAt(i)),
        },
        children: [
          TableRow(
            children: [
              DataCellWidget(
                width: columnWidths['#']!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Center(child: Text("${index + 1}")),
                ),
              ),
              DataCellWidget(
                width: columnWidths['Item']!,
                child: itemName.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        child: Text(
                          itemName,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    : inputWidget,
              ),
              DataCellWidget(
                width: columnWidths['Qty']!,
                child: TextField(
                  controller: controller.quantityControllers[index],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    final quantity = double.tryParse(value) ?? 0;
                    final price =
                        double.tryParse(
                          controller.priceControllers[index]?.text ?? '0',
                        ) ??
                        0;
                    final subtotal = quantity * price;
                    controller.rowFields[index] = {
                      ...?controller.rowFields[index],
                      'quantity': value,
                      'subtotal': subtotal.toStringAsFixed(2),
                    };
                    controller.ensureTempPurchaseItemsSize(index);
                    controller.tempPurchaseItems[index] = TempPurchaseItem(
                      customerId: controller.customerId.value ?? '',
                      purchaseId: '',
                      itemId: controller.rowFields[index]?['itemId'] ?? '',
                      itemName: controller.rowFields[index]?['itemName'] ?? '',
                      purchaseQty: value,
                      pricePerUnit:
                          controller.rowFields[index]?['price'] ?? '0',
                      taxName: '',
                      taxId: '',
                      taxAmount: '0',
                      discountType: '',
                      discountAmount: '0',
                      totalCost: subtotal.toStringAsFixed(2),
                      unit: controller.rowFields[index]?['unit'] ?? '',
                      taxRate: '0',
                      batchNo: controller.rowFields[index]?['barcode'] ?? '',
                      barcode: controller.rowFields[index]?['barcode'] ?? '',
                      serialNumbers: '',
                    );
                    controller.recalculateSubTotal();
                  },
                ),
              ),
              DataCellWidget(
                width: columnWidths['Unit']!,
                child: TextField(
                  controller: controller.unitControllers[index],
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    controller.rowFields[index] = {
                      ...?controller.rowFields[index],
                      'unit': value,
                    };
                    controller.ensureTempPurchaseItemsSize(index);
                    controller.tempPurchaseItems[index] = TempPurchaseItem(
                      customerId: controller.customerId.value ?? '',
                      purchaseId: '',
                      itemId: controller.rowFields[index]?['itemId'] ?? '',
                      itemName: controller.rowFields[index]?['itemName'] ?? '',
                      purchaseQty:
                          controller.rowFields[index]?['quantity'] ?? '0',
                      pricePerUnit:
                          controller.rowFields[index]?['price'] ?? '0',
                      taxName: '',
                      taxId: '',
                      taxAmount: '0',
                      discountType: '',
                      discountAmount: '0',
                      totalCost:
                          controller.rowFields[index]?['subtotal'] ?? '0',
                      unit: value,
                      taxRate: '0',
                      batchNo: controller.rowFields[index]?['barcode'] ?? '',
                      barcode: controller.rowFields[index]?['barcode'] ?? '',
                      serialNumbers: '',
                    );
                  },
                ),
              ),
              DataCellWidget(
                width: columnWidths['Price/Unit']!,
                child: TextField(
                  controller: controller.priceControllers[index],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    final price = double.tryParse(value) ?? 0;
                    final quantity =
                        double.tryParse(
                          controller.quantityControllers[index]?.text ?? '0',
                        ) ??
                        0;
                    final subtotal = quantity * price;
                    controller.rowFields[index] = {
                      ...?controller.rowFields[index],
                      'price': value,
                      'subtotal': subtotal.toStringAsFixed(2),
                    };
                    controller.ensureTempPurchaseItemsSize(index);
                    controller.tempPurchaseItems[index] = TempPurchaseItem(
                      customerId: controller.customerId.value ?? '',
                      purchaseId: '',
                      itemId: controller.rowFields[index]?['itemId'] ?? '',
                      itemName: controller.rowFields[index]?['itemName'] ?? '',
                      purchaseQty:
                          controller.rowFields[index]?['quantity'] ?? '0',
                      pricePerUnit: value,
                      taxName: '',
                      taxId: '',
                      taxAmount: '0',
                      discountType: '',
                      discountAmount: '0',
                      totalCost: subtotal.toStringAsFixed(2),
                      unit: controller.rowFields[index]?['unit'] ?? '',
                      taxRate: '0',
                      batchNo: controller.rowFields[index]?['barcode'] ?? '',
                      barcode: controller.rowFields[index]?['barcode'] ?? '',
                      serialNumbers: '',
                    );
                    controller.recalculateSubTotal();
                  },
                ),
              ),
              DataCellWidget(
                width: columnWidths['Subtotal']!,
                child: Text(
                  controller.rowFields[index]?['subtotal'] ?? '0.00',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuotationCreatePage extends GetView<QuotationController> {
  const QuotationCreatePage({super.key});

  TextEditingController controllerForRow(int rowIndex) {
    if (!controller.quantityControllers.containsKey(rowIndex)) {
      controller.quantityControllers[rowIndex] = TextEditingController(
        text: controller.rowFields[rowIndex]?['itemName'] ?? '',
      );
    }
    return controller.quantityControllers[rowIndex]!;
  }

  Widget input({required int rowIndex}) {
    return Obx(() {
      // Show a loading indicator if items are being fetched
      if (controller.isLoadingItems.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return Autocomplete<Item>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty || controller.itemsList.isEmpty) {
            return const Iterable<Item>.empty();
          }
          final query = textEditingValue.text.toLowerCase();
          return controller.itemsList
              .where((item) {
                final itemName =
                    item['item_name']?.toString().toLowerCase() ?? '';
                final barcode = item['Barcode']?.toString().toLowerCase() ?? '';
                final sku = item['SKU']?.toString().toLowerCase() ?? '';
                return itemName.contains(query) ||
                    barcode.contains(query) ||
                    sku.contains(query);
              })
              .map((item) => Item.fromJson(item));
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.5,
                  maxHeight: 200,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final Item item = options.elementAt(index);
                    return ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(
                        'Price: ${item.salesPrice ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () => onSelected(item),
                    );
                  },
                ),
              ),
            ),
          );
        },
        displayStringForOption: (Item item) => item.itemName,
        onSelected: (Item item) {
          controller.onItemSelected(item, rowIndex);
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  hintText: 'Enter item name or scan barcode',
                ),
                onChanged: (value) {
                  controller.rowFields[rowIndex] = {
                    ...?controller.rowFields[rowIndex],
                    'itemName': value,
                  };
                },
                onSubmitted: (value) {
                  /* keep your onSubmitted logic */
                },
              );
            },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                decoration: BoxDecoration(
                  color: accentColor,
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
                    'New Quotation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuotationTopSectionWidget(
                      controller: controller,
                      onCustomerAddSuccess: () {
                        controller.fetchCustomers(
                          controller.selectedStoreId.value,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Quotation Items",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: accentColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final columnWidths = {
                            '#': 40.0,
                            'Item': 300.0,
                            'Qty': 150.0,
                            'Unit': 80.0,
                            'Price/Unit': 150.0,
                            'Subtotal': 150.0,
                          };
                          final totalTableWidth = columnWidths.values.reduce(
                            (a, b) => a + b,
                          );
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: totalTableWidth,
                              child: Column(
                                children: [
                                  HeaderRowWidget(columnWidths: columnWidths),

                                  Obx(() {
                                    return Column(
                                      children: List.generate(
                                        controller.rowCount.value,
                                        (index) {
                                          controller.initControllers(index);
                                          return DataRowWidget(
                                            index: index,
                                            columnWidths: columnWidths,
                                            controller: controller,
                                            inputWidget: input(rowIndex: index),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    QuotationBottomSectionWidget(controller: controller),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                    onPressed: controller.isLoadingSave.value
                        ? null
                        : () async {
                            final selectedStore = controller.actualStoreData
                                .firstWhere(
                                  (store) =>
                                      store['id'] ==
                                      controller.selectedStoreId.value,
                                  orElse: () => null,
                                );
                            final selectedCustomer = controller
                                .actualCustomerData
                                .firstWhere(
                                  (customer) =>
                                      customer['id'] ==
                                      controller.selectedCustomerId.value,
                                  orElse: () => null,
                                );
                            await controller.saveQuotation(context: context);
                            if (!controller.isLoadingSave.value &&
                                context.mounted) {
                              await printQuotation(
                                context,
                                selectedStore,
                                selectedCustomer,
                              );
                            } else if (context.mounted) {
                              Get.snackbar(
                                'Error',
                                'Cannot start print, contact admin',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                    child: controller.isLoadingSave.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save & Print",
                            style: TextStyle(color: Colors.white),
                          ),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
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
                    onPressed: controller.isLoadingSave.value
                        ? null
                        : () => controller.saveQuotation(context: context),
                    child: controller.isLoadingSave.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Future<void> printQuotation(
    BuildContext context,
    dynamic storeData,
    dynamic customerData,
  ) async {
    final pdf = pw.Document();
    final defaultPrinter = storeData?['default_printer'] ?? 'a4';
    final isA4 = defaultPrinter == 'a4';

    String getStoreValue(String key, {String fallback = 'N/A'}) {
      if (key == 'currency_symbol') {
        return storeData?[key]?.toString().isNotEmpty ?? false
            ? storeData[key].toString()
            : '₹';
      }
      return storeData?[key]?.toString().isNotEmpty ?? false
          ? storeData[key].toString()
          : fallback;
    }

    final tableHeader = pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: pw.Text(
            '#',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: pw.Text(
            'Item',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.left,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: pw.Text(
            'Qty',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: pw.Text(
            'Unit',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: pw.Text(
            'Price',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: pw.Text(
            'Subtotal',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );

    final tableRows = controller.rowFields.entries
        .where((entry) => (entry.value['itemName'] ?? '').isNotEmpty)
        .map((entry) {
          final index = int.parse(entry.key.toString()) + 1;
          final row = entry.value;
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: pw.Text(
                  index.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: pw.Text(
                  row['itemName']?.toString() ?? 'Unknown Item',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                  maxLines: 2,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: pw.Text(
                  row['quantity']?.toString() ?? '0',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: pw.Text(
                  row['unit']?.toString() ?? '-',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: pw.Text(
                  '${getStoreValue('currency_symbol')}${double.tryParse(row['price']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 4,
                ),
                child: pw.Text(
                  '${getStoreValue('currency_symbol')}${double.tryParse(row['subtotal']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                ),
              ),
            ],
          );
        })
        .toList();

    final totalsSection = [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Total:', style: pw.TextStyle(fontSize: isA4 ? 12 : 7)),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.tempSubTotal.value.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
          ),
        ],
      ),
    ];

    pdf.addPage(
      pw.Page(
        pageFormat: isA4 ? PdfPageFormat.a4 : PdfPageFormat.roll80,
        margin: pw.EdgeInsets.all(isA4 ? 40 : 5),
        build: (pw.Context context) {
          return isA4
              ? pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              getStoreValue(
                                'store_name',
                                fallback:
                                    controller.storeController.text.isNotEmpty
                                    ? controller.storeController.text
                                    : 'Your Store Name',
                              ),
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Address: ${getStoreValue('store_address')}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              '${getStoreValue('store_city')}${getStoreValue('store_state').isNotEmpty ? ', ${getStoreValue('store_state')}' : ''}${getStoreValue('store_country').isNotEmpty ? ', ${getStoreValue('store_country')}' : ''}${getStoreValue('store_postal_code').isNotEmpty ? ' ${getStoreValue('store_postal_code')}' : ''}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Phone: ${getStoreValue('store_phone')}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Email: ${getStoreValue('store_email')}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Tax Number: ${getStoreValue('tax_number')}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Quotation',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Quote No: ${controller.quotationNumber.value}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Date: ${controller.getCurrentDateFormatted()}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Customer: ${controller.customerController.text.isNotEmpty ? controller.customerController.text : 'Unknown Customer'}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Owner: ${getStoreValue('owner_name')}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Owner Email: ${getStoreValue('owner_email')}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Divider(thickness: 1),
                    pw.Text(
                      'Items',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(width: 1),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(30),
                        1: const pw.FlexColumnWidth(3),
                        2: const pw.FixedColumnWidth(50),
                        3: const pw.FixedColumnWidth(60),
                        4: const pw.FixedColumnWidth(60),
                        5: const pw.FixedColumnWidth(80),
                      },
                      children: [tableHeader, ...tableRows],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Divider(thickness: 1),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: totalsSection,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Divider(thickness: 1),
                    pw.Text(
                      'Thank you for your inquiry!',
                      style: const pw.TextStyle(fontSize: 12),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'This quotation is valid for 30 days. Please contact us at ${getStoreValue('store_email')} for any inquiries.',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                )
              : pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      controller.storeController.text.isNotEmpty
                          ? controller.storeController.text
                          : 'Your Store Name',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Date: ${controller.getCurrentDateFormatted()}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                    pw.Text(
                      'Customer: ${controller.customerController.text.isNotEmpty ? controller.customerController.text : 'Unknown Customer'}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                    pw.Text(
                      'Quote No: ${controller.quotationNumber.value}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Divider(thickness: 0.5),
                    pw.Text(
                      'Items',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Table(
                      border: pw.TableBorder.all(width: 0.5),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(12),
                        1: const pw.FixedColumnWidth(60),
                        2: const pw.FixedColumnWidth(18),
                        3: const pw.FixedColumnWidth(25),
                        4: const pw.FixedColumnWidth(25),
                        5: const pw.FixedColumnWidth(30),
                      },
                      children: [tableHeader, ...tableRows],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Divider(thickness: 0.5),
                    ...totalsSection,
                    pw.SizedBox(height: 5),
                    pw.Divider(thickness: 0.5),
                    pw.Text(
                      'Thank you for your inquiry!',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                );
        },
      ),
    );

    final quoteNumber = controller.quotationNumber.value.isNotEmpty
        ? controller.quotationNumber.value.replaceAll(RegExp(r'[^\w\-]'), '_')
        : 'quotation';
    final fileName = 'Quote_$quoteNumber.pdf';

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: fileName,
      format: isA4 ? PdfPageFormat.a4 : PdfPageFormat.roll80,
    );
  }
}

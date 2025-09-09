import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/controller/sales_create_controller.dart';
import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';
import 'package:greenbiller/features/sale/view/widgets/sales_page_bottom_section_widget.dart';
import 'package:greenbiller/features/sale/view/widgets/sales_top_section_widget.dart';
import 'package:greenbiller/features/sale/view/widgets/sku_edit_dialog.dart';

class NewSalePage extends GetView<SalesController> {
  const NewSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Input widget for item selection
      Widget input({required int rowIndex}) {
        controller.initControllers(rowIndex);
        return Autocomplete<Item>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Item>.empty();
            }
            final query = textEditingValue.text.toLowerCase();
            return controller.itemsList
                .where((item) {
                  final itemName =
                      item['item_name']?.toString().toLowerCase() ?? '';
                  final barcode =
                      item['Barcode']?.toString().toLowerCase() ?? '';
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
                          'Selling Price: ${item.salesPrice ?? 'N/A'}, Wholesale Price: ${item.wholesalePrice ?? 'N/A'}',
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
          onSelected: (Item item) => controller.onItemSelected(item, rowIndex),
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
                controller.itemInputControllers[rowIndex] =
                    textEditingController;
                controller.itemInputFocusNodes[rowIndex] = focusNode;
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
                  onSubmitted: (value) {
                    final exactMatches = controller.itemsList
                        .where((item) {
                          final itemName =
                              item['item_name']?.toString().toLowerCase() ?? '';
                          final barcode =
                              item['Barcode']?.toString().toLowerCase() ?? '';
                          return barcode.toLowerCase() == value.toLowerCase() ||
                              itemName.toLowerCase() == value.toLowerCase();
                        })
                        .map((item) => Item.fromJson(item))
                        .toList();
                    if (exactMatches.isNotEmpty) {
                      controller.onItemSelected(exactMatches.first, rowIndex);
                    }
                  },
                );
              },
        );
      }

      return Stack(
        children: [
          Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
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
                    'New Sale',
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
                    SalesPageTopSectionWidget(
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
                        "Sales Items",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Define fixed column widths
                          final columnWidths = {
                            '#': 40.0,
                            'Item': 250.0,
                            'SKUs': 150.0,
                            'Qty': 60.0,
                            'Unit': 80.0,
                            'Price/Unit': 150.0,
                            'Sale Price': 150.0,
                            'Disc %': 150.0,
                            'Disc Amt': 150.0,
                            'Tax %': 250.0,
                            'Tax Amt': 150.0,
                            'Amount': 150.0,
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
                                    return SizedBox(
                                      height: controller.rowCount.value * 60,
                                      width: totalTableWidth,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: controller.rowCount.value,
                                        itemBuilder: (context, index) {
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
                    SalesPageBottomSectionWidget(controller: controller),
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
                    onPressed: controller.isLoadingSavePrint.value
                        ? null
                        : () => controller.saveSale(
                            print: true,
                            context: context,
                          ),
                    child: controller.isLoadingSavePrint.value
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
                      backgroundColor: Colors.green,
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
                        : () => controller.saveSale(
                            print: false,
                            context: context,
                          ),
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
}

class HeaderCellWidget extends StatelessWidget {
  final String text;
  final double width;

  const HeaderCellWidget({super.key, required this.text, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
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
    return SizedBox(width: width, child: child);
  }
}

class HeaderRowWidget extends StatelessWidget {
  final Map<String, double> columnWidths;

  const HeaderRowWidget({super.key, required this.columnWidths});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade200,
      child: Table(
        columnWidths: {
          for (int i = 0; i < columnWidths.length; i++)
            i: FixedColumnWidth(columnWidths.values.elementAt(i)),
        },
        children: [
          TableRow(
            children: [
              HeaderCellWidget(text: "#", width: columnWidths['#']!),
              HeaderCellWidget(text: "Item", width: columnWidths['Item']!),
              HeaderCellWidget(text: "SKUs", width: columnWidths['SKUs']!),
              HeaderCellWidget(text: "Qty", width: columnWidths['Qty']!),
              HeaderCellWidget(text: "Unit", width: columnWidths['Unit']!),
              HeaderCellWidget(
                text: "Price/Unit",
                width: columnWidths['Price/Unit']!,
              ),
              HeaderCellWidget(
                text: "Sale Price",
                width: columnWidths['Sale Price']!,
              ),
              HeaderCellWidget(text: "Disc %", width: columnWidths['Disc %']!),
              HeaderCellWidget(
                text: "Disc Amt",
                width: columnWidths['Disc Amt']!,
              ),
              HeaderCellWidget(text: "Tax %", width: columnWidths['Tax %']!),
              HeaderCellWidget(
                text: "Tax Amt",
                width: columnWidths['Tax Amt']!,
              ),
              HeaderCellWidget(text: "Amount", width: columnWidths['Amount']!),
            ],
          ),
        ],
      ),
    );
  }
}

class DataRowWidget extends StatelessWidget {
  final int index;
  final Map<String, double> columnWidths;
  final SalesController controller;
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
    return Obx(() {
      final itemName = controller.rowFields[index]?['itemName'] ?? '';
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.green.shade100),
            left: BorderSide(color: Colors.green.shade100),
            right: BorderSide(color: Colors.green.shade100),
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
                  width: columnWidths['SKUs']!,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.ensureTempPurchaseItemsSize(index);
                      Get.dialog(
                        SkuEditDialog(
                          item: controller.tempPurchaseItems[index],
                          onSave: () {
                            controller.rowFields[index] = {
                              ...?controller.rowFields[index],
                              'batchNo':
                                  controller.tempPurchaseItems[index].batchNo,
                              'quantity': controller
                                  .tempPurchaseItems[index]
                                  .purchaseQty,
                              'serialNumbers': controller
                                  .tempPurchaseItems[index]
                                  .serialNumbers,
                              'salesPrice':
                                  controller.tempPurchaseItems[index].totalCost,
                            };
                            controller.batchNoControllers[index]?.text =
                                controller.tempPurchaseItems[index].batchNo;
                            controller.quantityControllers[index]?.text =
                                controller.tempPurchaseItems[index].purchaseQty;
                            controller.salesPriceControllers[index]?.text =
                                controller.tempPurchaseItems[index].totalCost;
                            controller.recalculateGrandTotal();
                            controller.recalculateTotalDiscount();
                            controller.rowFields.refresh();
                          },
                        ),
                        barrierDismissible: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      minimumSize: const Size(0, 0),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: Obx(() {
                      final batchNo =
                          controller.rowFields[index]?['batchNo'] ?? '';
                      final skuCount = batchNo
                          .split(',')
                          .where((s) => s.trim().isNotEmpty)
                          .length;
                      return Text(
                        '$skuCount SKU${skuCount == 1 ? '' : 's'}',
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ),
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
                      final quantity = int.tryParse(value) ?? 0;
                      final price =
                          double.tryParse(
                            controller.priceControllers[index]?.text ?? '0',
                          ) ??
                          0;
                      final salesPrice = quantity * price;
                      final discountPercent =
                          double.tryParse(
                            controller
                                    .discountPercentControllers[index]
                                    ?.text ??
                                '0',
                          ) ??
                          0;
                      final discountAmount =
                          (salesPrice * discountPercent) / 100;
                      final taxRate =
                          double.tryParse(
                            controller.rowFields[index]?['taxRate'] ?? '0',
                          ) ??
                          0;
                      final taxAmount = salesPrice * taxRate / 100;
                      final amount = salesPrice + taxAmount - discountAmount;
                      controller.rowFields[index] = {
                        ...?controller.rowFields[index],
                        'quantity': value,
                        'salesPrice': salesPrice.toStringAsFixed(2),
                        'discountAmount': discountAmount.toStringAsFixed(2),
                        'taxAmount': taxAmount.toStringAsFixed(2),
                        'amount': amount.toStringAsFixed(2),
                      };
                      controller.salesPriceControllers[index]?.text = salesPrice
                          .toStringAsFixed(2);
                      controller.discountAmountControllers[index]?.text =
                          discountAmount.toStringAsFixed(2);
                      controller.taxAmountControllers[index]?.text = taxAmount
                          .toStringAsFixed(2);
                      controller.amountControllers[index]?.text = amount
                          .toStringAsFixed(2);
                      controller.ensureTempPurchaseItemsSize(index);
                      controller.tempPurchaseItems[index] = TempPurchaseItem(
                        customerId: controller.customerId.value ?? '',
                        purchaseId: '',
                        itemId: controller.rowFields[index]?['itemId'] ?? '',
                        itemName:
                            controller.rowFields[index]?['itemName'] ?? '',
                        purchaseQty: value,
                        pricePerUnit:
                            controller.rowFields[index]?['price'] ?? '0',
                        taxName: controller.rowFields[index]?['taxName'] ?? '',
                        taxId: controller.rowFields[index]?['taxId'] ?? '',
                        taxAmount: taxAmount.toStringAsFixed(2),
                        discountType:
                            controller.rowFields[index]?['discount'] ?? '',
                        discountAmount: discountAmount.toStringAsFixed(2),
                        totalCost: salesPrice.toStringAsFixed(2),
                        unit: controller.rowFields[index]?['unit'] ?? '',
                        taxRate: controller.rowFields[index]?['taxRate'] ?? '0',
                        batchNo: controller.rowFields[index]?['batchNo'] ?? '',
                        barcode: controller.rowFields[index]?['barcode'] ?? '',
                        serialNumbers:
                            controller.rowFields[index]?['serialNumbers'] ?? '',
                      );
                      controller.recalculateGrandTotal();
                      controller.recalculateTotalDiscount();
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
                        itemName:
                            controller.rowFields[index]?['itemName'] ?? '',
                        purchaseQty:
                            controller.rowFields[index]?['quantity'] ?? '0',
                        pricePerUnit:
                            controller.rowFields[index]?['price'] ?? '0',
                        taxName: controller.rowFields[index]?['taxName'] ?? '',
                        taxId: controller.rowFields[index]?['taxId'] ?? '',
                        taxAmount:
                            controller.rowFields[index]?['taxAmount'] ?? '0',
                        discountType:
                            controller.rowFields[index]?['discount'] ?? '',
                        discountAmount:
                            controller.rowFields[index]?['discountAmount'] ??
                            '0',
                        totalCost:
                            controller.rowFields[index]?['salesPrice'] ?? '0',
                        unit: value,
                        taxRate: controller.rowFields[index]?['taxRate'] ?? '0',
                        batchNo: controller.rowFields[index]?['batchNo'] ?? '',
                        barcode: controller.rowFields[index]?['barcode'] ?? '',
                        serialNumbers:
                            controller.rowFields[index]?['serialNumbers'] ?? '',
                      );
                    },
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Price/Unit']!,
                  child: Focus(
                    onFocusChange: (hasFocus) async {
                      if (!hasFocus &&
                          controller.priceControllers[index] != null) {
                        final oldPrice =
                            controller.priceOldValues[index] ?? '0';
                        controller.priceControllers[index]?.text = oldPrice;
                      }
                    },
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
                              controller.quantityControllers[index]?.text ??
                                  '0',
                            ) ??
                            0;
                        final salesPrice = quantity * price;
                        final percent =
                            double.tryParse(
                              controller
                                      .discountPercentControllers[index]
                                      ?.text ??
                                  '0',
                            ) ??
                            0;
                        final discountAmount = (salesPrice * percent) / 100;
                        final taxRate =
                            double.tryParse(
                              controller.rowFields[index]?['taxRate'] ?? '0',
                            ) ??
                            0;
                        final taxAmount = salesPrice * taxRate / 100;
                        final amount = salesPrice + taxAmount - discountAmount;
                        controller.rowFields[index] = {
                          ...?controller.rowFields[index],
                          'price': value,
                          'salesPrice': salesPrice.toStringAsFixed(2),
                          'taxAmount': taxAmount.toStringAsFixed(2),
                          'discountAmount': discountAmount.toStringAsFixed(2),
                          'amount': amount.toStringAsFixed(2),
                        };
                        controller.salesPriceControllers[index]?.text =
                            salesPrice.toStringAsFixed(2);
                        controller.discountAmountControllers[index]?.text =
                            discountAmount.toStringAsFixed(2);
                        controller.taxAmountControllers[index]?.text = taxAmount
                            .toStringAsFixed(2);
                        controller.amountControllers[index]?.text = amount
                            .toStringAsFixed(2);
                        controller.ensureTempPurchaseItemsSize(index);
                        controller.tempPurchaseItems[index] = TempPurchaseItem(
                          customerId: controller.customerId.value ?? '',
                          purchaseId: '',
                          itemId: controller.rowFields[index]?['itemId'] ?? '',
                          itemName:
                              controller.rowFields[index]?['itemName'] ?? '',
                          purchaseQty:
                              controller.rowFields[index]?['quantity'] ?? '0',
                          pricePerUnit: value,
                          taxName:
                              controller.rowFields[index]?['taxName'] ?? '',
                          taxId: controller.rowFields[index]?['taxId'] ?? '',
                          taxAmount: taxAmount.toStringAsFixed(2),
                          discountType:
                              controller.rowFields[index]?['discount'] ?? '',
                          discountAmount: discountAmount.toStringAsFixed(2),
                          totalCost: salesPrice.toStringAsFixed(2),
                          unit: controller.rowFields[index]?['unit'] ?? '',
                          taxRate:
                              controller.rowFields[index]?['taxRate'] ?? '0',
                          batchNo:
                              controller.rowFields[index]?['batchNo'] ?? '',
                          barcode:
                              controller.rowFields[index]?['barcode'] ?? '',
                          serialNumbers:
                              controller.rowFields[index]?['serialNumbers'] ??
                              '',
                        );
                        controller.recalculateGrandTotal();
                        controller.recalculateTotalDiscount();
                      },
                    ),
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Sale Price']!,
                  child: TextField(
                    controller: controller.salesPriceControllers[index],
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
                    readOnly: true,
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Disc %']!,
                  child: TextField(
                    controller: controller.discountPercentControllers[index],
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
                      final percent = double.tryParse(value) ?? 0;
                      final salesPrice =
                          double.tryParse(
                            controller.salesPriceControllers[index]?.text ??
                                '0',
                          ) ??
                          0;
                      final discountAmount = (salesPrice * percent) / 100;
                      final taxAmount =
                          double.tryParse(
                            controller.taxAmountControllers[index]?.text ?? '0',
                          ) ??
                          0;
                      final amount = salesPrice + taxAmount - discountAmount;
                      controller.discountAmountControllers[index]?.text =
                          discountAmount.toStringAsFixed(2);
                      controller.rowFields[index] = {
                        ...?controller.rowFields[index],
                        'discountPercent': value,
                        'discountAmount': discountAmount.toStringAsFixed(2),
                        'amount': amount.toStringAsFixed(2),
                      };
                      controller.amountControllers[index]?.text = amount
                          .toStringAsFixed(2);
                      controller.ensureTempPurchaseItemsSize(index);
                      controller.tempPurchaseItems[index] = TempPurchaseItem(
                        customerId: controller.customerId.value ?? '',
                        purchaseId: '',
                        itemId: controller.rowFields[index]?['itemId'] ?? '',
                        itemName:
                            controller.rowFields[index]?['itemName'] ?? '',
                        purchaseQty:
                            controller.rowFields[index]?['quantity'] ?? '0',
                        pricePerUnit:
                            controller.rowFields[index]?['price'] ?? '0',
                        taxName: controller.rowFields[index]?['taxName'] ?? '',
                        taxId: controller.rowFields[index]?['taxId'] ?? '',
                        taxAmount: taxAmount.toStringAsFixed(2),
                        discountType:
                            controller.rowFields[index]?['discount'] ?? '',
                        discountAmount: discountAmount.toStringAsFixed(2),
                        totalCost:
                            controller.rowFields[index]?['salesPrice'] ?? '0',
                        unit: controller.rowFields[index]?['unit'] ?? '',
                        taxRate: controller.rowFields[index]?['taxRate'] ?? '0',
                        batchNo: controller.rowFields[index]?['batchNo'] ?? '',
                        barcode: controller.rowFields[index]?['barcode'] ?? '',
                        serialNumbers:
                            controller.rowFields[index]?['serialNumbers'] ?? '',
                      );
                      controller.recalculateGrandTotal();
                      controller.recalculateTotalDiscount();
                    },
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Disc Amt']!,
                  child: TextField(
                    controller: controller.discountAmountControllers[index],
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
                      final amount = double.tryParse(value) ?? 0;
                      final salesPrice =
                          double.tryParse(
                            controller.salesPriceControllers[index]?.text ??
                                '0',
                          ) ??
                          0;
                      final percent = salesPrice > 0
                          ? (amount / salesPrice) * 100
                          : 0;
                      final taxAmount =
                          double.tryParse(
                            controller.taxAmountControllers[index]?.text ?? '0',
                          ) ??
                          0;
                      final totalAmount = salesPrice + taxAmount - amount;
                      controller.discountPercentControllers[index]?.text =
                          percent.toStringAsFixed(2);
                      controller.rowFields[index] = {
                        ...?controller.rowFields[index],
                        'discountPercent': percent.toStringAsFixed(2),
                        'discountAmount': value,
                        'amount': totalAmount.toStringAsFixed(2),
                      };
                      controller.amountControllers[index]?.text = totalAmount
                          .toStringAsFixed(2);
                      controller.ensureTempPurchaseItemsSize(index);
                      controller.tempPurchaseItems[index] = TempPurchaseItem(
                        customerId: controller.customerId.value ?? '',
                        purchaseId: '',
                        itemId: controller.rowFields[index]?['itemId'] ?? '',
                        itemName:
                            controller.rowFields[index]?['itemName'] ?? '',
                        purchaseQty:
                            controller.rowFields[index]?['quantity'] ?? '0',
                        pricePerUnit:
                            controller.rowFields[index]?['price'] ?? '0',
                        taxName: controller.rowFields[index]?['taxName'] ?? '',
                        taxId: controller.rowFields[index]?['taxId'] ?? '',
                        taxAmount: taxAmount.toStringAsFixed(2),
                        discountType:
                            controller.rowFields[index]?['discount'] ?? '',
                        discountAmount: value,
                        totalCost:
                            controller.rowFields[index]?['salesPrice'] ?? '0',
                        unit: controller.rowFields[index]?['unit'] ?? '',
                        taxRate: controller.rowFields[index]?['taxRate'] ?? '0',
                        batchNo: controller.rowFields[index]?['batchNo'] ?? '',
                        barcode: controller.rowFields[index]?['barcode'] ?? '',
                        serialNumbers:
                            controller.rowFields[index]?['serialNumbers'] ?? '',
                      );
                      controller.recalculateGrandTotal();
                      controller.recalculateTotalDiscount();
                    },
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Tax %']!,
                  child: GestureDetector(
                    onTap: () {
                      if (controller.showDropdownRows.contains(index)) {
                        controller.showDropdownRows.remove(index);
                      } else {
                        controller.showDropdownRows.add(index);
                      }
                      controller.rowFields.refresh();
                    },
                    child: controller.showDropdownRows.contains(index)
                        ? DropdownButtonFormField<String>(
                            value:
                                controller.rowFields[index]?['taxName'] ??
                                (controller.taxList.isNotEmpty
                                    ? controller.taxList.first['tax_name']
                                    : null),
                            isExpanded: true,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                            ),
                            items: controller.taxList.map((tax) {
                              return DropdownMenuItem<String>(
                                value: tax['tax_name'],
                                child: Text(
                                  '${tax['tax_name']} (${tax['tax']}%)',
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              final selectedTax = controller.taxList.firstWhere(
                                (e) => e['tax_name'] == value,
                                orElse: () => controller.taxList.isNotEmpty
                                    ? controller.taxList.first
                                    : {},
                              );
                              final salesPrice =
                                  double.tryParse(
                                    controller
                                            .salesPriceControllers[index]
                                            ?.text ??
                                        '0',
                                  ) ??
                                  0;
                              final taxRate =
                                  double.tryParse(
                                    selectedTax['tax']?.toString() ?? '0',
                                  ) ??
                                  0;
                              final taxAmount = salesPrice * taxRate / 100;
                              final discountAmount =
                                  double.tryParse(
                                    controller
                                            .discountAmountControllers[index]
                                            ?.text ??
                                        '0',
                                  ) ??
                                  0;
                              final amount =
                                  salesPrice + taxAmount - discountAmount;
                              controller.rowFields[index] = {
                                ...?controller.rowFields[index],
                                'taxName': value ?? '',
                                'taxRate':
                                    selectedTax['tax']?.toString() ?? '0',
                                'taxAmount': taxAmount.toStringAsFixed(2),
                                'taxId': selectedTax['id']?.toString() ?? '',
                                'amount': amount.toStringAsFixed(2),
                              };
                              controller.taxAmountControllers[index]?.text =
                                  taxAmount.toStringAsFixed(2);
                              controller.amountControllers[index]?.text = amount
                                  .toStringAsFixed(2);
                              controller.ensureTempPurchaseItemsSize(index);
                              controller
                                  .tempPurchaseItems[index] = TempPurchaseItem(
                                customerId: controller.customerId.value ?? '',
                                purchaseId: '',
                                itemId:
                                    controller.rowFields[index]?['itemId'] ??
                                    '',
                                itemName:
                                    controller.rowFields[index]?['itemName'] ??
                                    '',
                                purchaseQty:
                                    controller.rowFields[index]?['quantity'] ??
                                    '0',
                                pricePerUnit:
                                    controller.rowFields[index]?['price'] ??
                                    '0',
                                taxName: value ?? '',
                                taxId: selectedTax['id']?.toString() ?? '',
                                taxAmount: taxAmount.toStringAsFixed(2),
                                discountType:
                                    controller.rowFields[index]?['discount'] ??
                                    '',
                                discountAmount: discountAmount.toStringAsFixed(
                                  2,
                                ),
                                totalCost:
                                    controller
                                        .rowFields[index]?['salesPrice'] ??
                                    '0',
                                unit:
                                    controller.rowFields[index]?['unit'] ?? '',
                                taxRate: selectedTax['tax']?.toString() ?? '0',
                                batchNo:
                                    controller.rowFields[index]?['batchNo'] ??
                                    '',
                                barcode:
                                    controller.rowFields[index]?['barcode'] ??
                                    '',
                                serialNumbers:
                                    controller
                                        .rowFields[index]?['serialNumbers'] ??
                                    '',
                              );
                              controller.recalculateGrandTotal();
                              controller.recalculateTotalDiscount();
                              controller.rowFields.refresh();
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            child: Text(
                              '${controller.rowFields[index]?['taxName'] ?? ''} (${controller.rowFields[index]?['taxRate'] ?? '0'}%)',
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Tax Amt']!,
                  child: TextField(
                    controller: controller.taxAmountControllers[index],
                    readOnly: true,
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
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Amount']!,
                  child: TextField(
                    controller: controller.amountControllers[index],
                    readOnly: true,
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
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

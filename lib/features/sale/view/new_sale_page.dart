import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/controller/sales_create_controller.dart';
import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';
import 'package:greenbiller/features/sale/view/widgets/sales_page_bottom_section_widget.dart';
import 'package:greenbiller/features/sale/view/widgets/sales_top_section_widget.dart';

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
                      horizontal: 8,
                      vertical: 6,
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
                        if (controller.storeId.value != null) {
                          // controller.fetchAndUpdateData();
                        }
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
                          const columnCount = 11; // Adjusted to match columns
                          const itemFlex = 2.0;
                          const discountFlex = 1.0;
                          const totalFlex =
                              0.5 +
                              itemFlex +
                              0.75 +
                              0.75 +
                              1 +
                              1 +
                              1 +
                              discountFlex +
                              1 +
                              1 +
                              1.5;
                          final baseColumnWidth =
                              constraints.maxWidth / totalFlex;
                          final itemColumnWidth = baseColumnWidth * itemFlex;
                          final discountColumnWidth =
                              baseColumnWidth * (discountFlex / 2);

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: Column(
                                children: [
                                  HeaderRowWidget(
                                    baseColumnWidth: baseColumnWidth,
                                    itemColumnWidth: itemColumnWidth,
                                    discountColumnWidth: discountColumnWidth,
                                  ),
                                  ...List.generate(controller.rowCount.value, (
                                    index,
                                  ) {
                                    controller.initControllers(index);
                                    final itemName =
                                        controller
                                            .rowFields[index]?['itemName'] ??
                                        '';
                                    return DataRowWidget(
                                      index: index,
                                      itemName: itemName,
                                      baseColumnWidth: baseColumnWidth,
                                      itemColumnWidth: itemColumnWidth,
                                      discountColumnWidth: discountColumnWidth,
                                      controller: controller,
                                      inputWidget: input(rowIndex: index),
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
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          overflow: TextOverflow.ellipsis,
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
  final double baseColumnWidth;
  final double itemColumnWidth;
  final double discountColumnWidth;

  const HeaderRowWidget({
    super.key,
    required this.baseColumnWidth,
    required this.itemColumnWidth,
    required this.discountColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade200,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: HeaderCellWidget(text: "#", width: baseColumnWidth * 0.5),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Item", width: itemColumnWidth),
          ),
          Flexible(
            child: HeaderCellWidget(
              text: "SKUs",
              width: baseColumnWidth * 0.75,
            ),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Qty", width: baseColumnWidth * 0.75),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Unit", width: baseColumnWidth),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Price/Unit", width: baseColumnWidth),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Sale Price", width: baseColumnWidth),
          ),
          Flexible(
            child: SizedBox(
              width: baseColumnWidth,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.green.shade100),
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
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Amt",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Tax %", width: baseColumnWidth),
          ),
          Flexible(
            child: HeaderCellWidget(text: "Tax Amt", width: baseColumnWidth),
          ),
          Flexible(
            child: HeaderCellWidget(
              text: "Amount",
              width: baseColumnWidth * 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class DataRowWidget extends StatelessWidget {
  final int index;
  final String itemName;
  final double baseColumnWidth;
  final double itemColumnWidth;
  final double discountColumnWidth;
  final SalesController controller;
  final Widget inputWidget;

  const DataRowWidget({
    super.key,
    required this.index,
    required this.itemName,
    required this.baseColumnWidth,
    required this.itemColumnWidth,
    required this.discountColumnWidth,
    required this.controller,
    required this.inputWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.green.shade100),
          left: BorderSide(color: Colors.green.shade100),
          right: BorderSide(color: Colors.green.shade100),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth * 0.5,
              child: Center(child: Text("${index + 1}")),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: itemColumnWidth,
              child: itemName.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 10,
                      ),
                      child: Text(
                        itemName,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : inputWidget,
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth * 0.75,
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
                          'quantity':
                              controller.tempPurchaseItems[index].purchaseQty,
                          'serialNumbers':
                              controller.tempPurchaseItems[index].serialNumbers,
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
                        controller.updateRowCount();
                      },
                    ),
                    barrierDismissible: true,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  minimumSize: const Size(0, 0),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: Text(
                  '${(controller.rowFields[index]?['batchNo'] ?? '').split(',').where((s) => s.trim().isNotEmpty).length} SKU${(controller.rowFields[index]?['batchNo'] ?? '').split(',').where((s) => s.trim().isNotEmpty).length == 1 ? '' : 's'}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth * 0.75,
              child: TextField(
                controller: controller.quantityControllers[index],
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
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
                  final salesPrice = quantity * price;
                  final discountPercent =
                      double.tryParse(
                        controller.discountPercentControllers[index]?.text ??
                            '0',
                      ) ??
                      0;
                  final discountAmount = (salesPrice * discountPercent) / 100;
                  final taxRate =
                      double.tryParse(
                        controller.rowFields[index]?['taxRate'] ?? '0',
                      ) ??
                      0;
                  final taxAmount = salesPrice * taxRate / 100;
                  controller.rowFields[index] = {
                    ...?controller.rowFields[index],
                    'quantity': value,
                    'salesPrice': salesPrice.toStringAsFixed(2),
                    'discountAmount': discountAmount.toStringAsFixed(2),
                    'taxAmount': taxAmount.toStringAsFixed(2),
                  };
                  controller.salesPriceControllers[index]?.text = salesPrice
                      .toStringAsFixed(2);
                  controller.discountAmountControllers[index]?.text =
                      discountAmount.toStringAsFixed(2);
                  controller.recalculateGrandTotal();
                  controller.recalculateTotalDiscount();
                },
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth,
              child: TextField(
                controller: controller.unitControllers[index],
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  controller.rowFields[index] = {
                    ...?controller.rowFields[index],
                    'unit': value,
                  };
                },
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth,
              child: Focus(
                onFocusChange: (hasFocus) async {
                  if (!hasFocus && controller.priceControllers[index] != null) {
                    final oldPrice = controller.priceOldValues[index] ?? '0';
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
                      horizontal: 8,
                      vertical: 6,
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
                    final salesPrice = quantity * price;
                    final percent =
                        double.tryParse(
                          controller.discountPercentControllers[index]?.text ??
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
                    controller.rowFields[index] = {
                      ...?controller.rowFields[index],
                      'price': value,
                      'salesPrice': salesPrice.toStringAsFixed(2),
                      'taxAmount': taxAmount.toStringAsFixed(2),
                      'discountAmount': discountAmount.toStringAsFixed(2),
                    };
                    controller.salesPriceControllers[index]?.text = salesPrice
                        .toStringAsFixed(2);
                    controller.discountAmountControllers[index]?.text =
                        discountAmount.toStringAsFixed(2);
                    controller.recalculateGrandTotal();
                    controller.recalculateTotalDiscount();
                  },
                ),
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth,
              child: TextField(
                controller: controller.salesPriceControllers[index],
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                ),
                readOnly: true,
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: discountColumnWidth,
              child: TextField(
                controller: controller.discountPercentControllers[index],
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  final percent = double.tryParse(value) ?? 0;
                  final salesPrice =
                      double.tryParse(
                        controller.salesPriceControllers[index]?.text ?? '0',
                      ) ??
                      0;
                  final discountAmount = (salesPrice * percent) / 100;
                  controller.discountAmountControllers[index]?.text =
                      discountAmount.toStringAsFixed(2);
                  controller.rowFields[index] = {
                    ...?controller.rowFields[index],
                    'discountPercent': value,
                    'discountAmount': discountAmount.toStringAsFixed(2),
                  };
                  controller.recalculateGrandTotal();
                  controller.recalculateTotalDiscount();
                },
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: discountColumnWidth,
              child: TextField(
                controller: controller.discountAmountControllers[index],
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0;
                  final salesPrice =
                      double.tryParse(
                        controller.salesPriceControllers[index]?.text ?? '0',
                      ) ??
                      0;
                  final percent = salesPrice > 0
                      ? (amount / salesPrice) * 100
                      : 0;
                  controller.discountPercentControllers[index]?.text = percent
                      .toStringAsFixed(2);
                  controller.rowFields[index] = {
                    ...?controller.rowFields[index],
                    'discountPercent': percent.toStringAsFixed(2),
                    'discountAmount': value,
                  };
                  controller.recalculateGrandTotal();
                  controller.recalculateTotalDiscount();
                },
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth,
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
                            horizontal: 8,
                            vertical: 6,
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
                                controller.salesPriceControllers[index]?.text ??
                                    '0',
                              ) ??
                              0;
                          final taxRate =
                              double.tryParse(
                                selectedTax['tax']?.toString() ?? '0',
                              ) ??
                              0;
                          final taxAmount = salesPrice * taxRate / 100;
                          controller.rowFields[index] = {
                            ...?controller.rowFields[index],
                            'taxName': value ?? '',
                            'taxRate': selectedTax['tax']?.toString() ?? '0',
                            'taxAmount': taxAmount.toStringAsFixed(2),
                            'taxId': selectedTax['id']?.toString() ?? '',
                          };
                          controller.recalculateGrandTotal();
                          controller.rowFields.refresh();
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
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
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth,
              child: TextField(
                controller: TextEditingController(
                  text: controller.rowFields[index]?['taxAmount'] ?? '',
                ),
                readOnly: true,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Flexible(
            child: DataCellWidget(
              width: baseColumnWidth * 1.5,
              child: TextField(
                controller: TextEditingController(
                  text: (() {
                    final salesPrice =
                        double.tryParse(
                          controller.salesPriceControllers[index]?.text ?? '0',
                        ) ??
                        0;
                    final discountAmount =
                        double.tryParse(
                          controller.rowFields[index]?['discountAmount'] ?? '0',
                        ) ??
                        0;
                    final taxAmount =
                        double.tryParse(
                          controller.rowFields[index]?['taxAmount'] ?? '0',
                        ) ??
                        0;
                    final amount = salesPrice + taxAmount - discountAmount;
                    return amount.toStringAsFixed(2);
                  })(),
                ),
                readOnly: true,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkuEditDialog extends StatelessWidget {
  final TempPurchaseItem item;
  final VoidCallback onSave;

  SkuEditDialog({super.key, required this.item, required this.onSave});

  final TextEditingController serialController = TextEditingController();
  final RxList<String> serials = RxList<String>();

  @override
  Widget build(BuildContext context) {
    // Initialize serials from item
    serials.value = item.serialNumbers
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.qr_code, color: Colors.green.shade700, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Add Serial Numbers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: serialController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Scan or Enter Serial Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.green.shade600,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final value = serialController.text.trim();
                      if (value.isNotEmpty && !serials.contains(value)) {
                        serials.add(value);
                        serialController.clear();
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty && !serials.contains(value.trim())) {
                    serials.add(value.trim());
                    serialController.clear();
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Item: ${item.itemName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Price: ₹${item.pricePerUnit}'),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: serials.isEmpty
                    ? const Center(
                        child: Text(
                          'No serial numbers added',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: serials.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              serials[index],
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                serials.removeAt(index);
                              },
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Text('Total Items: ${serials.length}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      item.purchaseQty = serials.length.toString();
                      item.batchNo = serials.join(',');
                      item.serialNumbers = serials.join(',');

                      double price = double.tryParse(item.pricePerUnit) ?? 0;
                      item.totalCost = (serials.length * price).toStringAsFixed(
                        2,
                      );

                      onSave();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

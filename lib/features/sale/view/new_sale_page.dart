import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/sale/controller/sales_create_controller.dart';
import 'package:greenbiller/features/sale/model/temp_purchase_item.dart';
import 'package:greenbiller/features/sale/view/widgets/sales_page_bottom_section_widget.dart';
import 'package:greenbiller/features/sale/view/widgets/sales_top_section_widget.dart';
import 'package:greenbiller/features/sale/view/widgets/sku_edit_dialog.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
                            'Serial No': 150.0,
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
                          print(totalTableWidth);
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

                            // Save copies of rowFields and tempPurchaseItems
                            final rowFieldsCopy =
                                Map<int, Map<String, String>>.from(
                                  controller.rowFields,
                                );
                            final tempPurchaseItemsCopy =
                                List<TempPurchaseItem>.from(
                                  controller.tempPurchaseItems,
                                );

                            // Call saveSale to store data in the backend
                            await controller.saveSale(
                              print: true,
                              context: context,
                            );

                            // Check if save was successful
                            if (!controller.isLoadingSavePrint.value) {
                              // Rebuild rowFields from tempPurchaseItemsCopy
                              controller.rowFields.clear();
                              for (
                                int i = 0;
                                i < tempPurchaseItemsCopy.length;
                                i++
                              ) {
                                final item = tempPurchaseItemsCopy[i];
                                if (item.itemName.isNotEmpty) {
                                  controller.rowFields[i] = {
                                    'itemName': item.itemName,
                                    'itemId': item.itemId,
                                    'quantity': item.purchaseQty,
                                    'price': item.pricePerUnit,
                                    'salesPrice': item.totalCost,
                                    'discountAmount': item.discountAmount,
                                    'taxAmount': item.taxAmount,
                                    'taxName': item.taxName,
                                    'taxId': item.taxId,
                                    'taxRate': item.taxRate,
                                    'discount': item.discountType,
                                    'unit': item.unit,
                                    'batchNo': item.batchNo,
                                    'barcode': item.barcode,
                                    'serialNumbers': item.serialNumbers,
                                  };
                                  print(
                                    'Restored row $i: itemName=${item.itemName}',
                                  );
                                }
                              }
                              controller.rowFields.refresh();
                              print(
                                'rowFields after restore: ${controller.rowFields}',
                              );
                              print(
                                'tempPurchaseItems after saveSale: ${controller.tempPurchaseItems}',
                              );

                              // Print the bill directly
                              if (context.mounted) {
                                await printBill(
                                  context,
                                  selectedStore,
                                  selectedCustomer,
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Cant start print and save, Contact Admin',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
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

  Future<void> printBill(
    BuildContext context,
    dynamic storeData,
    dynamic customerData,
  ) async {
    final pdf = pw.Document();
    final defaultPrinter = storeData?['default_printer'] ?? 'a4';
    final isA4 = defaultPrinter == 'a4';

    // Helper function to get store data with fallback
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

    // Common table header
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
            'SKU',
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
            'Disc',
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
            'Tax',
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
            'Total',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );

    // Common table data rows
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
                  row['batchNo']?.toString() ?? '-',
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
                  '${getStoreValue('currency_symbol')}${double.tryParse(row['discountAmount']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
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
                  '${getStoreValue('currency_symbol')}${double.tryParse(row['taxAmount']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
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
                  '${getStoreValue('currency_symbol')}${double.tryParse(row['amount']?.toString() ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: isA4 ? 10 : 7),
                ),
              ),
            ],
          );
        })
        .toList();

    // Common totals section
    final totalsSection = [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Subtotal:', style: pw.TextStyle(fontSize: isA4 ? 12 : 7)),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.tempSubTotal.value.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
        ],
      ),
      pw.SizedBox(height: isA4 ? 8 : 2),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Total Tax:', style: pw.TextStyle(fontSize: isA4 ? 12 : 7)),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.tempTotalTax.value.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
        ],
      ),
      pw.SizedBox(height: isA4 ? 8 : 2),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total Discount:',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.tempTotalDiscount.value.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
        ],
      ),
      pw.SizedBox(height: isA4 ? 8 : 2),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Other Charges:',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.otherChargesController.text.isNotEmpty ? double.tryParse(controller.otherChargesController.text)?.toStringAsFixed(2) ?? '0.00' : '0.00'}',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
        ],
      ),
      pw.SizedBox(height: isA4 ? 8 : 2),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Grand Total:',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
          ),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.grandTotal.value.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: isA4 ? 12 : 7,
            ),
          ),
        ],
      ),
      pw.SizedBox(height: isA4 ? 8 : 2),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Paid Amount:', style: pw.TextStyle(fontSize: isA4 ? 12 : 7)),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.paidAmountController.text.isNotEmpty ? double.tryParse(controller.paidAmountController.text)?.toStringAsFixed(2) ?? '0.00' : '0.00'}',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
          ),
        ],
      ),
      pw.SizedBox(height: isA4 ? 8 : 2),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Balance:', style: pw.TextStyle(fontSize: isA4 ? 12 : 7)),
          pw.Text(
            '${getStoreValue('currency_symbol')}${controller.balance.value.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: isA4 ? 12 : 7),
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
                    // A4 Header
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
                              'Invoice',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Bill No: ${controller.saleBillConrtoller.text}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Date: ${controller.getCurrentDateFormatted()}',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Customer: ${controller.customerController.text.isNotEmpty ? controller.customerController.text : 'Walk-in Customer'}',
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

                    // A4 Itemized List
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
                        0: const pw.FixedColumnWidth(30), // #
                        1: const pw.FlexColumnWidth(3), // Item
                        2: const pw.FixedColumnWidth(60), // SKU
                        3: const pw.FixedColumnWidth(50), // Qty
                        4: const pw.FixedColumnWidth(60), // Price
                        5: const pw.FixedColumnWidth(60), // Disc
                        6: const pw.FixedColumnWidth(60), // Tax
                        7: const pw.FixedColumnWidth(80), // Total
                      },
                      children: [tableHeader, ...tableRows],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Divider(thickness: 1),

                    // A4 Totals
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: totalsSection,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Divider(thickness: 1),

                    // A4 Footer
                    pw.Text(
                      'Thank you for your purchase!',
                      style: const pw.TextStyle(fontSize: 12),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Terms & Conditions: Payment is due upon receipt. Please contact us at ${getStoreValue('store_email')} for any inquiries.',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                )
              : pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Thermal Header
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
                      'Customer: ${controller.customerController.text.isNotEmpty ? controller.customerController.text : 'Walk-in Customer'}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                    pw.Text(
                      'Bill No: ${controller.saleBillConrtoller.text}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Divider(thickness: 0.5),

                    // Thermal Itemized List
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
                        0: const pw.FixedColumnWidth(12), // #
                        1: const pw.FixedColumnWidth(60), // Item
                        2: const pw.FixedColumnWidth(25), // SKU
                        3: const pw.FixedColumnWidth(18), // Qty
                        4: const pw.FixedColumnWidth(25), // Price
                        5: const pw.FixedColumnWidth(20), // Disc
                        6: const pw.FixedColumnWidth(20), // Tax
                        7: const pw.FixedColumnWidth(30), // Total
                      },
                      children: [tableHeader, ...tableRows],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Divider(thickness: 0.5),

                    // Thermal Totals
                    ...totalsSection,
                    pw.SizedBox(height: 5),
                    pw.Divider(thickness: 0.5),

                    // Thermal Footer
                    pw.Text(
                      'Thank you for your purchase!',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                );
        },
      ),
    );

    // Sanitize bill number to ensure valid file name
    final billNumber = controller.saleBillConrtoller.text.isNotEmpty
        ? controller.saleBillConrtoller.text.replaceAll(RegExp(r'[^\w\-]'), '_')
        : 'invoice';
    final fileName = 'Bill_$billNumber.pdf';

    // Open print dialog with customized file name
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: fileName,
      format: isA4 ? PdfPageFormat.a4 : PdfPageFormat.roll80,
    );
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
              HeaderCellWidget(text: "#", width: columnWidths['#'] ?? 50),
              HeaderCellWidget(
                text: "Item",
                width: columnWidths['Item'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Serial No",
                width: columnWidths['SKUs'] ?? 150,
              ),
              HeaderCellWidget(text: "Qty", width: columnWidths['Qty'] ?? 150),
              HeaderCellWidget(
                text: "Unit",
                width: columnWidths['Unit'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Price/Unit",
                width: columnWidths['Price/Unit'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Sale Price",
                width: columnWidths['Sale Price'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Disc %",
                width: columnWidths['Disc %'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Disc Amt",
                width: columnWidths['Disc Amt'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Tax %",
                width: columnWidths['Tax %'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Tax Amt",
                width: columnWidths['Tax Amt'] ?? 150,
              ),
              HeaderCellWidget(
                text: "Amount",
                width: columnWidths['Amount'] ?? 150,
              ),
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
                  width: columnWidths['#'] ?? 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    child: Center(child: Text("${index + 1}")),
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Item'] ?? 150,
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
                  width: columnWidths['Serial No'] ?? 150,
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
                        '$skuCount Serial No${skuCount == 1 ? '' : 's'}',
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ),
                ),
                DataCellWidget(
                  width: columnWidths['Qty'] ?? 150,
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
                  width: columnWidths['Unit'] ?? 150,
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
                  width: columnWidths['Price/Unit'] ?? 150,
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
                  width: columnWidths['Sale Price'] ?? 150,
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
                  width: columnWidths['Disc %'] ?? 150,
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
                  width: columnWidths['Disc Amt'] ?? 150,
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
                                (controller.taxList.toList().any(
                                  (tax) =>
                                      tax['tax_name'] ==
                                      controller.rowFields[index]?['taxName'],
                                ))
                                ? controller.rowFields[index]!['taxName']
                                : (controller.taxList.isNotEmpty
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
                                  '${tax['tax']}%',
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

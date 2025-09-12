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

class QuotationCreatePage extends GetView<QuotationController> {
  const QuotationCreatePage({super.key});

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
        // Update itemController after selection
        final itemController = controller.itemInputControllers[rowIndex] ??
            TextEditingController();
        itemController.text = item.itemName;
        controller.onItemSelected(item, rowIndex);
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            // Initialize the controller from QuotationController
            final itemController = controller.itemInputControllers[rowIndex] ??
                TextEditingController();
            // Sync initial text
            textEditingController.text = itemController.text;
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
                  // Update itemController on submission
                  itemController.text = exactMatches.first.itemName;
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
                          // Define fixed column widths
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

                            // Call saveQuotation to store data in the backend
                            await controller.saveQuotation(context: context);

                            // Print the quotation if save was successful
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

    // Table header
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

    // Table data rows
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

    // Totals section
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
                        2: const pw.FixedColumnWidth(50), // Qty
                        3: const pw.FixedColumnWidth(60), // Unit
                        4: const pw.FixedColumnWidth(60), // Price
                        5: const pw.FixedColumnWidth(80), // Subtotal
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
                      'Customer: ${controller.customerController.text.isNotEmpty ? controller.customerController.text : 'Unknown Customer'}',
                      style: const pw.TextStyle(fontSize: 7),
                    ),
                    pw.Text(
                      'Quote No: ${controller.quotationNumber.value}',
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
                        2: const pw.FixedColumnWidth(18), // Qty
                        3: const pw.FixedColumnWidth(25), // Unit
                        4: const pw.FixedColumnWidth(25), // Price
                        5: const pw.FixedColumnWidth(30), // Subtotal
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
                      'Thank you for your inquiry!',
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                );
        },
      ),
    );

    // Sanitize quote number to ensure valid file name
    final quoteNumber = controller.quotationNumber.value.isNotEmpty
        ? controller.quotationNumber.value.replaceAll(
            RegExp(r'[^\w\-]'),
            '_',
          )
        : 'quotation';
    final fileName = 'Quote_$quoteNumber.pdf';

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
      color: accentColor.withOpacity(0.2),
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
              HeaderCellWidget(text: "Qty", width: columnWidths['Qty']!),
              HeaderCellWidget(text: "Unit", width: columnWidths['Unit']!),
              HeaderCellWidget(
                text: "Price/Unit",
                width: columnWidths['Price/Unit']!,
              ),
              HeaderCellWidget(
                text: "Subtotal",
                width: columnWidths['Subtotal']!,
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
    // Ensure controllers are initialized
    controller.initControllers(index);
    return Obx(() {
      final itemName = controller.rowFields[index]?['itemName'] ?? '';
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
                    controller: controller.quantityControllers[index] ??
                        TextEditingController(text: '1.0'),
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
                        itemName:
                            controller.rowFields[index]?['itemName'] ?? '',
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
                    controller: controller.unitControllers[index] ??
                        TextEditingController(text: ''),
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
                    controller: controller.priceControllers[index] ??
                        TextEditingController(text: '0'),
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
                        itemName:
                            controller.rowFields[index]?['itemName'] ?? '',
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
    });
  }
}
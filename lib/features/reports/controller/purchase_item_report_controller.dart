import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/reports/model/purchase_item_report_model.dart';
import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class PurchaseItemReportController extends GetxController {
  final DioClient _dioClient = DioClient();

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final selectedStoreId = RxnString();
  final selectedItemId = RxnString();
  final storesList = <StoreData>[].obs;
  final itemsList = <Item>[].obs;
  final purchaseData = <SinglePurchaseItemReportModel>[].obs;
  final isLoading = false.obs;
  final isItemLoading = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStores();
    ever(selectedStoreId, (_) => _onStoreChanged());
  }

  Future<void> loadStores() async {
    try {
      final response = await _dioClient.dio.get(viewStoreUrl);
      if (response.statusCode == 200) {
        final storeModel = StoreModel.fromJson(response.data);
        storesList.assignAll(storeModel.data ?? []);
        print('Loaded ${storesList.length} stores');
      } else {
        throw Exception('Failed to load stores: ${response.statusMessage}');
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Error loading stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching stores: $e');
    }
  }

  Future<void> loadItems(String storeId) async {
    if (storeId.isEmpty) return;
    isItemLoading.value = true;
    try {
      final response = await _dioClient.dio.get(
        purchaseItemViewUrl,
        queryParameters: {'store_id': storeId}, // ✅ send as query param
      );

      if (response.statusCode == 200) {
        final purchaseItemModel = ItemModel.fromJson(response.data);
        final Map<String, Item> uniqueItems = {};
        for (var item in purchaseItemModel.data ?? []) {
          final key = '${item.itemName}_${item.batchNo}';
          if (!uniqueItems.containsKey(key)) {
            uniqueItems[key] = item;
          }
        }
        itemsList.assignAll(uniqueItems.values.toList());
        print('Loaded ${itemsList.length} unique items');
      } else {
        throw Exception('Failed to load items: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Error loading items: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching items: $e');
    } finally {
      isItemLoading.value = false;
    }
  }

  Future<void> generateReport() async {
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select both start and end dates',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (endDate.value!.isBefore(startDate.value!)) {
      Get.snackbar(
        'Error',
        'End date cannot be before start date',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedStoreId.value == null || selectedItemId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a store and an item',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedStartDate = dateFormat.format(startDate.value!);
      final formattedEndDate = dateFormat.format(endDate.value!);

      final response = await _dioClient.dio.post(
        purchaseItemSummaryUrl,
        data: {
          'from_date': formattedStartDate,
          'to_date': formattedEndDate,
          'store_id': selectedStoreId.value,
          'item_id': selectedItemId.value,
        },
      );

      if (response.statusCode == 200) {
        final reportModel = PurchaseItemReportModel.fromJson(response.data);
        if (reportModel.data == null) {
          throw Exception('No data received from server');
        }
        purchaseData.assignAll(reportModel.data!);
        Get.snackbar(
          'Success',
          'Purchase item report generated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print('Report generated with ${purchaseData.length} items');
      } else {
        throw Exception('Failed to load report: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Error generating report: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error generating report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStartDate) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
      print('${isStartDate ? 'Start' : 'End'} date selected: $picked');
    }
  }

  void _onStoreChanged() {
    if (selectedStoreId.value == null) {
      selectedItemId.value = null;
      itemsList.clear();
    } else {
      loadItems(selectedStoreId.value!);
    }
  }

  Future<File> generatePurchaseItemPDF({
    required List<SinglePurchaseItemReportModel> data,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Purchase Item Report',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                  color: PdfColors.blue,
                  font: ttf,
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Period: ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    'Generated: ${DateTime.now().toString().split(' ')[0]}',
                    style: pw.TextStyle(font: ttf),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.blue),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.2),
              1: const pw.FlexColumnWidth(1.5),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(1.5),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue),
                children: [
                  _buildHeaderCell('Date', ttf),
                  _buildHeaderCell('Store', ttf),
                  _buildHeaderCell('Item', ttf),
                  _buildHeaderCell('Price/Unit', ttf),
                  _buildHeaderCell('Quantity', ttf),
                  _buildHeaderCell('Total', ttf),
                ],
              ),
              ...data.map(
                (item) => pw.TableRow(
                  children: [
                    _buildDataCell(
                      item.salesDate?.toString().split(' ')[0] ?? '-',
                      ttf,
                      alignment: pw.Alignment.center,
                    ),
                    _buildDataCell(
                      item.storeName ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    _buildDataCell(
                      item.itemName ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    _buildDataCell(
                      '₹${item.pricePerUnit ?? '0.00'}',
                      ttf,
                      alignment: pw.Alignment.centerRight,
                    ),
                    _buildDataCell(
                      item.purchaseQty ?? '-',
                      ttf,
                      alignment: pw.Alignment.center,
                    ),
                    _buildDataCell(
                      '₹${item.total?.toString() ?? '0.00'}',
                      ttf,
                      alignment: pw.Alignment.centerRight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Summary',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                    color: PdfColors.blue,
                    font: ttf,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Items:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                      data.length.toString(),
                      style: pw.TextStyle(font: ttf),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Quantity:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                      data
                          .fold<int>(
                            0,
                            (sum, item) =>
                                sum +
                                (int.tryParse(item.purchaseQty ?? '0') ?? 0),
                          )
                          .toString(),
                      style: pw.TextStyle(font: ttf),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Amount:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (double.tryParse(item.total?.toString() ?? '0') ?? 0)).toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by GreenBiller',
                style: pw.TextStyle(
                  color: PdfColors.blue,
                  fontSize: 10,
                  font: ttf,
                ),
              ),
              pw.Container(
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: pw.Text(
                  'Digitally Generated',
                  style: pw.TextStyle(fontSize: 8, font: ttf),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/purchase_item_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generatePurchaseItemCSV({
    required List<SinglePurchaseItemReportModel> data,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<List<dynamic>> rows = [];
    rows.add(['Date', 'Store', 'Item', 'Price/Unit', 'Quantity', 'Total']);
    for (final item in data) {
      rows.add([
        item.salesDate?.toString().split(' ')[0] ?? '-',
        item.storeName ?? '-',
        item.itemName ?? '-',
        '₹${item.pricePerUnit ?? '0.00'}',
        item.purchaseQty ?? '-',
        '₹${item.total?.toString() ?? '0.00'}',
      ]);
    }
    String csvData = const ListToCsvConverter().convert(rows);
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/purchase_item_${DateTime.now().millisecondsSinceEpoch}.csv",
    );
    await file.writeAsString(csvData);
    return file;
  }

  pw.Widget _buildHeaderCell(String text, pw.Font ttf) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          font: ttf,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildDataCell(
    String text,
    pw.Font ttf, {
    PdfColor? color,
    pw.Alignment alignment = pw.Alignment.center,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Container(
        alignment: alignment,
        child: pw.Text(
          text,
          style: pw.TextStyle(color: color ?? PdfColors.black, font: ttf),
          textAlign: alignment == pw.Alignment.centerLeft
              ? pw.TextAlign.left
              : alignment == pw.Alignment.centerRight
              ? pw.TextAlign.right
              : pw.TextAlign.center,
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/reports/model/sale_item_report_model.dart';
import 'package:greenbiller/features/store/model/store_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class SaleByItemReportController extends GetxController {
  final DioClient _dioClient = DioClient();

  final selectedStartDate = Rxn<DateTime>();
  final selectedEndDate = Rxn<DateTime>();
  final selectedStoreId = RxnString();
  final selectedItemId = RxnString();
  final storesList = <StoreData>[].obs;
  final itemsList = <dynamic>[].obs;
  final saleItemReport = Rxn<SaleItemReportModel>();
  final isLoadingStores = false.obs;
  final isLoadingItems = false.obs;
  final isLoadingReport = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  Future<void> fetchStores() async {
    isLoadingStores.value = true;
    hasError.value = false;
    try {
      final response = await _dioClient.dio.get(
        viewStoreUrl, // Assumed constant from api_constants.dart
      );

      if (response.statusCode == 200) {
        final storeModel = StoreModel.fromJson(response.data);
        storesList.assignAll(storeModel.data ?? []);
        // Reset selected store if not in list
        if (selectedStoreId.value != null &&
            !storesList.any(
              (store) => store.id?.toString() == selectedStoreId.value,
            )) {
          selectedStoreId.value = null;
          itemsList.clear();
          selectedItemId.value = null;
        }
      } else {
        throw Exception('Failed to fetch stores: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Error fetching stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> fetchItems(String storeId) async {
    isLoadingItems.value = true;
    hasError.value = false;
    try {
      final response = await _dioClient.dio.get(
        '$viewAllItemUrl/$storeId', // Assumed constant from api_constants.dart
      );

      if (response.statusCode == 200) {
        final itemModel = ItemModel.fromJson(response.data);
        itemsList.assignAll(itemModel.data ?? []);
        // Reset selected item if not in list
        if (selectedItemId.value != null &&
            !itemsList.any(
              (item) => item.id.toString() == selectedItemId.value,
            )) {
          selectedItemId.value = null;
        }
      } else {
        throw Exception('Failed to fetch items: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Error fetching items: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingItems.value = false;
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
        selectedStartDate.value = picked;
      } else {
        selectedEndDate.value = picked;
      }
    }
  }

  Future<void> generateReport() async {
    if (selectedStartDate.value == null ||
        selectedEndDate.value == null ||
        selectedStoreId.value == null ||
        selectedItemId.value == null) {
      Get.snackbar(
        'Error',
        'Please select all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingReport.value = true;
    hasError.value = false;
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedStartDate = dateFormat.format(selectedStartDate.value!);
      final formattedEndDate = dateFormat.format(selectedEndDate.value!);

      final response = await _dioClient.dio.post(
        salesItemSummaryUrl,
        data: {
          'from_date': formattedStartDate,
          'to_date': formattedEndDate,
          'store_id': selectedStoreId.value,
          'item_id': selectedItemId.value,
        },
      );

      if (response.statusCode == 200) {
        saleItemReport.value = SaleItemReportModel.fromJson(response.data);
        if (saleItemReport.value?.data == null) {
          throw Exception('No data received from server');
        }
      } else {
        throw Exception(
          'Failed to fetch sale item report: ${response.statusMessage}',
        );
      }
    } catch (e,stack) {
      print(stack);
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to generate report: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingReport.value = false;
    }
  }

  Future<File> generateSaleItemPDF({
    required List<SIngleSaleItemReportModel> data,
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
                'Sale Item Report',
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
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Date',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Store',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Item',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Price/Unit',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Quantity',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(
                      'Total',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                ],
              ),
              ...data.map(
                (item) => pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        item.salesDate?.toString().split(' ')[0] ?? '-',
                        style: pw.TextStyle(font: ttf),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        item.storeName ?? '-',
                        style: pw.TextStyle(font: ttf),
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        item.itemName ?? '-',
                        style: pw.TextStyle(font: ttf),
                        textAlign: pw.TextAlign.left,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        '₹${item.pricePerUnit ?? '0.00'}',
                        style: pw.TextStyle(font: ttf),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        item.salesQty.toString(),
                        style: pw.TextStyle(font: ttf),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        '₹${item.total?.toString() ?? '0.00'}',
                        style: pw.TextStyle(font: ttf),
                        textAlign: pw.TextAlign.right,
                      ),
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
                            (sum, item) => sum + (item.salesQty ?? 0),
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
      "${output.path}/sale_item_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generateSaleItemCSV({
    required List<SIngleSaleItemReportModel> data,
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
        item.salesQty ?? '-',
        '₹${item.total?.toString() ?? '0.00'}',
      ]);
    }
    String csvData = const ListToCsvConverter().convert(rows);
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/sale_item_${DateTime.now().millisecondsSinceEpoch}.csv",
    );
    await file.writeAsString(csvData);
    return file;
  }
}

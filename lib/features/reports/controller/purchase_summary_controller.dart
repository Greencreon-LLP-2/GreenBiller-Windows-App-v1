import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/reports/model/purchase_summary_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class PurchaseSummaryController extends GetxController {
  final DioClient _dioClient = DioClient();

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final purchaseData = <SinglePurchaseSummaryModel>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
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

    isLoading.value = true;
    hasError.value = false;
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedStartDate = dateFormat.format(startDate.value!);
      final formattedEndDate = dateFormat.format(endDate.value!);

      final response = await _dioClient.dio.post(
        purchaseSummaryUrl,
        data: {'from_date': formattedStartDate, 'to_date': formattedEndDate},
      );

      if (response.statusCode == 200) {
        final purchaseSummary = PurchaseSummaryModel.fromJson(response.data);
        if (purchaseSummary.data == null) {
          throw Exception('No data received from server');
        }
        purchaseData.assignAll(purchaseSummary.data!);
        Get.snackbar(
          'Success',
          'Purchase summary generated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(
          'Failed to load purchase summary: ${response.statusMessage}',
        );
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Failed to generate report: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<File> generatePurchaseSummaryPDF({
    required List<SinglePurchaseSummaryModel> data,
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
                'Purchase Summary Report',
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
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
              6: const pw.FlexColumnWidth(1.5),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.blue),
                children: [
                  _buildHeaderCell('Purchase Date', ttf),
                  _buildHeaderCell('Purchase ID', ttf),
                  _buildHeaderCell('Store Name', ttf),
                  _buildHeaderCell('Supplier Name', ttf),
                  _buildHeaderCell('Total Amount', ttf),
                  _buildHeaderCell('Paid Amount', ttf),
                  _buildHeaderCell('Balance', ttf),
                ],
              ),
              ...data.map(
                (item) => pw.TableRow(
                  children: [
                    _buildDataCell(
                      item.purchaseDate?.toString().split(' ')[0] ?? '-',
                      ttf,
                      alignment: pw.Alignment.center,
                    ),
                    _buildDataCell(
                      item.id.toString(),
                      ttf,
                      alignment: pw.Alignment.center,
                    ),
                    _buildDataCell(
                      item.storeName ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    _buildDataCell(
                      item.supplierName ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    _buildDataCell(
                      item.grandTotal ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerRight,
                    ),
                    _buildDataCell(
                      item.paidAmount ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerRight,
                    ),
                    _buildDataCell(
                      item.balance?.toString() ?? '-',
                      ttf,
                      color: (item.balance ?? 0) > 0
                          ? PdfColors.red
                          : PdfColors.green,
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
                    pw.Text('Total Purchases:', style: pw.TextStyle(font: ttf)),
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
                    pw.Text('Total Amount:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (double.tryParse(item.grandTotal ?? '0') ?? 0)).toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Paid:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (double.tryParse(item.paidAmount ?? '0') ?? 0)).toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Balance:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (item.balance ?? 0)).toStringAsFixed(2)}',
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
      "${output.path}/purchase_summary_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generatePurchaseSummaryCSV({
    required List<SinglePurchaseSummaryModel> data,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<List<dynamic>> rows = [];
    rows.add([
      'Purchase Date',
      'Purchase ID',
      'Store Name',
      'Supplier Name',
      'Total Amount',
      'Paid Amount',
      'Balance',
    ]);
    for (final item in data) {
      rows.add([
        item.purchaseDate?.toString().split(' ')[0] ?? '-',
        item.id.toString(),
        item.storeName ?? '-',
        item.supplierName ?? '-',
        item.grandTotal ?? '-',
        item.paidAmount ?? '-',
        item.balance?.toString() ?? '-',
      ]);
    }
    String csvData = const ListToCsvConverter().convert(rows);
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/purchase_summary_${DateTime.now().millisecondsSinceEpoch}.csv",
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

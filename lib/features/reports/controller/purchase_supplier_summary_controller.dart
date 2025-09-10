import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/parties/models/supplier_model.dart';
import 'package:greenbiller/features/reports/model/purchase_supplier_summary_model.dart';
import 'package:greenbiller/features/store/model/store_model.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class PurchaseSupplierSummaryController extends GetxController {
  final DioClient _dioClient = DioClient();

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final selectedStore = RxnString();
  final selectedSupplier = RxnString();
  final storeMap = <String, int>{}.obs;
  final supplierMap = <String, String>{}.obs;
  final selectedStoreId = RxnInt();
  final selectedSupplierId = RxnString();
  final purchaseData = <SignlePurchaseSummaryBySupplierModel>[].obs;
  final isLoading = false.obs;
  final isLoadingSuppliers = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();

    loadStores();

    ever(selectedStoreId, (_) => _onStoreChanged());
    ever(storeMap, (_) => _resetStoreIfInvalid());
    ever(supplierMap, (_) => _resetSupplierIfInvalid());
  }

  Future<void> loadStores() async {
    try {
      final response = await _dioClient.dio.get(viewStoreUrl);
      if (response.statusCode == 200) {
        final storeModel = StoreModel.fromJson(response.data);
        final newMap = <String, int>{};
        for (var store in storeModel.data ?? []) {
          if (store.id != null && store.storeName != null) {
            newMap[store.storeName!] = store.id!;
          }
        }
        storeMap.assignAll(newMap);
        print('Loaded ${storeMap.length} stores: $newMap');
      } else {
        throw Exception('Failed to load stores: ${response.statusMessage}');
      }
    } catch (e) {
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

  Future<void> loadSuppliers(String storeId) async {
    isLoadingSuppliers.value = true;
    try {
      final response = await _dioClient.dio.get(
        viewSupplierUrl, // Ensure this points to '/supplier-view'
        queryParameters: {'store_id': storeId},
      );
      if (response.statusCode == 200) {
        final supplierModel = SupplierModel.fromJson(response.data);
        final newMap = <String, String>{};
        for (var supplier in supplierModel.data ?? []) {
          if (supplier.supplierName != null && supplier.id != null) {
            newMap[supplier.supplierName!] = supplier.id.toString();
            print('Added supplier: ${supplier.supplierName} -> ${supplier.id}');
          }
        }
        supplierMap.assignAll(newMap);
        print('Loaded ${supplierMap.length} suppliers: $newMap');
      } else {
        throw Exception('Failed to load suppliers: ${response.statusMessage}');
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Error loading suppliers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching suppliers: $e');
    } finally {
      isLoadingSuppliers.value = false;
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
      final response = await _dioClient.dio.post(
        purchaseSupplierSummaryUrl,
        data: {
          'from_date': startDate.value!.toIso8601String(),
          'to_date': endDate.value!.toIso8601String(),
          'store_id': selectedStoreId.value.toString(),
          'supplier_id': selectedSupplierId.value ?? '',
        },
      );

      if (response.statusCode == 200) {
        final reportModel = PurchaseSummaryBySupplierModel.fromJson(
          response.data,
        );
        if (reportModel.data == null) {
          throw Exception('No data received from server');
        }
        purchaseData.assignAll(reportModel.data!);
        Get.snackbar(
          'Success',
          'Purchase supplier summary generated successfully',
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
    if (selectedStoreId.value != null) {
      loadSuppliers(selectedStoreId.value.toString());
    } else {
      selectedSupplier.value = null;
      selectedSupplierId.value = null;
      supplierMap.clear();
    }
  }

  void _resetStoreIfInvalid() {
    if (selectedStore.value != null &&
        !storeMap.containsKey(selectedStore.value)) {
      selectedStore.value = null;
      selectedStoreId.value = null;
    }
  }

  void _resetSupplierIfInvalid() {
    if (selectedSupplier.value != null &&
        !supplierMap.containsKey(selectedSupplier.value)) {
      selectedSupplier.value = null;
      selectedSupplierId.value = null;
    }
  }

  Future<File> generateSupplierSummaryPDF({
    required List<SignlePurchaseSummaryBySupplierModel> data,
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
                'Purchase Supplier Summary Report',
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
      "${output.path}/purchase_supplier_summary_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generateSupplierSummaryCSV({
    required List<SignlePurchaseSummaryBySupplierModel> data,
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
      "${output.path}/purchase_supplier_summary_${DateTime.now().millisecondsSinceEpoch}.csv",
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

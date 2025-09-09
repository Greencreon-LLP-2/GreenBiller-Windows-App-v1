import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/parties/models/customer_model.dart';
import 'package:greenbiller/features/reports/model/sales_customer_summary_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class SalesByCustomerController extends GetxController {
  final DioClient _dioClient = DioClient();
  late AuthController authController;
  final userId = RxnInt();
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final selectedStore = RxnString();
  final selectedCustomer = RxnString();
  final storeMap = <String, int>{}.obs;
  final customerMap = <String, String>{}.obs;
  final selectedStoreId = RxnInt();
  final selectedCustomerId = RxnString();
  final salesSummary = Rxn<SalesSummaryCustomerModel>();
  final isLoadingStores = false.obs;
  final isLoadingCustomers = false.obs;
  final isLoadingReport = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    authController = Get.find<AuthController>();
    userId.value = authController.user.value?.userId ?? 0;
    loadStores();
  }

  Future<void> loadStores() async {
    isLoadingStores.value = true;
    error.value = null;
    try {
      final response = await _dioClient.dio.get(viewStoreUrl);

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Extract the list under "data"
        final storeList = responseData['data'] as List<dynamic>;

        final newMap = <String, int>{};
        for (var store in storeList) {
          final storeJson = store as Map<String, dynamic>;
          final id = storeJson['id'] as int;
          final name = storeJson['store_name'] as String?;
          if (name != null) {
            newMap[name] = id;
          }
        }

        storeMap.assignAll(newMap);

        // Reset selected store if not in map
        if (selectedStore.value != null &&
            !storeMap.containsKey(selectedStore.value)) {
          selectedStore.value = null;
          selectedStoreId.value = null;
        }
      } else {
        throw Exception('Failed to fetch stores: ${response.statusMessage}');
      }
    } catch (e, stack) {
      print(stack);
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Error loading stores: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingStores.value = false;
    }
  }

  Future<void> loadCustomers(String storeId) async {
    isLoadingCustomers.value = true;
    error.value = null;
    try {
      final response = await _dioClient.dio.get(
        '$viewCustomerUrl?store_id=$storeId', // Assumed constant from api_constants.dart
      );

      if (response.statusCode == 200) {
        final customerModel = CustomerModel.fromJson(response.data);
        final newMap = <String, String>{};
        if (customerModel.data != null) {
          for (var customer in customerModel.data!) {
            if (customer.customerName != null && customer.id != null) {
              newMap[customer.customerName!] = customer.id.toString();
            }
          }
        }
        customerMap.assignAll(newMap);
        // Reset selected customer if not in map
        if (selectedCustomer.value != null &&
            !customerMap.containsKey(selectedCustomer.value)) {
          selectedCustomer.value = null;
          selectedCustomerId.value = null;
        }
      } else {
        throw Exception('Failed to fetch customers: ${response.statusMessage}');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Error loading customers: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCustomers.value = false;
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
    }
  }

  Future<void> generateReport(BuildContext context) async {
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
    if (selectedStoreId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a store',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedCustomerId.value == null) {
      Get.snackbar(
        'Error',
        'Please select a customer',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingReport.value = true;
    error.value = null;
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedStartDate = dateFormat.format(startDate.value!);
      final formattedEndDate = dateFormat.format(endDate.value!);

      final response = await _dioClient.dio.post(
        salesCustomerSummaryUrl,
        data: {
          'from_date': formattedStartDate,
          'to_date': formattedEndDate,
          'store_id': selectedStoreId.value.toString(),
          'customer_id': selectedCustomerId.value,
        },
      );

      if (response.statusCode == 200) {
        salesSummary.value = SalesSummaryCustomerModel.fromJson(response.data);
        if (salesSummary.value?.data == null) {
          throw Exception('No data received from server');
        }
      } else {
        throw Exception(
          'Failed to fetch sales summary: ${response.statusMessage}',
        );
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      error.value = e.toString();
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

  Future<File> generateCustomerSummaryPDF({
    required List<SingleSalesSummaryCustomerItem> data,
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
                'Sales Customer Summary Report',
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
                  _buildHeaderCell('Sales Date', ttf),
                  _buildHeaderCell('Sales ID', ttf),
                  _buildHeaderCell('Store Name', ttf),
                  _buildHeaderCell('Customer Name', ttf),
                  _buildHeaderCell('Total Amount', ttf),
                  _buildHeaderCell('Paid Amount', ttf),
                  _buildHeaderCell('Balance', ttf),
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
                      item.customerName ?? '-',
                      ttf,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    _buildDataCell(
                      item.grandTotal.toString(),
                      ttf,
                      alignment: pw.Alignment.centerRight,
                    ),
                    _buildDataCell(
                      item.paidAmount.toString(),
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
                    pw.Text('Total Sales:', style: pw.TextStyle(font: ttf)),
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
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (item.grandTotal ?? 0.0)).toStringAsFixed(2)}',
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
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (item.paidAmount ?? 0.0)).toStringAsFixed(2)}',
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
                      '₹ ${data.fold<double>(0, (sum, item) => sum + (item.balance ?? 0.0)).toStringAsFixed(2)}',
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
      "${output.path}/sales_customer_summary_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generateCustomerSummaryCSV({
    required List<SingleSalesSummaryCustomerItem> data,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<List<dynamic>> rows = [];
    rows.add([
      'Sales Date',
      'Sales ID',
      'Store Name',
      'Customer Name',
      'Total Amount',
      'Paid Amount',
      'Balance',
    ]);
    for (final item in data) {
      rows.add([
        item.salesDate?.toString().split(' ')[0] ?? '-',
        item.id.toString(),
        item.storeName ?? '-',
        item.customerName ?? '-',
        item.grandTotal ?? '-',
        item.paidAmount ?? '-',
        item.balance?.toString() ?? '-',
      ]);
    }
    String csvData = const ListToCsvConverter().convert(rows);
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/sales_customer_summary_${DateTime.now().millisecondsSinceEpoch}.csv",
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

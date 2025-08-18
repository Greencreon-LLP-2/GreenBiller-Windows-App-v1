import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/reports/purchase_report/controller/purchase_summary_controller.dart';
import 'package:green_biller/features/reports/purchase_report/models/purchase_summary/purchase_summary_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PurchaseSummary extends HookConsumerWidget {
  const PurchaseSummary({super.key});

  Future<void> _selectDate(BuildContext context, bool isStartDate,
      ValueNotifier<DateTime?> dateNotifier) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateNotifier.value = picked;
    }
  }

  Future<PurchaseSummaryModel> _generateReport(BuildContext context,
      String accessToken, DateTime? startDate, DateTime? endDate) async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
        ),
      );
      throw Exception('Start date and end date are required');
    }
    if (endDate.isBefore(startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date'),
        ),
      );
      throw Exception('End date cannot be before start date');
    }

    try {
      final response = await PurchaseSummaryController()
          .getPurchaseSummaryController(
              accessToken, startDate.toString(), endDate.toString(), context);

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      return response;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border(
          bottom: BorderSide(color: Colors.green.shade200, width: 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'Purchase Date',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              'Purchase ID',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'Store Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'Supplier Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'Total Amount',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'Paid Amount',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'Balance',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Datum data) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150,
              child: Text(
                data.purchaseDate?.toString().split(' ')[0] ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                data.id.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              width: 180,
              child: Text(
                data.storeName ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 180,
              child: Text(
                data.supplierName ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                data.grandTotal ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                data.paidAmount ?? '-',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                data.balance?.toString() ?? '-',
                style: TextStyle(
                  fontSize: 14,
                  color: (data.balance ?? 0) > 0
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> generatePurchaseSummaryPDF({
    required List<Datum> data,
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
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Purchase Summary Report',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                  color: PdfColors.blue,
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Period: ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                      'Generated: ${DateTime.now().toString().split(' ')[0]}'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          // Table
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.blue),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.2), // Purchase Date
              1: const pw.FlexColumnWidth(1), // Purchase ID
              2: const pw.FlexColumnWidth(2), // Store Name
              3: const pw.FlexColumnWidth(2), // Supplier Name
              4: const pw.FlexColumnWidth(1.5), // Total Amount
              5: const pw.FlexColumnWidth(1.5), // Paid Amount
              6: const pw.FlexColumnWidth(1.5), // Balance
            },
            children: [
              // Table Header
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
              // Table Data
              ...data.map((item) => pw.TableRow(
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
                  )),
            ],
          ),
          pw.SizedBox(height: 20),
          // Summary
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
                    pw.Text('Total Purchases:'),
                    pw.Text(data.length.toString()),
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
          // Footer
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by GreenBiller',
                style: const pw.TextStyle(color: PdfColors.blue, fontSize: 10),
              ),
              pw.Container(
                color: PdfColors.grey300,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                child: pw.Text(
                  'Digitaly Generated',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File(
        "${output.path}/purchase_summary_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generatePurchaseSummaryCSV({
    required List<Datum> data,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<List<dynamic>> rows = [];
    // Header
    rows.add([
      'Purchase Date',
      'Purchase ID',
      'Store Name',
      'Supplier Name',
      'Total Amount',
      'Paid Amount',
      'Balance',
    ]);
    // Data
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
        "${output.path}/purchase_summary_${DateTime.now().millisecondsSinceEpoch}.csv");
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

  pw.Widget _buildDataCell(String text, pw.Font ttf,
      {PdfColor? color, pw.Alignment alignment = pw.Alignment.center}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Container(
        alignment: alignment,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            color: color ?? PdfColors.black,
            font: ttf,
          ),
          textAlign: alignment == pw.Alignment.centerLeft
              ? pw.TextAlign.left
              : alignment == pw.Alignment.centerRight
                  ? pw.TextAlign.right
                  : pw.TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final purchaseData = useState<List<Datum>>([]);
    final reportFuture = useState<Future<PurchaseSummaryModel>?>(null);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/reports");
          },
        ),
        title: const Text('Purchase Summary'),
        backgroundColor: accentLightColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.summarize,
                            color: Colors.green, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          'Purchase Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (startDate.value == null ||
                                endDate.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please select both start and end dates'),
                                ),
                              );
                              return;
                            }
                            reportFuture.value = _generateReport(
                              context,
                              accessToken!,
                              startDate.value,
                              endDate.value,
                            );
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Generate'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _selectDate(context, true, startDate),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.green.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  startDate.value == null
                                      ? 'Start Date'
                                      : '${startDate.value!.day}/${startDate.value!.month}/${startDate.value!.year}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _selectDate(context, false, endDate),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.green.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  endDate.value == null
                                      ? 'End Date'
                                      : '${endDate.value!.day}/${endDate.value!.month}/${endDate.value!.year}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.list_alt, color: Colors.green, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Report Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      Expanded(
                        child: FutureBuilder<PurchaseSummaryModel>(
                          future: reportFuture.value,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data?.data == null) {
                              return Center(
                                child: Text(
                                  'Select date range and generate report to view results',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 15,
                                  ),
                                ),
                              );
                            }

                            final data = snapshot.data!.data!;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        try {
                                          final file =
                                              await generatePurchaseSummaryPDF(
                                            data: data,
                                            startDate: startDate.value!,
                                            endDate: endDate.value!,
                                          );
                                          await OpenFile.open(file.path);
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error generating PDF: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.picture_as_pdf,
                                          size: 20),
                                      label: const Text('Export as PDF'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade700,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        try {
                                          final file =
                                              await generatePurchaseSummaryCSV(
                                            data: data,
                                            startDate: startDate.value!,
                                            endDate: endDate.value!,
                                          );
                                          await OpenFile.open(file.path);
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error generating CSV: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.table_chart,
                                          size: 20),
                                      label: const Text('Export as CSV'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              _buildTableHeader(),
                                              ...data.map((item) =>
                                                  _buildTableRow(item)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

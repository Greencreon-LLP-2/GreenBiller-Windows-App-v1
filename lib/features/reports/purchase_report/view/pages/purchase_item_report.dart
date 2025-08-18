import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/purchase/services/purchase_item_service.dart';
import 'package:green_biller/features/reports/purchase_report/controller/purchase_item_report_controller.dart';
import 'package:green_biller/features/reports/purchase_report/models/purchase_item/purchase_item_report_model.dart'
    as purchase_item;
import 'package:green_biller/features/store/model/store_model/store_model.dart'
    as store_model;
import 'package:green_biller/features/store/services/view_store_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PurchaseItemReportPage extends HookConsumerWidget {
  const PurchaseItemReportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    final reportFuture =
        useState<Future<purchase_item.PurchaseItemReportModel>?>(null);
    final hasError = useState<bool>(false);
    final isLoading = useState<bool>(false);
    final selectedStartDate = useState<DateTime?>(null);
    final selectedEndDate = useState<DateTime?>(null);
    final selectedStoreId = useState<String?>(null);
    final selectedItemId = useState<String?>(null);
    final storesList = useState<List<store_model.StoreData>>([]);
    final itemsList = useState<List<dynamic>>([]);
    final logger = Logger();

    Future<void> fetchStores(String accessToken) async {
      try {
        final stores = await viewStoreService(accessToken);
        storesList.value = stores.data!;
      } catch (e) {
        debugPrint('Error fetching stores: $e');
      }
    }

    // Fetch stores when the page is first built
    useEffect(() {
      if (accessToken != null) {
        fetchStores(accessToken);
      }
      return null;
    }, [accessToken]);

    // Fetch items when storeId changes
    Future<void> fetchItems(String storeId) async {
      if (accessToken == null) return;

      isLoading.value = true;
      try {
        final purchaseItemService = PurchaseItemService();
        final purchaseItems = await purchaseItemService.getPurchaseItemService(
            accessToken, storeId);

        // Process items to merge duplicates
        final Map<String, dynamic> uniqueItems = {};
        for (var item in purchaseItems.data!) {
          final key = '${item.itemName}_${item.batchNo}';
          if (!uniqueItems.containsKey(key)) {
            uniqueItems[key] = item;
          }
        }

        itemsList.value = uniqueItems.values.toList();
        logger.w(itemsList.value);
      } catch (e) {
        debugPrint('Error fetching items: $e');
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
          selectedStartDate.value = picked;
        } else {
          selectedEndDate.value = picked;
        }
      }
    }

    Future<void> generateReport() async {
      if (accessToken == null ||
          selectedStartDate.value == null ||
          selectedEndDate.value == null ||
          selectedStoreId.value == null ||
          selectedItemId.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select all required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      reportFuture.value =
          PurchaseItemReportController().getPurchaseItemReportController(
        accessToken,
        selectedStartDate.value!.toString(),
        selectedEndDate.value!.toString(),
        selectedStoreId.value!,
        selectedItemId.value!,
      );
    }

    Future<File> generatePurchaseItemPDF({
      required List<purchase_item.Datum> data,
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
                  'Purchase Item Report',
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
                0: const pw.FlexColumnWidth(1.2), // Date
                1: const pw.FlexColumnWidth(1.5), // Store
                2: const pw.FlexColumnWidth(2), // Item
                3: const pw.FlexColumnWidth(1.5), // Price/Unit
                4: const pw.FlexColumnWidth(1), // Quantity
                5: const pw.FlexColumnWidth(1.5), // Total
              },
              children: [
                // Table Header
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
                // Table Data
                ...data.map((item) => pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item.salesDate?.toString().split(' ')[0] ?? '-',
                            style: pw.TextStyle(
                              font: ttf,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item.storeName ?? '-',
                            style: pw.TextStyle(
                              font: ttf,
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item.itemName ?? '-',
                            style: pw.TextStyle(
                              font: ttf,
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '₹${item.pricePerUnit ?? '0.00'}',
                            style: pw.TextStyle(
                              font: ttf,
                            ),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            item.purchaseQty ?? '-',
                            style: pw.TextStyle(
                              font: ttf,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '₹${item.total?.toString() ?? '0.00'}',
                            style: pw.TextStyle(
                              font: ttf,
                            ),
                            textAlign: pw.TextAlign.right,
                          ),
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
                      pw.Text('Total Items:'),
                      pw.Text(data.length.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Quantity:',
                          style: pw.TextStyle(font: ttf)),
                      pw.Text(
                        data
                            .fold<int>(
                                0,
                                (sum, item) =>
                                    sum +
                                    (int.tryParse(item.purchaseQty ?? '0') ??
                                        0))
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
            // Footer
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Generated by GreenBiller',
                  style:
                      const pw.TextStyle(color: PdfColors.blue, fontSize: 10),
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
          "${output.path}/purchase_item_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(await pdf.save());
      return file;
    }

    Future<File> generatePurchaseItemCSV({
      required List<purchase_item.Datum> data,
      required DateTime startDate,
      required DateTime endDate,
    }) async {
      List<List<dynamic>> rows = [];
      // Header
      rows.add([
        'Date',
        'Store',
        'Item',
        'Price/Unit',
        'Quantity',
        'Total',
      ]);
      // Data
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
          "${output.path}/purchase_item_${DateTime.now().millisecondsSinceEpoch}.csv");
      await file.writeAsString(csvData);
      return file;
    }

    pw.Widget buildHeaderCell(String text, pw.Font ttf) {
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

    pw.Widget buildDataCell(String text, pw.Font ttf,
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

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.go("/reports"),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Purchase Item Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Date Range Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date Range',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => selectDate(context, true),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      selectedStartDate.value != null
                                          ? DateFormat('dd/MM/yyyy')
                                              .format(selectedStartDate.value!)
                                          : 'Start Date',
                                      style: TextStyle(
                                        color: selectedStartDate.value != null
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InkWell(
                                  onTap: () => selectDate(context, false),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      selectedEndDate.value != null
                                          ? DateFormat('dd/MM/yyyy')
                                              .format(selectedEndDate.value!)
                                          : 'End Date',
                                      style: TextStyle(
                                        color: selectedEndDate.value != null
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Store Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Store',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedStoreId.value,
                                isExpanded: true,
                                hint: Text(
                                  'Select Store',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                items: storesList.value.map((store) {
                                  return DropdownMenuItem<String>(
                                    value: store.id?.toString(),
                                    child: Text(store.storeName ?? ''),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  selectedStoreId.value = value;
                                  if (value != null) {
                                    fetchItems(value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Item Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButton<String>(
                              value: selectedItemId.value?.isEmpty ?? true
                                  ? null
                                  : itemsList.value
                                      .where((item) =>
                                          item.itemId.toString() ==
                                          selectedItemId.value)
                                      .map((item) =>
                                          '${item.itemId}_${item.batchNo}')
                                      .firstOrNull,
                              isExpanded: true,
                              hint: const Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              underline: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                              items: itemsList.value.map((item) {
                                return DropdownMenuItem(
                                  value: '${item.itemId}_${item.batchNo}',
                                  child: Text(
                                    '${item.itemName ?? ''} (Batch: ${item.batchNo ?? 'N/A'})',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  selectedItemId.value = value.split('_')[0];
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: generateReport,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Generate Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Results',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child:
                          FutureBuilder<purchase_item.PurchaseItemReportModel>(
                        future: reportFuture.value,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            hasError.value = true;
                            return _buildNoInternetView();
                          }

                          if (!snapshot.hasData ||
                              snapshot.data?.data == null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No report data available',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
                                            await generatePurchaseItemPDF(
                                          data: data,
                                          startDate: selectedStartDate.value!,
                                          endDate: selectedEndDate.value!,
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final file =
                                            await generatePurchaseItemCSV(
                                          data: data,
                                          startDate: selectedStartDate.value!,
                                          endDate: selectedEndDate.value!,
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
                                    icon:
                                        const Icon(Icons.table_chart, size: 20),
                                    label: const Text('Export as CSV'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.of(context).size.width -
                                              328,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          _buildTableHeader(),
                                          ...data.map(
                                              (item) => _buildTableRow(item)),
                                        ],
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Store',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Item',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Price/Unit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Quantity',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Total',
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

  Widget _buildTableRow(purchase_item.Datum data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              data.salesDate?.toString().split(' ')[0] ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              data.storeName ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              data.itemName ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '₹${data.pricePerUnit ?? '0.00'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              data.purchaseQty ?? '-',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '₹${data.total?.toString() ?? '0.00'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection and try again',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Add retry logic here
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

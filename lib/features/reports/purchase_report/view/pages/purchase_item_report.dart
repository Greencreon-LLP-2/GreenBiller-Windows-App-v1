import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
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

  Future<void> _loadStores(BuildContext context, String accessToken,
      List<store_model.StoreData> storesList) async {
    try {
      final stores = await viewStoreService(accessToken);
      storesList.clear();
      storesList.addAll(stores.data!);
      debugPrint('Loaded ${storesList.length} stores');
    } catch (e) {
      debugPrint('Error fetching stores: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading stores: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadItems(BuildContext context, String accessToken,
      String storeId, List<dynamic> itemsList) async {
    try {
      debugPrint('Loading items for store: $storeId');
      final purchaseItemService = PurchaseItemService();
      final purchaseItems = await purchaseItemService.getPurchaseItemService(
          accessToken, storeId);

      final Map<String, dynamic> uniqueItems = {};
      for (var item in purchaseItems.data!) {
        final key = '${item.itemName}_${item.batchNo}';
        if (!uniqueItems.containsKey(key)) {
          uniqueItems[key] = item;
        }
      }

      itemsList.clear();
      itemsList.addAll(uniqueItems.values.toList());
      debugPrint('Loaded ${itemsList.length} unique items');
    } catch (e) {
      debugPrint('Error fetching items: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading items: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStoreDropdown(BuildContext context, String? selectedStoreId,
      Function(String?) onChanged, List<store_model.StoreData> storesList) {
    debugPrint('Building store dropdown with ${storesList.length} stores');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStoreId,
          hint: const Text('Select Store'),
          isExpanded: true,
          icon: const Icon(Icons.store, color: Colors.green),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select a Store',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...storesList.map((store) {
              debugPrint('Store entry: ${store.storeName} -> ${store.id}');
              return DropdownMenuItem<String>(
                value: store.id?.toString(),
                child: Text(
                  store.storeName ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              );
            }),
          ],
          onChanged: (value) {
            debugPrint('Store selected: $value');
            onChanged(value);
          },
        ),
      ),
    );
  }

  Widget _buildItemDropdown(BuildContext context, String? selectedItemId,
      Function(String?) onChanged, List<dynamic> itemsList, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItemId,
          hint: const Text('Select Item'),
          isExpanded: true,
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              : const Icon(Icons.inventory, color: Colors.green),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select an Item',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...itemsList.map((item) => DropdownMenuItem<String>(
                  value: item.itemId.toString(),
                  child: Text(
                    '${item.itemName ?? ''} (Batch: ${item.batchNo ?? 'N/A'})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ],
          onChanged: (value) {
            debugPrint('Item selected: $value');
            onChanged(value);
          },
        ),
      ),
    );
  }

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
      debugPrint(
          '${isStartDate ? 'Start' : 'End'} date selected: ${picked.toString()}');
    }
  }

  Future<purchase_item.PurchaseItemReportModel> _generateReport(
      BuildContext context,
      String accessToken,
      DateTime? startDate,
      DateTime? endDate,
      String storeId,
      String itemId) async {
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
    if (storeId.isEmpty || itemId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a store and an item'),
        ),
      );
      throw Exception('Store and item are required');
    }

    try {
      final response =
          await PurchaseItemReportController().getPurchaseItemReportController(
        accessToken,
        startDate.toString(),
        endDate.toString(),
        storeId,
        itemId,
      );
      if (response.data == null) {
        throw Exception('No data received from server');
      }
      debugPrint('Report generated with ${response.data!.length} items');
      return response;
    } catch (e) {
      debugPrint('Error generating report: $e');
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
                    style:
                        pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
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
              ...data.map((item) => pw.TableRow(
                    children: [
                      _buildDataCell(
                          item.salesDate?.toString().split(' ')[0] ?? '-', ttf,
                          alignment: pw.Alignment.center),
                      _buildDataCell(item.storeName ?? '-', ttf,
                          alignment: pw.Alignment.centerLeft),
                      _buildDataCell(item.itemName ?? '-', ttf,
                          alignment: pw.Alignment.centerLeft),
                      _buildDataCell('₹${item.pricePerUnit ?? '0.00'}', ttf,
                          alignment: pw.Alignment.centerRight),
                      _buildDataCell(item.purchaseQty ?? '-', ttf,
                          alignment: pw.Alignment.center),
                      _buildDataCell(
                          '₹${item.total?.toString() ?? '0.00'}', ttf,
                          alignment: pw.Alignment.centerRight),
                    ],
                  )),
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
                    pw.Text(data.length.toString(),
                        style: pw.TextStyle(font: ttf)),
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
                                  (int.tryParse(item.purchaseQty ?? '0') ?? 0))
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
                    color: PdfColors.blue, fontSize: 10, font: ttf),
              ),
              pw.Container(
                color: PdfColors.grey300,
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
    rows.add([
      'Date',
      'Store',
      'Item',
      'Price/Unit',
      'Quantity',
      'Total',
    ]);
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
            width: 180,
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
            width: 180,
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
            width: 150,
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
            width: 150,
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
            width: 150,
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
              data.salesDate?.toString().split(' ')[0] ?? '-',
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
              data.itemName ?? '-',
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
              '₹${data.pricePerUnit ?? '0.00'}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              data.purchaseQty ?? '-',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              '₹${data.total?.toString() ?? '0.00'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    final userId = user?.user?.id?.toString() ?? '';
    final logger = Logger();
    final reportFuture =
        useState<Future<purchase_item.PurchaseItemReportModel>?>(null);
    final isLoading = useState<bool>(false);
    final selectedStartDate = useState<DateTime?>(null);
    final selectedEndDate = useState<DateTime?>(null);
    final selectedStoreId = useState<String?>(null);
    final selectedItemId = useState<String?>(null);
    final storesList = useState<List<store_model.StoreData>>([]);
    final itemsList = useState<List<dynamic>>([]);

    debugPrint('Current user ID: $userId');
    debugPrint(
        'Current access token: ${accessToken != null ? 'present' : 'null'}');

    // Load stores when the widget is built
    useEffect(() {
      if (accessToken != null) {
        _loadStores(context, accessToken, storesList.value);
      }
      return null;
    }, [accessToken]);

    // Load items when store is selected
    useEffect(() {
      if (accessToken != null && selectedStoreId.value != null) {
        isLoading.value = true;
        _loadItems(
                context, accessToken, selectedStoreId.value!, itemsList.value)
            .then((_) {
          isLoading.value = false;
        });
      }
      return null;
    }, [selectedStoreId.value, accessToken]);

    // Reset selected item if store changes
    useEffect(() {
      if (selectedStoreId.value == null) {
        selectedItemId.value = null;
        itemsList.value.clear();
      }
      return null;
    }, [selectedStoreId.value]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/reports");
          },
        ),
        title: const Text('Purchase Item Report'),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
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
                          'Purchase Item Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (selectedStartDate.value == null ||
                                selectedEndDate.value == null ||
                                selectedStoreId.value == null ||
                                selectedItemId.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please select all required fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            reportFuture.value = _generateReport(
                              context,
                              accessToken!,
                              selectedStartDate.value,
                              selectedEndDate.value,
                              selectedStoreId.value!,
                              selectedItemId.value!,
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
                                _selectDate(context, true, selectedStartDate),
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
                                  selectedStartDate.value == null
                                      ? 'Start Date'
                                      : DateFormat('dd/MM/yyyy')
                                          .format(selectedStartDate.value!),
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
                                _selectDate(context, false, selectedEndDate),
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
                                  selectedEndDate.value == null
                                      ? 'End Date'
                                      : DateFormat('dd/MM/yyyy')
                                          .format(selectedEndDate.value!),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStoreDropdown(
                            context,
                            selectedStoreId.value,
                            (value) {
                              selectedStoreId.value = value;
                              selectedItemId.value =
                                  null; // Reset item selection
                            },
                            storesList.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildItemDropdown(
                            context,
                            selectedItemId.value,
                            (value) {
                              selectedItemId.value = value;
                            },
                            itemsList.value,
                            isLoading.value,
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
                        child: FutureBuilder<
                            purchase_item.PurchaseItemReportModel>(
                          future: reportFuture.value,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
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
                                  'Select date range, store, and item to generate report',
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
                                              await generatePurchaseItemPDF(
                                            data: data,
                                            startDate: selectedStartDate.value!,
                                            endDate: selectedEndDate.value!,
                                          );
                                          await OpenFile.open(file.path);
                                          debugPrint(
                                              'PDF generated and opened: ${file.path}');
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
                                              await generatePurchaseItemCSV(
                                            data: data,
                                            startDate: selectedStartDate.value!,
                                            endDate: selectedEndDate.value!,
                                          );
                                          await OpenFile.open(file.path);
                                          debugPrint(
                                              'CSV generated and opened: ${file.path}');
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

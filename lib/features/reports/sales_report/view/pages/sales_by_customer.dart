import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/add_category_controller.dart';
import 'package:green_biller/features/reports/sales_report/controllers/store_customer_summary_controller.dart';
import 'package:green_biller/features/reports/sales_report/models/sales_customer_summary/sales_customer_summary_model.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesByCustomerPage extends HookConsumerWidget {
  const SalesByCustomerPage({super.key});

  Future<void> _loadStores(BuildContext context, String accessToken,
      Map<String, int> storeMap) async {
    try {
      final storeList = await AddCategoryController().getStoreList(accessToken);
      final newMap = <String, int>{};

      for (var store in storeList) {
        store.forEach((id, name) {
          newMap[name] = int.parse(id.toString());
        });
      }

      storeMap.clear();
      storeMap.addAll(newMap);
    } catch (e) {
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

  Future<void> _loadCustomers(BuildContext context, String accessToken,
      Map<String, String> customerMap, String storeId, String userId) async {
    try {
      debugPrint('Starting _loadCustomers function');
      debugPrint('Loading customers for store: $storeId and user: $userId');
      debugPrint('Access token: $accessToken');

      final customerModel = await ViewPartiesController().viewCustomer(
        accessToken,
        storeId,
      );

      debugPrint('Raw customer response: ${customerModel.toString()}');
      debugPrint('Customers loaded: ${customerModel.data?.length ?? 0}');

      customerMap.clear();
      if (customerModel.data != null) {
        for (var customer in customerModel.data!) {
          if (customer.customerName != null && customer.id != null) {
            customerMap[customer.customerName!] = customer.id.toString();
            debugPrint(
                'Added customer: ${customer.customerName} -> ${customer.id}');
          }
        }
      }

      debugPrint('Final customer map: $customerMap');
    } catch (e, stackTrace) {
      debugPrint('Error loading customers: $e');
      debugPrint('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading customers: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }

  Future<SalesSummaryCustomerModel> _generateReport(
      BuildContext context,
      String accessToken,
      DateTime? startDate,
      DateTime? endDate,
      String storeId,
      String customerId) async {
    logger.w('Starting _generateReport');
    logger.w('Access Token: ${accessToken != null ? 'present' : 'null'}');
    logger.w('Start Date: $startDate');
    logger.w('End Date: $endDate');
    logger.w('Store ID: $storeId');
    logger.w('Customer ID: $customerId');

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
      debugPrint('Calling StoreCustomerSummaryController');
      final response = await StoreCustomerSummaryController()
          .getSalesCustomerSummaryController(
        accessToken,
        startDate.toString(),
        endDate.toString(),
        storeId,
        customerId,
      );
      debugPrint('Response received: ${response.toString()}');

      if (response.data == null) {
        debugPrint('No data received from server');
        throw Exception('No data received from server');
      }

      debugPrint('Data received successfully');
      return response;
    } catch (e, stackTrace) {
      debugPrint('Error in _generateReport: $e');
      debugPrint('Stack trace: $stackTrace');
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

  Widget _buildStoreDropdown(BuildContext context, String? selectedStore,
      Function(String?) onChanged, Map<String, int> storeMap) {
    debugPrint('Building store dropdown with ${storeMap.length} stores');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStore,
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
            ...storeMap.entries.map((entry) {
              debugPrint('Store entry: ${entry.key} -> ${entry.value}');
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.key,
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
            if (value != null && storeMap.containsKey(value)) {
              final storeId = storeMap[value];
              debugPrint('Store ID for selection: $storeId');
              onChanged(value);
            } else {
              debugPrint('Invalid store selection');
              onChanged(null);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCustomerDropdown(
      BuildContext context,
      String? selectedCustomer,
      Function(String?) onChanged,
      Map<String, String> customerMap,
      bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCustomer,
          hint: const Text('Select Customer'),
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
              : const Icon(Icons.person, color: Colors.green),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select a Customer',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            ...customerMap.entries.map((entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                )),
          ],
          onChanged: (value) {
            debugPrint('Customer dropdown selected value: $value');
            if (value != null && customerMap.containsKey(value)) {
              final customerId = customerMap[value];
              debugPrint('Selected customer ID: $customerId');
              debugPrint('Full customer map: $customerMap');
              onChanged(value);
            } else {
              debugPrint('Invalid customer selection or no customer selected');
              onChanged(null);
            }
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
              'Sales Date',
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
              'Sales ID',
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
              'Customer Name',
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
                data.salesDate?.toString().split(' ')[0] ?? '-',
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
                data.customerName ?? '-',
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

  Future<File> generateCustomerSummaryPDF({
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
              ...data.map((item) => pw.TableRow(
                    children: [
                      _buildDataCell(
                          item.salesDate?.toString().split(' ')[0] ?? '-', ttf,
                          alignment: pw.Alignment.center),
                      _buildDataCell(item.id.toString(), ttf,
                          alignment: pw.Alignment.center),
                      _buildDataCell(item.storeName ?? '-', ttf,
                          alignment: pw.Alignment.centerLeft),
                      _buildDataCell(item.customerName ?? '-', ttf,
                          alignment: pw.Alignment.centerLeft),
                      _buildDataCell(item.grandTotal ?? '-', ttf,
                          alignment: pw.Alignment.centerRight),
                      _buildDataCell(item.paidAmount ?? '-', ttf,
                          alignment: pw.Alignment.centerRight),
                      _buildDataCell(item.balance?.toString() ?? '-', ttf,
                          color: (item.balance ?? 0) > 0
                              ? PdfColors.red
                              : PdfColors.green,
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
                    pw.Text('Total Sales:', style: pw.TextStyle(font: ttf)),
                    pw.Text(data.length.toString(),
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Amount:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        '₹ ${data.fold<double>(0, (sum, item) => sum + (double.tryParse(item.grandTotal ?? '0') ?? 0)).toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Paid:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        '₹ ${data.fold<double>(0, (sum, item) => sum + (double.tryParse(item.paidAmount ?? '0') ?? 0)).toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total Balance:', style: pw.TextStyle(font: ttf)),
                    pw.Text(
                        '₹ ${data.fold<double>(0, (sum, item) => sum + (item.balance ?? 0)).toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf)),
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
        "${output.path}/sales_customer_summary_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
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

  Future<File> generateCustomerSummaryCSV({
    required List<Datum> data,
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
        "${output.path}/sales_customer_summary_${DateTime.now().millisecondsSinceEpoch}.csv");
    await file.writeAsString(csvData);
    return file;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final accessToken = user?.accessToken;
    final userId = user?.user?.id?.toString() ?? '';
    debugPrint('Current user ID: $userId');
    debugPrint(
        'Current access token: ${accessToken != null ? 'present' : 'null'}');
    final startDate = useState<DateTime?>(null);
    final endDate = useState<DateTime?>(null);
    final selectedStore = useState<String?>(null);
    final selectedCustomer = useState<String?>(null);
    final storeMap = useState<Map<String, int>>({});
    final customerMap = useState<Map<String, String>>({});
    final selectedStoreId = useState<int?>(null);
    final selectedCustomerId = useState<String?>(null);
    final isLoadingCustomers = useState<bool>(false);
    final reportFuture = useState<Future<SalesSummaryCustomerModel>?>(null);

    // Load stores when the widget is built
    useEffect(() {
      if (accessToken != null) {
        _loadStores(context, accessToken, storeMap.value);
      }
      return null;
    }, [accessToken]);

    // Load customers when store is selected
    useEffect(() {
      debugPrint('useEffect triggered for customer loading');
      debugPrint('Store ID changed to: ${selectedStoreId.value}');
      debugPrint('Access token present: ${accessToken != null}');
      debugPrint('User ID: $userId');

      if (accessToken != null && selectedStoreId.value != null) {
        debugPrint(
            'Triggering customer load for store: ${selectedStoreId.value}');
        isLoadingCustomers.value = true;
        _loadCustomers(
          context,
          accessToken,
          customerMap.value,
          selectedStoreId.value.toString(),
          userId,
        ).then((_) {
          debugPrint(
              'Customer load completed. Count: ${customerMap.value.length}');
          debugPrint('Customer map contents: ${customerMap.value}');
          isLoadingCustomers.value = false;
        }).catchError((error) {
          debugPrint('Error in customer loading: $error');
          debugPrint('Error stack trace: ${StackTrace.current}');
          isLoadingCustomers.value = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading customers: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      } else {
        debugPrint(
            'Cannot load customers: accessToken=${accessToken != null}, storeId=${selectedStoreId.value}');
      }
      return null;
    }, [selectedStoreId.value, accessToken, userId]);

    // Reset selected store if it's not in the storeMap
    useEffect(() {
      if (selectedStore.value != null &&
          !storeMap.value.containsKey(selectedStore.value)) {
        selectedStore.value = null;
        selectedStoreId.value = null;
      }
      return null;
    }, [storeMap.value]);

    // Reset selected customer if it's not in the customerMap
    useEffect(() {
      if (selectedCustomer.value != null &&
          !customerMap.value.containsKey(selectedCustomer.value)) {
        selectedCustomer.value = null;
        selectedCustomerId.value = null;
      }
      return null;
    }, [customerMap.value]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/reports");
          },
        ),
        title: const Text('Sales Summary'),
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
                          'Sales Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const Spacer(),

                        const SizedBox(width: 12),
                        // Generate button
                        GestureDetector(
                          onTap: () {
                            print('Generate button tapped');
                            logger.w('Generate button tapped');

                            // Show immediate feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Generating report...'),
                                duration: Duration(seconds: 1),
                              ),
                            );

                            if (startDate.value == null ||
                                endDate.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please select both start and end dates'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            if (selectedStoreId.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a store'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            if (selectedCustomerId.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a customer'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            print('Starting report generation');
                            logger.w('Starting report generation with:');
                            logger.w('Start Date: ${startDate.value}');
                            logger.w('End Date: ${endDate.value}');
                            logger.w('Store ID: ${selectedStoreId.value}');
                            logger
                                .w('Customer ID: ${selectedCustomerId.value}');

                            reportFuture.value = _generateReport(
                              context,
                              accessToken!,
                              startDate.value,
                              endDate.value,
                              selectedStoreId.value.toString(),
                              selectedCustomerId.value ?? '',
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Generate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStoreDropdown(
                            context,
                            selectedStore.value,
                            (value) {
                              debugPrint(
                                  'Store dropdown callback with value: $value');
                              selectedStore.value = value;
                              selectedStoreId.value =
                                  value != null ? storeMap.value[value] : null;
                              debugPrint(
                                  'Updated store ID to: ${selectedStoreId.value}');
                              // Reset customer selection when store changes
                              selectedCustomer.value = null;
                              selectedCustomerId.value = null;
                            },
                            storeMap.value,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCustomerDropdown(
                            context,
                            selectedCustomer.value,
                            (value) {
                              selectedCustomer.value = value;
                              selectedCustomerId.value = value != null
                                  ? customerMap.value[value]
                                  : null;
                            },
                            customerMap.value,
                            isLoadingCustomers.value,
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
                        child: FutureBuilder<SalesSummaryCustomerModel>(
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
                              return const Center(
                                child: Text(
                                  'Select date range and generate report to view results',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                                              await generateCustomerSummaryPDF(
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
                                              await generateCustomerSummaryCSV(
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

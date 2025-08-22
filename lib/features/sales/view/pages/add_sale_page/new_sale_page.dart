import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/home/controllers/tax_controller.dart';
import 'package:green_biller/features/home/model/tax_model.dart' as tax;
import 'package:green_biller/features/item/model/item/item_model.dart'
    as item_model;
import 'package:green_biller/features/sales/controllers/sales_create_controller.dart';
import 'package:green_biller/features/sales/controllers/sales_payment_controller.dart';
import 'package:green_biller/features/sales/controllers/single_item_sales_controller.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/widgets/sales_bottom_section.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/widgets/sales_table_data_cell_widget.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/widgets/sales_table_header_widget.dart';
import 'package:green_biller/features/sales/view/pages/add_sale_page/widgets/sales_topsection_widget.dart';
import 'package:green_biller/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempPurchaseItem {
  final String customerId;
  final String purchaseId;
  final String itemId;
  final String purchaseQty;
  final String pricePerUnit;
  final String taxName;
  final String taxId;
  final String taxAmount;
  final String discountType;
  final String discountAmount;
  final String totalCost;
  final String unit;
  final String taxRate;
  final String batchNo;
  final String barcode;

  TempPurchaseItem({
    required this.customerId,
    required this.purchaseId,
    required this.itemId,
    required this.purchaseQty,
    required this.pricePerUnit,
    required this.taxName,
    required this.taxId,
    required this.taxAmount,
    required this.discountType,
    required this.discountAmount,
    required this.totalCost,
    required this.unit,
    required this.taxRate,
    required this.batchNo,
    required this.barcode,
  });
}

class InvoiceItem {
  final String name;
  final int qty;
  final String unit;
  final double price;
  final double total;
  final String taxName;
  final double taxRate;

  InvoiceItem({
    required this.name,
    required this.qty,
    required this.unit,
    required this.price,
    required this.total,
    required this.taxName,
    required this.taxRate,
  });
}

Future<Uint8List> generateRealisticInvoice({
  required String shopName,
  required String shopAddress,
  required String shopContact,
  required String shopEmail,
  required String invoiceNo,
  required String invoiceDate,
  required String website,
  required String amountInWords,
  required String terms,
  required double received,
  required double subtotal,
  required double total,
  required double balance,
  required String customerName,
  required String paymentMode,
  required List<InvoiceItem> items,
  required double totalDiscount,
  required double otherCharges,
  required double totalTax,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll57,
      build: (pw.Context context) {
        return pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Container(
                      width: 100,
                      height: 50,
                      decoration: const pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        color: PdfColors.grey300,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          "GC",
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      shopName,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      shopAddress,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      "Tel: $shopContact | Email: $shopEmail",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Divider(thickness: 1),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Invoice: $invoiceNo",
                        style: const pw.TextStyle(fontSize: 8)),
                    pw.Text("Date: ${invoiceDate.toString()}",
                        style: const pw.TextStyle(fontSize: 8)),
                    pw.Text("Customer: $customerName",
                        style: const pw.TextStyle(fontSize: 8)),
                    pw.Text("Payment: $paymentMode",
                        style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text("Item",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text("Qty",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text("Price",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text("Total",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  ),
                ],
              ),
              pw.Divider(thickness: 0.3),
              for (var item in items)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(item.name,
                                style: const pw.TextStyle(fontSize: 7)),
                            pw.Text(
                              "${item.unit} | ${item.taxName} ${item.taxRate}%",
                              style: const pw.TextStyle(
                                  fontSize: 6, color: PdfColors.grey600),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(item.qty.toString(),
                            style: const pw.TextStyle(fontSize: 7)),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(item.price.toStringAsFixed(2),
                            style: const pw.TextStyle(fontSize: 7)),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(item.total.toStringAsFixed(2),
                            style: const pw.TextStyle(fontSize: 7)),
                      ),
                    ],
                  ),
                ),
              pw.Divider(thickness: 0.5),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Column(
                  children: [
                    _buildSummaryRow("Subtotal", subtotal),
                    _buildSummaryRow("Discount", -totalDiscount),
                    _buildSummaryRow("Tax", totalTax),
                    _buildSummaryRow("Other Charges", otherCharges),
                    pw.Divider(thickness: 1),
                    _buildSummaryRow("TOTAL", total, isBold: true),
                    pw.SizedBox(height: 8),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Payment Method:",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6)),
                              pw.Text(paymentMode,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.blue700,
                                      fontSize: 6)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Amount Paid:",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6)),
                              pw.Text(
                                received.toStringAsFixed(2),
                                style: const pw.TextStyle(fontSize: 8),
                              )
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Balance Due:",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6)),
                              pw.Text(
                                balance.toStringAsFixed(2),
                                style: const pw.TextStyle(fontSize: 8),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "Thank you for your business!",
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      "Terms: $terms",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      "Software by Green Biller",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}

pw.Widget _buildSummaryRow(String label, double value,
    {bool isBold = false, double fontSize = 7}) {
  final style = pw.TextStyle(
    fontSize: fontSize,
    fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            label,
            style: style,
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            value.toStringAsFixed(2),
            textAlign: pw.TextAlign.right,
            style: style,
          ),
        ),
      ],
    ),
  );
}

class AddNewSalePage extends HookConsumerWidget {
  const AddNewSalePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final userId = user?.user?.id?.toString();
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('User not found. Please login again.')),
      );
    }

    final isLoadingStores = useState(false);

    final storeId = useState<String?>(null);
    final billNo = useState<String?>(null);
    final newSalesPrices = useState<Map<int, String>>({});
    final priceOldValues = useState<Map<int, String>>({});
    final priceFocusNodes = useState<Map<int, FocusNode>>({});
    final tempPurchaseItems = useState<List<TempPurchaseItem>>([]);
    final tempSubTotal = useState<double>(0.0);
    final tempTotalDiscount = useState<double>(0.0);
    final tempTotalTax = useState<double>(0.0);
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final taxModel = useState<tax.TaxModel?>(null);

    final customerMap = useState<Map<String, String>>({});
    final warehouseMap = useState<Map<String, String>>({});
    final storeMap = useState<Map<String, String>>({});
    final isLoading = useState(false);
    final quantityControllers = useRef(<int, TextEditingController>{});
    final priceControllers = useRef(<int, TextEditingController>{});
    final salesPriceControllers = useRef(<int, TextEditingController>{});
    final discountPercentControllers = useRef(<int, TextEditingController>{});
    final discountAmountControllers = useRef(<int, TextEditingController>{});
    final batchNoControllers = useRef(<int, TextEditingController>{});
    final unitControllers = useState<List<TextEditingController>>(
        List.generate(10, (_) => TextEditingController()));
    final showDropdownRows = useState<Set<int>>({});
    final itemsList = useState<List<item_model.Item>>([]);
    final selectedItem = useState<item_model.Item?>(null);
    final rowFields = useState<Map<int, Map<String, String>>>({});
    final customerId = useState<String?>(null);
    final selectedWarehouse = useState<String?>(null);
    final otherChargesController = useTextEditingController();
    final paidAmountController = useTextEditingController();
    final orderNoController = useTextEditingController();
    final salesNoteController = useTextEditingController();
    final salesType = useState<String?>('Cash');
    final isLoadingSave = useState<bool>(false);
    final isLoadingSavePrint = useState<bool>(false);
    final rowCount = useState<int>(1);
    final itemInputFocusNode = useState<Map<int, FocusNode>>({});
    final itemInputController = useRef(<int, TextEditingController>{});
    final salesOrderId = useState<String>('');

    void onSalesTypeChanged(String? value) {
      salesType.value = value;
      logger.i('Sales type changed to: ${salesType.value}');
    }

    String getCurrentDateFormatted() {
      final now = DateTime.now();
      final month = now.month
          .toString()
          .padLeft(2, '0'); // Ensures 2 digits (e.g., 03 for March)
      final day = now.day
          .toString()
          .padLeft(2, '0'); // Ensures 2 digits (e.g., 05 for the 5th)
      final year = now.year.toString();
      return '$month/$day/$year'; // Format: MM/DD/YYYY
    }

    useEffect(() {
      Future<void> fetchTax() async {
        if (accessToken == null) return;
        isLoading.value = true;
        try {
          taxModel.value = await TaxController().getTaxController();
        } catch (e) {
          debugPrint('Error fetching tax: $e');
        } finally {
          isLoading.value = false;
        }
      }

      fetchTax();
      return () {
        for (var controller in quantityControllers.value.values) {
          controller.dispose();
        }
        for (var controller in priceControllers.value.values) {
          controller.dispose();
        }
        for (var controller in salesPriceControllers.value.values) {
          controller.dispose();
        }
        for (var controller in discountPercentControllers.value.values) {
          controller.dispose();
        }
        for (var controller in discountAmountControllers.value.values) {
          controller.dispose();
        }
        for (var controller in batchNoControllers.value.values) {
          controller.dispose();
        }
        for (var controller in unitControllers.value) {
          controller.dispose();
        }
        for (var node in priceFocusNodes.value.values) {
          node.dispose();
        }
        for (var node in itemInputFocusNode.value.values) {
          node.dispose();
        }
        for (var controller in itemInputController.value.values) {
          controller.dispose();
        }
      };
    }, [accessToken]);

    void initControllers(int index) {
      quantityControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['quantity'] ?? ''));
      priceControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['price'] ?? ''));
      salesPriceControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['salesPrice'] ?? ''));
      discountPercentControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['discountPercent'] ?? ''));
      discountAmountControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['discountAmount'] ?? ''));
      batchNoControllers.value.putIfAbsent(
          index,
          () => TextEditingController(
              text: rowFields.value[index]?['batchNo'] ?? ''));
      unitControllers.value[index].text = rowFields.value[index]?['unit'] ?? '';
      priceFocusNodes.value.putIfAbsent(index, () => FocusNode());
      itemInputFocusNode.value.putIfAbsent(index, () => FocusNode());
      itemInputController.value
          .putIfAbsent(index, () => TextEditingController());
    }

    double recalculateGrandTotal() {
      double subTotalSum = 0.0;
      double taxSum = 0.0;
      for (int i = 0; i < 10; i++) {
        final fields = rowFields.value[i];
        if (fields != null) {
          final salesPrice = double.tryParse(fields['salesPrice'] ?? '0') ?? 0;
          final taxAmount = double.tryParse(fields['taxAmount'] ?? '0') ?? 0;
          final discountAmount =
              double.tryParse(fields['discountAmount'] ?? '0') ?? 0;
          subTotalSum +=
              salesPrice; // Sum base sales price (pre-tax, pre-discount)
          taxSum += taxAmount;
        }
      }
      tempSubTotal.value = subTotalSum;
      tempTotalTax.value = taxSum;
      return subTotalSum + taxSum - tempTotalDiscount.value; // Grand total
    }

    double recalculateTotalDiscount() {
      double discountSum = 0.0;
      for (int i = 0; i < 10; i++) {
        final fields = rowFields.value[i];
        if (fields != null) {
          final quantity = double.tryParse(fields['quantity'] ?? '0') ?? 0;
          final price = double.tryParse(fields['price'] ?? '0') ?? 0;
          final salesPrice = quantity * price;
          double discountAmount =
              double.tryParse(fields['discountAmount'] ?? '0') ?? 0;
          final percent =
              double.tryParse(fields['discountPercent'] ?? '0') ?? 0;
          if (percent > 0 && salesPrice > 0) {
            discountAmount = (salesPrice * percent) / 100;
            discountAmountControllers.value[i]?.text =
                discountAmount.toStringAsFixed(2);
            rowFields.value = {
              ...rowFields.value,
              i: {
                ...?rowFields.value[i],
                'discountAmount': discountAmount.toStringAsFixed(2)
              }
            };
          }
          discountSum += discountAmount;
        }
      }
      tempTotalDiscount.value = discountSum;
      return discountSum;
    }

    Future<String> getBillNumber(
        TextEditingController orderNoController) async {
      final prefs = await SharedPreferences.getInstance();
      final savedBillNo = prefs.getString('billNo') ?? '';

      // Generate a random order number if orderNoController is empty
      String orderNo = orderNoController.text;
      if (orderNo.isEmpty) {
        final random = Random();
        orderNo =
            (10000 + random.nextInt(90000)).toString(); // 5-digit random number
      }

      // Combine savedBillNo and orderNo
      final salesOrderId = '$savedBillNo-$orderNo';
      orderNoController.text = salesOrderId; // Set to controller

      return salesOrderId;
    }

    useEffect(() {
      Future.microtask(() async {
        final orderId = await getBillNumber(orderNoController);
        salesOrderId.value = orderId;
        logger.i('Generated sales order ID: $orderId');
      });
      return null; // Cleanup for useEffect
    }, []);
    void onItemSelected(item_model.Item item, int index) {
      initControllers(index);
      const quantity = 1.0;
      final price = double.tryParse(item.salesPrice ?? '0') ?? 0;
      final salesPrice = quantity * price;
      final taxRate = double.tryParse(item.taxRate ?? '0') ?? 0;
      final taxAmount = salesPrice * taxRate / 100;
      final discountPercent = double.tryParse(item.discount ?? '0') ?? 0;
      final discountAmount =
          discountPercent > 0 ? (salesPrice * discountPercent) / 100 : 0;

      rowFields.value = {
        ...rowFields.value,
        index: {
          'itemName': item.itemName,
          'barcode': item.barcode ?? '',
          'unit': item.unit ?? '',
          'price': item.salesPrice ?? '0',
          'taxRate': item.taxRate ?? '0',
          'taxName': item.taxType ?? '',
          'discount': item.discount ?? '0',
          'discountPercent': item.discount ?? '0',
          'discountAmount': discountAmount.toStringAsFixed(2),
          'quantity': '1',
          'salesPrice': salesPrice.toStringAsFixed(2),
          'itemId': item.id.toString(),
          'taxAmount': taxAmount.toStringAsFixed(2),
          'batchNo': item.sku,
        }
      };

      quantityControllers.value[index]?.text = '1';
      priceControllers.value[index]?.text = item.salesPrice ?? '0';
      salesPriceControllers.value[index]?.text = salesPrice.toStringAsFixed(2);
      discountPercentControllers.value[index]?.text = item.discount ?? '0';
      discountAmountControllers.value[index]?.text =
          discountAmount.toStringAsFixed(2);
      batchNoControllers.value[index]?.text = item.sku ?? '';
      unitControllers.value[index].text = item.unit ?? '';

      priceOldValues.value = {
        ...priceOldValues.value,
        index: item.salesPrice ?? '0'
      };
      newSalesPrices.value = {
        ...newSalesPrices.value,
        index: item.salesPrice ?? '0'
      };
      recalculateGrandTotal();
      recalculateTotalDiscount();

      if (index < 9) {
        rowCount.value = (index + 2).clamp(1, 10);
        initControllers(index + 1);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          itemInputFocusNode.value[index + 1]?.requestFocus();
          itemInputController.value[index]?.clear();
        });
      }
    }

    Widget input({required int rowIndex}) {
      initControllers(rowIndex);
      return Autocomplete<item_model.Item>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<item_model.Item>.empty();
          }
          final query = textEditingValue.text.toLowerCase();
          return itemsList.value.where((item) {
            return (item.itemName ?? '').toLowerCase().contains(query) ||
                (item.barcode ?? '').toLowerCase().contains(query);
          });
        },
        displayStringForOption: (item_model.Item item) => item.itemName,
        onSelected: (item_model.Item item) => onItemSelected(item, rowIndex),
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          itemInputController.value[rowIndex] = controller;
          itemInputFocusNode.value[rowIndex] = focusNode;
          return TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              border: InputBorder.none,
              hintText: 'Enter item name or scan barcode',
            ),
            onSubmitted: (value) {
              final exactMatches = itemsList.value.where((item) {
                return (item.barcode ?? '').toLowerCase() ==
                        value.toLowerCase() ||
                    (item.itemName ?? '').toLowerCase() == value.toLowerCase();
              }).toList();
              if (exactMatches.isNotEmpty) {
                onItemSelected(exactMatches.first, rowIndex);
              }
            },
          );
        },
      );
    }

    bool rowHasData(int index) {
      final row = rowFields.value[index] ?? {};
      return row.values.any((v) => v.trim().isNotEmpty);
    }

    useEffect(() {
      for (int i = 0; i < rowCount.value; i++) {
        if (rowHasData(i)) {
          if (rowCount.value == i + 1 && rowCount.value < 10) {
            rowCount.value = rowCount.value + 1;
            break;
          }
        }
      }
      return null;
    }, [rowFields.value]);

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
                  'New Sale',
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
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SalesPageTopSectionwidget(
                    selectedStore: storeId,
                    selectedCustomer: customerId,
                    selectedWarehouse: selectedWarehouse,
                    itemsList: itemsList,
                    supplierMap: customerMap,
                    warehouseMap: warehouseMap,
                    storeMap: storeMap,
                    accessToken: accessToken!,
                    onCustomerAddSucess: () {
                      // fetchCustomers(storeId.value!);
                    },
                    billNo: billNo,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Text(
                      "Sales Items",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    child: LayoutBuilder(builder: (context, constraints) {
                      const columnCount = 16;
                      const itemFlex = 4;
                      const discountFlex =
                          3; // For Discount column (split into % and Amount)
                      const totalFlex = 0.5 +
                          itemFlex +
                          0.75 +
                          0.75 +
                          1 +
                          1 +
                          1 +
                          1 +
                          discountFlex +
                          1 +
                          1 +
                          1; // Sum of width multipliers
                      final baseColumnWidth = constraints.maxWidth / totalFlex;
                      final itemColumnWidth = baseColumnWidth * itemFlex;
                      final discountColumnWidth =
                          baseColumnWidth * (discountFlex / 2); // 3/2 = 1.5

                      return ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.green.shade200,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: baseColumnWidth * 0.5,
                                    child: HeaderCellWidget(
                                        text: "#",
                                        width: baseColumnWidth * 0.5),
                                  ),
                                  SizedBox(
                                    width: itemColumnWidth,
                                    child: HeaderCellWidget(
                                        text: "Item", width: itemColumnWidth),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth * 0.75,
                                    child: HeaderCellWidget(
                                        text: "SKU",
                                        width: baseColumnWidth * 0.75),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth * 0.75,
                                    child: HeaderCellWidget(
                                        text: "Qty",
                                        width: baseColumnWidth * 0.75),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth,
                                    child: HeaderCellWidget(
                                        text: "Unit", width: baseColumnWidth),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth,
                                    child: HeaderCellWidget(
                                        text: "Price/Unit",
                                        width: baseColumnWidth),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth,
                                    child: HeaderCellWidget(
                                        text: "Sale Price",
                                        width: baseColumnWidth),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth * discountFlex,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Colors.green.shade100),
                                        ),
                                      ),
                                      child: const Column(
                                        children: [
                                          Text(
                                            "Discount",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                child: Center(
                                                  child: Text(
                                                    "%",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Center(
                                                  child: Text(
                                                    "Amt",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth,
                                    child: HeaderCellWidget(
                                        text: "Tax %", width: baseColumnWidth),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth,
                                    child: HeaderCellWidget(
                                        text: "Tax Amt",
                                        width: baseColumnWidth),
                                  ),
                                  SizedBox(
                                    width: baseColumnWidth * 1.5,
                                    child: HeaderCellWidget(
                                      text: "Amount",
                                      width: baseColumnWidth * 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...List.generate(
                              rowCount.value,
                              (index) {
                                initControllers(index);
                                final itemName =
                                    rowFields.value[index]?['itemName'] ?? '';
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.green.shade100),
                                      left: BorderSide(
                                          color: Colors.green.shade100),
                                      right: BorderSide(
                                          color: Colors.green.shade100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DataCellWidget(
                                        width: baseColumnWidth * 0.5,
                                        child:
                                            Center(child: Text("${index + 1}")),
                                      ),
                                      DataCellWidget(
                                        width: itemColumnWidth,
                                        child: itemName.isNotEmpty
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 9,
                                                        vertical: 10),
                                                child: Text(
                                                  itemName,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              )
                                            : input(rowIndex: index),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth * 0.75,
                                        child: TextField(
                                          controller:
                                              batchNoControllers.value[index],
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            rowFields.value = {
                                              ...rowFields.value,
                                              index: {
                                                ...?rowFields.value[index],
                                                'batchNo': value,
                                              }
                                            };
                                          },
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth * 0.75,
                                        child: TextField(
                                          controller:
                                              quantityControllers.value[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            final quantity =
                                                double.tryParse(value) ?? 0;
                                            final price = double.tryParse(
                                                    priceControllers
                                                            .value[index]
                                                            ?.text ??
                                                        '0') ??
                                                0;
                                            final salesPrice = quantity * price;
                                            salesPriceControllers
                                                    .value[index]?.text =
                                                salesPrice.toStringAsFixed(2);
                                            final percent = double.tryParse(
                                                    discountPercentControllers
                                                            .value[index]
                                                            ?.text ??
                                                        '0') ??
                                                0;
                                            final discountAmount =
                                                (salesPrice * percent) / 100;
                                            discountAmountControllers
                                                    .value[index]?.text =
                                                discountAmount
                                                    .toStringAsFixed(2);
                                            final taxRate = double.tryParse(
                                                    rowFields.value[index]
                                                            ?['taxRate'] ??
                                                        '0') ??
                                                0;
                                            final taxAmount =
                                                salesPrice * taxRate / 100;
                                            rowFields.value = {
                                              ...rowFields.value,
                                              index: {
                                                ...?rowFields.value[index],
                                                'quantity': value,
                                                'salesPrice': salesPrice
                                                    .toStringAsFixed(2),
                                                'taxAmount': taxAmount
                                                    .toStringAsFixed(2),
                                                'discountAmount': discountAmount
                                                    .toStringAsFixed(2),
                                              }
                                            };
                                            recalculateGrandTotal();
                                            recalculateTotalDiscount();
                                          },
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: TextField(
                                          controller:
                                              unitControllers.value[index],
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            rowFields.value = {
                                              ...rowFields.value,
                                              index: {
                                                ...?rowFields.value[index],
                                                'unit': value,
                                              }
                                            };
                                          },
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: Focus(
                                          onFocusChange: (hasFocus) async {
                                            if (!hasFocus &&
                                                priceControllers.value[index] !=
                                                    null) {
                                              final oldPrice =
                                                  priceOldValues.value[index] ??
                                                      '0';
                                              priceControllers.value[index]
                                                  ?.text = oldPrice;
                                            }
                                          },
                                          child: TextField(
                                            controller:
                                                priceControllers.value[index],
                                            keyboardType: TextInputType.number,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 6),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              final price =
                                                  double.tryParse(value) ?? 0;
                                              final quantity = double.tryParse(
                                                      quantityControllers
                                                              .value[index]
                                                              ?.text ??
                                                          '0') ??
                                                  0;
                                              final salesPrice =
                                                  quantity * price;
                                              salesPriceControllers
                                                      .value[index]?.text =
                                                  salesPrice.toStringAsFixed(2);
                                              final percent = double.tryParse(
                                                      discountPercentControllers
                                                              .value[index]
                                                              ?.text ??
                                                          '0') ??
                                                  0;
                                              final discountAmount =
                                                  (salesPrice * percent) / 100;
                                              discountAmountControllers
                                                      .value[index]?.text =
                                                  discountAmount
                                                      .toStringAsFixed(2);
                                              final taxRate = double.tryParse(
                                                      rowFields.value[index]
                                                              ?['taxRate'] ??
                                                          '0') ??
                                                  0;
                                              final taxAmount =
                                                  salesPrice * taxRate / 100;
                                              rowFields.value = {
                                                ...rowFields.value,
                                                index: {
                                                  ...?rowFields.value[index],
                                                  'price': value,
                                                  'salesPrice': salesPrice
                                                      .toStringAsFixed(2),
                                                  'taxAmount': taxAmount
                                                      .toStringAsFixed(2),
                                                  'discountAmount':
                                                      discountAmount
                                                          .toStringAsFixed(2),
                                                }
                                              };
                                              recalculateGrandTotal();
                                              recalculateTotalDiscount();
                                            },
                                          ),
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: TextField(
                                          controller: salesPriceControllers
                                              .value[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          readOnly: true,
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: discountColumnWidth,
                                        child: TextField(
                                          controller: discountPercentControllers
                                              .value[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            final percent =
                                                double.tryParse(value) ?? 0;
                                            final salesPrice = double.tryParse(
                                                    salesPriceControllers
                                                            .value[index]
                                                            ?.text ??
                                                        '0') ??
                                                0;
                                            final discountAmount =
                                                (salesPrice * percent) / 100;
                                            discountAmountControllers
                                                    .value[index]?.text =
                                                discountAmount
                                                    .toStringAsFixed(2);
                                            rowFields.value = {
                                              ...rowFields.value,
                                              index: {
                                                ...?rowFields.value[index],
                                                'discountPercent': value,
                                                'discountAmount': discountAmount
                                                    .toStringAsFixed(2),
                                              }
                                            };
                                            recalculateGrandTotal();
                                            recalculateTotalDiscount();
                                          },
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: discountColumnWidth,
                                        child: TextField(
                                          controller: discountAmountControllers
                                              .value[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            final amount =
                                                double.tryParse(value) ?? 0;
                                            final salesPrice = double.tryParse(
                                                    salesPriceControllers
                                                            .value[index]
                                                            ?.text ??
                                                        '0') ??
                                                0;
                                            final percent = salesPrice > 0
                                                ? (amount / salesPrice) * 100
                                                : 0;
                                            discountPercentControllers
                                                    .value[index]?.text =
                                                percent.toStringAsFixed(2);
                                            rowFields.value = {
                                              ...rowFields.value,
                                              index: {
                                                ...?rowFields.value[index],
                                                'discountPercent':
                                                    percent.toStringAsFixed(2),
                                                'discountAmount': value,
                                              }
                                            };
                                            recalculateGrandTotal();
                                            recalculateTotalDiscount();
                                          },
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: GestureDetector(
                                          onTap: () =>
                                              showDropdownRows.value = {
                                            ...showDropdownRows.value,
                                            index
                                          },
                                          child: showDropdownRows.value
                                                  .contains(index)
                                              ? DropdownButtonFormField<String>(
                                                  value: rowFields.value[index]
                                                          ?['taxName'] ??
                                                      (taxModel.value?.data
                                                                  ?.isNotEmpty ??
                                                              false
                                                          ? taxModel
                                                              .value!
                                                              .data!
                                                              .first
                                                              .taxName
                                                          : null),
                                                  isExpanded: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 6),
                                                    border: InputBorder.none,
                                                  ),
                                                  items: taxModel.value?.data
                                                      ?.map((tax) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: tax.taxName,
                                                      child: Text(
                                                        tax.taxName ?? '',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    final selectedTax = taxModel
                                                        .value?.data
                                                        ?.firstWhere(
                                                      (e) => e.taxName == value,
                                                      orElse: () => taxModel
                                                          .value!.data!.first,
                                                    );
                                                    final salesPrice = double.tryParse(
                                                            salesPriceControllers
                                                                    .value[
                                                                        index]
                                                                    ?.text ??
                                                                '0') ??
                                                        0;
                                                    final taxRate =
                                                        double.tryParse(
                                                                selectedTax
                                                                        ?.tax ??
                                                                    '0') ??
                                                            0;
                                                    final taxAmount =
                                                        salesPrice *
                                                            taxRate /
                                                            100;
                                                    rowFields.value = {
                                                      ...rowFields.value,
                                                      index: {
                                                        ...?rowFields
                                                            .value[index],
                                                        'taxName': value ?? '',
                                                        'taxRate':
                                                            selectedTax?.tax ??
                                                                '0',
                                                        'taxAmount': taxAmount
                                                            .toStringAsFixed(2),
                                                      }
                                                    };
                                                    recalculateGrandTotal();
                                                  },
                                                )
                                              : Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 10),
                                                  child: Text(
                                                    rowFields.value[index]
                                                            ?['taxRate'] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text: rowFields.value[index]
                                                      ?['taxAmount'] ??
                                                  ''),
                                          readOnly: true,
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth * 1.5,
                                        child: TextField(
                                          controller: TextEditingController(
                                            text: (() {
                                              final salesPrice =
                                                  double.tryParse(
                                                          salesPriceControllers
                                                                  .value[index]
                                                                  ?.text ??
                                                              '0') ??
                                                      0;
                                              final discountAmount =
                                                  double.tryParse(rowFields
                                                                  .value[index]
                                                              ?[
                                                              'discountAmount'] ??
                                                          '0') ??
                                                      0;
                                              final taxAmount = double.tryParse(
                                                      rowFields.value[index]
                                                              ?['taxAmount'] ??
                                                          '0') ??
                                                  0;
                                              final amount = salesPrice +
                                                  taxAmount -
                                                  discountAmount;
                                              return amount.toStringAsFixed(2);
                                            })(),
                                          ),
                                          readOnly: true,
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SalesPageBottomSectionWidget(
                    subTotal: tempSubTotal.value,
                    totalDiscount: tempTotalDiscount.value,
                    otherChargesController: otherChargesController,
                    paidAmountController: paidAmountController,
                    purchaseNoteController: salesNoteController,
                    onPurchaseTypeChanged: onSalesTypeChanged,
                    purchaseType: salesType.value,
                    orderNoController: orderNoController,
                  ),
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
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 52, 177, 104),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                  ),
                  onPressed: () async {
                    if (isLoadingSavePrint.value) return;
                    if (storeId.value == null ||
                        selectedWarehouse.value == null ||
                        billNo.value == null ||
                        salesType.value == null ||
                        orderNoController.text.isEmpty ||
                        customerId.value == null ||
                        tempSubTotal.value <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all required fields."),
                          backgroundColor: Color.fromARGB(255, 255, 96, 4),
                        ),
                      );
                      return;
                    }

                    isLoadingSavePrint.value = true;
                    try {
                      tempPurchaseItems.value.clear();
                      for (int i = 0; i < 10; i++) {
                        final fields = rowFields.value[i];
                        if (fields != null &&
                            (fields['price'] != null ||
                                fields['quantity'] != null)) {
                          tempPurchaseItems.value.add(
                            TempPurchaseItem(
                              customerId: customerId.value!,
                              purchaseId: '',
                              itemId: fields['itemId'] ?? '',
                              purchaseQty: fields['quantity'] ?? '',
                              pricePerUnit: fields['price'] ?? '',
                              taxName: fields['taxName'] ?? '',
                              taxId: fields['taxId'] ?? '',
                              taxAmount: fields['taxAmount'] ?? '',
                              discountType: fields['discount'] ?? '',
                              discountAmount: fields['discountAmount'] ?? '',
                              totalCost: fields['salesPrice'] ?? '',
                              unit: fields['unit'] ?? '',
                              taxRate: fields['taxRate'] ?? '0',
                              batchNo: fields['batchNo'] ?? '',
                              barcode: fields['barcode'] ?? '',
                            ),
                          );
                        }
                      }

                      final double otherChargesValue =
                          double.tryParse(otherChargesController.text) ?? 0;
                      final double grandTotal = tempSubTotal.value +
                          tempTotalTax.value +
                          otherChargesValue -
                          tempTotalDiscount.value;

                      final saleId = await SalesCreateController(
                        accessToken: accessToken,
                        storeId: storeMap.value[storeId.value]!,
                        warehouseId:
                            warehouseMap.value[selectedWarehouse.value]!,
                        referenceNo: billNo.value!,
                        customerId: customerMap.value[customerId.value]!,
                        salesDate: getCurrentDateFormatted(),
                        otherChargesAmt: otherChargesValue.toString(),
                        discountAmt: tempTotalDiscount.value.toString(),
                        subTotal: tempSubTotal.value.toString(),
                        grandTotal: grandTotal.toString(),
                        salesNote: salesNoteController.text,
                        paidAmount: paidAmountController.text,
                        orderId: orderNoController.text.trim(),
                      ).createSalesController();
                      if (saleId !=
                          "Sales creation failed. Please try again.") {
                        for (var item in tempPurchaseItems.value) {
                          final response = await SingleItemSalesController(
                            accessToken: accessToken,
                            storeId: storeMap.value[storeId.value]!,
                            salesId: saleId,
                            itemId: item.itemId,
                            salesQty: item.purchaseQty,
                            pricePerUnit: item.pricePerUnit,
                            taxName: item.taxName,
                            taxId: item.taxId,
                            taxAmount: item.taxAmount,
                            discountType: item.discountType,
                            discountAmount: item.discountAmount,
                            totalCost: item.totalCost,
                            customerId: customerMap.value[customerId.value]!,
                            itemName: '',
                            description: '',
                          ).singleItemSalesController(context);
                        }

                        final paymentResponse =
                            await SalesPaymentCreateController()
                                .salesPaymentCreateController(
                          accessToken: accessToken,
                          storeId: storeMap.value[storeId.value]!,
                          salesId: saleId,
                          customerId: customerMap.value[customerId.value]!,
                          paymentMethod: salesType.value ?? "Cash",
                          paymentAmount: paidAmountController.text,
                          paymentDate: getCurrentDateFormatted(),
                          paymentNote: salesNoteController.text,
                          accountId: "",
                        );

                        final customerName = customerMap.value.entries
                            .firstWhere(
                              (entry) => entry.value == customerId.value,
                              orElse: () => const MapEntry('', ''),
                            )
                            .key;

                        final storeName = storeMap.value.entries
                            .firstWhere(
                              (entry) => entry.value == storeId.value,
                              orElse: () => const MapEntry('', ''),
                            )
                            .key;

                        String storeAddress = "";
                        // final storeService = ViewStoreService();
                        // final storeModel = await storeService.viewStoreService(
                        //   accessToken,
                        //   storeId.value!,
                        // );
                        // storeAddress = storeModel?.data?.first.address ?? "";

                        final pdfItems = tempPurchaseItems.value.map((item) {
                          final actualItem = itemsList.value.firstWhere(
                            (i) => i.id.toString() == item.itemId,
                            orElse: () => item_model.Item(
                              id: 0,
                              itemName: 'Unknown Item',
                              barcode: '',
                              unit: '',
                              salesPrice: '0',
                              taxRate: '0',
                              taxType: '',
                              discount: '0',
                              sku: '',
                              userId: 0,
                              itemImage: '',
                              storeId: null,
                              categoryId: 0,
                              brandId: 0,
                              hsnCode: '',
                              itemCode: '',
                              description: null,
                              purchasePrice: '',
                              mrp: '',
                              discountType: '',
                              profitMargin: '',
                              warehouse: null,
                              openingStock: null,
                              alertQuantity: '',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              storeName: '',
                              categoryName: '',
                              brandName: '',
                            ),
                          );
                          return InvoiceItem(
                            name: actualItem.itemName,
                            qty: int.tryParse(item.purchaseQty) ?? 0,
                            unit: item.unit,
                            price: double.tryParse(item.pricePerUnit) ?? 0,
                            total: (double.tryParse(item.totalCost) ?? 0) +
                                (double.tryParse(item.taxAmount) ?? 0) -
                                (double.tryParse(item.discountAmount) ?? 0),
                            taxName: item.taxName,
                            taxRate: double.tryParse(item.taxRate) ?? 0,
                          );
                        }).toList();

                        final double calculatedSubTotal = tempSubTotal.value;
                        final double calculatedGrandTotal = calculatedSubTotal +
                            tempTotalTax.value +
                            otherChargesValue -
                            tempTotalDiscount.value;
                        final double calculatedBalance = calculatedGrandTotal -
                            (double.tryParse(paidAmountController.text) ?? 0);

                        final pdfBytes = await generateRealisticInvoice(
                          shopName: storeName,
                          shopAddress: storeAddress,
                          shopContact: userModel?.user?.mobile ?? "",
                          shopEmail: userModel?.user?.email ?? "",
                          invoiceNo: billNo.value!,
                          invoiceDate: getCurrentDateFormatted(),
                          website: "www.greenbiller.com",
                          amountInWords: "",
                          terms: salesNoteController.text,
                          received:
                              double.tryParse(paidAmountController.text) ?? 0,
                          subtotal: calculatedSubTotal,
                          total: calculatedGrandTotal,
                          balance: calculatedBalance,
                          customerName: customerName,
                          paymentMode: salesType.value ?? "Cash",
                          items: pdfItems,
                          totalDiscount: tempTotalDiscount.value,
                          otherCharges: otherChargesValue,
                          totalTax: tempTotalTax.value,
                        );

                        try {
                          await Printing.layoutPdf(
                            onLayout: (format) => pdfBytes,
                            name: 'Sale_Invoice_${billNo.value!}',
                          );
                        } catch (e) {
                          logger.e("Error printing: $e");
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Sale saved and printed successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(saleId),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Something went wrong: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      isLoadingSavePrint.value = false;
                    }
                  },
                  child: isLoadingSavePrint.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save & Print",
                          style: TextStyle(color: Colors.white)),
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
                child: TextButton(
                  style: TextButton.styleFrom(
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
                  onPressed: () async {
                    if (isLoadingSave.value) return;
                    if (storeId.value == null ||
                        selectedWarehouse.value == null ||
                        billNo.value == null ||
                        orderNoController.text.isEmpty ||
                        salesType.value == null ||
                        customerId.value == null ||
                        tempSubTotal.value <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all required fields."),
                          backgroundColor: Color.fromARGB(255, 255, 96, 4),
                        ),
                      );
                      return;
                    }
                    isLoadingSave.value = true;
                    try {
                      tempPurchaseItems.value.clear();
                      for (int i = 0; i < 10; i++) {
                        final fields = rowFields.value[i];
                        if (fields != null &&
                            (fields['price'] != null ||
                                fields['quantity'] != null)) {
                          tempPurchaseItems.value.add(
                            TempPurchaseItem(
                              customerId: customerMap.value[customerId.value]!,
                              purchaseId: '',
                              itemId: fields['itemId'] ?? '',
                              purchaseQty: fields['quantity'] ?? '',
                              pricePerUnit: fields['price'] ?? '',
                              taxName: fields['taxName'] ?? '',
                              taxId: fields['taxId'] ?? '',
                              taxAmount: fields['taxAmount'] ?? '',
                              discountType: fields['discount'] ?? '',
                              discountAmount: fields['discountAmount'] ?? '',
                              totalCost: fields['salesPrice'] ?? '',
                              unit: fields['unit'] ?? '',
                              taxRate: fields['taxRate'] ?? '0',
                              batchNo: fields['batchNo'] ?? '',
                              barcode: fields['barcode'] ?? '',
                            ),
                          );
                        }
                      }

                      final double otherChargesValue =
                          double.tryParse(otherChargesController.text) ?? 0;
                      final double grandTotal = tempSubTotal.value +
                          tempTotalTax.value +
                          otherChargesValue -
                          tempTotalDiscount.value;

                      final saleId = await SalesCreateController(
                        storeId: storeMap.value[storeId.value]!,
                        warehouseId:
                            warehouseMap.value[selectedWarehouse.value]!,
                        referenceNo: billNo.value!,
                        customerId: customerMap.value[customerId.value]!,
                        salesDate: getCurrentDateFormatted(),
                        accessToken: accessToken,
                        otherChargesAmt: otherChargesValue.toString(),
                        discountAmt: tempTotalDiscount.value.toString(),
                        subTotal: tempSubTotal.value.toString(),
                        grandTotal: grandTotal.toString(),
                        salesNote: salesNoteController.text,
                        paidAmount: paidAmountController.text,
                        orderId: orderNoController.text.trim(),
                      ).createSalesController();
                      if (saleId !=
                          "Sales creation failed. Please try again.") {
                        for (var item in tempPurchaseItems.value) {
                          final response = await SingleItemSalesController(
                            accessToken: accessToken,
                            storeId: storeMap.value[storeId.value]!,
                            salesId: saleId,
                            itemId: item.itemId,
                            salesQty: item.purchaseQty,
                            pricePerUnit: item.pricePerUnit,
                            taxName: item.taxName,
                            taxId: item.taxId,
                            taxAmount: item.taxAmount,
                            discountType: item.discountType,
                            discountAmount: item.discountAmount,
                            totalCost: item.totalCost,
                            customerId: customerMap.value[customerId.value]!,
                            itemName: '',
                            description: '',
                          ).singleItemSalesController(context);
                        }

                        final paymentResponse =
                            await SalesPaymentCreateController()
                                .salesPaymentCreateController(
                          accessToken: accessToken,
                          storeId: storeMap.value[storeId.value]!,
                          salesId: saleId,
                          customerId: customerMap.value[customerId.value]!,
                          paymentMethod: salesType.value ?? "Cash",
                          paymentAmount: paidAmountController.text,
                          paymentDate: getCurrentDateFormatted(),
                          paymentNote: salesNoteController.text,
                          accountId: "1",
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Sale saved successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(saleId),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Something went wrong: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      isLoadingSave.value = false;
                    }
                  },
                  child: isLoadingSave.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save",
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

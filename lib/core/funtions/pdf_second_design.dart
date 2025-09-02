import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceItem {
  final String name;
  final String? hsn;
  final int qty;
  final String unit;
  final double price;
  final double total;
  final List<String>? serialNumber;

  const InvoiceItem({
    required this.name,
    this.hsn,
    required this.qty,
    required this.unit,
    required this.price,
    required this.total,
    this.serialNumber,
  });

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      name: map['name'] as String,
      serialNumber: map['serialNumber'] as List<String>?,
      hsn: map['hsn'] as String?,
      qty: map['qty'] as int,
      unit: map['unit'] as String,
      price: (map['price'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hsn': hsn,
      'qty': qty,
      'unit': unit,
      'price': price,
      'total': total,
    };
  }
}

Future<File> pdfFormatSecond({
  required String shopName,
  required String shopAddress,
  required String shopContact,
  required String shopEmail,
  required String shopState,
  required String invoiceNo,
  required DateTime invoiceDate,
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
  required bool print,
  required double totalDiscount,
  required double otherCharges,
  // required double paidAmount,
}) async {
  final pdf = pw.Document();

  final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [
        // Header row
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    shopName,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                      color: PdfColors.blue,
                    ),
                  ),
                  pw.Text(shopAddress),
                  pw.Text("Phone: $shopContact"),
                  pw.Text("Email: $shopEmail"),
                  pw.Text("State: $shopState"),
                ],
              ),
            ),
            pw.Container(
              width: 60,
              height: 60,
              alignment: pw.Alignment.center,
              child: pw.Text(
                'LOGO',
                style: pw.TextStyle(
                  color: PdfColors.green400,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Container(height: 2, color: PdfColors.blue),
        pw.SizedBox(height: 10),
        // Invoice meta
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Tax Invoice',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 18,
                color: PdfColors.blue,
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Invoice No: $invoiceNo',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text('Date: ${invoiceDate.toString().split(' ')[0]}'),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        // Customer section
        pw.Row(
          children: [
            pw.Text(
              'Bill To: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(customerName),
          ],
        ),
        pw.SizedBox(height: 10),
        // Table
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.white),
          columnWidths: {
            0: const pw.FixedColumnWidth(24),
            1: const pw.FlexColumnWidth(3),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FixedColumnWidth(40),
            4: const pw.FixedColumnWidth(40),
            5: const pw.FlexColumnWidth(2),
            6: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    '#',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'Item name',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'HSN/ SAC',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'Quantity',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'Unit',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(
                    'Price/ unit',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Amount',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'inc. all taxes',
                        style: pw.TextStyle(
                          color: PdfColors.grey200,
                          fontWeight: pw.FontWeight.normal,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ...List.generate(items.length, (i) {
              final item = items[i];
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text((i + 1).toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(item.name),
                        if (item.serialNumber != null &&
                            item.serialNumber!.isNotEmpty)
                          pw.Text(
                            'S/N: ${item.serialNumber!.join(", ")}',
                            style: const pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.hsn ?? ''),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qty.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.unit ?? '-'),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      '₹${item.total.toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        pw.SizedBox(height: 8),
        // Summary
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              width: 220,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Sub Total', style: pw.TextStyle(font: ttf)),
                      pw.Text(
                        '₹${subtotal.toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Other Charges', style: pw.TextStyle(font: ttf)),
                      pw.Text(
                        '₹${otherCharges.toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Discount', style: pw.TextStyle(font: ttf)),
                      pw.Text(
                        '₹${totalDiscount.toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Grand caTotal',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          // color: PdfColors,
                          font: ttf,
                        ),
                      ),
                      pw.Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          // color: PdfColors.white,
                          font: ttf,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    color: PdfColors.green800,
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Received',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            font: ttf,
                          ),
                        ),
                        pw.Text(
                          '₹${received.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            font: ttf,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Balance', style: pw.TextStyle(font: ttf)),
                      pw.Text(
                        '₹${balance.toStringAsFixed(2)}',
                        style: pw.TextStyle(font: ttf),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Payment Mode'),
                      pw.Text(paymentMode),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),
        // Footer
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              website,
              style: const pw.TextStyle(color: PdfColors.blue, fontSize: 10),
            ),
            pw.Container(
              color: PdfColors.grey300,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              child: pw.Text(
                'Digitaly Generated On GreenBiller',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/green_biller_invoice.pdf");
  await file.writeAsBytes(await pdf.save());
  if (print) {
    await OpenFile.open(file.path);
  }
  return file;
}

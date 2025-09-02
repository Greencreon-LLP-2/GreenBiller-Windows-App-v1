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
}

Future<File> pdfFormatThird({
  required String shopName,
  required String shopAddress,
  required String shopContact,
  required String shopEmail,
  // required String shopState,
  required String gstin,
  required String invoiceNo,
  required DateTime invoiceDate,
  required String website,
  // required String amountInWords,
  required String terms,
  required double received,
  required double subtotal,
  required double total,
  required double balance,
  required String customerName,
  required String customerAddress,
  required String customerContact,
  required String paymentMode,
  required List<InvoiceItem> items,
  required bool print,
  required double totalDiscount,
  required double otherCharges,
  required List<Map<String, dynamic>>
      taxSummary, // [{hsn, taxable, cgst, sgst, totalTax}]
  required double roundOff,
  required double earnedPoints,
  required double availablePoints,
  required String bankName,
  required String accountNo,
}) async {
  final pdf = pw.Document();
  final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16),
      build: (context) => [
        // Header
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 60,
              height: 60,
              child: pw.Text('LOGO',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green,
                      font: ttf)),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(shopName,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                          color: PdfColors.blue,
                          font: ttf)),
                  pw.Text(shopAddress, style: pw.TextStyle(font: ttf)),
                  pw.Text("Phone: $shopContact",
                      style: pw.TextStyle(font: ttf)),
                  pw.Text("Email: $shopEmail", style: pw.TextStyle(font: ttf)),
                  pw.Text("GSTIN: $gstin", style: pw.TextStyle(font: ttf)),
                  // pw.Text("State: $shopState", style: pw.TextStyle(font: ttf)),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Container(height: 2, color: PdfColors.blue),
        pw.SizedBox(height: 8),
        // Bill To & Invoice Details
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Bill To:',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, font: ttf)),
                pw.Text(customerName, style: pw.TextStyle(font: ttf)),
                pw.Text(customerAddress, style: pw.TextStyle(font: ttf)),
                pw.Text('Contact: $customerContact',
                    style: pw.TextStyle(font: ttf)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Invoice No: $invoiceNo',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, font: ttf)),
                pw.Text('Date: ${invoiceDate.toString().split(' ')[0]}',
                    style: pw.TextStyle(font: ttf)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        // Item Table
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FixedColumnWidth(20),
            1: const pw.FlexColumnWidth(3),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FixedColumnWidth(40),
            4: const pw.FixedColumnWidth(40),
            5: const pw.FlexColumnWidth(2),
            6: const pw.FlexColumnWidth(2),
            7: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.blue),
              children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('#',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Item name',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('HSN/ SAC',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Quantity',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Unit',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Price/Unit',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('GST',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Amount',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                            font: ttf))),
              ],
            ),
            ...List.generate(items.length, (i) {
              final item = items[i];
              // You can add GST calculation logic here if needed
              return pw.TableRow(
                children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text((i + 1).toString(),
                          style: pw.TextStyle(font: ttf))),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(item.name, style: pw.TextStyle(font: ttf)),
                        if (item.serialNumber != null &&
                            item.serialNumber!.isNotEmpty)
                          pw.Text('Serial: ${item.serialNumber!.join(", ")}',
                              style: pw.TextStyle(
                                  fontSize: 8,
                                  color: PdfColors.grey,
                                  font: ttf)),
                      ],
                    ),
                  ),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(item.hsn ?? '',
                          style: pw.TextStyle(font: ttf))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(item.qty.toString(),
                          style: pw.TextStyle(font: ttf))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child:
                          pw.Text(item.unit, style: pw.TextStyle(font: ttf))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('₹${item.price.toStringAsFixed(2)}',
                          style: pw.TextStyle(font: ttf))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('GST%',
                          style: pw.TextStyle(
                              font:
                                  ttf))), // Replace with actual GST if available
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('₹${item.total.toStringAsFixed(2)}',
                          style: pw.TextStyle(font: ttf))),
                ],
              );
            }),
          ],
        ),
        pw.SizedBox(height: 12),
        // Tax Summary Table
        pw.Text('Tax Summary:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('HSN/SAC',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Taxable Amount',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('CGST',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('SGST',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: ttf))),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text('Total Tax',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: ttf))),
              ],
            ),
            ...taxSummary.map((row) => pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(row['hsn'].toString(),
                            style: pw.TextStyle(font: ttf))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('₹${row['taxable'].toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('₹${row['cgst'].toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('₹${row['sgst'].toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text('₹${row['totalTax'].toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))),
                  ],
                )),
          ],
        ),
        pw.SizedBox(height: 12),
        // Summary Section
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Terms & Conditions:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text(terms, style: pw.TextStyle(fontSize: 8, font: ttf)),
                  pw.SizedBox(height: 8),
                  pw.Text('Bank Details:',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                  pw.Text('Name: $bankName', style: pw.TextStyle(font: ttf)),
                  pw.Text('Account No.: $accountNo',
                      style: pw.TextStyle(font: ttf)),
                ],
              ),
            ),
            pw.Container(
              width: 220,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Sub Total', style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${subtotal.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Other Charges',
                            style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${otherCharges.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Discount',
                            style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${totalDiscount.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Round Off', style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${roundOff.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total', style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${total.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  // pw.Row(
                  //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       pw.Text('Amount in Words',
                  //           style: pw.TextStyle(font: ttf)),
                  // pw.Text(amountInWords,
                  //     style: pw.TextStyle(fontSize: 8, font: ttf))
                  // ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Received', style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${received.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Balance', style: pw.TextStyle(font: ttf)),
                        pw.Text('₹${balance.toStringAsFixed(2)}',
                            style: pw.TextStyle(font: ttf))
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Payment Mode', style: pw.TextStyle(font: ttf)),
                        pw.Text(paymentMode, style: pw.TextStyle(font: ttf))
                      ]),
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
            pw.Text(website,
                style: pw.TextStyle(
                    color: PdfColors.blue, fontSize: 10, font: ttf)),
            pw.Text('Authorized Signatory',
                style: pw.TextStyle(fontSize: 10, font: ttf)),
          ],
        ),
      ],
    ),
  );

  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/tax_invoice_$invoiceNo.pdf");
  await file.writeAsBytes(await pdf.save());
  if (print) {
    await OpenFile.open(file.path);
  }
  return file;
}

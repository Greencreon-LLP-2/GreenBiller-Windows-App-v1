import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> pdfFormatFirst() async {
  final pdf = pw.Document();

  // Business and invoice details
  const shopName = "Greenhone";
  const shopAddress = "Avittom, Mukhathala, Kollam";
  const shopContact = "9020583270";
  const shopEmail = "greenhonetech@gmail.com";
  const shopState = "32-Kerala";
  const invoiceNo = "INV-2025-001";
  final invoiceDate = DateTime.now();
  const website = "www.greenhone.in";
  const amountInWords = "One Lakh Ninety Thousand and Eighty Five Rupees only";
  const terms =
      "Thank you for doing business with us. For more about us visit : $website";
  final bankDetails = [
    "Bank Name: CANARA BANK, TRIKOVILVATTAM",
    "Bank Account No.: 120000132319",
    "Bank IFSC code: CNRB0000999",
    "Account Holder's Name: GREENHONE",
  ];
  const received = 170000.0;
  const subtotal = 190085.0;
  const total = 190085.0;
  const balance = total - received;

  const customerName = "Karthik Rajendran";

  const paymentMode = "Cash";

  // Items
  final items = [
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Tenda router", "qty": 2, "price": 1650.0, "total": 3300.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "60m hdmi extenter", "qty": 1, "price": 1000.0, "total": 1000.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
    {"name": "Wireless mouse", "qty": 1, "price": 800.0, "total": 800.0},
  ];

  final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => [
        // HEADER
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Company info
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    shopName,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  pw.Text(shopAddress),
                  pw.Text("Phone no.: $shopContact"),
                  pw.Text("Email: $shopEmail"),
                  pw.Text("State: $shopState"),
                ],
              ),
            ),
            // Logo
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
        // Blue line under header
        pw.Container(height: 2, color: PdfColors.green400),
        pw.SizedBox(height: 12),
        // Title
        pw.Center(
          child: pw.Text(
            'Tax Invoice',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
              color: PdfColors.blue,
            ),
          ),
        ),
        pw.SizedBox(height: 12),
        // Bill To and Invoice Details
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Bill To
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Bill To',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(customerName),
                  // Add more customer fields if needed
                ],
              ),
            ),
            // Invoice Details
            pw.Container(
              width: 200,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Invoice Details',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Invoice No.: $invoiceNo',
                    style: const pw.TextStyle(color: PdfColors.red),
                  ),
                  pw.Text('Date: ${invoiceDate.toString().split(' ')[0]}'),
                  pw.Text('PO date: 20-02-2025'), // Example static value
                  pw.Text('PO number: 1314'), // Example static value
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
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
            // Table header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.green400),
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
                  child: pw.Text(
                    'Amount',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Table rows (example with multiline description)
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
                        pw.Text(item['name'].toString()),
                        if (item['description'] != null)
                          pw.Text(
                            item['description'].toString(),
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text((item['hsn'] ?? '').toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item['qty'].toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text((item['unit'] ?? '-').toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      '₹${((item['price'] ?? 0) as double).toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      '₹${((item['total'] ?? 0) as double).toStringAsFixed(2)}',
                      style: pw.TextStyle(font: ttf),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        // SUMMARY SECTION (after table, so it appears after the last page of the table)
        pw.SizedBox(height: 8),
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
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          font: ttf,
                        ),
                      ),
                      pw.Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
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

        // Branding row
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              color: PdfColors.grey300,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              child: pw.Text(
                'Generated For Free On GreenBiller',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 16),

        // FOOTER
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left: Details, QR, Bank
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    shopName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(shopAddress),
                  pw.Text("Phone no.: $shopContact"),
                  pw.Text("Email: $shopEmail"),
                  pw.Text("State: $shopState"),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Invoice Amount In Words',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(amountInWords),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Terms And Conditions',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(terms),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    children: [
                      // QR code placeholder
                      pw.Container(
                        width: 70,
                        height: 70,
                        color: PdfColors.grey300,
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          'QR CODE',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Pay To:'),
                          ...bankDetails.map((b) => pw.Text(b)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            // Right: Logo, signature/stamp
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Container(
                  width: 60,
                  height: 60,
                  color: PdfColors.green400,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'LOGO',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Container(
                  width: 80,
                  height: 40,
                  color: PdfColors.grey300,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'SIGNATURE/STAMP',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Authorized Signatory',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'For: Greenhone',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 8),
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
                'Generated For Free On GreenBiller',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  final output = await getApplicationDocumentsDirectory();
  final file = File("${output.path}/real_invoice.pdf");
  await file.writeAsBytes(await pdf.save());
  await OpenFile.open(file.path);
}

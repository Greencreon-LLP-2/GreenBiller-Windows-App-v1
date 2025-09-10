import 'dart:typed_data';

import 'package:greenbiller/features/sale/model/invoice_item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
                    pw.Text(
                      "Invoice: $invoiceNo",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      "Date: ${invoiceDate.toString()}",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      "Customer: $customerName",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      "Payment: $paymentMode",
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      "Item",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      "Qty",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Price",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      "Total",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
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
                            pw.Text(
                              item.name,
                              style: const pw.TextStyle(fontSize: 7),
                            ),
                            pw.Text(
                              "${item.unit} | ${item.taxName} ${item.taxRate}%",
                              style: const pw.TextStyle(
                                fontSize: 6,
                                color: PdfColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          item.qty.toString(),
                          style: const pw.TextStyle(fontSize: 7),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          item.price.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 7),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          item.total.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 7),
                        ),
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
                              pw.Text(
                                "Payment Method:",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 6,
                                ),
                              ),
                              pw.Text(
                                paymentMode,
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue700,
                                  fontSize: 6,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Amount Paid:",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 6,
                                ),
                              ),
                              pw.Text(
                                received.toStringAsFixed(2),
                                style: const pw.TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                "Balance Due:",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 6,
                                ),
                              ),
                              pw.Text(
                                balance.toStringAsFixed(2),
                                style: const pw.TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

pw.Widget _buildSummaryRow(
  String label,
  double value, {
  bool isBold = false,
  double fontSize = 7,
}) {
  final style = pw.TextStyle(
    fontSize: fontSize,
    fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );

  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        pw.Expanded(flex: 3, child: pw.Text(label, style: style)),
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

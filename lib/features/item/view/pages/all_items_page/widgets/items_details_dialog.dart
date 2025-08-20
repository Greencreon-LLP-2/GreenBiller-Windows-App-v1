import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:green_biller/core/constants/colors.dart';

class ItemDetailsDialog extends StatelessWidget {
  final String itemId;
  final String itemName;
  final String itemCode;
  final String barcode;
  final String categoryName;
  final String brandName;
  final String storeName;
  final int stock;
  final double price;
  final String mrp;
  final String unit;
  final String sku;
  final double profitMargin;
  final double taxRate;
  final String taxType;
  final String discountType;
  final String discount;
  final String alertQuantity;
  final String? imageUrl;

  const ItemDetailsDialog({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.barcode,
    required this.categoryName,
    required this.brandName,
    required this.storeName,
    required this.stock,
    required this.price,
    required this.mrp,
    required this.unit,
    required this.sku,
    required this.profitMargin,
    required this.taxRate,
    required this.taxType,
    required this.discountType,
    required this.discount,
    required this.alertQuantity,
    this.imageUrl,
  });

  Future<void> _printBarcode() async {
    final pdf = pw.Document();
    const double barcodeWidth = 30;
    const double barcodeHeight = 20;
    const double padding = 10;
    const int rows = 10;
    const int columns = 2;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(padding),
            child: pw.GridView(
              crossAxisCount: columns,
              crossAxisSpacing: padding,
              mainAxisSpacing: padding,
              childAspectRatio: barcodeWidth / barcodeHeight,
              children: List.generate(rows * columns, (index) {
                return pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300, width: 1),
                  ),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.code128(),
                    data: barcode,
                    drawText: true,
                    textStyle: const pw.TextStyle(fontSize: 10),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final safeAlertQty = int.tryParse(alertQuantity) ?? 0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 520,
          maxHeight: 720,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Item Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: imageUrl != null && imageUrl!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.grey.shade100,
                                              Colors.grey.shade200,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor.withOpacity(0.1),
                                        primaryColor.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.inventory_2_rounded,
                                    size: 48,
                                    color: primaryColor.withOpacity(0.6),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: textPrimaryColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: barcode.isNotEmpty
                                            ? BarcodeWidget(
                                                barcode: Barcode.code128(),
                                                data: barcode,
                                                drawText: false,
                                                color: Colors.black,
                                                padding:
                                                    const EdgeInsets.all(5),
                                              )
                                            : const Icon(
                                                Icons.broken_image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton.icon(
                                        onPressed: barcode.isNotEmpty
                                            ? _printBarcode
                                            : null,
                                        icon: const Icon(Icons.print, size: 16),
                                        label: const Text('Print Barcodes'),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      accentColor.withOpacity(0.1),
                                      primaryColor.withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: accentColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  categoryName,
                                  style: const TextStyle(
                                    color: textPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: stock > safeAlertQty
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: stock > safeAlertQty
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.orange.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      stock > safeAlertQty
                                          ? Icons.check_circle_rounded
                                          : Icons.warning_rounded,
                                      color: stock > safeAlertQty
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      stock > safeAlertQty
                                          ? 'In Stock'
                                          : 'Low Stock',
                                      style: TextStyle(
                                        color: stock > safeAlertQty
                                            ? Colors.green
                                            : Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.15),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPriceInfo(
                              'Sales Price',
                              '₹${price.toStringAsFixed(2)}',
                              textSecondaryColor),
                          _buildDivider(),
                          _buildPriceInfo('MRP', '₹$mrp', textSecondaryColor),
                          _buildDivider(),
                          _buildPriceInfo(
                              'Stock',
                              '$stock ',
                              stock > safeAlertQty
                                  ? Colors.green
                                  : Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                        'Product Information', Icons.info_rounded),
                    const SizedBox(height: 16),
                    _buildDetailsGrid([
                      _buildDetailRow('Item Code', Icons.numbers, itemCode),
                      _buildDetailRow('SKU', Icons.qr_code, sku),
                      _buildDetailRow('Barcode', Icons.barcode_reader, barcode),
                      _buildDetailRow(
                          'Brand', Icons.branding_watermark_rounded, brandName),
                      _buildDetailRow('Store', Icons.store, storeName),
                      _buildDetailRow('Unit', Icons.scale, unit),
                    ]),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                        'Pricing & Tax', Icons.attach_money_rounded),
                    const SizedBox(height: 16),
                    _buildDetailsGrid([
                      _buildDetailRow(
                          'Profit Margin',
                          Icons.trending_up_rounded,
                          '${profitMargin.toStringAsFixed(1)}%'),
                      _buildDetailRow('Tax Rate', Icons.percent_rounded,
                          '${taxRate.toStringAsFixed(1)}%'),
                      _buildDetailRow('Tax Type', Icons.receipt_long_rounded,
                          taxType.toUpperCase()),
                      _buildDetailRow('Discount Type', Icons.discount_rounded,
                          discountType.isEmpty ? 'None' : discountType),
                      _buildDetailRow('Discount', Icons.percent_rounded,
                          discount.isEmpty ? '0%' : '$discount%'),
                      _buildDetailRow('Alert Quantity',
                          Icons.notifications_active_rounded, alertQuantity),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _buildDetailRow(
      String title, IconData icon, String value) {
    return {
      'title': title,
      'icon': icon,
      'value': value,
    };
  }

  Widget _buildPriceInfo(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: textPrimaryColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1.5,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: accentColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimaryColor,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(List<Map<String, dynamic>> details) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: details.map((detail) {
          bool isLast = details.indexOf(detail) == details.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    detail['icon'],
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['title'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detail['value'],
                        style: const TextStyle(
                          color: textPrimaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

void showItemDetailsDialog({
  required BuildContext context,
  required String itemId,
  required String itemName,
  required String itemCode,
  required String barcode,
  required String categoryName,
  required String brandName,
  required String storeName,
  required int stock,
  required double price,
  required String mrp,
  required String unit,
  required String sku,
  required double profitMargin,
  required double taxRate,
  required String taxType,
  required String discountType,
  required String discount,
  required String alertQuantity,
  String? imageUrl,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ItemDetailsDialog(
        itemId: itemId,
        itemName: itemName,
        itemCode: itemCode,
        barcode: barcode,
        categoryName: categoryName,
        brandName: brandName,
        storeName: storeName,
        stock: stock,
        price: price,
        mrp: mrp,
        unit: unit,
        sku: sku,
        profitMargin: profitMargin,
        taxRate: taxRate,
        taxType: taxType,
        discountType: discountType,
        discount: discount,
        alertQuantity: alertQuantity,
        imageUrl: imageUrl,
      );
    },
  );
}

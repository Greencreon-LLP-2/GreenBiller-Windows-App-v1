import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ItemDetailsDialog extends StatefulWidget {
  final Item item;

  const ItemDetailsDialog({super.key, required this.item});

  @override
  _ItemDetailsDialogState createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends State<ItemDetailsDialog> {
  int _barcodeCount = 1;

  Future<void> _printBarcode() async {
    final pdf = pw.Document();
    const double barcodeWidth = 50;
    const double barcodeHeight = 20;
    const double padding = 0;
    const int columns = 2;
    final int rows = (_barcodeCount / columns).ceil();

    final pageFormat = PdfPageFormat(
      2 * PdfPageFormat.inch,
      1 * PdfPageFormat.inch * rows,
      marginAll: 4,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (context) {
          return pw.GridView(
            crossAxisCount: columns,
            childAspectRatio: barcodeWidth / barcodeHeight,
            padding: const pw.EdgeInsets.all(padding),
            children: List.generate(_barcodeCount, (index) {
              return pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      widget.item.storeName,
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 1),
                    pw.Text(
                      widget.item.itemName,
                      style: const pw.TextStyle(fontSize: 6),
                      textAlign: pw.TextAlign.center,
                      maxLines: 1,
                    ),
                    pw.SizedBox(height: 1),
                    pw.Text(
                      'MRP: ${widget.item.salesPrice.toString()}',
                      style: const pw.TextStyle(fontSize: 7),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 2),
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.code128(),
                      data: widget.item.barcode,
                      width: barcodeWidth,
                      height: barcodeHeight,
                      drawText: false,
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeAlertQty = int.tryParse(widget.item.alertQuantity) ?? 0;
    final openingStock = int.tryParse(widget.item.openingStock ?? '0') ?? 0;
    final isInStock = openingStock > safeAlertQty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 750),
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
                      onPressed: () => Get.back(),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 190,
                              child: Text(
                                widget.item.itemName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimaryColor,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 200,
                              height: 190,
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
                              child: widget.item.itemImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        widget.item.itemImage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                                                  Icons
                                                      .image_not_supported_rounded,
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
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.item.storeName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: textPrimaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.item.itemName,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: textPrimaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${widget.item.salesPrice.toString()}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: textPrimaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 6),
                                        widget.item.barcode.isNotEmpty
                                            ? BarcodeWidget(
                                                barcode: Barcode.code128(),
                                                data: widget.item.barcode,
                                                drawText: false,
                                                color: Colors.black,
                                                height: 40,
                                                padding: const EdgeInsets.all(
                                                  5,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.broken_image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 80,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'Count',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                          ),
                                          style: const TextStyle(fontSize: 14),
                                          textAlign: TextAlign.center,
                                          onChanged: (value) {
                                            setState(() {
                                              _barcodeCount =
                                                  int.tryParse(value) ?? 1;
                                              if (_barcodeCount < 1)
                                                _barcodeCount = 1;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed:
                                            widget.item.barcode.isNotEmpty
                                            ? _printBarcode
                                            : null,
                                        icon: const Icon(Icons.print, size: 16),
                                        label: const Text(
                                          'Print',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          backgroundColor: accentColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          accentColor.withOpacity(0.15),
                                          primaryColor.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: accentColor.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Text(
                                      widget.item.categoryName,
                                      style: const TextStyle(
                                        color: textPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isInStock
                                          ? Colors.green.withOpacity(0.15)
                                          : Colors.orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isInStock
                                            ? Colors.green.withOpacity(0.3)
                                            : Colors.orange.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isInStock
                                              ? Icons.check_circle_rounded
                                              : Icons.warning_rounded,
                                          color: isInStock
                                              ? Colors.green
                                              : Colors.orange,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isInStock
                                              ? 'In Stock ($openingStock)'
                                              : 'Low Stock ($openingStock)',
                                          style: TextStyle(
                                            color: isInStock
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
                            '₹${widget.item.salesPrice.toString()}',
                            textSecondaryColor,
                          ),
                          _buildDivider(),
                          _buildPriceInfo(
                            'MRP',
                            '₹${widget.item.mrp}',
                            textSecondaryColor,
                          ),
                          _buildDivider(),
                          _buildPriceInfo(
                            'Stock',
                            '${openingStock}',
                            openingStock > safeAlertQty
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      'Product Information',
                      Icons.info_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailsGrid([
                      _buildDetailRow(
                        'Item Code',
                        Icons.numbers,
                        widget.item.itemCode,
                      ),
                      _buildDetailRow('SKU', Icons.qr_code, widget.item.sku),
                      _buildDetailRow(
                        'Barcode',
                        Icons.barcode_reader,
                        widget.item.barcode,
                      ),
                      _buildDetailRow(
                        'Brand',
                        Icons.branding_watermark_rounded,
                        widget.item.brandName,
                      ),
                      _buildDetailRow(
                        'Store',
                        Icons.store,
                        widget.item.storeName,
                      ),
                      _buildDetailRow(
                        'Unit',
                        Icons.scale,
                        widget.item.unitId.toString(),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSectionTitle(
                      'Pricing & Tax',
                      Icons.attach_money_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailsGrid([
                      _buildDetailRow(
                        'Profit Margin',
                        Icons.trending_up_rounded,
                        '${widget.item.profitMargin.toString()}%',
                      ),
                      _buildDetailRow(
                        'Tax Rate',
                        Icons.percent_rounded,
                        '${widget.item.taxRate.toString()}%',
                      ),
                      _buildDetailRow(
                        'Tax Type',
                        Icons.receipt_long_rounded,
                        widget.item.taxType.toUpperCase(),
                      ),
                      _buildDetailRow(
                        'Discount Type',
                        Icons.discount_rounded,
                        widget.item.discountType.isEmpty
                            ? 'None'
                            : widget.item.discountType,
                      ),
                      _buildDetailRow(
                        'Discount',
                        Icons.percent_rounded,
                        widget.item.discount.isEmpty
                            ? '0%'
                            : '${widget.item.discount}%',
                      ),
                      _buildDetailRow(
                        'Alert Quantity',
                        Icons.notifications_active_rounded,
                        widget.item.alertQuantity,
                      ),
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
    String title,
    IconData icon,
    String value,
  ) {
    return {'title': title, 'icon': icon, 'value': value};
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
          child: Icon(icon, size: 20, color: accentColor),
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
        border: Border.all(color: Colors.grey, width: 1.5),
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
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
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
                  child: Icon(detail['icon'], size: 20, color: Colors.black),
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
  required Item item,
}) {
  Get.dialog(ItemDetailsDialog(item: item), barrierDismissible: true);
}

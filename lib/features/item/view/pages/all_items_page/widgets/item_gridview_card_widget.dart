import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/item/controller/edit_item_controller.dart';
import 'package:green_biller/features/item/services/item/view_all_item_services.dart';
import 'package:green_biller/features/item/view/pages/all_items_page/widgets/items_details_dialog.dart';
import 'package:green_biller/utils/dialog.dart';

class ItemGridViewCardWidget extends StatefulWidget {
  const ItemGridViewCardWidget({
    super.key,
    required this.accessToken,
    required this.storeId,
    required this.userId,
    required this.itemId,
    required this.stock,
    required this.itemName,
    required this.itemCode,
    required this.barcode,
    required this.category,
    required this.brand,
    required this.price,
    required this.mrp,
    required this.unit,
    required this.sku,
    required this.taxType,
    required this.discountType,
    required this.discount,

    // required this.warehouse,
    required this.alertQuantity,
    required this.profitMargin,
    required this.taxRate,
    this.onRefresh,
    required this.categoryName,
    required this.brandName,
    required this.storeName,
    this.imageUrl,
  });
  final String accessToken;
  final String storeId;
  final String userId;
  final String itemId;
  final dynamic stock;
  final String itemName;
  final String itemCode;
  final String barcode;
  final int category;
  final int brand;
  final Object price;
  final String taxType;
  final String discountType;
  final String discount;
  final String mrp;
  final String unit;
  final String sku;
  final Object profitMargin;
  // final String warehouse;
  final String alertQuantity;
  final Object taxRate;
  final VoidCallback? onRefresh;
  final String categoryName;
  final String brandName;
  final String storeName;
  final String? imageUrl;
  @override
  State<ItemGridViewCardWidget> createState() => _ItemGridViewCardWidgetState();
}

class _ItemGridViewCardWidgetState extends State<ItemGridViewCardWidget> {
  // Basic Information Controllers
  late final TextEditingController itemNameController;
  late final TextEditingController skuController;
  late final TextEditingController itemCodeController;
  late final TextEditingController barcodeController;

  // Pricing Controllers
  late final TextEditingController purchasePriceController;
  late final TextEditingController salesPriceController;
  late final TextEditingController mrpController;
  late final TextEditingController profitMarginController;

  // Tax & Discount Controllers
  late final TextEditingController taxTypeController;
  late final TextEditingController taxRateController;
  late final TextEditingController discountTypeController;
  late final TextEditingController discountController;

  // Inventory Controllers
  late final TextEditingController unitController;
  late final TextEditingController warehouseController;
  late final TextEditingController openingStockController;
  late final TextEditingController alertQuantityController;

  @override
  void initState() {
    super.initState();
    // Initialize Basic Information Controllers
    itemNameController = TextEditingController(text: widget.itemName);
    skuController = TextEditingController(text: widget.sku);
    itemCodeController = TextEditingController(text: widget.itemCode);
    barcodeController = TextEditingController(text: widget.barcode);

    // Initialize Pricing Controllers
    purchasePriceController =
        TextEditingController(text: widget.price.toString());
    salesPriceController = TextEditingController(text: widget.price.toString());
    mrpController = TextEditingController(text: widget.mrp);
    profitMarginController =
        TextEditingController(text: widget.profitMargin.toString());

    // Initialize Tax & Discount Controllers
    taxTypeController = TextEditingController(text: widget.taxType);
    taxRateController = TextEditingController(text: widget.taxRate.toString());
    discountTypeController = TextEditingController(text: widget.discountType);
    discountController =
        TextEditingController(text: widget.discount.toString());

    // Initialize Inventory Controllers
    unitController = TextEditingController(text: widget.unit);
    // warehouseController = TextEditingController(text: widget.warehouse);
    openingStockController =
        TextEditingController(text: widget.stock.toString());
    alertQuantityController = TextEditingController(text: widget.alertQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth;
        final double headerHeight = cardWidth * 0.23;
        final double iconSize = cardWidth * 0.12;
        final double fontSize = cardWidth * 0.055;
        final double smallFontSize = cardWidth * 0.04;

        return Card(
          elevation: 1,
          margin: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              showItemDetailsDialog(
                context: context,
                itemId: widget.itemId,
                itemName: widget.itemName,
                itemCode: widget.itemCode,
                barcode: widget.barcode,
                categoryName: widget.categoryName,
                brandName: widget.brandName,
                storeName: widget.storeName,
                stock: int.tryParse(widget.stock.toString()) ?? 0,
                price: double.tryParse(widget.price.toString()) ?? 0.0,
                mrp: widget.mrp,
                unit: widget.unit,
                sku: widget.sku,
                profitMargin:
                    double.tryParse(widget.profitMargin.toString()) ?? 0.0,
                taxRate: double.tryParse(widget.taxRate.toString()) ?? 0.0,
                taxType: widget.taxType,
                discountType: widget.discountType,
                discount: widget.discount,
                alertQuantity: widget.alertQuantity,
                imageUrl: widget.imageUrl,
              );
              // Handle item tap
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Image and Status
                  SizedBox(
                    height: headerHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                accentColor.withOpacity(0.1),
                                accentColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                          ),
                        ),
                        // Item Icon
                        Positioned(
                          left: 12,
                          top: 12,
                          child: Container(
                              padding: EdgeInsets.all(iconSize * 0.3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.inventory,
                                color: Colors.green,
                                size: 40,
                              )),
                        ),

                        Positioned(
                          right: 12,
                          top: 12,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                    4), // Space between icon and border
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors
                                        .redAccent, // Same as the icon color
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Make it square-ish
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final shouldDelete = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Deletion"),
                                          content: const Text(
                                              "Are you sure you want to delete this item?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (shouldDelete == true) {
                                      final response = await deleteItemById(
                                          widget.accessToken, widget.itemId);

                                      if (response == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Item Deleted Successfully"),
                                            backgroundColor: Colors.greenAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                        widget.onRefresh?.call();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Failed to delete item"),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: fontSize * 1.2,
                                  ),
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                padding: const EdgeInsets.all(
                                    4), // Space between icon and border
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors
                                        .blueAccent, // Same as the icon color
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Make it square-ish
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    showCustomEditDialog(
                                      context: context,
                                      title: 'Edit Item : ${widget.itemName}',
                                      subtitle: 'Update all item details',
                                      sections: [
                                        DialogSection(
                                          title: 'Basic Information',
                                          icon: Icons.info_outline,
                                          fields: [
                                            DialogField(
                                              label: 'Item Name',
                                              icon: Icons.label_outline,
                                              controller: itemNameController,
                                            ),
                                            DialogField(
                                              label: 'SKU',
                                              icon: Icons.qr_code,
                                              controller: skuController,
                                            ),
                                            DialogField(
                                              label: 'Item Code',
                                              icon: Icons.numbers,
                                              controller: itemCodeController,
                                            ),
                                            DialogField(
                                              label: 'Barcode',
                                              icon: Icons.barcode_reader,
                                              controller: barcodeController,
                                            ),
                                          ],
                                        ),
                                        DialogSection(
                                          title: 'Pricing Details',
                                          icon: Icons.attach_money,
                                          fields: [
                                            DialogField(
                                              label: 'Purchase Price',
                                              icon:
                                                  Icons.shopping_cart_outlined,
                                              controller:
                                                  purchasePriceController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            DialogField(
                                              label: 'Sales Price',
                                              icon: Icons.point_of_sale,
                                              controller: salesPriceController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            DialogField(
                                              label: 'MRP',
                                              icon: Icons.price_change,
                                              controller: mrpController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            DialogField(
                                              label: 'Profit Margin',
                                              icon: Icons.trending_up,
                                              controller:
                                                  profitMarginController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ],
                                        ),
                                        DialogSection(
                                          title: 'Tax & Discount',
                                          icon: Icons.percent,
                                          fields: [
                                            DialogField(
                                              label: 'Tax Type',
                                              icon: Icons.receipt_long,
                                              controller: taxTypeController,
                                            ),
                                            DialogField(
                                              label: 'Tax Rate',
                                              icon: Icons.calculate,
                                              controller: taxRateController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            DialogField(
                                              label: 'Discount Type',
                                              icon: Icons.discount,
                                              controller:
                                                  discountTypeController,
                                            ),
                                            DialogField(
                                              label: 'Discount',
                                              icon: Icons.local_offer,
                                              controller: discountController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ],
                                        ),
                                        DialogSection(
                                          title: 'Inventory',
                                          icon: Icons.inventory_2_outlined,
                                          fields: [
                                            DialogField(
                                              label: 'Unit',
                                              icon: Icons.straighten,
                                              controller: unitController,
                                            ),
                                            DialogField(
                                              label: 'Opening Stock',
                                              icon: Icons.inventory,
                                              controller:
                                                  openingStockController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            DialogField(
                                              label: 'Alert Quantity',
                                              icon: Icons.notifications_active,
                                              controller:
                                                  alertQuantityController,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ],
                                        ),
                                      ],
                                      onSave: () async {
                                        try {
                                          final response =
                                              await EditItemController(
                                            accessToken: widget.accessToken,
                                            itemId: widget.itemId,
                                            itemName: itemNameController.text,
                                            sku: skuController.text,
                                            itemCode: itemCodeController.text,
                                            barcode: barcodeController.text,
                                            unit: unitController.text,
                                            purchasePrice:
                                                purchasePriceController.text,
                                            salesPrice:
                                                salesPriceController.text,
                                            mrp: mrpController.text,
                                            profitMargin:
                                                profitMarginController.text,
                                            taxType: taxTypeController.text,
                                            taxRate: taxRateController.text,
                                            discountType:
                                                discountTypeController.text,
                                            discount: discountController.text,
                                            openingStock:
                                                openingStockController.text,
                                            alertQuantity:
                                                alertQuantityController.text,
                                          ).editItemController(context);
                                          widget.onRefresh?.call();
                                        } catch (e) {
                                          print('Edit error: $e');
                                        }
                                      },
                                      // onCancel: () => Navigator.pop(context),
                                      saveButtonText: 'Save Changes',
                                      primaryColor: accentColor,
                                      secondaryColor: accentColor,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit_note_sharp,
                                    color: Colors.blueAccent,
                                    size: fontSize * 1.2,
                                  ),
                                  splashRadius: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Item Details
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(
                          fontSize * 0.6), // Reduced from 0.8 to 0.6
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item Name
                          Text(
                            widget.itemName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                              color: textPrimaryColor,
                              height: 1.1, // Added to reduce vertical space
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                              height:
                                  fontSize * 0.4), // Reduced from 0.6 to 0.4
                          // Category and Brand Tags
                          Wrap(
                            spacing: fontSize * 0.3, // Reduced from 0.4 to 0.3
                            runSpacing:
                                fontSize * 0.3, // Reduced from 0.4 to 0.3
                            children: [
                              _buildTag(
                                widget.categoryName.toString(),
                                Icons.category_sharp,
                                smallFontSize,
                              ),
                              _buildTag(
                                widget.brandName.toString(),
                                Icons.branding_watermark,
                                smallFontSize,
                              ),
                              _buildTag(
                                widget.storeName,
                                Icons.store,
                                smallFontSize,
                              ),
                              _buildTag(
                                widget.sku,
                                Icons.qr_code_outlined,
                                smallFontSize,
                              ),
                              _buildTag(
                                widget.unit,
                                Icons.inventory,
                                smallFontSize,
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  fontSize * 0.4), // Reduced from 0.6 to 0.4
                          // Price Section
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(fontSize * 0.4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Price Row
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '₹${widget.price}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: accentColor,
                                                    fontSize: fontSize,
                                                    height: 1.1,
                                                  ),
                                                ),
                                                Text(
                                                  'MRP: ₹${widget.mrp}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: smallFontSize,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    height: 1.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Stock Info
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: fontSize * 0.6,
                                              vertical: fontSize * 0.2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: Colors.grey.shade200),
                                            ),
                                            child: Text(
                                              '${widget.stock} ${widget.unit}',
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                                fontSize: smallFontSize,
                                                fontWeight: FontWeight.w600,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: fontSize * 0.4),
                                      // Profit and Tax Row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoChip(
                                            'Profit',
                                            '${widget.profitMargin}%',
                                            Colors.green,
                                            smallFontSize,
                                          ),
                                          _buildInfoChip(
                                            'Tax',
                                            '${widget.taxRate}%',
                                            Colors.blue,
                                            smallFontSize,
                                          ),
                                        ],
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, IconData icon, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.8,
        vertical: fontSize * 0.4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize, color: Colors.grey.shade600),
          SizedBox(width: fontSize * 0.4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
      String label, String value, MaterialColor color, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.8,
        vertical: fontSize * 0.2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color[700],
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon,
      List<Widget> children) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

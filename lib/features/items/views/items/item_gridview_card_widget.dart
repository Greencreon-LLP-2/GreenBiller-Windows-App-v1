import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dialog_field.dart';
import 'package:greenbiller/features/items/controller/all_items_controller.dart';
import 'package:greenbiller/features/items/controller/edit_item_controller.dart';
import 'package:greenbiller/features/items/model/item_model.dart';
import 'package:greenbiller/features/items/views/items/items_details_dialog.dart';

class ItemGridViewCardWidget extends StatelessWidget {
  final VoidCallback? onRefresh;
  final Item item;

  const ItemGridViewCardWidget({super.key, this.onRefresh, required this.item});

  @override
  Widget build(BuildContext context) {
    final itemNameController = TextEditingController(text: item.itemName);
    final skuController = TextEditingController(text: item.sku);
    final itemCodeController = TextEditingController(text: item.itemCode);
    final barcodeController = TextEditingController(text: item.barcode);
    final purchasePriceController = TextEditingController(
      text: item.purchasePrice.toString(),
    );
    final salesPriceController = TextEditingController(
      text: item.salesPrice.toString(),
    );
    final mrpController = TextEditingController(text: item.mrp);
    final profitMarginController = TextEditingController(
      text: item.profitMargin.toString(),
    );
    final taxTypeController = TextEditingController(text: item.taxType);
    final taxRateController = TextEditingController(
      text: item.taxRate.toString(),
    );
    final discountTypeController = TextEditingController(
      text: item.discountType,
    );
    final discountController = TextEditingController(text: item.discount);
    final unitController = TextEditingController(text: item.unitId);
    final openingStockController = TextEditingController(
      text: item.openingStock.toString(),
    );
    final alertQuantityController = TextEditingController(
      text: item.alertQuantity,
    );

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
              showItemDetailsDialog(context: context, item: item);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey.shade50],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              top: Radius.circular(12),
                            ),
                          ),
                        ),
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
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.redAccent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    final shouldDelete = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text(
                                          'Are you sure you want to delete this item?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Get.back(result: true),
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (shouldDelete == true) {
                                      final success =
                                          await Get.find<AllItemsController>()
                                              .deleteItem(item.id);
                                      if (success) {
                                        onRefresh?.call();
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
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: Colors.blueAccent,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    showCustomEditDialog(
                                      context: context,
                                      title: 'Edit Item: ${item.itemName}',
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
                                        final controller = Get.put(
                                          EditItemController(),
                                        );

                                        controller.initialize({
                                          'storeId': item.storeId.toString(),
                                          'itemId': item.id.toString(),
                                          'itemName': itemNameController.text,
                                          'sku': skuController.text,
                                          'itemCode': itemCodeController.text,
                                          'barcode': barcodeController.text,
                                          'unit': unitController.text,
                                          'purchasePrice':
                                              purchasePriceController.text,
                                          'salesPrice':
                                              salesPriceController.text,
                                          'mrp': mrpController.text,
                                          'profitMargin':
                                              profitMarginController.text,
                                          'taxType': taxTypeController.text,
                                          'taxRate': taxRateController.text,
                                          'discountType':
                                              discountTypeController.text,
                                          'discount': discountController.text,
                                          'Opening_Stock':
                                              openingStockController.text,
                                          'alertQuantity':
                                              alertQuantityController.text,
                                        });

                                        final success = await controller
                                            .editItem();

                                        if (success) {
                                          onRefresh?.call();
                                          await Future.delayed(
                                            const Duration(milliseconds: 600),
                                          ); // ⏳ let snackbar show
                                          Get.back(); // Close after showing success
                                        }

                                        Get.delete<EditItemController>();
                                      },

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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(fontSize * 0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize,
                              color: textPrimaryColor,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: fontSize * 0.4),
                          Wrap(
                            spacing: fontSize * 0.3,
                            runSpacing: fontSize * 0.3,
                            children: [
                              _buildTag(
                                item.categoryName,
                                Icons.category_sharp,
                                smallFontSize,
                              ),
                              _buildTag(
                                item.brandName,
                                Icons.branding_watermark,
                                smallFontSize,
                              ),
                              _buildTag(
                                item.storeName,
                                Icons.store,
                                smallFontSize,
                              ),
                              _buildTag(
                                item.sku,
                                Icons.qr_code_outlined,
                                smallFontSize,
                              ),
                              _buildTag(
                                item.unitId.toString(),
                                Icons.inventory,
                                smallFontSize,
                              ),
                            ],
                          ),
                          SizedBox(height: fontSize * 0.4),
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
                                                  '₹${item.salesPrice}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: accentColor,
                                                    fontSize: fontSize,
                                                    height: 1.1,
                                                  ),
                                                ),
                                                Text(
                                                  'MRP: ₹${item.mrp}',
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
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: fontSize * 0.6,
                                              vertical: fontSize * 0.2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                            child: Text(
                                              'Stock : ${item.openingStock} Unit#${item.unitId}',
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoChip(
                                            'Profit',
                                            '${item.profitMargin}%',
                                            Colors.green,
                                            smallFontSize,
                                          ),
                                          _buildInfoChip(
                                            'Tax',
                                            '${item.taxRate}%',
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
    String label,
    String value,
    MaterialColor color,
    double fontSize,
  ) {
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
}

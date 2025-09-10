import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/purchase/controller/purchase_manage_controller.dart';
import 'package:greenbiller/features/purchase/view/sub_widgets/purchase_return_bottom_section.dart';
import 'package:greenbiller/features/purchase/view/sub_widgets/purchase_return_topsection_widget.dart';
import 'package:greenbiller/features/purchase/view/sub_widgets/purchase_table_data_cell_widget.dart';
import 'package:greenbiller/features/purchase/view/sub_widgets/purchase_table_header_widget.dart';
import 'package:intl/intl.dart';

class PurchaseReturnPage extends GetView<PurchaseManageController> {
  final String purchaseId;

  const PurchaseReturnPage({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    controller.purchaseId.value = int.parse(purchaseId);
    controller.fetchPurchaseById();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentColor, accentColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
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
              'Create Purchase Return',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final purchaseData = controller.currentPurchaseData.value;

        if (controller.isLoadingPurchaseById.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: accentColor)),
          );
        }

        if (purchaseData == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'The Data Is corrupted for the selected Purcahse contatct Admins',
              ),
            ),
          );
        }

        return Container(
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
                PurchaseReturnTopsectionWidget(
                  billNo: purchaseData.id.toString(),
                  store: purchaseData.storeName ?? '',
                  supplier: purchaseData.supplierName ?? '',
                  warehouse: purchaseData.warehouseName ?? '',
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    "Purchase Items",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const columnCount = 5;
                      const itemFlex = 3;
                      const otherFlex = 1;
                      const totalFlex =
                          itemFlex + (columnCount - 1) * otherFlex;
                      final baseColumnWidth = constraints.maxWidth / totalFlex;
                      final itemColumnWidth = baseColumnWidth * itemFlex * 0.9;

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.green.shade200,
                                child: Row(
                                  children: [
                                    HeaderCellWidget(
                                      text: "S.No",
                                      width: baseColumnWidth,
                                    ),
                                    HeaderCellWidget(
                                      text: "Item",
                                      width: itemColumnWidth,
                                    ),
                                    HeaderCellWidget(
                                      text: "Price",
                                      width: baseColumnWidth,
                                    ),
                                    HeaderCellWidget(
                                      text: "Purchased Qty",
                                      width: baseColumnWidth,
                                    ),
                                    HeaderCellWidget(
                                      text: "Return Qty",
                                      width: baseColumnWidth,
                                    ),
                                  ],
                                ),
                              ),
                              ...List.generate(controller.itemsList.length, (
                                index,
                              ) {
                                final item = controller.itemsList[index];
                                final price =
                                    double.tryParse(item.pricePerUnit ?? '0') ??
                                    0;
                                final currencyFormatter = NumberFormat.currency(
                                  locale: 'en_IN',
                                  symbol: '₹',
                                  decimalDigits: 2,
                                );
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.green.shade100,
                                      ),
                                      left: BorderSide(
                                        color: Colors.green.shade100,
                                      ),
                                      right: BorderSide(
                                        color: Colors.green.shade100,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: Text("${index + 1}"),
                                      ),
                                      DataCellWidget(
                                        width: itemColumnWidth,
                                        child: Text(item.itemName ?? ''),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: Text(
                                          currencyFormatter.format(price),
                                        ),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: Text(item.purchaseQty ?? '0'),
                                      ),
                                      DataCellWidget(
                                        width: baseColumnWidth,
                                        child: TextField(
                                          controller: controller
                                              .returnQtyControllers[index],
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 6,
                                                ),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            final purchaseQty =
                                                int.tryParse(
                                                  item.purchaseQty ?? '0',
                                                ) ??
                                                0;
                                            final returnQty =
                                                int.tryParse(value) ?? 0;
                                            if (purchaseQty < returnQty) {
                                              controller
                                                      .returnQtyControllers[index]!
                                                      .text =
                                                  '0';
                                              Get.snackbar(
                                                'Error',
                                                'Return qty cannot be larger than Purchase qty',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                            controller.recalculateGrandTotal();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                PurchaseReturnBottomSection(
                  subTotal: controller.tempSubTotal.value,
                  totalDiscount: 0.0,
                  otherChargesController: controller.otherChargesController,
                  purchaseNoteController: controller.purchaseNoteController,
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 8),
                ),
              ],
            ),
            child: ElevatedButton(
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
              onPressed: controller.isLoadingSave.value
                  ? null
                  : () async {
                      await controller.handleSave();
                      Get.snackbar(
                        'Print',
                        'Initiating print for purchase return',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
              child: const Text("Save & Print"),
            ),
          ),
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
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
              onPressed: controller.isLoadingSave.value
                  ? null
                  : controller.handleSave,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}

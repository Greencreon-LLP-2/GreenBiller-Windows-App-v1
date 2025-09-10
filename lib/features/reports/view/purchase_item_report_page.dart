import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/reports/controller/purchase_item_report_controller.dart';
import 'package:greenbiller/features/reports/model/purchase_item_report_model.dart';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class PurchaseItemReportPage extends GetView<PurchaseItemReportController> {
  const PurchaseItemReportPage({super.key});

  Widget _buildStoreDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedStoreId.value,
            hint: const Text('Select Store'),
            isExpanded: true,
            icon: const Icon(Icons.store, color: Colors.green),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'Select a Store',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ...controller.storesList.map((store) {
                return DropdownMenuItem<String>(
                  value: store.id?.toString(),
                  child: Text(
                    store.storeName ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                );
              }),
            ],
            onChanged: (value) {
              controller.selectedStoreId.value = value;
              print('Store selected: $value');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItemDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedItemId.value,
            hint: const Text('Select Item'),
            isExpanded: true,
            icon: controller.isItemLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  )
                : const Icon(Icons.inventory, color: Colors.green),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text(
                  'Select an Item',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ...controller.itemsList.map(
                (item) => DropdownMenuItem<String>(
                  value: item.id.toString(),
                  child: Text(
                    '${item.itemName ?? ''} (Batch: ${item.batchNo ?? 'N/A'})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              controller.selectedItemId.value = value;
              print('Item selected: $value');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border(
          bottom: BorderSide(color: Colors.green.shade200, width: 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'Store',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              'Item',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'Price/Unit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'Quantity',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              'Total',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(SinglePurchaseItemReportModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              data.salesDate?.toString().split(' ')[0] ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              data.storeName ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 180,
            child: Text(
              data.itemName ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              '₹${data.pricePerUnit ?? '0.00'}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              data.purchaseQty ?? '-',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              '₹${data.total?.toString() ?? '0.00'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Purchase Item Report'),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.summarize,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Purchase Item Report',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: controller.generateReport,
                          icon: const Icon(Icons.search),
                          label: const Text('Generate'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  controller.selectDate(context, true),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.green.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.startDate.value == null
                                        ? 'Start Date'
                                        : DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(controller.startDate.value!),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  controller.selectDate(context, false),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: Colors.green.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.endDate.value == null
                                        ? 'End Date'
                                        : DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(controller.endDate.value!),
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildStoreDropdown()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildItemDropdown()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.list_alt, color: Colors.green, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Report Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (controller.hasError.value) {
                            return Center(
                              child: Text(
                                'Error: Failed to load report',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            );
                          }
                          if (controller.purchaseData.isEmpty) {
                            return Center(
                              child: Text(
                                'Select date range, store, and item to generate report',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }
                          final data = controller.purchaseData;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final file = await controller
                                            .generatePurchaseItemPDF(
                                              data: data,
                                              startDate:
                                                  controller.startDate.value!,
                                              endDate:
                                                  controller.endDate.value!,
                                            );
                                        await OpenFile.open(file.path);
                                        print(
                                          'PDF generated and opened: ${file.path}',
                                        );
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Error generating PDF: $e',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.picture_as_pdf,
                                      size: 20,
                                    ),
                                    label: const Text('Export as PDF'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final file = await controller
                                            .generatePurchaseItemCSV(
                                              data: data,
                                              startDate:
                                                  controller.startDate.value!,
                                              endDate:
                                                  controller.endDate.value!,
                                            );
                                        await OpenFile.open(file.path);
                                        print(
                                          'CSV generated and opened: ${file.path}',
                                        );
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Error generating CSV: $e',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.table_chart,
                                      size: 20,
                                    ),
                                    label: const Text('Export as CSV'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: MediaQuery.of(
                                          context,
                                        ).size.width,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            _buildTableHeader(),
                                            ...data.map(
                                              (item) => _buildTableRow(item),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

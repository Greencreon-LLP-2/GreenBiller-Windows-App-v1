import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/reports/controller/sale_by_item_report_controller.dart';
import 'package:greenbiller/features/reports/model/sale_item_report_model.dart';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class SaleByItemReportPage extends GetView<SaleByItemReportController> {
  const SaleByItemReportPage({super.key});

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
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
            width: 120,
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
            width: 120,
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
            width: 120,
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
            width: 120,
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
            width: 120,
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

  Widget _buildTableRow(SIngleSaleItemReportModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              data.salesDate?.toString().split(' ')[0] ?? '-',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              data.storeName ?? '-',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              data.itemName ?? '-',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '₹${data.pricePerUnit ?? '0.00'}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              data.salesQty.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              '₹${data.total?.toString() ?? '0.00'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection and try again',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.generateReport,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          Container(
            width: 280,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Sale Item Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date Range',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () =>
                                        controller.selectDate(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        controller.selectedStartDate.value !=
                                                null
                                            ? DateFormat('dd/MM/yyyy').format(
                                                controller
                                                    .selectedStartDate
                                                    .value!,
                                              )
                                            : 'Start Date',
                                        style: TextStyle(
                                          color:
                                              controller
                                                      .selectedStartDate
                                                      .value !=
                                                  null
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: InkWell(
                                    onTap: () =>
                                        controller.selectDate(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        controller.selectedEndDate.value != null
                                            ? DateFormat('dd/MM/yyyy').format(
                                                controller
                                                    .selectedEndDate
                                                    .value!,
                                              )
                                            : 'End Date',
                                        style: TextStyle(
                                          color:
                                              controller
                                                      .selectedEndDate
                                                      .value !=
                                                  null
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Store',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.selectedStoreId.value,
                                  isExpanded: true,
                                  hint: Text(
                                    'Select Store',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  items: controller.storesList.map((store) {
                                    return DropdownMenuItem<String>(
                                      value: store.id?.toString(),
                                      child: Text(store.storeName ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    controller.selectedStoreId.value = value;
                                    if (value != null) {
                                      controller.fetchItems(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value:
                                      controller
                                              .selectedItemId
                                              .value
                                              ?.isEmpty ??
                                          true
                                      ? null
                                      : controller.selectedItemId.value,
                                  hint: const Text('Select Item'),
                                  isExpanded: true,
                                  items: controller.itemsList.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item.id.toString(),
                                      child: Text(item.itemName),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.selectedItemId.value = value;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.generateReport,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Generate Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Results',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        if (controller.isLoadingReport.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.hasError.value) {
                          return _buildNoInternetView();
                        }
                        if (controller.saleItemReport.value == null ||
                            controller.saleItemReport.value!.data == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No report data available',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final data = controller.saleItemReport.value!.data!;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      final file = await controller
                                          .generateSaleItemPDF(
                                            data: data,
                                            startDate: controller
                                                .selectedStartDate
                                                .value!,
                                            endDate: controller
                                                .selectedEndDate
                                                .value!,
                                          );
                                      await OpenFile.open(file.path);
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
                                          .generateSaleItemCSV(
                                            data: data,
                                            startDate: controller
                                                .selectedStartDate
                                                .value!,
                                            endDate: controller
                                                .selectedEndDate
                                                .value!,
                                          );
                                      await OpenFile.open(file.path);
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Error generating CSV: $e',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.table_chart, size: 20),
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
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width - 328,
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
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

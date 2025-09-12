import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/sale/controller/quatation_controller.dart';
import 'package:greenbiller/features/sale/model/quotation_model.dart';
import 'package:intl/intl.dart';

class QuotationViewPage extends GetView<QuotationController> {
  final Quotation quotation;
  final int index;
  const QuotationViewPage({
    super.key,
    required this.quotation,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final customerName = quotation.customerId != null
        ? controller.customerMap[quotation.customerId] ?? 'Unknown Customer'
        : 'Unknown Customer';
    final storeName = controller.storeMap.entries
        .firstWhere(
          (entry) => entry.value == quotation.storeId,
          orElse: () => MapEntry('Unknown Store', ''),
        )
        .key;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          'Quotation #${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoadingQuotations.value) {
              return const Center(
                child: CircularProgressIndicator(color: accentColor),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quotation Details
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quotation Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow('Quote Number', quotation.quoteNumber),
                        _buildDetailRow(
                          'Quote Date',
                          DateFormat('dd MMM yyyy').format(quotation.quoteDate ?? DateTime.now()),
                        ),
                        _buildDetailRow('Store', storeName),
                        _buildDetailRow('Customer', customerName),
                        _buildDetailRow('Total Items', quotation.itemQty.toString()),
                        _buildDetailRow('Total Amount', '₹${quotation.totalAmount.toString()}'),
                        _buildDetailRow('Status', quotation.status == '1' ? 'completed' : 'pending'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Items Table
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Items',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Item Name')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Unit')),
                              DataColumn(label: Text('Price/Unit')),
                              DataColumn(label: Text('Total')),
                            ],
                            rows: quotation.items.asMap().entries.map((entry) {
                              final itemIndex = entry.key;
                              final item = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text((itemIndex + 1).toString())),
                                  DataCell(Text(item.itemName)),
                                  DataCell(Text(item.salesQty)),
                                  DataCell(Text(item.unit)),
                                  DataCell(Text('₹${item.pricePerUnit}')),
                                  DataCell(Text('₹${item.totalCost}')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
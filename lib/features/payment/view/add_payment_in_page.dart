import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';

import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/payment/controller/add_payment_controller.dart';

class AddPaymentInPage extends GetView<AddPaymentController> {
  const AddPaymentInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final padding = isDesktop ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text("Payment In"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildCustomerSection(context),
            const SizedBox(height: 24),
            _buildPaymentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection(BuildContext context) {
    return CardContainer(
      elevation: 5,
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey),
                const SizedBox(width: 10),
                const Text(
                  'Customer Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.searchCustomerController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                labelText: 'Search customer',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.searchCustomerController,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) {
                      return const SizedBox();
                    }
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.searchCustomerController.clear();
                        controller.showSuggestions.value = false;
                      },
                    );
                  },
                ),
              ),
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : controller.hasError.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Failed to load customers',
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: controller.fetchCustomers,
                              child: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            Obx(
              () => controller.showSuggestions.value
                  ? Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      child: controller.customerSuggestions.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No customers found'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.customerSuggestions.length,
                              itemBuilder: (context, index) {
                                final customer =
                                    controller.customerSuggestions[index];
                                return ListTile(
                                  title: Text(customer.customerName ?? ''),
                                  subtitle: Text(customer.mobile ?? '-'),
                                  onTap: () =>
                                      controller.selectCustomer(customer),
                                );
                              },
                            ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final selected = controller.selectedCustomer.value;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: selected == null
                          ? const Text('No customer selected')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${selected.customerName}'),
                                Text('Phone: ${selected.mobile ?? '-'}'),
                                Text('Email: ${selected.email ?? '-'}'),
                              ],
                            ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: controller.refreshCustomers,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return CardContainer(
      elevation: 5,
      borderRadius: 12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payments_outlined, color: Colors.grey),
                const SizedBox(width: 10),
                const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.saleIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: 'Sale ID',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller.paymentController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: 'Payment Amount',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.referenceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: 'Reference Number (Optional)',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.paymentType.value,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                        DropdownMenuItem(value: 'Card', child: Text('Card')),
                        DropdownMenuItem(
                          value: 'Cheque',
                          child: Text('Cheque'),
                        ),
                        DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                        DropdownMenuItem(
                          value: 'Credit',
                          child: Text('Credit'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        labelText: 'Payment Type',
                      ),
                      onChanged: (val) => controller.paymentType.value = val!,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                labelText: 'Payment Note',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Obx(
                  () => InkWell(
                    onTap: () => controller.pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Payment Date: ${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: controller.isSaving.value
                        ? null
                        : controller.savePaymentIn,
                    child: controller.isSaving.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Payment',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

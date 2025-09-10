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
                Icon(Icons.person, color: Colors.grey),
                SizedBox(width: 10),
                const Text(
                  'Customer Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 30),
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                labelText: 'Search customer',
                prefixIcon: Icon(Icons.search),
                suffixIcon: controller.searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => controller.searchController.clear(),
                      ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black12,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    Obx(() {
                      if (controller.showSuggestions.value) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.customerSuggestions.length,
                          itemBuilder: (context, index) {
                            final customer =
                                controller.customerSuggestions[index];
                            return ListTile(
                              title: Text(customer['customer_name'] ?? ''),
                              onTap: () => controller.selectCustomer(customer),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      final selected = controller.selectedCustomer.value;
                      if (selected == null)
                        return const Text('No customer selected');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${selected['customer_name']}'),
                          Text('Phone: ${selected['mobile'] ?? '-'}'),
                          Text('Email: ${selected['email'] ?? '-'}'),
                        ],
                      );
                    }),
                    Spacer(),
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
              ),
            ),

            const SizedBox(height: 12),
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
                Icon(Icons.payments_outlined, color: Colors.grey),
                SizedBox(width: 10),
                const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 35),
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
                const SizedBox(width: 30),
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
            const SizedBox(height: 30),

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
                const SizedBox(width: 30),
                Expanded(
                  child: Obx(() {
                    return DropdownButtonFormField<String>(
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onChanged: (val) => controller.paymentType.value = val!,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 30),

            Row(
              children: [
                Obx(
                  () => InkWell(
                    onTap: () => controller.pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        // border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        style: TextStyle(color: Colors.white),
                        'Payment Date: ${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                      ),
                    ),
                  ),
                ),
                Spacer(),
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

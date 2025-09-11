import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';

import 'package:greenbiller/core/gloabl_widgets/cards/card_container.dart';
import 'package:greenbiller/features/parties/view/add_supplier_dialog.dart';
import 'package:greenbiller/features/payment/controller/add_payment_controller.dart';

class AddPaymentOutPage extends GetView<AddPaymentController> {
  const AddPaymentOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final padding = isDesktop ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text("Payment Out"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSupplierSection(context),
            const SizedBox(height: 24),
            _buildPaymentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierSection(BuildContext context) {
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
                const Icon(Icons.store, color: Colors.grey),
                const SizedBox(width: 10),
                const Text(
                  'Supplier Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.searchSupplierController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search supplier',
                hintText: 'Search supplier by name or phone',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),

                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.searchSupplierController,
                  builder: (context, value, _) {
                    if (value.text.isEmpty) {
                      return const SizedBox();
                    }
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.searchSupplierController.clear();
                        controller.showSupplierSuggestions.value = false;
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
                              'Failed to load suppliers',
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: controller.fetchSuppliers,
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
              () => controller.showSupplierSuggestions.value
                  ? Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      child: controller.supplierSuggestions.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No suppliers found'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.supplierSuggestions.length,
                              itemBuilder: (context, index) {
                                final supplier =
                                    controller.supplierSuggestions[index];
                                return ListTile(
                                  title: Text(supplier.supplierName ?? ''),
                                  subtitle: Text(supplier.mobile ?? '-'),
                                  onTap: () =>
                                      controller.selectSupplier(supplier),
                                );
                              },
                            ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final selected = controller.selectedSupplier.value;
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
                          ? const Text('No supplier selected')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${selected.supplierName}'),
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddSupplierDialog(
                            onSuccess: controller.refreshSuppliers,
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('New Supplier'),
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
                const Icon(Icons.payments, color: Colors.grey),
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
                      labelText: 'Purchase ID',
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => controller.pickDate(context),
                    child: Obx(() {
                      final date = controller.selectedDate.value;
                      return InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: 'Payment Date',
                          suffixIcon: Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        child: Text('${date.day}/${date.month}/${date.year}'),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.paymentType.value,
                      items: const [
                        DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                        DropdownMenuItem(value: 'Card', child: Text('Card')),
                        DropdownMenuItem(
                          value: 'Cheque',
                          child: Text('Cheque'),
                        ),
                        DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                        DropdownMenuItem(
                          value: 'Bank Transfer',
                          child: Text('Bank Transfer'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) controller.paymentType.value = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        labelText: 'Payment Type',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.referenceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                labelText: 'Reference Number (Optional)',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                labelText: 'Payment Note (Optional)',
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => controller.isSaving.value
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: controller.savePaymentOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Save Payment',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

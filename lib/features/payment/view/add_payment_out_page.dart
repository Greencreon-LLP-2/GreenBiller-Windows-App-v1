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
            const Text(
              'Supplier Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged:
                        controller.onSupplierSearch, // hook supplier search
                    decoration: InputDecoration(
                      labelText: 'Search supplier',
                      suffixIcon: controller.searchController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                controller.searchController.clear();
                                controller.showSupplierSuggestions.value =
                                    false;
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddSupplierDialog(
                        onSuccess:
                            controller.refreshSuppliers, // refresh suppliers
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('New Supplier'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.showSupplierSuggestions.value) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.supplierSuggestions.length,
                  itemBuilder: (context, index) {
                    final supplier = controller.supplierSuggestions[index];
                    return ListTile(
                      title: Text(supplier['supplier_name'] ?? ''),
                      onTap: () => controller.selectSupplier(supplier),
                    );
                  },
                );
              }
              return const SizedBox();
            }),
            const SizedBox(height: 12),
            Obx(() {
              final selected = controller.selectedSupplier.value;
              if (selected == null) return const Text('No supplier selected');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${selected['supplier_name']}'),
                  Text('Phone: ${selected['mobile'] ?? '-'}'),
                  Text('Email: ${selected['email'] ?? '-'}'),
                ],
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
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.saleIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Purchase ID'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.paymentController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Payment Amount'),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => controller.pickDate(context),
              child: Obx(() {
                final date = controller.selectedDate.value;
                return InputDecorator(
                  decoration: const InputDecoration(labelText: 'Payment Date'),
                  child: Text('${date.day}/${date.month}/${date.year}'),
                );
              }),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.paymentType.value,
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Card', child: Text('Card')),
                  DropdownMenuItem(value: 'Cheque', child: Text('Cheque')),
                  DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                  DropdownMenuItem(
                    value: 'Bank Transfer',
                    child: Text('Bank Transfer'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) controller.paymentType.value = value;
                },
                decoration: const InputDecoration(labelText: 'Payment Type'),
              );
            }),
            const SizedBox(height: 12),
            TextField(
              controller: controller.referenceController,
              decoration: const InputDecoration(labelText: 'Reference Number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.noteController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Payment Note'),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return controller.isSaving.value
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.savePaymentOut,
                            child: const Text('Save Payment'),
                          ),
                        ),
                      ],
                    );
            }),
          ],
        ),
      ),
    );
  }
}

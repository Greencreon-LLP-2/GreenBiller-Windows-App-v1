import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/features/purchase/controller/new_purchase_controller.dart';

class NewPurchasePage extends GetView<NewPurchaseController> {
  const NewPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Quick Purchase',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save, color: Colors.white),
                onPressed: controller.savePurchase,
              ),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
                onPressed: controller.clearForm,
              ),
            ],
          ),
        ),
      ),
      body: Container(
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
              _buildPurchaseInfoCard(context, controller),
              const SizedBox(height: 16),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.green.shade800,
                                    size: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: " Purchase Items",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: controller.addItem,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Add Item"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildItemsTable(context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailsAndSummary(context, controller),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: controller.clearForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text("Clear Form"),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: controller.savePurchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text("Save Purchase"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseInfoCard(
    BuildContext context,
    NewPurchaseController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.green.shade700, size: 24),
              const SizedBox(width: 8),
              Text(
                "Purchase Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Store"),
                    const SizedBox(height: 6),
                    Obx(
                      () => controller.isLoadingStores.value
                          ? _buildLoadingDropdown("Loading stores...")
                          : _buildDropdown(
                              items: controller.storeMap.keys.toList(),
                              value: controller.storeController.text.isEmpty
                                  ? null
                                  : controller.storeController.text,
                              onChanged: controller.onStoreSelected,
                              hint: "Select Store",
                              icon: Icons.store,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Warehouse"),
                    const SizedBox(height: 6),
                    Obx(
                      () =>
                          controller.isLoadingWarehouses.value ||
                              controller.warehouseMap.isEmpty
                          ? _buildLoadingDropdown(
                              controller.warehouseMap.isEmpty
                                  ? "Select store first"
                                  : "Loading warehouses...",
                            )
                          : _buildDropdown(
                              items: controller.warehouseMap.keys.toList(),
                              value: controller.warehouseController.text.isEmpty
                                  ? null
                                  : controller.warehouseController.text,
                              onChanged: controller.onWarehouseSelected,
                              hint: "Select Warehouse",
                              icon: Icons.warehouse,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bill Number"),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.billNumberController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Enter bill no.",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green.shade300,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: controller.generateBillNumber,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            child: const Text(
                              "Generate",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Suppliers"),
                    const SizedBox(height: 6),
                    Obx(
                      () =>
                          controller.isLoadingSuppliers.value ||
                              controller.supplierMap.isEmpty
                          ? _buildLoadingDropdown(
                              controller.supplierMap.isEmpty
                                  ? "Select store first"
                                  : "Loading suppliers...",
                            )
                          : _buildDropdown(
                              items: controller.supplierMap.keys.toList(),
                              value: controller.supplierController.text.isEmpty
                                  ? null
                                  : controller.supplierController.text,
                              onChanged: controller.onSupplierSelected,
                              hint: "Select Supplier",
                              icon: Icons.person,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bill Date"),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) {
                          controller.setBillDate(date);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade300),
                          color: Colors.green.shade50,
                        ),
                        child: TextField(
                          controller: controller.billDateController,
                          readOnly: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: "Select date",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.green.shade600,
                              size: 18,
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
        ],
      ),
    );
  }

  Widget _buildItemsTable(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columnCount = 13;
        const itemFlex = 3;
        const otherFlex = 1;
        const totalFlex = itemFlex + (columnCount - 1) * otherFlex;
        final baseColumnWidth = constraints.maxWidth / totalFlex;
        final itemColumnWidth = baseColumnWidth * itemFlex;

        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              final items = controller.items;
              final rowCount = items.isEmpty ? 1 : items.length;

              return Column(
                children: [
                  // Header
                  Container(
                    color: Colors.green.shade200,
                    child: Row(
                      children: [
                        _buildHeaderCell("Sl No", baseColumnWidth * 0.5),
                        _buildHeaderCell("Item", itemColumnWidth * 0.97),
                        _buildHeaderCell("Serial No", baseColumnWidth * 0.9),
                        _buildHeaderCell("Qty", baseColumnWidth * 0.5),
                        _buildHeaderCell("Price/Unit", baseColumnWidth),
                        _buildHeaderCell("Purchase Price", baseColumnWidth),
                        _buildHeaderCell("SKU", baseColumnWidth * 0.5),
                        _buildHeaderCell("Discount", baseColumnWidth),
                        _buildHeaderCell("Tax", baseColumnWidth),
                        _buildHeaderCell("Tax Amt", baseColumnWidth),
                        _buildHeaderCell("Total", baseColumnWidth),
                        _buildHeaderCell("Actions", baseColumnWidth),
                      ],
                    ),
                  ),

                  // Rows
                  ...List.generate(rowCount, (index) {
                    final item = index < items.length
                        ? items[index]
                        : PurchaseItem();

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.green.shade100),
                          left: BorderSide(color: Colors.green.shade100),
                          right: BorderSide(color: Colors.green.shade100),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildDataCell(
                            Text("${index + 1}"),
                            baseColumnWidth * 0.5,
                          ),
                          _buildDataCell(
                            controller.isLoadingItems.value
                                ? const Text("Loading...")
                                : Autocomplete<Map<String, dynamic>>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                          if (textEditingValue.text.isEmpty) {
                                            return const Iterable<
                                              Map<String, dynamic>
                                            >.empty();
                                          }
                                          final query = textEditingValue.text
                                              .toLowerCase();
                                          return controller.itemsList.where(
                                            (i) =>
                                                i['item_name']
                                                    .toLowerCase()
                                                    .contains(query) ||
                                                (i['Barcode'] ?? '')
                                                    .toLowerCase()
                                                    .contains(query) ||
                                                (i['SKU'] ?? '')
                                                    .toLowerCase()
                                                    .contains(query),
                                          );
                                        },
                                    displayStringForOption: (item) =>
                                        item['item_name'],
                                    onSelected: (selected) => controller
                                        .onItemSelected(index, selected),
                                    fieldViewBuilder:
                                        (
                                          context,
                                          textEditingController,
                                          focusNode,
                                          onFieldSubmitted,
                                        ) {
                                          if (index < items.length) {
                                            textEditingController.text =
                                                items[index].item.text;
                                          }
                                          return TextField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            onSubmitted: (value) {
                                              onFieldSubmitted();
                                              final scannedItem = controller
                                                  .itemsList
                                                  .firstWhereOrNull(
                                                    (i) =>
                                                        i['Barcode'] == value ||
                                                        i['SKU'] == value,
                                                  );
                                              if (scannedItem != null) {
                                                controller.onItemSelected(
                                                  index,
                                                  scannedItem,
                                                );
                                              }
                                            },
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: InputBorder.none,
                                              hintText: 'Scan or type item',
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.green.shade600,
                                              ),
                                            ),
                                          );
                                        },
                                  ),
                            itemColumnWidth * 0.97,
                          ),
                          _buildDataCell(
                            Obx(
                              () => TextButton(
                                onPressed: () {
                                  Get.dialog(
                                    SerialNumberModal(
                                      item: item,
                                      onSave: () =>
                                          controller.calculateTotals(),
                                    ),
                                  );
                                },
                                child: Text(
                                  item.serials.isEmpty
                                      ? 'Add Serial'
                                      : '${item.serials.length} Serials',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ),
                            baseColumnWidth * 0.9,
                          ),
                          _buildDataCell(
                            _buildTextField(
                              item.qty,
                              keyboardType: TextInputType.number,
                            ),
                            baseColumnWidth * 0.5,
                          ),

                          _buildDataCell(
                            _buildTextField(
                              item.pricePerUnit,
                              keyboardType: TextInputType.number,
                            ),
                            baseColumnWidth,
                          ),
                          _buildDataCell(
                            _buildTextField(item.purchasePrice, readOnly: true),
                            baseColumnWidth,
                          ),
                          _buildDataCell(
                            _buildTextField(item.sku, readOnly: true),
                            baseColumnWidth * 0.5,
                          ),
                          _buildDataCell(
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    item.discountPercent,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Expanded(
                                  child: _buildTextField(
                                    item.discountAmount,
                                    keyboardType: TextInputType.number,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            baseColumnWidth,
                          ),
                          _buildDataCell(
                            controller.isLoadingTaxes.value
                                ? const Text("Loading...")
                                : DropdownButtonFormField<String>(
                                    value: item.taxName,
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                    items: controller.taxList.map((tax) {
                                      return DropdownMenuItem<String>(
                                        value: tax['tax_name'],
                                        child: Text(tax['tax_name'] ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      final selectedTax = controller.taxList
                                          .firstWhere(
                                            (t) => t['tax_name'] == value,
                                            orElse: () => {
                                              'tax_name': '',
                                              'tax_rate': '0',
                                            },
                                          );
                                      controller.onTaxSelected(
                                        index,
                                        selectedTax,
                                      );
                                    },
                                  ),
                            baseColumnWidth,
                          ),
                          _buildDataCell(
                            _buildTextField(item.taxAmount, readOnly: true),
                            baseColumnWidth,
                          ),
                          _buildDataCell(
                            _buildTextField(item.totalAmount, readOnly: true),
                            baseColumnWidth,
                          ),
                          _buildDataCell(
                            index < items.length
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        controller.removeItem(index),
                                  )
                                : const SizedBox(),
                            baseColumnWidth,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildDetailsAndSummary(
    BuildContext context,
    NewPurchaseController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Purchase Details & Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.paymentType.value.isEmpty
                            ? null
                            : controller.paymentType.value,
                        items: const [
                          DropdownMenuItem(value: "Cash", child: Text('Cash')),
                          DropdownMenuItem(value: "Upi", child: Text('UPI')),
                          DropdownMenuItem(
                            value: "Cheque",
                            child: Text('Cheque'),
                          ),
                          DropdownMenuItem(
                            value: "Bank Transfer",
                            child: Text('Bank Transfer'),
                          ),
                        ],
                        onChanged: (val) =>
                            controller.paymentType.value = val ?? "",
                        decoration: InputDecoration(
                          hintText: "Select Payment Type",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade300,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.payment,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.selectedAccountId.value.isEmpty
                            ? null
                            : controller.selectedAccountId.value,
                        items: controller.accountController.accounts
                            .map(
                              (account) => DropdownMenuItem<String>(
                                value: account['id'],
                                child: Text(
                                  '${account['name']} (${account['bank'] ?? 'No Bank'})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          controller.selectedAccountId.value = val ?? '';
                        },
                        decoration: InputDecoration(
                          hintText: "Select Account",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.green.shade300,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.account_balance,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Note",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: controller.noteController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Enter note",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.green.shade700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow("Subtotal", controller.subtotal, Colors.black),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  "Total Discount",
                  controller.totalDiscount,
                  Colors.red,
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  "Total Tax",
                  controller.totalTax,
                  Colors.black,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Other Charges",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: controller.otherChargesController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Enter other charges",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green.shade300,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  "Grand Total",
                  controller.grandTotal,
                  Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Paid Amount",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: controller.paidAmountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Enter paid amount",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.green.shade300,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.payment,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  "Balance Amount",
                  controller.balanceAmount,
                  Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    String? value,
    required void Function(String?) onChanged,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.green.shade600, size: 20),
        ),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
      ),
    );
  }

  Widget _buildHeaderCell(String title, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.green.shade100)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.green.shade100)),
      ),
      child: child,
    );
  }

  Widget _buildTextField(
    TextEditingController textController, {
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return TextField(
      controller: textController,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 14),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        controller.calculateTotals();
      },
    );
  }

  Widget _buildSummaryRow(
    String label,
    RxDouble value,
    Color color, {
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: fontWeight,
            color: Colors.grey.shade700,
          ),
        ),
        Obx(
          () => Text(
            "₹ ${value.value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

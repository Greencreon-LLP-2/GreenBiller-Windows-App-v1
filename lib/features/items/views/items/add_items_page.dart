import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/items/views/items/unit_dropdown_withvalue.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/items/controller/add_items_controller.dart';

class AddItemsPage extends GetView<AddItemController> {
  const AddItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Obx(
      () => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            "Add Item",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: controller.calculatedProfit.value < 0
              ? errorColor
              : accentColor,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {},
              tooltip: 'Help',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
              tooltip: 'Settings',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _buildDesktopLayout(context, controller, formKey),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AddItemController controller,
    GlobalKey<FormState> formKey,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Item Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            "Add new inventory item",
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildNavItem(
                          "Basic Info",
                          Icons.info_outline,
                          0,
                          controller,
                        ),
                        _buildNavItem(
                          "Pricing",
                          Icons.attach_money,
                          1,
                          controller,
                        ),
                        _buildNavItem("Stock", Icons.inventory, 2, controller),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: errorColor,
                            side: const BorderSide(color: errorColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSubmitButton(controller, formKey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Form(
              key: formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Obx(
                            () => Text(
                              controller.currentIndex.value == 0
                                  ? "Basic Information"
                                  : controller.currentIndex.value == 1
                                  ? "Pricing Details"
                                  : "Stock Information",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.help_outline, size: 18),
                            label: const Text("Help"),
                            style: TextButton.styleFrom(
                              foregroundColor: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => IndexedStack(
                          index: controller.currentIndex.value,
                          children: [
                            _buildDesktopBasicInfoContent(controller),
                            _buildDesktopPricingContent(controller),
                            _buildDesktopStockContent(controller),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String title,
    IconData icon,
    int tabIndex,
    AddItemController controller,
  ) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == tabIndex;
      return InkWell(
        onTap: () {
          controller.tabController.animateTo(tabIndex);
          controller.currentIndex.value = tabIndex;
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? accentColor.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? accentColor : textSecondaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? accentColor : textPrimaryColor,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDesktopBasicInfoContent(AddItemController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 250, child: _buildImageSection(controller)),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: "Item Name",
                      hint: "Enter item name",
                      prefixIcon: Icons.inventory,
                      required: true,
                      controller: controller.itemNameController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppDropdown(
                            label: "Store",
                            placeHolderText: 'Select Store',
                            selectedValue: controller
                                .storeDropdownController
                                .selectedStoreId,
                            options:
                                controller.storeDropdownController.storeMap,
                            isLoading: controller
                                .storeDropdownController
                                .isLoadingStores,
                            onChanged: (val) async {
                              if (val != null) {
                                controller.genereateItemCode(val);
                                await controller.storeDropdownController
                                    .loadBrands(val);
                                await controller.storeDropdownController
                                    .loadCategories(val);
                                await controller.storeDropdownController
                                    .loadWarehouses(val);
                              }
                            },
                          ),
                        ),

                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDropdown(
                            label: "Category",
                            placeHolderText: 'Select Category',
                            selectedValue: controller
                                .storeDropdownController
                                .selectedCategoryId,
                            options:
                                controller.storeDropdownController.categoryMap,
                            isLoading: controller
                                .storeDropdownController
                                .isLoadingCategories,
                            onChanged: (val) {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDropdown(
                            label: "Brands",
                            placeHolderText: 'Select Brands',
                            selectedValue: controller
                                .storeDropdownController
                                .selectedBrandId,
                            options:
                                controller.storeDropdownController.brandMap,
                            isLoading: controller
                                .storeDropdownController
                                .isLoadingBrands,
                            onChanged: (val) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Product Identification",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: "SKU",
                  hint: "Enter SKU",
                  prefixIcon: Icons.qr_code,
                  controller: controller.skuController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: "HSN Code",
                  hint: "Enter HSN code",
                  prefixIcon: Icons.qr_code,
                  controller: controller.hsnCodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: "Barcode",
                  hint: "Enter barcode number",
                  prefixIcon: Icons.crop_free,
                  controller: controller.barcodeController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: "Item Code",
                  hint: "Enter item code",
                  prefixIcon: Icons.code,
                  controller: controller.itemCodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: UnitDropdownWithValue(controller: controller)),
            ],
          ),
          const SizedBox(height: 12),
          _buildInputField(
            label: "Description",
            hint: "Enter item description",
            prefixIcon: Icons.description,
            controller: controller.descriptionController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopPricingContent(AddItemController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Purchase Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Purchase Price",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: controller.purchasePriceController,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: DropdownButtonFormField<String>(
                                  value:
                                      controller.selectedTaxType.value.isEmpty
                                      ? null
                                      : controller.selectedTaxType.value,
                                  onChanged: (value) {
                                    controller.selectedTaxType.value =
                                        value ?? '';
                                  },
                                  hint: const Text('Tax Type'),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                  ),
                                  iconEnabledColor: accentColor.withOpacity(
                                    0.7,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimaryColor,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Tax Type",
                                    labelStyle: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.receipt_long,
                                        color: accentColor.withOpacity(0.7),
                                        size: 20,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: accentColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  items: controller.taxTypeList
                                      .map(
                                        (item) => DropdownMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: textPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdownField(
                                label: "Tax Rate (%)",
                                items: controller.taxRateList,
                                prefixIcon: Icons.percent,
                                controller: controller,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.point_of_sale,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Sales Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "WholeSale Price",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: controller.wholesalePriceController,
                          keyboardType: TextInputType.number,
                        ),
                        _buildInputField(
                          label: "Sales Price",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: controller.salesPriceController,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                        _buildInputField(
                          label: "MRP",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: controller.mrpController,
                          keyboardType: TextInputType.number,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: "Discount Type",
                                items: ["Percentage", "Fixed Amount", "None"],
                                prefixIcon: Icons.local_offer,
                                controller: controller,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: "Discount",
                                hint: "0.00",
                                prefixIcon: Icons.money_off,
                                controller: controller.discountController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: accentColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: "💡 Profit Calculation ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textPrimaryColor,
                              ),
                            ),
                            TextSpan(
                              text: "(for your reference only)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                              ),
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
                        child: _buildInputField(
                          label: "Profit Margin (%)",
                          hint: "0.00",
                          prefixIcon: controller.calculatedProfit.value < 0
                              ? Icons.trending_down
                              : Icons.trending_up,
                          iconColor: controller.calculatedProfit.value < 0
                              ? Colors.red
                              : null,
                          controller: controller.profitMarginController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Calculated Profit",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(
                                () => Text(
                                  "₹${controller.calculatedProfit.value.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: controller.calculatedProfit.value < 0
                                        ? Colors.red
                                        : accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.calculateProfit,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text("Calculate Profit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.calculatedProfit.value < 0
                          ? errorColor
                          : accentColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      elevation: 2,
                      shadowColor: accentColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildDesktopStockContent(AddItemController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                color: Colors.purple,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Stock Management",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppDropdown(
                          label: "Warehouses",
                          placeHolderText: 'Select Warehouses',
                          selectedValue: controller
                              .storeDropdownController
                              .selectedWarehouseId,
                          options:
                              controller.storeDropdownController.warehouseMap,
                          isLoading: controller
                              .storeDropdownController
                              .isLoadingWarehouses,
                          onChanged: (val) {},
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Opening Stock",
                          hint: "10",
                          prefixIcon: Icons.inventory,
                          controller: controller.openingStockController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.warning_amber,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Stock Alerts",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Alert Quantity",
                          hint: "0",
                          prefixIcon: Icons.warning,
                          controller: controller.alertQuantityController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(AddItemController controller) {
    return GestureDetector(
      onTap: () async {
        final source = await showDialog<ImageSource>(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a picture'),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Choose from gallery'),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ),
          ),
        );
        if (source != null) {
          final pickedFile = await controller.picker.pickImage(
            source: source,
            maxWidth: 1000,
            maxHeight: 1000,
            imageQuality: 85,
          );
          if (pickedFile != null) {
            controller.imageFile.value = File(pickedFile.path);
          }
        }
      },
      child: Obx(
        () => Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: controller.imageFile.value != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.file(
                        controller.imageFile.value!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: GestureDetector(
                          onTap: () {
                            controller.imageFile.value = null;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close,
                              color: errorColor,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Text(
                            "Item Image",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: accentColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Add Item Image",
                      style: TextStyle(
                        color: textPrimaryColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tap to browse",
                      style: TextStyle(color: accentColor, fontSize: 12),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    IconData? suffixIcon,
    Color? iconColor,
    required TextEditingController controller,
    bool required = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {},
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(prefixIcon, color: iconColor ?? accentColor, size: 20),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: iconColor ?? accentColor.withOpacity(0.7),
                  size: 20,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(color: errorColor, fontSize: 12),
        ),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    '$label is required',
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return '$label is required';
                }
                if (keyboardType == TextInputType.number) {
                  if (double.tryParse(value) == null) {
                    Get.snackbar(
                      'Error',
                      'Enter valid number',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                    return 'Enter valid number';
                  }
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required IconData prefixIcon,
    required AddItemController controller,
  }) {
    return Obx(() {
      String? selectedValue;
      void Function(String?) onChanged;

      switch (label) {
        case "Tax Rate (%)":
          selectedValue = controller.selectedTaxRate.value;
          onChanged = (value) {
            controller.selectedTaxRate.value = value;
            if (value != null) {
              // controller.taxRateController.text =
              //     controller.taxMap[value]?.toString() ?? "0";
            }
          };
          break;
        case "Discount Type":
          selectedValue = controller.selectedDiscountType.value;
          onChanged = (value) {
            controller.selectedDiscountType.value = value;
            if (value == "None") {
              controller.discountController.text = "0";
            }
          };
          break;
        default:
          selectedValue = null;
          onChanged = (value) {};
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          iconEnabledColor: accentColor.withOpacity(0.7),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                prefixIcon,
                color: accentColor.withOpacity(0.7),
                size: 20,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: accentColor, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          isExpanded: true,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textPrimaryColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    });
  }

  Widget _buildSubmitButton(
    AddItemController controller,
    GlobalKey<FormState> formKey,
  ) {
    return Obx(
      () => SizedBox(
        width: 200,
        height: 35,
        child: ElevatedButton(
          onPressed:
              controller.isProcessing.value ||
                  controller.storeDropdownController.selectedStoreId.value ==
                      null
              ? null
              : () => controller.addItem(formKey),
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: accentColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isProcessing.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Save Item',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

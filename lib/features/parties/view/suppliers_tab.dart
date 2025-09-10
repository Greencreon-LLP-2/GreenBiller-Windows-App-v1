import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dialog_field.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/features/parties/models/supplier_model.dart';
import 'package:greenbiller/features/parties/view/custom_filter_chip.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/parties/view/summary_card_page.dart';
import 'package:greenbiller/features/parties/view/supplier_card.dart';

class SuppliersTab extends StatelessWidget {
  const SuppliersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PartiesController>();

    return Column(
      children: [
        // Summary Cards
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Obx(
            () => Row(
              children: [
                SummaryCard(
                  title: 'Total Suppliers',
                  value:
                      controller.supplierModel.value?.insights?.totalSuppliers
                          ?.toString() ??
                      '0',
                  icon: Icons.business,
                  color: Colors.blue,
                ),
                const SizedBox(width: 16),
                SummaryCard(
                  title: 'Active Suppliers',
                  value:
                      controller.supplierModel.value?.insights?.totalSuppliers
                          ?.toString() ??
                      '0',
                  icon: Icons.check_circle,
                  color: successColor,
                ),
                const SizedBox(width: 16),
                SummaryCard(
                  title: 'New Suppliers (30 days)',
                  value:
                      controller
                          .supplierModel
                          .value
                          ?.insights
                          ?.newSuppliersLast30Days
                          ?.toString() ??
                      '0',
                  icon: Icons.person_add,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
        // Search, Filter and Store Selection Section
        Container(
          padding: const EdgeInsets.all(16),
          color: cardColor,
          child: Obx(
            () => Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: textLightColor, width: 1),
                    ),
                    child: TextField(
                      controller: controller.supplierSearchController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: textPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search suppliers...',
                        hintStyle: TextStyle(
                          color: textSecondaryColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: textSecondaryColor.withOpacity(0.6),
                        ),
                        suffixIcon:
                            controller.supplierSearchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: textSecondaryColor.withOpacity(0.6),
                                ),
                                onPressed: () {
                                  controller.supplierSearchQuery.value = '';
                                  controller.supplierSearchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) =>
                          controller.supplierSearchQuery.value = value
                              .toLowerCase(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDropdown(
                    label: "Store",
                    selectedValue:
                        controller.storeDropdownController.selectedStoreId,
                    options: controller.storeDropdownController.storeMap,
                    isLoading:
                        controller.storeDropdownController.isLoadingStores,
                    onChanged: (val) {
                      controller.selectedCustomerStoreId.value = val;
                    },
                  ),
                ),

                const SizedBox(width: 12),
                CustomFilterChip(
                  icon: Icons.filter_list,
                  label: controller.supplierSelectedFilter.value,
                  onTap: () => controller.showSupplierFilterDialog(context),
                ),
              ],
            ),
          ),
        ),
        // Suppliers List
        Expanded(
          child: Obx(
            () => controller.isLoadingSuppliers.value
                ? const Center(child: CircularProgressIndicator())
                : controller.supplierError.value != null
                ? Center(
                    child: Text(
                      'Error: ${controller.supplierError.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : controller.filteredSuppliers.isEmpty
                ? const Center(child: Text('No suppliers found'))
                : ListView.builder(
                    itemCount: controller.filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = controller.filteredSuppliers[index];
                      return SupplierCard(supplier: supplier);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

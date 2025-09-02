import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dialog_field.dart';
import 'package:greenbiller/features/parties/controller/parties_controller.dart';
import 'package:greenbiller/features/parties/models/customer_model.dart';
import 'package:greenbiller/features/parties/view/custom_filter_chip.dart';
import 'package:greenbiller/features/parties/view/customers_card.dart';
import 'package:greenbiller/features/parties/view/store_dropdown.dart';
import 'package:greenbiller/features/parties/view/summary_card_page.dart';

class CustomersTab extends StatelessWidget {
  const CustomersTab({super.key});

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
                  title: 'Total Customers',
                  value:
                      controller.customerModel.value?.insights?.totalCustomers
                          ?.toString() ??
                      '0',
                  icon: Icons.people,
                  color: accentColor,
                ),
                const SizedBox(width: 16),
                SummaryCard(
                  title: 'Active Customers',
                  value:
                      controller.customerModel.value?.insights?.totalCustomers
                          ?.toString() ??
                      '0',
                  icon: Icons.check_circle,
                  color: successColor,
                ),
                const SizedBox(width: 16),
                SummaryCard(
                  title: 'New Customers (30 days)',
                  value:
                      controller
                          .customerModel
                          .value
                          ?.insights
                          ?.newCustomersLast30Days
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
                      controller: controller.customerSearchController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: textPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
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
                            controller.customerSearchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: textSecondaryColor.withOpacity(0.6),
                                ),
                                onPressed: () {
                                  controller.customerSearchQuery.value = '';
                                  controller.customerSearchController.clear();
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
                          controller.customerSearchQuery.value = value
                              .toLowerCase(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                StoreDropdown(
                  onStoreChanged: (storeId) {
                    controller.selectedCustomerStoreId.value = storeId;
                  },
                ),

                const SizedBox(width: 12),
                CustomFilterChip(
                  icon: Icons.filter_list,
                  label: controller.customerSelectedFilter.value,
                  onTap: () => controller.showCustomerFilterDialog(context),
                ),
              ],
            ),
          ),
        ),
        // Customers List
        Expanded(
          child: Obx(
            () => controller.isLoadingCustomers.value
                ? const Center(child: CircularProgressIndicator())
                : controller.customerError.value != null
                ? Center(
                    child: Text(
                      'Error: ${controller.customerError.value}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : controller.filteredCustomers.isEmpty
                ? const Center(child: Text('No customers found'))
                : ListView.builder(
                    itemCount: controller.filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = controller.filteredCustomers[index];
                      return CustomerCard(customer: customer);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

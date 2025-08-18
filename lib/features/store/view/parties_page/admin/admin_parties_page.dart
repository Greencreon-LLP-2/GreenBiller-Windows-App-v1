// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart' as theme;
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/store/view/parties_page/parties_page_providers.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/add_customer_dialog.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/add_supplier_dialog.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/customers_tab.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/suppliers_tab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminPartiesPage extends HookConsumerWidget {
  const AdminPartiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final currentTabIndex = useState(0);
    refreshCustomers() => ref.read(customerRefreshProvider.notifier).state++;
    refreshSuppliers() => ref.read(supplierRefreshProvider.notifier).state++;

    // Listen to tab changes
    useEffect(() {
      void listener() {
        currentTabIndex.value = tabController.index;
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'Parties Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: currentTabIndex.value == 0
                      ? refreshCustomers
                      : refreshSuppliers,
                ),
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              controller: tabController,
              onTap: (index) => currentTabIndex.value = index,
              tabs: const [
                Tab(text: 'Customers'),
                Tab(text: 'Suppliers'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          CustomersTab(),
          SuppliersTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(
        currentTabIndex.value,
        context,
        currentTabIndex.value == 0 ? refreshCustomers : refreshSuppliers,
      ),
    );
  }

  Widget _buildFloatingActionButton(
    int currentTabIndex,
    BuildContext context,
    VoidCallback callback,
  ) {
    return FloatingActionButton.extended(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      onPressed: () => _showAddDialog(currentTabIndex, context, callback),
      icon: Icon(currentTabIndex == 0 ? Icons.person_add : Icons.business),
      label: Text(currentTabIndex == 0 ? 'Add Customer' : 'Add Supplier'),
    );
  }

  void _showAddDialog(
    int currentTabIndex,
    BuildContext context,
    VoidCallback refreshCustomers,
  ) {
    showDialog(
      context: context,
      builder: (context) => currentTabIndex == 0
          ? AddCustomerDialog(onSuccess: refreshCustomers)
          : AddSupplierDialog(onSuccess: refreshCustomers),
    ).then((_) => refreshCustomers()); // Refresh after dialog closes
  }
}

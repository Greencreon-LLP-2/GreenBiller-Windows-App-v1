import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/payment/controller/payment_data_providers.dart';
import 'package:green_biller/features/payment/services/payment_in_out_service.dart';
import 'package:green_biller/features/payment/view/pages/payment_in_page/payment_in_bottom_bar.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/add_customer_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPaymentInPage extends ConsumerStatefulWidget {
  const AddPaymentInPage({super.key});

  @override
  ConsumerState<AddPaymentInPage> createState() => _AddPaymentInPageState();
}

class _AddPaymentInPageState extends ConsumerState<AddPaymentInPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> customerMap =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<bool> isLoadingCustomers = ValueNotifier<bool>(false);
  final ValueNotifier<String?> selectedCustomer = ValueNotifier<String?>(null);
  late String accessToken;
  bool _loadingCustomers = false;
  Map<String, dynamic> _customerDetails = {};
  List<Map<String, dynamic>> _customerSuggestions = []; // FIX: full maps now
  bool _showSuggestions = false;
  late PaymentInOutService _service;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    accessToken = user?.accessToken ?? '';
    _service = PaymentInOutService(accessToken);
    _searchController.addListener(_onSearchChanged);
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    customerMap.dispose();
    isLoadingCustomers.dispose();
    selectedCustomer.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    isLoadingCustomers.value = true;
    try {
      // Replace with your actual customer fetching logic
      final customers = await _fetchCustomers('', context);
      customerMap.value = customers;
    } catch (e) {
      // Handle error
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCustomers(
    String storeId,
    BuildContext context,
  ) async {
    return await _service.viewCustomerServies(storeId);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _customerSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final suggestions = customerMap.value
          .where((customer) =>
              (customer['customer_name']?.toString().toLowerCase() ?? '')
                  .contains(query))
          .toList();

      setState(() {
        _customerSuggestions = suggestions;
        _showSuggestions = suggestions.isNotEmpty;
      });
    });
  }

  void _selectCustomer(Map<String, dynamic> customer) {
    setState(() {
      selectedCustomer.value = customer['id']?.toString(); // ✅ just ID
      _searchController.text = customer['customer_name'] ?? ''; // display name
      _showSuggestions = false;
      _customerDetails = customer; // ✅ keep full details for info section
    });

    FocusScope.of(context).unfocus(); // close keyboard
  }

  void _refreshCustomers() {
    _loadCustomers();
    setState(() {
      selectedCustomer.value = null;
      _searchController.clear();
      _customerDetails = {};
    });
  }

  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddCustomerDialog(onSuccess: _refreshCustomers),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    final padding = isDesktop ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        title: const Text(
          "Payment In",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => ref.refresh(paymentInProvider('')),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information Section
            _buildSectionTitle("Customer Information"),
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchCustomer(),
                  const SizedBox(height: 16),
                  _buildCustomerDetails(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Details Section
            _buildSectionTitle("Payment Details"),
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPaymentFields(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: PaymentInBottomBar(
        customerId: selectedCustomer.value,
        accessToken: accessToken,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildSearchCustomer() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search customer...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: textLightColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: accentColor),
                      ),
                    ),
                  ),
                  if (_showSuggestions && _customerSuggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: textLightColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: _customerSuggestions
                            .map(
                              (customer) => ListTile(
                                title: Text(customer['customer_name'] ?? ''),
                                onTap: () => _selectCustomer(customer),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddCustomerDialog(context),
              icon: const Icon(Icons.person_add),
              label: const Text('New Customer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerDetails() {
    if (_customerDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.person, 'Customer Name',
            _customerDetails['customer_name'] ?? ''),
        const SizedBox(height: 12),
        _buildInfoRow(
            Icons.phone, 'Phone Number', _customerDetails['mobile'] ?? ''),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.email, 'Email', _customerDetails['email'] ?? ''),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: textSecondaryColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: textSecondaryColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: textPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFields() {
    return const Column(
      children: [
        Row(
          children: [
            Text(
              'Total Due ₹ 25,450',
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text('Amount Received ₹ 0'),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              'Balance ₹ 25,450',
            ),
          ],
        ),
      ],
    );
  }
}

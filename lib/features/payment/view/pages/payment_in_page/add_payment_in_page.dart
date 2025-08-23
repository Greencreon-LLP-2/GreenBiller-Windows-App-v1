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
  List<Map<String, dynamic>> _customerSuggestions = [];
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
      final customers = await _fetchCustomers('', context);
      customerMap.value = customers;
    } catch (e) {
      // Handle error
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCustomers(
      String storeId, BuildContext context) async {
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
      selectedCustomer.value = customer['id']?.toString();
      _searchController.text = customer['customer_name'] ?? '';
      _showSuggestions = false;
      _customerDetails = customer;
    });
    FocusScope.of(context).unfocus();
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
    final padding = isDesktop ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //   splashRadius: 24,
        // ),
        title: const Text(
          "Payment In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            splashRadius: 24,
            onPressed: () => ref.refresh(paymentInProvider('')),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Customer Information"),
            CardContainer(
              elevation: 5,
              borderRadius: 12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchCustomer(),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: isLoadingCustomers,
                      builder: (context, isLoading, _) {
                        return isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(accentColor),
                              ))
                            : _buildCustomerDetails();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Payment Details"),
            CardContainer(
              elevation: 5,
              borderRadius: 12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPaymentFields(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("Payment Form"),
            PaymentInBottomBar(
              customerId: selectedCustomer.value,
              accessToken: accessToken,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildSearchCustomer() {
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: customerMap,
      builder: (context, customers, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search customer by name...',
                          labelStyle:
                              TextStyle(color: textLightColor.withOpacity(0.6)),
                          prefixIcon:
                              Icon(Icons.search, color: textSecondaryColor),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: accentColor, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                        ),
                        style: const TextStyle(
                            fontSize: 16, color: textPrimaryColor),
                      ),
                      if (_searchController.text.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: IconButton(
                            icon: const Icon(Icons.clear,
                                size: 20, color: textSecondaryColor),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _showAddCustomerDialog(context),
                  icon: const Icon(Icons.person_add, size: 20),
                  label: const Text('Add Customer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.2),
                  ),
                ),
              ],
            ),
            if (_showSuggestions && _customerSuggestions.isNotEmpty)
              CardContainer(
                elevation: 5,
                borderRadius: 12,
                margin: const EdgeInsets.only(top: 8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: _customerSuggestions.length,
                    itemBuilder: (context, index) {
                      final customer = _customerSuggestions[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _selectCustomer(customer),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            child: Text(
                              customer['customer_name'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                color: textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCustomerDetails() {
    if (_customerDetails.isEmpty) {
      return const Text(
        'No customer selected',
        style: TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return AnimatedOpacity(
      opacity: _customerDetails.isEmpty ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
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
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: textSecondaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: textSecondaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentRow('Total Due', '₹ 25,450', Colors.redAccent),
        const SizedBox(height: 16),
        _buildPaymentRow('Amount Received', '₹ 0', Colors.green),
        const SizedBox(height: 16),
        _buildPaymentRow('Balance', '₹ 25,450', textPrimaryColor),
      ],
    );
  }

  Widget _buildPaymentRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

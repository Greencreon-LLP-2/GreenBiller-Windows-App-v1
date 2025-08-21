import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/core/widgets/card_container.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/payment/services/payment_in_out_service.dart';
import 'package:green_biller/features/payment/view/pages/payment_out_page/payment_out_bottom_bar.dart';
import 'package:green_biller/features/store/view/parties_page/widgets/add_supplier_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPaymentOutPage extends ConsumerStatefulWidget {
  const AddPaymentOutPage({super.key});

  @override
  ConsumerState<AddPaymentOutPage> createState() => _AddPaymentOutPageState();
}

class _AddPaymentOutPageState extends ConsumerState<AddPaymentOutPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> supplierMap =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  final ValueNotifier<bool> isLoadingSuppliers = ValueNotifier<bool>(false);
  final ValueNotifier<String?> selectedSupplier = ValueNotifier<String?>(null);
  late String accessToken;
  bool _loadingSuppliers = false;
  Map<String, dynamic> _supplierDetails = {};
  List<Map<String, dynamic>> _supplierSuggestions = [];
  bool _showSuggestions = false;
  late PaymentInOutService _service;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    accessToken = user?.accessToken ?? '';
    _service = PaymentInOutService(accessToken);
    _searchController.addListener(_onSearchChanged);
    _loadSuppliers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    supplierMap.dispose();
    isLoadingSuppliers.dispose();
    selectedSupplier.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    isLoadingSuppliers.value = true;
    try {
      final suppliers = await _fetchSuppliers('', context);
      supplierMap.value = suppliers;
    } catch (e) {
      // Handle error
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSuppliers(
    String storeId,
    BuildContext context,
  ) async {
    return await _service.viewSupplierServies(storeId);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _supplierSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final suggestions = supplierMap.value
          .where((supplier) =>
              (supplier['supplier_name']?.toString().toLowerCase() ?? '')
                  .contains(query))
          .toList();

      setState(() {
        _supplierSuggestions = suggestions;
        _showSuggestions = suggestions.isNotEmpty;
      });
    });
  }

  void _selectSupplier(Map<String, dynamic> supplier) {
    setState(() {
      selectedSupplier.value = supplier['id']?.toString();
      _searchController.text = supplier['supplier_name'] ?? '';
      _showSuggestions = false;
      _supplierDetails = supplier;
    });

    FocusScope.of(context).unfocus();
  }

  void _refreshSuppliers() {
    _loadSuppliers();
    setState(() {
      selectedSupplier.value = null;
      _searchController.clear();
      _supplierDetails = {};
    });
  }

  void _showAddSupplierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddSupplierDialog(onSuccess: _refreshSuppliers),
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
          icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 0, 0, 0)),
        ),
        title: const Text(
          "Payment Out",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => _refreshSuppliers(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Information Section
            _buildSectionTitle("Supplier Information"),
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchSupplier(),
                  const SizedBox(height: 16),
                  _buildSupplierDetails(),
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
      bottomNavigationBar: PaymentOutBottomBar(
        supplierId: selectedSupplier.value,
        accessToken: accessToken,
        supplierDue: _supplierDetails['purchase_due']?.toString(),
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

  Widget _buildSearchSupplier() {
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
                      hintText: 'Search supplier...',
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
                  if (_showSuggestions && _supplierSuggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: textLightColor),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        children: _supplierSuggestions
                            .map(
                              (supplier) => ListTile(
                                title: Text(supplier['supplier_name'] ?? ''),
                                onTap: () => _selectSupplier(supplier),
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
              onPressed: () => _showAddSupplierDialog(context),
              icon: const Icon(Icons.person_add),
              label: const Text('New Supplier'),
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

  Widget _buildSupplierDetails() {
    if (_supplierDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.person, 'Supplier Name', _supplierDetails['supplier_name'] ?? ''),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.phone, 'Phone Number', _supplierDetails['mobile'] ?? _supplierDetails['phone'] ?? ''),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.email, 'Email', _supplierDetails['email'] ?? ''),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.attach_money, 'Purchase Due', '₹ ${_supplierDetails['purchase_due'] ?? '0.00'}'),
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
    final purchaseDue = double.tryParse(_supplierDetails['purchase_due']?.toString() ?? '0') ?? 0;
    
    return Column(
      children: [
        _buildAmountField('Total Due', '₹ ${purchaseDue.toStringAsFixed(2)}', isReadOnly: true),
        const SizedBox(height: 12),
        _buildAmountField('Amount Paid', '₹ 0.00', isReadOnly: false),
        const SizedBox(height: 12),
        _buildAmountField('Balance', '₹ ${purchaseDue.toStringAsFixed(2)}',
            isNegative: purchaseDue > 0, isReadOnly: true),
      ],
    );
  }

  Widget _buildAmountField(String label, String value,
      {bool isReadOnly = false, bool isNegative = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: textPrimaryColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isReadOnly ? Colors.grey.shade100 : Colors.white,
              border: Border.all(color: textLightColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isNegative ? errorColor : textPrimaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

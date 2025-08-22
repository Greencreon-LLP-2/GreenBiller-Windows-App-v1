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
      String storeId, BuildContext context) async {
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
    final padding = isDesktop ? 32.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          splashRadius: 24,
        ),
        title: const Text(
          "Payment Out",
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
            onPressed: _refreshSuppliers,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Supplier Information"),
            CardContainer(
              elevation: 5,
              borderRadius: 12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchSupplier(),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: isLoadingSuppliers,
                      builder: (context, isLoading, _) {
                        return isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(accentColor),
                              ))
                            : _buildSupplierDetails();
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
            _buildSectionTitle("Payment Actions"),
            CardContainer(
              elevation: 5,
              borderRadius: 12,
              margin: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PaymentOutBottomBar(
                  supplierId: selectedSupplier.value,
                  accessToken: accessToken,
                  supplierDue: _supplierDetails['purchase_due']?.toString(),
                ),
              ),
            ),
            const SizedBox(height: 24),
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

  Widget _buildSearchSupplier() {
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
                      labelText: 'Search supplier by name...',
                      labelStyle:
                          TextStyle(color: textLightColor.withOpacity(0.6)),
                      prefixIcon: Icon(Icons.search, color: textSecondaryColor),
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
                    style:
                        const TextStyle(fontSize: 16, color: textPrimaryColor),
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
              onPressed: () => _showAddSupplierDialog(context),
              icon: const Icon(Icons.person_add, size: 20),
              label: const Text('New Supplier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                shadowColor: Colors.black.withOpacity(0.2),
              ),
            ),
          ],
        ),
        if (_showSuggestions && _supplierSuggestions.isNotEmpty)
          CardContainer(
            elevation: 5,
            borderRadius: 12,
            margin: const EdgeInsets.only(top: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: _supplierSuggestions.length,
                itemBuilder: (context, index) {
                  final supplier = _supplierSuggestions[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _selectSupplier(supplier),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Text(
                          supplier['supplier_name'] ?? '',
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
  }

  Widget _buildSupplierDetails() {
    if (_supplierDetails.isEmpty) {
      return const Text(
        'No supplier selected',
        style: TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return AnimatedOpacity(
      opacity: _supplierDetails.isEmpty ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.person, 'Supplier Name',
              _supplierDetails['supplier_name'] ?? ''),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone, 'Phone Number',
              _supplierDetails['mobile'] ?? _supplierDetails['phone'] ?? ''),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email, 'Email', _supplierDetails['email'] ?? ''),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.attach_money, 'Purchase Due',
              '₹ ${_supplierDetails['purchase_due']?.toStringAsFixed(2) ?? '0.00'}'),
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
    final purchaseDue =
        double.tryParse(_supplierDetails['purchase_due']?.toString() ?? '0') ??
            0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAmountField('Total Due', '₹ ${purchaseDue.toStringAsFixed(2)}',
            isReadOnly: true),
        const SizedBox(height: 12),
        _buildAmountField('Amount Paid', '',
            isReadOnly: false, isPlaceholder: true),
        const SizedBox(height: 12),
        _buildAmountField('Balance', '₹ ${purchaseDue.toStringAsFixed(2)}',
            isNegative: purchaseDue > 0, isReadOnly: true),
      ],
    );
  }

  Widget _buildAmountField(String label, String value,
      {bool isReadOnly = false,
      bool isNegative = false,
      bool isPlaceholder = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            readOnly: isReadOnly,
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              labelText: isPlaceholder ? 'Enter amount' : null,
              labelStyle: TextStyle(color: textLightColor.withOpacity(0.6)),
              filled: true,
              fillColor: isReadOnly ? Colors.grey.shade100 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: accentColor, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isNegative ? errorColor : textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

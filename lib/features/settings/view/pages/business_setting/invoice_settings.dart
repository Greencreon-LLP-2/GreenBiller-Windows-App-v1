import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/settings/services/invoice_settings_service.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:green_biller/utils/custom_appbar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceSettingsPage extends StatefulWidget {
  final String accessToken;
  const InvoiceSettingsPage({super.key, required this.accessToken});

  @override
  State<InvoiceSettingsPage> createState() => _InvoiceSettingsPageState();
}

class _InvoiceSettingsPageState extends State<InvoiceSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  bool _enableTax = true;
  bool _showLogo = true;
  bool _includeNotes = false;
  bool _autoNumbering = true;
  bool _sendCopy = false;
  String _selectedTemplate = "Template A";
  bool isLoadingStores = false;
  final _businessNameController =
      TextEditingController(text: "GreenBiller Solutions");
  final _businessAddressController = TextEditingController(
      text: "123 Business Street, Suite 100\nCity, State 12345");
  final _businessEmailController =
      TextEditingController(text: "info@greenbiller.com");
  final _businessPhoneController =
      TextEditingController(text: "+1 (555) 123-4567");
  final _taxIdController = TextEditingController(text: "GST123456789");
  final _invoicePrefixController = TextEditingController(text: "INV-");
  final _startingNumberController = TextEditingController(text: "1001");
  final _taxRateController = TextEditingController(text: "18");
  final _paymentDetailsController = TextEditingController(
      text:
          "Bank Transfer\nAccount: 1234567890\nIFSC: ABCD0123456\nUPI: business@paytm");
  final _invoiceNotesController =
      TextEditingController(text: "Thank you for your business!");
  String? selectStoreId = '';
  bool _isLoading = false;
  bool _isshowSettings = false;
  String? _errorMessage = '';
  late InvoiceSettingsService _service;
  late Map<String, String> _storeMap;

  @override
  void initState() {
    super.initState();
    _service = InvoiceSettingsService(widget.accessToken);
    _fetchStore();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _businessEmailController.dispose();
    _businessPhoneController.dispose();
    _taxIdController.dispose();
    _invoicePrefixController.dispose();
    _startingNumberController.dispose();
    _taxRateController.dispose();
    _paymentDetailsController.dispose();
    _invoiceNotesController.dispose();
    super.dispose();
  }

  Future<void> _fetchStore() async {
    setState(() {
      isLoadingStores = true;
    });
    try {
      final map =
          await ViewStoreController(accessToken: widget.accessToken, storeId: 0)
              .getStoreList();
      setState(() {
        _storeMap = map;
        isLoadingStores = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching store: $e';
        isLoadingStores = false;
      });
    }
  }

  Future<void> _fetchSettings() async {
    if (selectStoreId == null) {
      setState(() {
        _errorMessage = "Please select a store first";
      });
      return;
    }
    setState(() {
      _isshowSettings = false;
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _service.fetchInvoiceSettings(selectStoreId!);
      setState(() {
        _businessNameController.text =
            data['business_name'] ?? "GreenBiller Solutions";
        _businessAddressController.text = data['business_address'] ??
            "123 Business Street, Suite 100\nCity, State 12345";
        _businessEmailController.text =
            data['business_email'] ?? "info@greenbiller.com";
        _businessPhoneController.text =
            data['business_phone'] ?? "+1 (555) 123-4567";
        _taxIdController.text = data['tax_id'] ?? "GST123456789";
        _invoicePrefixController.text = data['invoice_prefix'] ?? "INV-";
        _startingNumberController.text = data['starting_number'] ?? "1001";
        _taxRateController.text = data['tax_rate'] ?? "18";
        _paymentDetailsController.text = data['payment_details'] ??
            "Bank Transfer\nAccount: 1234567890\nIFSC: ABCD0123456\nUPI: business@paytm";
        _invoiceNotesController.text =
            data['invoice_notes'] ?? "Thank you for your business!";
        _enableTax = _parseBool(data['enable_tax'], defaultValue: true);
        _showLogo = _parseBool(data['show_logo'], defaultValue: true);
        _includeNotes = _parseBool(data['include_notes'], defaultValue: false);
        _autoNumbering = _parseBool(data['auto_numbering'], defaultValue: true);
        _sendCopy = _parseBool(data['send_copy'], defaultValue: false);
        _selectedTemplate = data['selected_template'] ?? "Template A";
        _isLoading = false;
        _isshowSettings = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching settings: $e';
      });
    }
  }

  bool _parseBool(dynamic value, {bool defaultValue = false}) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  Future<void> _saveSettings() async {
    if (selectStoreId == null) {
      setState(() {
        _errorMessage = "Please select a store first";
      });
      return;
    }
    if (_formKey.currentState!.validate()) {
      final data = {
        'business_name': _businessNameController.text,
        'business_address': _businessAddressController.text,
        'business_email': _businessEmailController.text,
        'business_phone': _businessPhoneController.text,
        'tax_id': _taxIdController.text,
        'invoice_prefix': _invoicePrefixController.text,
        'starting_number': _startingNumberController.text,
        'tax_rate': _taxRateController.text,
        'payment_details': _paymentDetailsController.text,
        'invoice_notes': _invoiceNotesController.text,
        'enable_tax': _enableTax,
        'show_logo': _showLogo,
        'include_notes': _includeNotes,
        'auto_numbering': _autoNumbering,
        'send_copy': _sendCopy,
        'selected_template': _selectedTemplate,
      };

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response =
            await _service.saveInvoiceSettings(data, selectStoreId!);
        setState(() {
          _isLoading = false;
        });
        if (response) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Invoice settings saved successfully!"),
                ],
              ),
              backgroundColor: accentColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
          await _fetchSettings();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Invoice Settings',
        subtitle: "Configure your invoice templates and billing information",
        gradientColor: accentColor,
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showTemplateSelector(),
            icon: const Icon(Icons.palette, size: 16, color: Colors.white),
            label: const Text('Templates'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor.withOpacity(0.1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoadingStores
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && selectStoreId == null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDesktopLayout(),
                ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save, size: 16),
                label: const Text("Save Settings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _previewInvoice,
                icon: const Icon(Icons.preview, size: 16),
                label: const Text("Preview"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildStoreDropdown(),
        const SizedBox(
          height: 20,
        ),
        if (_isshowSettings)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildBusinessInfoCard(),
                      _buildInvoiceDetailsCard(),
                      _buildTaxInfoCard(),
                      _buildPaymentInfoCard(),
                      _buildDisplayOptionsCard(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: _buildPreviewCard(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF9CA3AF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade300),
        color: Colors.green.shade50,
      ),
      child: DropdownButtonFormField<String>(
        items: _storeMap.keys.map((String store) {
          return DropdownMenuItem<String>(
            value: store,
            child: Text(store),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectStoreId = _storeMap[value];
            _fetchSettings();
          });
        },
        decoration: InputDecoration(
          hintText: "Select Store",
          prefixIcon: Icon(Icons.store, color: Colors.green.shade600),
          border: InputBorder.none, 
          enabledBorder: InputBorder.none, 
          focusedBorder: InputBorder.none, 
        ),
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return _buildCard(
      title: 'Business Information',
      icon: Icons.business,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _businessNameController,
                  label: 'Business Name',
                  hint: 'Enter your business name',
                  icon: Icons.business_center,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Business name is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _taxIdController,
                  label: 'Tax ID/GST Number',
                  hint: 'Enter tax identification number',
                  icon: Icons.verified_user,
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _businessAddressController,
            label: 'Business Address',
            hint: 'Enter your complete business address',
            icon: Icons.location_on,
            maxLines: 3,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _businessEmailController,
                  label: 'Email Address',
                  hint: 'Enter business email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _businessPhoneController,
                  label: 'Phone Number',
                  hint: 'Enter contact number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailsCard() {
    return _buildCard(
      title: 'Invoice Configuration',
      icon: Icons.description,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _invoicePrefixController,
                  label: 'Invoice Prefix',
                  hint: 'Enter invoice prefix',
                  icon: Icons.text_fields,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _startingNumberController,
                  label: 'Starting Number',
                  hint: 'Enter starting number',
                  icon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    final num = int.tryParse(value);
                    if (num == null || num <= 0) {
                      return 'Enter valid number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Automatic Invoice Numbering',
            subtitle: 'Generate sequential invoice numbers automatically',
            value: _autoNumbering,
            onChanged: (value) => setState(() => _autoNumbering = value),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _invoiceNotesController,
            label: 'Default Invoice Notes',
            hint: 'Enter default notes for all invoices',
            icon: Icons.note,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Include Notes on Invoice',
            subtitle: 'Show notes section on printed invoices',
            value: _includeNotes,
            onChanged: (value) => setState(() => _includeNotes = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxInfoCard() {
    return _buildCard(
      title: 'Tax Configuration',
      icon: Icons.calculate,
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Enable Tax on Invoices',
            subtitle: 'Apply tax calculations to all invoices',
            value: _enableTax,
            onChanged: (value) => setState(() => _enableTax = value),
          ),
          if (_enableTax) ...[
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: _buildTextField(
                controller: _taxRateController,
                label: 'Tax Rate',
                hint: 'Enter tax rate percentage',
                icon: Icons.percent,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                isRequired: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tax rate is required';
                  }
                  final rate = double.tryParse(value);
                  if (rate == null || rate < 0 || rate > 100) {
                    return 'Enter valid rate (0-100)';
                  }
                  return null;
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return _buildCard(
      title: 'Payment Information',
      icon: Icons.payment,
      child: Column(
        children: [
          _buildTextField(
            controller: _paymentDetailsController,
            label: 'Payment Details',
            hint: 'Enter bank details, UPI, payment terms, etc.',
            icon: Icons.account_balance,
            maxLines: 4,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Send Invoice Copy to Customer',
            subtitle: 'Automatically email invoice copy to customers',
            value: _sendCopy,
            onChanged: (value) => setState(() => _sendCopy = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayOptionsCard() {
    return _buildCard(
      title: 'Display Options',
      icon: Icons.visibility,
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Show Business Logo',
            subtitle: 'Display your business logo on invoices',
            value: _showLogo,
            onChanged: (value) => setState(() => _showLogo = value),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Template',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedTemplate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showTemplateSelector,
                  icon: const Icon(Icons.palette, size: 16),
                  label: const Text('Change'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor.withOpacity(0.1),
                    foregroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return _buildCard(
      title: 'Invoice Preview',
      icon: Icons.preview,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "INVOICE",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  Text(
                    "${_invoicePrefixController.text}${_startingNumberController.text}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_showLogo) ...[
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          "Your Logo Here",
                          style: TextStyle(
                              color: accentColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                _businessNameController.text.isEmpty
                    ? "Your Business Name"
                    : _businessNameController.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _businessAddressController.text.isEmpty
                    ? "Your Business Address"
                    : _businessAddressController.text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 8),
              Text(
                "Email: ${_businessEmailController.text.isEmpty ? "your@email.com" : _businessEmailController.text}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              Text(
                "Phone: ${_businessPhoneController.text.isEmpty ? "+1 (555) 123-4567" : _businessPhoneController.text}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              if (_taxIdController.text.isNotEmpty) ...[
                Text(
                  "Tax ID: ${_taxIdController.text}",
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
              const Divider(height: 30),
              const Text(
                "Bill To:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Sample Customer\n123 Customer Street\nCity, State 12345",
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Expanded(
                        child: Text("Description",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Qty",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Price",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        child: Text("Total",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildInvoiceItem(
                  "Sample Product A", "2", "₹500.00", "₹1,000.00"),
              _buildInvoiceItem(
                  "Sample Service B", "1", "₹1,500.00", "₹1,500.00"),
              const Divider(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal:",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Text("₹2,500.00",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              if (_enableTax) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax (${_taxRateController.text.isEmpty ? "0" : _taxRateController.text}%):",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "₹${_calculateTax().toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "₹${_calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: accentColor),
                    ),
                  ],
                ),
              ),
              if (_includeNotes && _invoiceNotesController.text.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text("Notes:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  _invoiceNotesController.text,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
              const SizedBox(height: 20),
              const Text("Payment Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                _paymentDetailsController.text.isEmpty
                    ? "Payment details will appear here"
                    : _paymentDetailsController.text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(
      String desc, String qty, String price, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 12))),
          Expanded(
              child: Text(qty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12))),
          Expanded(
              child: Text(price,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12))),
          Expanded(
              child: Text(total,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  double _calculateTax() {
    if (!_enableTax || _taxRateController.text.isEmpty) return 0.0;
    final rate = double.tryParse(_taxRateController.text) ?? 0.0;
    return 2500.0 * rate / 100;
  }

  double _calculateTotal() {
    return 2500.0 + _calculateTax();
  }

  Future<void> _printInvoice() async {
    final pdf = pw.Document();
    // Load the custom font
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "INVOICE",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color:
                          PdfColor.fromHex(accentColor.value.toRadixString(16)),
                      font: ttf,
                    ),
                  ),
                  pw.Text(
                    "${_invoicePrefixController.text}${_startingNumberController.text}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                      font: ttf,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              if (_showLogo) ...[
                pw.Container(
                  height: 50,
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    color:
                        PdfColor.fromHex(accentColor.value.toRadixString(16)),
                    border: pw.Border.all(
                        color: PdfColor.fromHex(
                            accentColor.value.toRadixString(16))),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      "Your Logo Here",
                      style: pw.TextStyle(
                        color: PdfColor.fromHex(
                            accentColor.value.toRadixString(16)),
                        fontWeight: pw.FontWeight.bold,
                        font: ttf,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
              pw.Text(
                _businessNameController.text.isEmpty
                    ? "Your Business Name"
                    : _businessNameController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                _businessAddressController.text.isEmpty
                    ? "Your Business Address"
                    : _businessAddressController.text,
                style: pw.TextStyle(
                    fontSize: 12, color: PdfColors.grey, font: ttf),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Email: ${_businessEmailController.text.isEmpty ? "your@email.com" : _businessEmailController.text}",
                style: pw.TextStyle(
                    fontSize: 12, color: PdfColors.grey, font: ttf),
              ),
              pw.Text(
                "Phone: ${_businessPhoneController.text.isEmpty ? "+1 (555) 123-4567" : _businessPhoneController.text}",
                style: pw.TextStyle(
                    fontSize: 12, color: PdfColors.grey, font: ttf),
              ),
              if (_taxIdController.text.isNotEmpty) ...[
                pw.Text(
                  "Tax ID: ${_taxIdController.text}",
                  style: pw.TextStyle(
                      fontSize: 12, color: PdfColors.grey, font: ttf),
                ),
              ],
              pw.Divider(height: 30),
              pw.Text(
                "Bill To:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
              ),
              pw.Text(
                "Sample Customer\n123 Customer Street\nCity, State 12345",
                style: pw.TextStyle(
                    fontSize: 14, color: PdfColors.grey, font: ttf),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex(accentColor.value.toRadixString(16)),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text("Description",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: ttf))),
                    pw.Expanded(
                        child: pw.Text("Qty",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: ttf))),
                    pw.Expanded(
                        child: pw.Text("Price",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: ttf))),
                    pw.Expanded(
                        child: pw.Text("Total",
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: ttf))),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              _buildPdfInvoiceItem(
                  "Sample Product A", "2", "₹500.00", "₹1,000.00", ttf),
              _buildPdfInvoiceItem(
                  "Sample Service B", "1", "₹1,500.00", "₹1,500.00", ttf),
              pw.Divider(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Subtotal:",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal, font: ttf)),
                  pw.Text("₹2,500.00",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf)),
                ],
              ),
              if (_enableTax) ...[
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Tax (${_taxRateController.text.isEmpty ? "0" : _taxRateController.text}%):",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal, font: ttf),
                    ),
                    pw.Text(
                      "₹${_calculateTax().toStringAsFixed(2)}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, font: ttf),
                    ),
                  ],
                ),
              ],
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: PdfColors.grey)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Total:",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                            font: ttf)),
                    pw.Text(
                      "₹${_calculateTotal().toStringAsFixed(2)}",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 16,
                          color: PdfColor.fromHex(
                              accentColor.value.toRadixString(16)),
                          font: ttf),
                    ),
                  ],
                ),
              ),
              if (_includeNotes && _invoiceNotesController.text.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Text("Notes:",
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, font: ttf)),
                pw.SizedBox(height: 8),
                pw.Text(
                  _invoiceNotesController.text,
                  style: pw.TextStyle(
                      fontSize: 12, color: PdfColors.grey, font: ttf),
                ),
              ],
              pw.SizedBox(height: 20),
              pw.Text("Payment Information:",
                  style:
                      pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf)),
              pw.SizedBox(height: 8),
              pw.Text(
                _paymentDetailsController.text.isEmpty
                    ? "Payment details will appear here"
                    : _paymentDetailsController.text,
                style: pw.TextStyle(
                    fontSize: 12, color: PdfColors.grey, font: ttf),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfInvoiceItem(
      String desc, String qty, String price, String total, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
              child:
                  pw.Text(desc, style: pw.TextStyle(fontSize: 12, font: font))),
          pw.Expanded(
              child: pw.Text(qty,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 12, font: font))),
          pw.Expanded(
              child: pw.Text(price,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 12, font: font))),
          pw.Expanded(
              child: pw.Text(total,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      font: font))),
        ],
      ),
    );
  }

  void _showTemplateSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Invoice Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTemplateOption("Template A"),
            _buildTemplateOption("Template B"),
            _buildTemplateOption("Template C"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateOption(String name) {
    final bool isSelected = _selectedTemplate == name;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTemplate = name);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected ? accentColor.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.description,
              color: isSelected ? accentColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? accentColor : Colors.grey.shade700,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: accentColor),
          ],
        ),
      ),
    );
  }

  void _previewInvoice() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Invoice Preview',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _printInvoice,
                          icon: const Icon(Icons.print, size: 16),
                          label: const Text("Print Invoice"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildPreviewCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

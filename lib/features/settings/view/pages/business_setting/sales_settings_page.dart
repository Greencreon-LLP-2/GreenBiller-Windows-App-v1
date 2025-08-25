import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/settings/services/sales_settings_service.dart';
import 'package:green_biller/utils/custom_appbar.dart';

class SalesSettingsPage extends StatefulWidget {
  final String accessToken;
  const SalesSettingsPage({super.key, required this.accessToken});

  @override
  State<SalesSettingsPage> createState() => _SalesSettingsPageState();
}

class _SalesSettingsPageState extends State<SalesSettingsPage> {
  late SalesSettingsService _service;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int? _existingSettingsId;

  // Controllers
  final _salesDiscountController = TextEditingController();
  final _salesInvoiceFooterController = TextEditingController();
  final _termsConditionsController = TextEditingController();

  // Dropdown values
  String? _selectedDefaultAccount;
  String? _selectedSalesInvoiceFormat;
  String? _selectedPOSInvoiceFormat;
  String? _selectedNumberToWordsFormat;

  // Toggle switches
  bool _showMRPColumn = true;
  bool _showPaidAmount = true;
  bool _showChangeReturn = true;
  bool _showPreviousBalance = false;
  bool _showTermsOnInvoice = true;
  bool _showTermsOnPOS = false;

  // Dropdown options
  final List<String> _accountOptions = [
    'Cash Account',
    'Bank Account - HDFC',
    'Bank Account - SBI',
    'Petty Cash',
    'Sales Account',
    'Revenue Account',
  ];

  final List<String> _invoiceFormatOptions = [
    'Standard Format',
    'Detailed Format',
    'Compact Format',
    'Professional Format',
    'Custom Format',
  ];

  final List<String> _posInvoiceFormatOptions = [
    'Thermal 58mm',
    'Thermal 80mm',
    'A4 Format',
    'Custom POS Format',
  ];

  final List<String> _numberToWordsOptions = [
    'Default',
    'Indian GST Format',
    'International Format',
  ];

  @override
  void initState() {
    super.initState();
    _service = SalesSettingsService(accessToken: widget.accessToken);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _service.getSalesSettings();

      if (response['status'] == 1 &&
          response['data'] is List &&
          response['data'].isNotEmpty) {
        final settings = response['data'][0]; // Get first settings record
        _populateForm(settings);
      } else {
        // No existing settings, set default values
        _setDefaultValues();
      }
    } catch (e) {
      print('Error loading settings: $e');
      _setDefaultValues();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateForm(Map<String, dynamic> settings) {
    setState(() {
      _existingSettingsId = settings['id'];
      _selectedDefaultAccount = settings['account'] ?? _accountOptions.first;
      _salesDiscountController.text =
          settings['discount']?.toString() ?? '0.00';
      _showMRPColumn = bool.parse(settings['show_mrp']) ?? true;
      _showPaidAmount = bool.parse(settings['show_paidamount']) ?? true;
      _showChangeReturn = bool.parse(settings['show_return']) ?? true;
      _salesInvoiceFooterController.text =
          settings['footer_text'] ?? 'Thank you for your business!';
      _selectedSalesInvoiceFormat =
          settings['sale_invoice'] ?? _invoiceFormatOptions.first;
      _selectedPOSInvoiceFormat =
          settings['pos_invoice'] ?? _posInvoiceFormatOptions.first;
      _selectedNumberToWordsFormat =
          settings['number_to_word'] ?? _numberToWordsOptions.first;
      _showPreviousBalance = bool.parse(settings['show_previous_balance']) ?? false;
      _showTermsOnInvoice = bool.parse(settings['show_invoice']) ?? true;
      _showTermsOnPOS = bool.parse(settings['show_pos_invoice']) ?? false;
      _termsConditionsController.text =
          settings['term_conditions'] ??
          '1. Payment is due within 30 days\n2. Late payments may incur additional charges\n3. Goods once sold cannot be returned without prior approval';
    });
  }

  void _setDefaultValues() {
    setState(() {
      _selectedDefaultAccount = _accountOptions.first;
      _selectedSalesInvoiceFormat = _invoiceFormatOptions.first;
      _selectedPOSInvoiceFormat = _posInvoiceFormatOptions.first;
      _selectedNumberToWordsFormat = _numberToWordsOptions.first;
      _salesDiscountController.text = '0.00';
      _salesInvoiceFooterController.text = 'Thank you for your business!';
      _termsConditionsController.text =
          '1. Payment is due within 30 days\n2. Late payments may incur additional charges\n3. Goods once sold cannot be returned without prior approval';
      _showMRPColumn = true;
      _showPaidAmount = true;
      _showChangeReturn = true;
      _showPreviousBalance = false;
      _showTermsOnInvoice = true;
      _showTermsOnPOS = false;
    });
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final Map<String, dynamic> requestData = {
          'account': _selectedDefaultAccount,
          'discount': double.tryParse(_salesDiscountController.text) ?? 0.0,
          'show_mrp': _showMRPColumn,
          'show_paidamount': _showPaidAmount,
          'show_return': _showChangeReturn,
          'footer_text': _salesInvoiceFooterController.text,
          'sale_invoice': _selectedSalesInvoiceFormat,
          'pos_invoice': _selectedPOSInvoiceFormat,
          'number_to_word': _selectedNumberToWordsFormat,
          'show_previous_balance': _showPreviousBalance,
          'show_invoice': _showTermsOnInvoice,
          'show_pos_invoice': _showTermsOnPOS,
          'term_conditions': _termsConditionsController.text,
        };

        Map<String, dynamic> response;

        if (_existingSettingsId != null) {
          // Update existing settings
          response = await _service.updateSalesSettings(
            _existingSettingsId!,
            requestData,
          );
        } else {
          // Create new settings
          response = await _service.createSalesSettings(requestData);
        }

        if (response['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _existingSettingsId != null
                    ? 'Sales settings updated successfully!'
                    : 'Sales settings created successfully!',
              ),
              backgroundColor: accentColor,
            ),
          );

          // Reload settings to get the ID if it was a create operation
          if (_existingSettingsId == null) {
            _loadSettings();
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to save settings');
        }
      } catch (e,stack) {
        print(e);
        print(stack);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _salesDiscountController.dispose();
    _salesInvoiceFooterController.dispose();
    _termsConditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const GradientAppBar(
        title: 'Sales Settings',
        subtitle: "Configure sales preferences and invoice formats",
        gradientColor: accentColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 768) {
                            return _buildDesktopLayout();
                          } else {
                            return _buildMobileLayout();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                // Bottom Action Bar
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _resetToDefaults,
                          icon: const Icon(Icons.restore),
                          label: const Text('Reset to Defaults'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B7280),
                            side: const BorderSide(color: Color(0xFFD1D5DB)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _saveSettings,
                          icon: const Icon(Icons.save, size: 16),
                          label: const Text('Save Settings'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        // First Row - Default Settings & Invoice Formats
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildCard(
                    title: 'Default Settings',
                    icon: Icons.settings,
                    child: Column(
                      children: [
                        _buildDropdown(
                          value: _selectedDefaultAccount,
                          label: 'Default Account *',
                          hint: 'Select default account',
                          items: _accountOptions,
                          onChanged: (value) =>
                              setState(() => _selectedDefaultAccount = value),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _salesDiscountController,
                          label: 'Default Sales Discount (%)',
                          hint: 'Enter default discount percentage',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          suffixText: '%',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildCard(
                    title: 'Invoice Format Settings',
                    icon: Icons.receipt,
                    child: Column(
                      children: [
                        _buildDropdown(
                          value: _selectedSalesInvoiceFormat,
                          label: 'Sales Invoice Format *',
                          hint: 'Select invoice format',
                          items: _invoiceFormatOptions,
                          onChanged: (value) => setState(
                            () => _selectedSalesInvoiceFormat = value,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          value: _selectedPOSInvoiceFormat,
                          label: 'POS Invoice Format *',
                          hint: 'Select POS format',
                          items: _posInvoiceFormatOptions,
                          onChanged: (value) =>
                              setState(() => _selectedPOSInvoiceFormat = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Second Row - POS Settings & Display Settings
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildCard(
                    title: 'POS Display Settings',
                    icon: Icons.point_of_sale,
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          title: 'Show MRP Column',
                          subtitle: 'Display Maximum Retail Price',
                          value: _showMRPColumn,
                          onChanged: (value) =>
                              setState(() => _showMRPColumn = value),
                        ),
                        const Divider(height: 24),
                        _buildSwitchTile(
                          title: 'Show Paid Amount',
                          subtitle: 'Display payment details',
                          value: _showPaidAmount,
                          onChanged: (value) =>
                              setState(() => _showPaidAmount = value),
                        ),
                        const Divider(height: 24),
                        _buildSwitchTile(
                          title: 'Show Change Return',
                          subtitle: 'Display change amount',
                          value: _showChangeReturn,
                          onChanged: (value) =>
                              setState(() => _showChangeReturn = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildCard(
                    title: 'Invoice Display Settings',
                    icon: Icons.description,
                    child: Column(
                      children: [
                        _buildDropdown(
                          value: _selectedNumberToWordsFormat,
                          label: 'Number to Words Format *',
                          hint: 'Select format',
                          items: _numberToWordsOptions,
                          onChanged: (value) => setState(
                            () => _selectedNumberToWordsFormat = value,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSwitchTile(
                          title: 'Show Previous Balance',
                          subtitle: 'Display outstanding balance',
                          value: _showPreviousBalance,
                          onChanged: (value) =>
                              setState(() => _showPreviousBalance = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Third Row - Footer Settings & Terms
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildCard(
                    title: 'Footer Settings',
                    icon: Icons.text_snippet,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _salesInvoiceFooterController,
                          label: 'Sales Invoice Footer Text',
                          hint: 'Enter footer message for invoices',
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildCard(
                    title: 'Terms and Conditions',
                    icon: Icons.gavel,
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          title: 'Show on Invoice',
                          subtitle: 'Display on sales invoices',
                          value: _showTermsOnInvoice,
                          onChanged: (value) =>
                              setState(() => _showTermsOnInvoice = value),
                        ),
                        const Divider(height: 24),
                        _buildSwitchTile(
                          title: 'Show on POS Invoice',
                          subtitle: 'Display on POS invoices',
                          value: _showTermsOnPOS,
                          onChanged: (value) =>
                              setState(() => _showTermsOnPOS = value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Full Width Terms Text Area
        _buildCard(
          title: 'Terms and Conditions Content',
          icon: Icons.article,
          child: Column(
            children: [
              _buildTextField(
                controller: _termsConditionsController,
                label: 'Terms and Conditions Text',
                hint: 'Enter your terms and conditions here...',
                maxLines: 6,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Default Settings Card
        _buildCard(
          title: 'Default Settings',
          icon: Icons.settings,
          child: Column(
            children: [
              _buildDropdown(
                value: _selectedDefaultAccount,
                label: 'Default Account *',
                hint: 'Select default account',
                items: _accountOptions,
                onChanged: (value) =>
                    setState(() => _selectedDefaultAccount = value),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _salesDiscountController,
                label: 'Default Sales Discount (%)',
                hint: 'Enter default discount percentage',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                suffixText: '%',
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Invoice Format Settings Card
        _buildCard(
          title: 'Invoice Format Settings',
          icon: Icons.receipt,
          child: Column(
            children: [
              _buildDropdown(
                value: _selectedSalesInvoiceFormat,
                label: 'Sales Invoice Format *',
                hint: 'Select invoice format',
                items: _invoiceFormatOptions,
                onChanged: (value) =>
                    setState(() => _selectedSalesInvoiceFormat = value),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                value: _selectedPOSInvoiceFormat,
                label: 'POS Invoice Format *',
                hint: 'Select POS format',
                items: _posInvoiceFormatOptions,
                onChanged: (value) =>
                    setState(() => _selectedPOSInvoiceFormat = value),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                value: _selectedNumberToWordsFormat,
                label: 'Number to Words Format *',
                hint: 'Select format',
                items: _numberToWordsOptions,
                onChanged: (value) =>
                    setState(() => _selectedNumberToWordsFormat = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // POS Display Settings Card
        _buildCard(
          title: 'POS Display Settings',
          icon: Icons.point_of_sale,
          child: Column(
            children: [
              _buildSwitchTile(
                title: 'Show MRP Column on POS Invoice',
                subtitle: 'Display Maximum Retail Price column',
                value: _showMRPColumn,
                onChanged: (value) => setState(() => _showMRPColumn = value),
              ),
              const Divider(height: 24),
              _buildSwitchTile(
                title: 'Show Paid Amount and Change Return',
                subtitle: 'Display payment details on POS invoice',
                value: _showPaidAmount,
                onChanged: (value) => setState(() => _showPaidAmount = value),
              ),
              const Divider(height: 24),
              _buildSwitchTile(
                title: 'Show Change Return (in POS)',
                subtitle: 'Display change amount separately',
                value: _showChangeReturn,
                onChanged: (value) => setState(() => _showChangeReturn = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Invoice Display Settings Card
        _buildCard(
          title: 'Invoice Display Settings',
          icon: Icons.description,
          child: Column(
            children: [
              _buildSwitchTile(
                title: 'Show Previous Balance on Invoice',
                subtitle:
                    'Display outstanding balance from previous transactions',
                value: _showPreviousBalance,
                onChanged: (value) =>
                    setState(() => _showPreviousBalance = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Footer Settings Card
        _buildCard(
          title: 'Footer Settings',
          icon: Icons.text_snippet,
          child: Column(
            children: [
              _buildTextField(
                controller: _salesInvoiceFooterController,
                label: 'Sales Invoice Footer Text',
                hint: 'Enter footer message for invoices',
                maxLines: 2,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Terms and Conditions Card
        _buildCard(
          title: 'Terms and Conditions',
          icon: Icons.gavel,
          child: Column(
            children: [
              _buildTextField(
                controller: _termsConditionsController,
                label: 'Terms and Conditions',
                hint: 'Enter terms and conditions',
                maxLines: 6,
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                title: 'Show on Invoice',
                subtitle: 'Display terms and conditions on sales invoices',
                value: _showTermsOnInvoice,
                onChanged: (value) =>
                    setState(() => _showTermsOnInvoice = value),
              ),
              const Divider(height: 24),
              _buildSwitchTile(
                title: 'Show on POS Invoice',
                subtitle: 'Display terms and conditions on POS invoices',
                value: _showTermsOnPOS,
                onChanged: (value) => setState(() => _showTermsOnPOS = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
                Icon(icon, size: 20, color: accentColor),
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
    TextInputType? keyboardType,
    int maxLines = 1,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            fillColor: const Color(0xFFFAFAFA),
            filled: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            fillColor: const Color(0xFFFAFAFA),
            filled: true,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: accentColor,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Reset to Defaults',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to reset all settings to default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _setDefaultValues();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _performReset() {
    setState(() {
      _selectedDefaultAccount = _accountOptions.first;
      _selectedSalesInvoiceFormat = _invoiceFormatOptions.first;
      _selectedPOSInvoiceFormat = _posInvoiceFormatOptions.first;
      _selectedNumberToWordsFormat = _numberToWordsOptions.first;
      _salesDiscountController.text = '0.00';
      _salesInvoiceFooterController.text = 'Thank you for your business!';
      _termsConditionsController.text =
          '1. Payment is due within 30 days\n2. Late payments may incur additional charges\n3. Goods once sold cannot be returned without prior approval';
      _showMRPColumn = true;
      _showPaidAmount = true;
      _showChangeReturn = true;
      _showPreviousBalance = false;
      _showTermsOnInvoice = true;
      _showTermsOnPOS = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset to defaults'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

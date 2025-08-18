import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/utils/custom_appbar.dart';

class InvoiceSettingsPage extends StatefulWidget {
  const InvoiceSettingsPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1024) {
              return _buildDesktopLayout();
            } else {
              return _buildMobileLayout();
            }
          },
        ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Settings Form
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
        // Right: Preview Panel
        Expanded(
          flex: 1,
          child: _buildPreviewCard(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildBusinessInfoCard(),
          _buildInvoiceDetailsCard(),
          _buildTaxInfoCard(),
          _buildPaymentInfoCard(),
          _buildDisplayOptionsCard(),
          _buildPreviewCard(),
        ],
      ),
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
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
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
            _buildInvoiceItem("Sample Product A", "2", "₹500.00", "₹1,000.00"),
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
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text("₹${_calculateTax().toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("₹${_calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: accentColor)),
                ],
              ),
            ),
            if (_includeNotes && _invoiceNotesController.text.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text("Notes:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_invoiceNotesController.text,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(child: _buildPreviewCard()),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
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
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _businessNameController.text = "GreenBiller Solutions";
                _businessAddressController.text =
                    "123 Business Street, Suite 100\nCity, State 12345";
                _businessEmailController.text = "info@greenbiller.com";
                _businessPhoneController.text = "+1 (555) 123-4567";
                _taxIdController.text = "GST123456789";
                _invoicePrefixController.text = "INV-";
                _startingNumberController.text = "1001";
                _taxRateController.text = "18";
                _paymentDetailsController.text =
                    "Bank Transfer\nAccount: 1234567890\nIFSC: ABCD0123456\nUPI: business@paytm";
                _invoiceNotesController.text = "Thank you for your business!";
                _enableTax = true;
                _showLogo = true;
                _includeNotes = false;
                _autoNumbering = true;
                _sendCopy = false;
                _selectedTemplate = "Template A";
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Settings reset to defaults"),
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
}

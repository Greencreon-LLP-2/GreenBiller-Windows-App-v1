// invoice_settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/custom_appbar.dart';
import 'package:greenbiller/features/settings/controller/invoice_settings_controller.dart';

class InvoiceSettingsPage extends StatelessWidget {
  InvoiceSettingsPage({super.key});

  final InvoiceSettingsController _controller = Get.put(
    InvoiceSettingsController(),
  );

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
            onPressed: _showTemplateSelector,
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
      body: Obx(
        () => _controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
        Expanded(flex: 1, child: _buildPreviewCard()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Form(
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

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _controller.saveSettings,
              icon: const Icon(Icons.save, size: 16),
              label: const Text("Save Settings"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
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
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
          maxLines: maxLines,
          onChanged: (_) => _controller.hasChanges.value = true,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required RxBool value,
  }) {
    return Obx(
      () => Container(
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
              value: value.value,
              onChanged: (newValue) {
                value.value = newValue;
                _controller.hasChanges.value = true;
              },
              activeColor: accentColor,
            ),
          ],
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
                  controller: _controller.businessNameController,
                  label: 'Business Name',
                  hint: 'Enter your business name',
                  icon: Icons.business_center,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _controller.taxIdController,
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
            controller: _controller.businessAddressController,
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
                  controller: _controller.businessEmailController,
                  label: 'Email Address',
                  hint: 'Enter business email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _controller.businessPhoneController,
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
                  controller: _controller.invoicePrefixController,
                  label: 'Invoice Prefix',
                  hint: 'Enter invoice prefix',
                  icon: Icons.text_fields,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _controller.startingNumberController,
                  label: 'Starting Number',
                  hint: 'Enter starting number',
                  icon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Automatic Invoice Numbering',
            subtitle: 'Generate sequential invoice numbers automatically',
            value: _controller.autoNumbering,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _controller.invoiceNotesController,
            label: 'Default Invoice Notes',
            hint: 'Enter default notes for all invoices',
            icon: Icons.note,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Include Notes on Invoice',
            subtitle: 'Show notes section on printed invoices',
            value: _controller.includeNotes,
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
            value: _controller.enableTax,
          ),
          Obx(
            () => _controller.enableTax.value
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _controller.taxRateController,
                        label: 'Tax Rate',
                        hint: 'Enter tax rate percentage',
                        icon: Icons.percent,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d*'),
                          ),
                        ],
                        isRequired: true,
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
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
            controller: _controller.paymentDetailsController,
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
            value: _controller.sendCopy,
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
            value: _controller.showLogo,
          ),
          const SizedBox(height: 16),
          Obx(
            () => Container(
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
                          _controller.selectedTemplate.value,
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
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return _buildCard(
      title: 'Invoice Preview',
      icon: Icons.preview,
      child: Obx(
        () => Container(
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
                    "${_controller.invoicePrefixController.text}${_controller.startingNumberController.text}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_controller.showLogo.value) ...[
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
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Text(
                _controller.businessNameController.text.isEmpty
                    ? "Your Business Name"
                    : _controller.businessNameController.text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _controller.businessAddressController.text.isEmpty
                    ? "Your Business Address"
                    : _controller.businessAddressController.text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 8),
              Text(
                "Email: ${_controller.businessEmailController.text.isEmpty ? "your@email.com" : _controller.businessEmailController.text}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              Text(
                "Phone: ${_controller.businessPhoneController.text.isEmpty ? "+1 (555) 123-4567" : _controller.businessPhoneController.text}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              if (_controller.taxIdController.text.isNotEmpty) ...[
                Text(
                  "Tax ID: ${_controller.taxIdController.text}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
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
                      child: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Qty",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Price",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Total",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildInvoiceItem(
                "Sample Product A",
                "2",
                "₹500.00",
                "₹1,000.00",
              ),
              _buildInvoiceItem(
                "Sample Service B",
                "1",
                "₹1,500.00",
                "₹1,500.00",
              ),
              const Divider(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtotal:",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "₹2,500.00",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (_controller.enableTax.value) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax (${_controller.taxRateController.text.isEmpty ? "0" : _controller.taxRateController.text}%):",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "₹${_controller.calculateTax().toStringAsFixed(2)}",
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
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "₹${_controller.calculateTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (_controller.includeNotes.value &&
                  _controller.invoiceNotesController.text.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  "Notes:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _controller.invoiceNotesController.text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                "Payment Information:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _controller.paymentDetailsController.text.isEmpty
                    ? "Payment details will appear here"
                    : _controller.paymentDetailsController.text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(
    String desc,
    String qty,
    String price,
    String total,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              price,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              total,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showTemplateSelector() {
    showDialog(
      context: Get.context!,
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
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildTemplateOption(String name) {
    return Obx(() {
      final bool isSelected = _controller.selectedTemplate.value == name;
      return GestureDetector(
        onTap: () => _controller.selectTemplate(name),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withOpacity(0.1)
                : Colors.grey.shade50,
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
              if (isSelected)
                const Icon(Icons.check_circle, color: accentColor),
            ],
          ),
        ),
      );
    });
  }

  void _previewInvoice() {
    showDialog(
      context: Get.context!,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
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

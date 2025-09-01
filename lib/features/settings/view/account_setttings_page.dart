import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/sidebar/admin_sidebar_wrapper.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/features/settings/controller/account_settings_controller.dart';

class AccountSetttingsPage extends StatelessWidget {
  AccountSetttingsPage({super.key});
  final AccountController _controller = Get.put(AccountController());
  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final storeId = authController.user.value?.storeId ?? 0;
    final userId = authController.user.value?.userId ?? 0;
    return AdminSidebarWrapper(
      title: 'Settings',
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildDesktopLayout(storeId, userId),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(int storeId, int? userId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: List of accounts
        Expanded(flex: 2, child: _buildAccountsList()),
        const SizedBox(width: 24),
        // Right: Add/Edit account form
        Expanded(flex: 3, child: _buildAccountForm(storeId, userId)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: const Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 16),
          Text(
            'No Accounts Added Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first account to get started with payments',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsList() {
    return Obx(
      () => _buildCard(
        title: 'Your Accounts',
        icon: Icons.account_balance,
        child: _controller.accounts.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.accounts.length,
                separatorBuilder: (context, i) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final acc = _controller.accounts[i];
                  return _buildAccountCard(acc);
                },
              ),
      ),
    );
  }

  Widget _buildAccountCard(Map<String, String> account) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          account['bank'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _controller.editAccount(account),
                      icon: const Icon(Icons.edit, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        // Show QR code
                      },
                      icon: const Icon(Icons.qr_code, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: accentColor.withOpacity(0.1),
                        foregroundColor: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Account Number', account['number'] ?? ''),
                  const SizedBox(height: 8),
                  _buildDetailRow('IFSC Code', account['ifsc'] ?? ''),
                  const SizedBox(height: 8),
                  _buildDetailRow('UPI ID', account['upi'] ?? ''),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    'Balance',
                    '₹${account['balance'] ?? '0'}',
                    valueColor: accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor ?? const Color(0xFF374151),
          ),
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
    TextCapitalization? textCapitalization,
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
          textCapitalization: textCapitalization ?? TextCapitalization.none,
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

  Widget _buildAccountForm(int storeId, int? userId) {
    return Obx(
      () => _buildCard(
        title: _controller.isEditing.value ? 'Edit Account' : 'Add New Account',
        icon: _controller.isEditing.value ? Icons.edit : Icons.add,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _controller.accountNameController,
                    label: 'Account Name *',
                    hint: 'Enter account holder name',
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _controller.bankNameController,
                    label: 'Bank Name *',
                    hint: 'Enter bank name',
                    icon: Icons.account_balance,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _controller.accountNumberController,
                    label: 'Account Number *',
                    hint: 'Enter account number',
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _controller.ifscCodeController,
                    label: 'IFSC Code *',
                    hint: 'Enter IFSC code',
                    icon: Icons.code,
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _controller.upiIdController,
                    label: 'UPI ID',
                    hint: 'Enter UPI ID (Mandatory)',
                    icon: Icons.qr_code,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _controller.openingBalanceController,
                    label: 'Opening Balance',
                    hint: 'Enter opening balance',
                    icon: Icons.account_balance_wallet,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_controller.isEditing.value)
                  TextButton(
                    onPressed: _controller.clearForm,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                const Spacer(),
                ElevatedButton.icon(
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
                  onPressed: () async {
                    if (_controller.accountNameController.text.isEmpty ||
                        _controller.bankNameController.text.isEmpty ||
                        _controller.accountNumberController.text.isEmpty ||
                           _controller.upiIdController.text.isEmpty||
                        _controller.ifscCodeController.text.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please fill in all required fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    bool success;
                    if (_controller.isEditing.value) {
                      success = await _controller.updateAccount(
                        _controller.selectedAccount.value?['id'] ?? '',
                        storeId,
                        _controller.accountNameController.text,
                        _controller.bankNameController.text,
                        _controller.ifscCodeController.text,
                        _controller.upiIdController.text,
                        _controller.openingBalanceController.text,
                        _controller.accountNumberController.text,
                        userId.toString(),
                      );
                    } else {
                      success = await _controller.createAccount(
                        storeId,
                        _controller.accountNameController.text,
                        _controller.bankNameController.text,
                        _controller.ifscCodeController.text,
                        _controller.upiIdController.text,
                        _controller.openingBalanceController.text,
                        _controller.accountNumberController.text,
                        userId.toString(),
                      );
                    }

                    if (success) {
                      _controller.clearForm();
                      _controller.fetchAccounts();
                      Get.snackbar(
                        'Success',
                        _controller.isEditing.value
                            ? 'Account updated successfully!'
                            : 'Account added successfully!',
                        backgroundColor: accentColor,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Failed to ${_controller.isEditing.value ? 'update' : 'create'} account',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  icon: Icon(
                    _controller.isEditing.value ? Icons.save : Icons.add,
                    size: 16,
                  ),
                  label: Text(
                    _controller.isEditing.value
                        ? 'Update Account'
                        : 'Add Account',
                  ),
                ),
                const SizedBox(width: 12),
                if (_controller.upiIdController.text.isNotEmpty)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Generate QR code logic here
                    },
                    icon: const Icon(Icons.qr_code, size: 16),
                    label: const Text('Generate QR'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

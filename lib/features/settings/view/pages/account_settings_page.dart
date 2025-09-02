import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/settings/controller/account_controller.dart';
import 'package:green_biller/main.dart';
import 'package:green_biller/utils/custom_appbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountSettingsPage extends HookConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;
    final userId = userModel?.user?.id;
    final storeId = userModel?.user?.storeId ?? '6';

    final accountNameController = useTextEditingController();
    final accountNumberController = useTextEditingController();
    final upiIdController = useTextEditingController();
    final openingBalanceController = useTextEditingController();
    final bankNameController = useTextEditingController();
    final balanceController = useTextEditingController();
    final ifscCodeController = useTextEditingController();

    final accounts = useState<List<Map<String, String>>>([]);
    final selectedAccount = useState<Map<String, String>?>(null);
    final isEditing = useState<bool>(false);

    void clearForm() {
      accountNameController.clear();
      bankNameController.clear();
      accountNumberController.clear();
      ifscCodeController.clear();
      upiIdController.clear();
      openingBalanceController.clear();
      selectedAccount.value = null;
      isEditing.value = false;
    }

    void fetchAccounts() async {
      if (accessToken != null) {
        final accountData = await AccountController()
            .viewAccountController(accessToken, context);
        if (accountData.data != null) {
          accounts.value = [];
          for (var account in accountData.data!) {
            accounts.value.add({
              'id': account.id?.toString() ?? '',
              'name': account.accountName ?? '',
              'bank': account.bankName ?? '',
              'number': account.accountNumber ?? '',
              'ifsc': account.ifscCode ?? '',
              'upi': account.upiId ?? '',
              'balance': account.balance?.toString() ?? '0',
            });
          }
          logger.i('Fetched accounts: $accounts');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No accounts found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    void editAccount(Map<String, String> account) {
      selectedAccount.value = account;
      isEditing.value = true;
      accountNameController.text = account['name'] ?? '';
      bankNameController.text = account['bank'] ?? '';
      accountNumberController.text = account['number'] ?? '';
      ifscCodeController.text = account['ifsc'] ?? '';
      upiIdController.text = account['upi'] ?? '';
      openingBalanceController.text = account['balance'] ?? '';
    }

    useEffect(() {
      fetchAccounts();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Account Settings',
        subtitle: "Manage your payment accounts and banking information",
        gradientColor: accentColor,
        actions: [
          ElevatedButton.icon(
            onPressed: clearForm,
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: const Text('Add New Account'),
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
              return _buildDesktopLayout(
                accounts,
                selectedAccount,
                isEditing,
                editAccount,
                accountNameController,
                bankNameController,
                accountNumberController,
                ifscCodeController,
                upiIdController,
                openingBalanceController,
                fetchAccounts,
                clearForm,
                accessToken,
                storeId,
                userId,
                context,
              );
            } else {
              return _buildMobileLayout(
                accounts,
                selectedAccount,
                isEditing,
                editAccount,
                accountNameController,
                bankNameController,
                accountNumberController,
                ifscCodeController,
                upiIdController,
                openingBalanceController,
                fetchAccounts,
                clearForm,
                accessToken,
                storeId,
                userId,
                context,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    ValueNotifier<List<Map<String, String>>> accounts,
    ValueNotifier<Map<String, String>?> selectedAccount,
    ValueNotifier<bool> isEditing,
    Function(Map<String, String>) editAccount,
    TextEditingController accountNameController,
    TextEditingController bankNameController,
    TextEditingController accountNumberController,
    TextEditingController ifscCodeController,
    TextEditingController upiIdController,
    TextEditingController openingBalanceController,
    Function() fetchAccounts,
    Function() clearForm,
    String? accessToken,
    String storeId,
    int? userId,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: List of accounts
        Expanded(
          flex: 2,
          child: _buildAccountsList(accounts, editAccount),
        ),
        const SizedBox(width: 24),
        // Right: Add/Edit account form
        Expanded(
          flex: 3,
          child: _buildAccountForm(
            selectedAccount,
            isEditing,
            accountNameController,
            bankNameController,
            accountNumberController,
            ifscCodeController,
            upiIdController,
            openingBalanceController,
            fetchAccounts,
            clearForm,
            accessToken,
            storeId,
            userId,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    ValueNotifier<List<Map<String, String>>> accounts,
    ValueNotifier<Map<String, String>?> selectedAccount,
    ValueNotifier<bool> isEditing,
    Function(Map<String, String>) editAccount,
    TextEditingController accountNameController,
    TextEditingController bankNameController,
    TextEditingController accountNumberController,
    TextEditingController ifscCodeController,
    TextEditingController upiIdController,
    TextEditingController openingBalanceController,
    Function() fetchAccounts,
    Function() clearForm,
    String? accessToken,
    String storeId,
    int? userId,
    BuildContext context,
  ) {
    return Column(
      children: [
        _buildAccountForm(
          selectedAccount,
          isEditing,
          accountNameController,
          bankNameController,
          accountNumberController,
          ifscCodeController,
          upiIdController,
          openingBalanceController,
          fetchAccounts,
          clearForm,
          accessToken,
          storeId,
          userId,
          context,
        ),
        const SizedBox(height: 24),
        _buildAccountsList(accounts, editAccount),
      ],
    );
  }

  Widget _buildAccountsList(
    ValueNotifier<List<Map<String, String>>> accounts,
    Function(Map<String, String>) editAccount,
  ) {
    return _buildCard(
      title: 'Your Accounts',
      icon: Icons.account_balance,
      child: accounts.value.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts.value.length,
              separatorBuilder: (context, i) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final acc = accounts.value[i];
                return _buildAccountCard(acc, editAccount);
              },
            ),
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    Map<String, String> account,
    Function(Map<String, String>) editAccount,
  ) {
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
                      onPressed: () => editAccount(account),
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
                  _buildDetailRow('Balance', '₹${account['balance'] ?? '0'}',
                      valueColor: accentColor),
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
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
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

  Widget _buildAccountForm(
    ValueNotifier<Map<String, String>?> selectedAccount,
    ValueNotifier<bool> isEditing,
    TextEditingController accountNameController,
    TextEditingController bankNameController,
    TextEditingController accountNumberController,
    TextEditingController ifscCodeController,
    TextEditingController upiIdController,
    TextEditingController openingBalanceController,
    Function() fetchAccounts,
    Function() clearForm,
    String? accessToken,
    String storeId,
    int? userId,
    BuildContext context,
  ) {
    return _buildCard(
      title: isEditing.value ? 'Edit Account' : 'Add New Account',
      icon: isEditing.value ? Icons.edit : Icons.add,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: accountNameController,
                  label: 'Account Name *',
                  hint: 'Enter account holder name',
                  icon: Icons.person,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: bankNameController,
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
                  controller: accountNumberController,
                  label: 'Account Number *',
                  hint: 'Enter account number',
                  icon: Icons.numbers,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: ifscCodeController,
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
                  controller: upiIdController,
                  label: 'UPI ID',
                  hint: 'Enter UPI ID (optional)',
                  icon: Icons.qr_code,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: openingBalanceController,
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
              if (isEditing.value)
                TextButton(
                  onPressed: clearForm,
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
                  // Validation
                  if (accountNameController.text.isEmpty ||
                      bankNameController.text.isEmpty ||
                      accountNumberController.text.isEmpty ||
                      ifscCodeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final response = await AccountController().createAccount(
                    accessToken!,
                    storeId,
                    accountNameController.text,
                    bankNameController.text,
                    ifscCodeController.text,
                    upiIdController.text,
                    openingBalanceController.text,
                    accountNumberController.text,
                    userId.toString(),
                    context,
                  );

                  if (response) {
                    clearForm();
                    fetchAccounts();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing.value
                            ? 'Account updated successfully!'
                            : 'Account added successfully!'),
                        backgroundColor: accentColor,
                      ),
                    );
                  }
                },
                icon: Icon(isEditing.value ? Icons.save : Icons.add, size: 16),
                label: Text(isEditing.value ? 'Update Account' : 'Add Account'),
              ),
              const SizedBox(width: 12),
              if (upiIdController.text.isNotEmpty)
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}

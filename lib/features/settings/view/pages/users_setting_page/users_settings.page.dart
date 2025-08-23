import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/settings/view/pages/users_setting_page/utils/users_permisson_dialog.dart';
import 'package:green_biller/utils/custom_appbar.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final List<User> users = [];

  String searchQuery = '';
  int? selectedUserId;
  String selectedFilter = 'All';
  bool showAddUserForm = false;

  final _nameController = TextEditingController();
  final _employeeCodeController = TextEditingController();
  String _selectedRole = 'Manager';
  String _selectedStore = 'Main Store';
  bool _isActive = true;

  final List<String> _roles = [];

  final List<String> _stores = [];

  final List<String> _filters = ['All', 'Active', 'Inactive'];

  @override
  void dispose() {
    _nameController.dispose();
    _employeeCodeController.dispose();
    super.dispose();
  }

  List<User> get filteredUsers {
    return users.where((user) {
      final query = searchQuery.toLowerCase();
      final matchesSearch =
          (user.name?.toLowerCase().contains(query) ?? false) ||
              (user.userLevel?.toLowerCase().contains(query) ?? false) ||
              (user.employeeCode?.toString().toLowerCase().contains(query) ??
                  false) ||
              (user.storeId?.toLowerCase().contains(query) ?? false);

      final matchesFilter = selectedFilter == 'All' ||
          (selectedFilter == 'Active' && user.status == true) ||
          (selectedFilter == 'Inactive' && user.status == false);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get activeUsersCount => users.where((u) => u.status == true).length;
  int get inactiveUsersCount => users.where((u) => u.status == false).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'User Management',
        subtitle: "Manage user accounts, roles and permissions",
        gradientColor: accentColor,
        actions: [
          ElevatedButton.icon(
            onPressed: () => setState(() => showAddUserForm = !showAddUserForm),
            icon: Icon(showAddUserForm ? Icons.close : Icons.person_add,
                size: 16, color: Colors.white),
            label: Text(showAddUserForm ? 'Cancel' : 'Add User'),
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
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: User List and Filters
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildStatsCard(),
              _buildFiltersAndSearch(),
              _buildUsersList(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right: Add User Form (when visible)
        if (showAddUserForm)
          Expanded(
            flex: 1,
            child: _buildAddUserForm(),
          ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildStatsCard(),
        _buildFiltersAndSearch(),
        if (showAddUserForm) ...[
          _buildAddUserForm(),
          const SizedBox(height: 24),
        ],
        _buildUsersList(),
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

  Widget _buildStatsCard() {
    return _buildCard(
      title: 'User Statistics',
      icon: Icons.analytics,
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total Users',
              users.length.toString(),
              Icons.group,
              accentColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatItem(
              'Active',
              activeUsersCount.toString(),
              Icons.check_circle,
              Colors.green.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatItem(
              'Inactive',
              inactiveUsersCount.toString(),
              Icons.pause_circle,
              Colors.orange.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return _buildCard(
      title: 'Search & Filters',
      icon: Icons.search,
      child: Column(
        children: [
          // Search Bar
          TextFormField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search by name, role, store, or employee code...',
              prefixIcon:
                  const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => setState(() => searchQuery = ''),
                    )
                  : null,
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
          const SizedBox(height: 16),
          // Status Filters
          Row(
            children: [
              const Text(
                'Filter by Status:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(width: 12),
              ..._filters.map((filter) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: selectedFilter == filter,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => selectedFilter = filter);
                        }
                      },
                      selectedColor: accentColor.withOpacity(0.2),
                      checkmarkColor: accentColor,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    final users = filteredUsers;

    return _buildCard(
      title: 'Users (${users.length})',
      icon: Icons.group,
      child: users.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => _buildUserCard(users[index]),
            ),
    );
  }

  Widget _buildUserCard(User user) {
    final bool isSelected = selectedUserId == user.id;

    return GestureDetector(
      onTap: () => setState(() {
        selectedUserId = isSelected ? null : user.id;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(0.05)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (user.name ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name ?? 'Unknown User',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        _buildStatusBadge(
                            user.status == 'active' ? true : false),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildUserDetail(
                        'Role', user.userLevel ?? 'N/A', Icons.badge),
                    const SizedBox(height: 4),
                    _buildUserDetail(
                        'Store', user.storeId ?? 'N/A', Icons.store),
                    const SizedBox(height: 4),
                    _buildUserDetail(
                        'Code', user.employeeCode ?? 'N/A', Icons.qr_code),
                  ],
                ),
              ),
              // Actions
              Column(
                children: [
                  IconButton(
                    onPressed: () => _openEditDialog(user),
                    icon: const Icon(Icons.edit, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () => _confirmDelete(user),
                    icon: const Icon(Icons.delete, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.pause_circle,
            size: 12,
            color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddUserForm() {
    return _buildCard(
      title: 'Add New User',
      icon: Icons.person_add,
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter user full name',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _employeeCodeController,
            label: 'Employee Code',
            hint: 'Enter employee code',
            icon: Icons.qr_code,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            value: _selectedRole,
            label: 'Role',
            hint: 'Select user role',
            items: _roles,
            onChanged: (value) => setState(() => _selectedRole = value!),
            icon: Icons.badge,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            value: _selectedStore,
            label: 'Store',
            hint: 'Select store',
            items: _stores,
            onChanged: (value) => setState(() => _selectedStore = value!),
            icon: Icons.store,
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Account Status',
            subtitle: _isActive
                ? 'User account will be active'
                : 'User account will be inactive',
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _clearForm,
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addUser,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
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

  Widget _buildDropdown({
    required String value,
    required String label,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
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
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      child: const Column(
        children: [
          Icon(
            Icons.group_off,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 16),
          Text(
            'No Users Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
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

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _employeeCodeController.clear();
      _selectedRole = 'Manager';
      _selectedStore = 'Main Store';
      _isActive = true;
    });
  }

  void _addUser() {
    if (_nameController.text.isEmpty || _employeeCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newUser = User(
      id: users.length + 1,
      name: _nameController.text,
      userLevel: _selectedRole,
      storeId: _selectedStore,
      employeeCode: _employeeCodeController.text,
      status: _isActive ? 'active' : '',
    );

    setState(() {
      users.add(newUser);
      showAddUserForm = false;
    });

    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newUser.name} added successfully'),
        backgroundColor: accentColor,
      ),
    );
  }

  void _openEditDialog(User user) async {
    final updatedUser = await showDialog<User>(
      context: context,
      builder: (_) => UserPermissionDialog(user: user),
    );

    if (updatedUser != null) {
      setState(() {
        final index = users.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) users[index] = updatedUser;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedUser.name} updated successfully'),
          backgroundColor: accentColor,
        ),
      );
    }
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Delete',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this user?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? 'Unknown User',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Role: ${user.userLevel ?? 'N/A'}'),
                  Text('Store: ${user.storeId ?? 'N/A'}'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                users.removeWhere((u) => u.id == user.id);
                if (selectedUserId == user.id) {
                  selectedUserId = null;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.name} deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

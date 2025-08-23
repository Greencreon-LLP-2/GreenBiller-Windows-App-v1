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

class _UserSettingsPageState extends State<UserSettingsPage>
    with TickerProviderStateMixin {
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

  late AnimationController _formAnimationController;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _formAnimation = CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeInOut,
    );
    if (showAddUserForm) {
      _formAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeCodeController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UserSettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (showAddUserForm) {
      _formAnimationController.forward();
    } else {
      _formAnimationController.reverse();
    }
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Manage user accounts, roles and permissions',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildActionButton(
                  showAddUserForm ? 'Cancel' : 'Add User',
                  showAddUserForm ? Icons.close : Icons.person_add,
                  () => setState(() {
                    showAddUserForm = !showAddUserForm;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildStatsCard(),
              const SizedBox(height: 16),
              _buildFiltersAndSearch(),
              const SizedBox(height: 16),
              _buildUsersList(),
            ],
          ),
        ),
        if (showAddUserForm) ...[
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: _buildAddUserForm(),
          ),
        ],
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildStatsCard(),
        const SizedBox(height: 16),
        _buildFiltersAndSearch(),
        const SizedBox(height: 16),
        SizeTransition(
          sizeFactor: _formAnimation,
          child: Column(
            children: [
              if (showAddUserForm) ...[
                _buildAddUserForm(),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
              const Color(0xFF3B82F6),
              '+${users.isNotEmpty ? (users.length / (users.length + 1) * 100).toStringAsFixed(0) : '0'}%',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatItem(
              'Active',
              activeUsersCount.toString(),
              Icons.check_circle,
              const Color(0xFF10B981),
              '+${activeUsersCount > 0 ? '5' : '0'}%',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatItem(
              'Inactive',
              inactiveUsersCount.toString(),
              Icons.pause_circle,
              const Color(0xFFEF4444),
              '-${inactiveUsersCount > 0 ? '2' : '0'}%',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color, String trend) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
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
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by name, role, store, or employee code...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                        onPressed: () => setState(() => searchQuery = ''),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                'Filter by Status:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 12),
              ..._filters.map((filter) => Padding(
                    padding: const EdgeInsets.only(right: 12),
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
                      labelStyle: TextStyle(
                        color: selectedFilter == filter
                            ? accentColor
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selectedFilter == filter
                              ? accentColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
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
              itemBuilder: (_, index) => _buildUserCard(users[index], index),
            ),
    );
  }

  Widget _buildUserCard(User user, int index) {
    final bool isSelected = selectedUserId == user.id;
    final bool isEven = index % 2 == 0;

    return GestureDetector(
      onTap: () => setState(() {
        selectedUserId = isSelected ? null : user.id;
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEven ? const Color(0xFFFAFAFA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  (user.name ?? 'U').substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
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
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      _buildStatusBadge(user.status ?? false),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildUserDetail(
                      'Role', user.userLevel ?? 'N/A', Icons.badge),
                  const SizedBox(height: 4),
                  _buildUserDetail('Store', user.storeId ?? 'N/A', Icons.store),
                  const SizedBox(height: 4),
                  _buildUserDetail(
                      'Code', user.employeeCode ?? 'N/A', Icons.qr_code),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => _openEditDialog(user),
                  icon: const Icon(Icons.edit, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6).withOpacity(0.1),
                    foregroundColor: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: () => _confirmDelete(user),
                  icon: const Icon(Icons.delete, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
                    foregroundColor: const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF10B981).withOpacity(0.1)
            : const Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFEF4444).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color:
                  isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
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
                child: TextButton(
                  onPressed: _clearForm,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _addUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add User',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          labelText: '$label *',
          prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
        ),
      ),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: '$label *',
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: Color(0xFF64748B)),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: accentColor,
            inactiveTrackColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.group_off,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Users Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filter criteria',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
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
      _showErrorSnackBar('Please fill in all required fields');
      return;
    }

    final newUser = User(
      id: users.length + 1,
      name: _nameController.text,
      userLevel: _selectedRole,
      storeId: _selectedStore,
      employeeCode: _employeeCodeController.text,
      status: _isActive,
    );

    setState(() {
      users.add(newUser);
      showAddUserForm = false;
    });

    _clearForm();
    _showSuccessSnackBar('${newUser.name} added successfully');
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
      _showSuccessSnackBar('${updatedUser.name} updated successfully');
    }
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Color(0xFFEF4444),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirm Delete',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEF4444).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Role: ${user.userLevel ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Store: ${user.storeId ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEF4444),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          users.removeWhere((u) => u.id == user.id);
                          if (selectedUserId == user.id) {
                            selectedUserId = null;
                          }
                        });
                        Navigator.pop(context);
                        _showErrorSnackBar('${user.name} deleted successfully');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}

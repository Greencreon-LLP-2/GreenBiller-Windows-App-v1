import 'package:flutter/material.dart';

class ComplexDropdownDemo extends StatefulWidget {
  const ComplexDropdownDemo({super.key});

  @override
  State<ComplexDropdownDemo> createState() => _ComplexDropdownDemoState();
}

class _ComplexDropdownDemoState extends State<ComplexDropdownDemo> {
  // Dummy grouped data
  final Map<String, List<Map<String, dynamic>>> _groupedUsers = {
    'Online': [
      {
        'id': '1',
        'name': 'Alice Johnson',
        'email': 'alice@example.com',
        'avatar': Icons.person,
        'role': 'Admin',
      },
      {
        'id': '4',
        'name': 'Diana Prince',
        'email': 'diana@example.com',
        'avatar': Icons.person_3,
        'role': 'Manager',
      },
    ],
    'Offline': [
      {
        'id': '2',
        'name': 'Bob Smith',
        'email': 'bob@example.com',
        'avatar': Icons.person_outline,
        'role': 'User',
      },
    ],
    'Busy': [
      {
        'id': '3',
        'name': 'Charlie Rose',
        'email': 'charlie@example.com',
        'avatar': Icons.person_2,
        'role': 'Support',
      },
    ],
  };

  List<String> _selectedUserIds = [];
  final String _searchQuery = '';

  void _showComplexDropdown(BuildContext context) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => _ComplexDropdownDialog(
        groupedUsers: _groupedUsers,
        initiallySelected: _selectedUserIds,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedUserIds = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedNames = _groupedUsers.values
        .expand((list) => list)
        .where((user) => _selectedUserIds.contains(user['id']))
        .map((user) => user['name'])
        .join(', ');

    return Scaffold(
      appBar: AppBar(title: const Text('Ultra-Complex Dropdown')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GestureDetector(
            onTap: () => _showComplexDropdown(context),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Select Users',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade700,
                ),
                filled: true,
                fillColor: Colors.blueGrey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide:
                      BorderSide(color: Colors.blue.shade100, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide:
                      BorderSide(color: Colors.blue.shade100, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                prefixIcon: Icon(Icons.people, color: Colors.blue.shade400),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedNames.isEmpty
                          ? 'Tap to select users'
                          : selectedNames,
                      style: TextStyle(
                        fontSize: 15,
                        color: selectedNames.isEmpty
                            ? Colors.blueGrey.shade400
                            : Colors.blueGrey.shade800,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 28, color: Colors.blue.shade400),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ComplexDropdownDialog extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> groupedUsers;
  final List<String> initiallySelected;

  const _ComplexDropdownDialog({
    required this.groupedUsers,
    required this.initiallySelected,
  });

  @override
  State<_ComplexDropdownDialog> createState() => _ComplexDropdownDialogState();
}

class _ComplexDropdownDialogState extends State<_ComplexDropdownDialog> {
  late List<String> _selectedUserIds;
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedUserIds = List<String>.from(widget.initiallySelected);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter and flatten grouped users with section headers
    final List<_DropdownSection> sections = [];
    widget.groupedUsers.forEach((status, users) {
      final filtered = users.where((user) {
        final query = _searchQuery.toLowerCase();
        return user['name'].toLowerCase().contains(query) ||
            user['email'].toLowerCase().contains(query) ||
            user['role'].toLowerCase().contains(query);
      }).toList();
      if (filtered.isNotEmpty) {
        sections.add(_DropdownSection(header: status, users: filtered));
      }
    });

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        constraints: const BoxConstraints(maxHeight: 480, minWidth: 350),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (q) => setState(() => _searchQuery = q),
              ),
            ),
            Expanded(
              child: sections.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No results found.',
                          style: TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      thickness: 6,
                      radius: const Radius.circular(8),
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        itemCount: sections.fold<int>(
                            0, (sum, s) => sum + s.users.length + 1),
                        separatorBuilder: (_, __) => const SizedBox(height: 2),
                        itemBuilder: (context, idx) {
                          int running = 0;
                          for (final section in sections) {
                            if (idx == running) {
                              // Section header
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 4, left: 8),
                                child: Text(
                                  section.header,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blueGrey.shade600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              );
                            }
                            running++;
                            if (idx < running + section.users.length) {
                              final user = section.users[idx - running];
                              final selected =
                                  _selectedUserIds.contains(user['id']);
                              return Card(
                                color: selected ? Colors.blue.shade50 : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: selected ? 2 : 0,
                                child: ListTile(
                                  leading: Tooltip(
                                    message: user['role'],
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(user['avatar'],
                                          color: Colors.blue.shade700),
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        user['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selected
                                              ? Colors.blue.shade700
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (user['role'] == 'Admin')
                                        Tooltip(
                                          message: 'Admin',
                                          child: Chip(
                                            label: const Text('Admin',
                                                style: TextStyle(fontSize: 10)),
                                            backgroundColor:
                                                Colors.blue.shade100,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    user['email'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                        value: selected,
                                        onChanged: (v) {
                                          setState(() {
                                            if (v == true) {
                                              _selectedUserIds.add(user['id']);
                                            } else {
                                              _selectedUserIds
                                                  .remove(user['id']);
                                            }
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.info_outline,
                                            size: 20, color: Colors.blueGrey),
                                        tooltip: 'Show info',
                                        onPressed: () => _showUserInfo(user),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        _selectedUserIds.remove(user['id']);
                                      } else {
                                        _selectedUserIds.add(user['id']);
                                      }
                                    });
                                  },
                                  onLongPress: () => _showUserActions(user),
                                ),
                              );
                            }
                            running += section.users.length;
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => setState(() => _selectedUserIds.clear()),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.check),
                    label: Text('Select (${_selectedUserIds.length})'),
                    onPressed: () =>
                        Navigator.of(context).pop(_selectedUserIds),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserInfo(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['name']),
        content: Text('Email: ${user['email']}\nRole: ${user['role']}'),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _showUserActions(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Wrap(
          runSpacing: 12,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Send Email'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Pretend to send email to ${user['email']}')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.of(context).pop();
                _showUserInfo(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownSection {
  final String header;
  final List<Map<String, dynamic>> users;
  _DropdownSection({required this.header, required this.users});
}

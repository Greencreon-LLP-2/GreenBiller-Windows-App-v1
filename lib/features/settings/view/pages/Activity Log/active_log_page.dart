import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/utils/custom_appbar.dart';
import 'package:intl/intl.dart';

class ActiveLogPage extends StatefulWidget {
  const ActiveLogPage({super.key});

  @override
  State<ActiveLogPage> createState() => _ActiveLogPageState();
}

class _ActiveLogPageState extends State<ActiveLogPage> {
  final List<Map<String, dynamic>> activityLogs = [
    {
      "user": "Adithya S",
      "action": "Created a new bill",
      "time": "2025-07-24 10:15 AM",
      "type": "create",
      "details": "Bill #INV-2024-001 created for customer ABC Corp",
    },
    {
      "user": "Rahul D",
      "action": "Edited tax settings",
      "time": "2025-07-23 5:40 PM",
      "type": "edit",
      "details": "Updated GST rate from 18% to 28%",
    },
    {
      "user": "Priya M",
      "action": "Deleted user 'Mike'",
      "time": "2025-07-22 4:10 PM",
      "type": "delete",
      "details": "User account permanently removed from system",
    },
    {
      "user": "John K",
      "action": "Generated monthly report",
      "time": "2025-07-22 2:30 PM",
      "type": "report",
      "details": "Sales report for July 2025 generated",
    },
    {
      "user": "Sarah L",
      "action": "Updated customer information",
      "time": "2025-07-21 11:45 AM",
      "type": "edit",
      "details": "Modified contact details for XYZ Ltd",
    },
  ];

  List<Map<String, dynamic>> filteredLogs = [];
  DateTime? selectedDate;
  String selectedFilter = "All";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredLogs = List.from(activityLogs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLogs() {
    setState(() {
      filteredLogs = activityLogs.where((log) {
        final logDate = DateFormat("yyyy-MM-dd hh:mm a").parse(log["time"]!);

        // Filter by search query
        if (searchQuery.isNotEmpty) {
          final searchLower = searchQuery.toLowerCase();
          if (!log["user"]!.toLowerCase().contains(searchLower) &&
              !log["action"]!.toLowerCase().contains(searchLower) &&
              !log["details"]!.toLowerCase().contains(searchLower)) {
            return false;
          }
        }

        if (selectedDate != null) {
          if (logDate.year != selectedDate!.year ||
              logDate.month != selectedDate!.month ||
              logDate.day != selectedDate!.day) {
            return false;
          }
        }

        if (selectedFilter == "Today") {
          final now = DateTime.now();
          return logDate.year == now.year &&
              logDate.month == now.month &&
              logDate.day == now.day;
        } else if (selectedFilter == "This Week") {
          final now = DateTime.now();
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          return logDate.isAfter(startOfWeek);
        } else if (selectedFilter == "This Month") {
          final now = DateTime.now();
          return logDate.year == now.year && logDate.month == now.month;
        }
        return true;
      }).toList();
    });
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _filterLogs();
    }
  }

  void _clearFilters() {
    setState(() {
      selectedDate = null;
      selectedFilter = "All";
      searchQuery = "";
      _searchController.clear();
      filteredLogs = List.from(activityLogs);
    });
  }

  IconData _getActionIcon(String type) {
    switch (type) {
      case "create":
        return Icons.add_circle_outline;
      case "edit":
        return Icons.edit_outlined;
      case "delete":
        return Icons.delete_outline;
      case "report":
        return Icons.assessment_outlined;
      default:
        return Icons.history;
    }
  }

  Color _getActionColor(String type) {
    switch (type) {
      case "create":
        return Colors.green;
      case "edit":
        return Colors.blue;
      case "delete":
        return Colors.red;
      case "report":
        return Colors.orange;
      default:
        return accentColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Activity Logs',
        subtitle: "Track all system activities and user actions",
        gradientColor: accentColor,
        actions: [
          IconButton(
            onPressed: _clearFilters,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Clear Filters',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: filteredLogs.isEmpty ? _buildEmptyState() : _buildLogsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        searchQuery = value;
                        _filterLogs();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search logs...',
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter Controls
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: selectedFilter,
                    label: 'Time Filter',
                    items: ["All", "Today", "This Week", "This Month"],
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value!;
                      });
                      _filterLogs();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                  child: InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate == null
                                ? "Select Date"
                                : DateFormat("dd MMM yyyy")
                                    .format(selectedDate!),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (selectedDate != null ||
                searchQuery.isNotEmpty ||
                selectedFilter != "All")
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Text(
                      'Showing ${filteredLogs.length} of ${activityLogs.length} logs',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear Filters'),
                      style: TextButton.styleFrom(
                        foregroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLogsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final log = filteredLogs[index];
        return _buildLogCard(log, index);
      },
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log, int index) {
    final actionColor = _getActionColor(log["type"]);
    final actionIcon = _getActionIcon(log["type"]);
    final logDate = DateFormat("yyyy-MM-dd hh:mm a").parse(log["time"]!);
    final formattedDate = DateFormat("MMM dd, yyyy").format(logDate);
    final formattedTime = DateFormat("hh:mm a").format(logDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: actionColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                actionIcon,
                color: actionColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log["action"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: actionColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          log["type"]!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: actionColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    log["details"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        log["user"]!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$formattedDate at $formattedTime',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              Icons.history,
              size: 32,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Activity Logs Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'There are no activity logs matching your current filters.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

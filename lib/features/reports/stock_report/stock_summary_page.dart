import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StockSummaryPage extends StatefulWidget {
  const StockSummaryPage({super.key});

  @override
  State<StockSummaryPage> createState() => _StockSummaryPageState();
}

class _StockSummaryPageState extends State<StockSummaryPage> {
  // Sample stores data - replace with actual data from your backend
  final List<Map<String, dynamic>> _stores = [
    {
      'id': '1',
      'name': 'Main Store',
      'address': 'Avittom, Mukhathala, Kollam',
      'phone': '9020583270',
    },
    {
      'id': '2',
      'name': 'Branch Store 1',
      'address': 'Kollam City Center',
      'phone': '9020583271',
    },
    {
      'id': '3',
      'name': 'Branch Store 2',
      'address': 'Karunagappally',
      'phone': '9020583272',
    },
  ];

  // Sample stock data per store - replace with actual data from your backend
  final Map<String, List<Map<String, dynamic>>> _storeStocks = {
    '1': [
      {
        'name': 'Tenda Router',
        'quantity': 10,
        'price': 1650.0,
        'category': 'Networking',
        'lastUpdated': '2024-03-15',
        'minStock': 5,
      },
      {
        'name': 'HDMI Extender',
        'quantity': 5,
        'price': 1000.0,
        'category': 'Cables',
        'lastUpdated': '2024-03-14',
        'minStock': 3,
      },
    ],
    '2': [
      {
        'name': 'Wireless Mouse',
        'quantity': 15,
        'price': 800.0,
        'category': 'Accessories',
        'lastUpdated': '2024-03-13',
        'minStock': 8,
      },
      {
        'name': 'Tenda Router',
        'quantity': 8,
        'price': 1650.0,
        'category': 'Networking',
        'lastUpdated': '2024-03-12',
        'minStock': 5,
      },
    ],
    '3': [
      {
        'name': 'HDMI Extender',
        'quantity': 3,
        'price': 1000.0,
        'category': 'Cables',
        'lastUpdated': '2024-03-11',
        'minStock': 3,
      },
    ],
  };

  String? _selectedStoreId;
  final bool _isAdmin = true; // Replace with actual admin check
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (_stores.isNotEmpty) {
      _selectedStoreId = _stores[0]['id'].toString();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _currentStoreStocks {
    final stocks = _storeStocks[_selectedStoreId] ?? [];
    if (_searchQuery.isEmpty) return stocks;

    return stocks.where((item) {
      final name = item['name'].toString().toLowerCase();
      final category = item['category'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || category.contains(query);
    }).toList();
  }

  int get _lowStockCount {
    return _currentStoreStocks
        .where((item) => item['quantity'] <= item['minStock'])
        .length;
  }

  void _showAddEditDialog([Map<String, dynamic>? item]) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?['name']);
    final quantityController =
        TextEditingController(text: item?['quantity']?.toString());
    final priceController =
        TextEditingController(text: item?['price']?.toString());
    final minStockController =
        TextEditingController(text: item?['minStock']?.toString());
    String selectedCategory = item?['category'] ?? 'Networking';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Item' : 'Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Networking', 'Cables', 'Accessories', 'Other']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: minStockController,
                decoration: const InputDecoration(labelText: 'Minimum Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement save functionality
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog(Map<String, dynamic> item) {
    String? selectedStoreId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Transfer ${item['name']} to:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedStoreId,
              decoration: const InputDecoration(labelText: 'Select Store'),
              items: _stores
                  .where((store) => store['id'].toString() != _selectedStoreId)
                  .map((store) => DropdownMenuItem<String>(
                        value: store['id'].toString(),
                        child: Text(store['name']),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedStoreId = value;
              },
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Transfer Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement transfer functionality
              Navigator.pop(context);
            },
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/reports');
          },
        ),
        title: const Text('Stock Summary'),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.store),
              onPressed: () {
                // TODO: Navigate to store management
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filtering
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search Items'),
                  content: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by name or category',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Clear'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Store Selector
          if (_isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Store',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedStoreId,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: _stores.map((store) {
                          return DropdownMenuItem<String>(
                            value: store['id'].toString(),
                            child: Text(store['name']),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedStoreId = value;
                          });
                        },
                      ),
                      if (_selectedStoreId != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Address: ${_stores.firstWhere((s) => s['id'].toString() == _selectedStoreId)['address']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Phone: ${_stores.firstWhere((s) => s['id'].toString() == _selectedStoreId)['phone']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildSummaryCard(
                  'Total Items',
                  _currentStoreStocks.length.toString(),
                  Icons.inventory_2,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'Low Stock',
                  _lowStockCount.toString(),
                  Icons.warning,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildSummaryCard(
                  'Total Value',
                  '₹${_calculateTotalValue()}',
                  Icons.attach_money,
                  Colors.green,
                ),
              ],
            ),
          ),
          // Data Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Min Stock')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Total Value')),
                    DataColumn(label: Text('Last Updated')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _currentStoreStocks.map((item) {
                    final isLowStock = item['quantity'] <= item['minStock'];
                    return DataRow(
                      color: isLowStock
                          ? MaterialStateProperty.all(
                              Colors.red.withOpacity(0.1))
                          : null,
                      cells: [
                        DataCell(Text(item['name'])),
                        DataCell(Text(item['category'])),
                        DataCell(
                          Text(
                            item['quantity'].toString(),
                            style: TextStyle(
                              color: isLowStock ? Colors.red : null,
                              fontWeight: isLowStock ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                        DataCell(Text(item['minStock'].toString())),
                        DataCell(Text('₹${item['price'].toStringAsFixed(2)}')),
                        DataCell(Text(
                            '₹${(item['quantity'] * item['price']).toStringAsFixed(2)}')),
                        DataCell(Text(item['lastUpdated'])),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showAddEditDialog(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Item'),
                                      content: Text(
                                          'Are you sure you want to delete ${item['name']}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // TODO: Implement delete functionality
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              if (_isAdmin)
                                IconButton(
                                  icon: const Icon(Icons.swap_horiz, size: 20),
                                  onPressed: () => _showTransferDialog(item),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'stock_summary_floating_btn_tag1',
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
        ),
      ),
    );
  }

  String _calculateTotalValue() {
    double total = 0;
    for (var item in _currentStoreStocks) {
      total += item['quantity'] * item['price'];
    }
    return total.toStringAsFixed(2);
  }
}

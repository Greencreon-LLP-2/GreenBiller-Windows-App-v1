import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LowStockAlertPage extends StatefulWidget {
  const LowStockAlertPage({super.key});

  @override
  State<LowStockAlertPage> createState() => _LowStockAlertPageState();
}

class _LowStockAlertPageState extends State<LowStockAlertPage> {
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
        'quantity': 3,
        'price': 1650.0,
        'category': 'Networking',
        'lastUpdated': '2024-03-15',
        'minStock': 5,
      },
      {
        'name': 'HDMI Extender',
        'quantity': 2,
        'price': 1000.0,
        'category': 'Cables',
        'lastUpdated': '2024-03-14',
        'minStock': 3,
      },
    ],
    '2': [
      {
        'name': 'Wireless Mouse',
        'quantity': 5,
        'price': 800.0,
        'category': 'Accessories',
        'lastUpdated': '2024-03-13',
        'minStock': 8,
      },
      {
        'name': 'Tenda Router',
        'quantity': 4,
        'price': 1650.0,
        'category': 'Networking',
        'lastUpdated': '2024-03-12',
        'minStock': 5,
      },
    ],
    '3': [
      {
        'name': 'HDMI Extender',
        'quantity': 1,
        'price': 1000.0,
        'category': 'Cables',
        'lastUpdated': '2024-03-11',
        'minStock': 3,
      },
    ],
  };

  String? _selectedStoreId;
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Networking',
    'Cables',
    'Accessories',
    'Other'
  ];
  final bool _isAdmin = true; // Replace with actual admin check

  @override
  void initState() {
    super.initState();
    if (_stores.isNotEmpty) {
      _selectedStoreId = _stores[0]['id'].toString();
    }
  }

  List<Map<String, dynamic>> get _lowStockItems {
    final List<Map<String, dynamic>> allLowStockItems = [];

    // If a store is selected, only show items from that store
    final storesToCheck = _selectedStoreId != null
        ? {_selectedStoreId!: _storeStocks[_selectedStoreId] ?? []}
        : _storeStocks;

    storesToCheck.forEach((storeId, items) {
      final store = _stores.firstWhere((s) => s['id'].toString() == storeId);

      for (var item in items) {
        if (item['quantity'] <= item['minStock']) {
          if (_selectedCategory == 'All' ||
              item['category'] == _selectedCategory) {
            allLowStockItems.add({
              ...item,
              'storeName': store['name'],
              'storeId': storeId,
            });
          }
        }
      }
    });

    // Sort by quantity (lowest first)
    allLowStockItems.sort((a, b) => a['quantity'].compareTo(b['quantity']));
    return allLowStockItems;
  }

  void _showRestockDialog(Map<String, dynamic> item) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restock Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Restock ${item['name']} at ${item['storeName']}'),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity to Add',
                hintText: 'Enter quantity to restock',
              ),
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
              // TODO: Implement restock functionality
              Navigator.pop(context);
            },
            child: const Text('Restock'),
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
        title: const Text('Low Stock Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Filter by Category'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _categories.map((category) {
                      return RadioListTile<String>(
                        title: Text(category),
                        value: category,
                        groupValue: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
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
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Stores'),
                          ),
                          ..._stores.map((store) {
                            return DropdownMenuItem<String>(
                              value: store['id'].toString(),
                              child: Text(store['name']),
                            );
                          }),
                        ],
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
          // Summary Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade700, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_lowStockItems.length} Items Need Attention',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedStoreId != null
                                ? 'Items below minimum stock level at ${_stores.firstWhere((s) => s['id'].toString() == _selectedStoreId)['name']}'
                                : 'Items below minimum stock level across all stores',
                            style: TextStyle(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Items List
          Expanded(
            child: ListView.builder(
              itemCount: _lowStockItems.length,
              itemBuilder: (context, index) {
                final item = _lowStockItems[index];
                final stockPercentage =
                    (item['quantity'] / item['minStock']) * 100;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['storeName']} • ${item['category']}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item['quantity']}/${item['minStock']}',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: stockPercentage / 100,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            stockPercentage < 30
                                ? Colors.red
                                : stockPercentage < 50
                                    ? Colors.orange
                                    : Colors.yellow,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Last Updated: ${item['lastUpdated']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showRestockDialog(item),
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Restock'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

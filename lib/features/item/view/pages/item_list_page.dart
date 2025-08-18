import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item List"),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildItemGrid(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Item Page
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search items...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildItemGrid() {
    // Sample data for demonstration
    final List<Map<String, String>> items = [
      {"name": "Item 1", "code": "001", "price": "\$10"},
      {"name": "Item 2", "code": "002", "price": "\$15"},
      {"name": "Item 3", "code": "003", "price": "\$20"},
      {"name": "Item 4", "code": "004", "price": "\$25"},
      {"name": "Item 5", "code": "005", "price": "\$30"},
      {"name": "Item 1", "code": "001", "price": "\$10"},
      {"name": "Item 2", "code": "002", "price": "\$15"},
      {"name": "Item 3", "code": "003", "price": "\$20"},
      {"name": "Item 4", "code": "004", "price": "\$25"},
      {"name": "Item 5", "code": "005", "price": "\$30"},
      {"name": "Item 1", "code": "001", "price": "\$10"},
      {"name": "Item 2", "code": "002", "price": "\$15"},
      {"name": "Item 3", "code": "003", "price": "\$20"},
      {"name": "Item 4", "code": "004", "price": "\$25"},
      {"name": "Item 5", "code": "005", "price": "\$30"},
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2, // Adjust aspect ratio for card size
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Implement item detail view
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Code: ${item["code"]}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["price"]!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

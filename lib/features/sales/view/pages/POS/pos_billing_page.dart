import 'package:flutter/material.dart';

class POSBillingPage extends StatefulWidget {
  const POSBillingPage({Key? key}) : super(key: key);

  @override
  State<POSBillingPage> createState() => _POSBillingPageState();
}

class _POSBillingPageState extends State<POSBillingPage> {
  // Controllers
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();

  // Dropdown values
  String? selectedWarehouse;
  String? selectedCustomer;
  String? selectedItemName;
  String? selectedCategory;
  String? selectedBrand;

  // State variables
  bool taxReport = false;
  double previousDue = 0.0;
  List<CartItem> cartItems = [];

  // Sample data
  final List<String> warehouses = [
    'Main Warehouse',
    'Secondary Warehouse',
    'Branch Warehouse'
  ];
  final List<String> customers = [
    'Walk-in Customer',
    'John Doe',
    'Jane Smith',
    'ABC Company'
  ];
  final List<String> itemNames = [
    'Product A',
    'Product B',
    'Product C',
    'Product D'
  ];
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Food & Beverage',
    'Home & Garden'
  ];
  final List<String> brands = ['Brand A', 'Brand B', 'Brand C', 'Brand D'];

  // Sample product images
  final List<String> productImages = [
    'https://via.placeholder.com/150x150/4CAF50/FFFFFF?text=Product+1',
    'https://via.placeholder.com/150x150/2196F3/FFFFFF?text=Product+2',
    'https://via.placeholder.com/150x150/FF9800/FFFFFF?text=Product+3',
    'https://via.placeholder.com/150x150/9C27B0/FFFFFF?text=Product+4',
    'https://via.placeholder.com/150x150/F44336/FFFFFF?text=Product+5',
    'https://via.placeholder.com/150x150/795548/FFFFFF?text=Product+6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Billing System'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.indigo.shade50],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Container - Billing
            Expanded(
              flex: 2,
              child: _buildBillingContainer(),
            ),
            const SizedBox(width: 16),
            // Right Container - Inventory
            Expanded(
              flex: 1,
              child: _buildInventoryContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billing Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Warehouse and Customer Selection
          Row(
            children: [
              Expanded(child: _buildWarehouseDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildCustomerDropdown()),
            ],
          ),
          const SizedBox(height: 16),

          // Item Selection Row
          Row(
            children: [
              Expanded(child: _buildItemNameDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildBarcodeField()),
            ],
          ),
          const SizedBox(height: 16),

          // Previous Due and Tax Report Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    'Previous Due: ₹${previousDue.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: taxReport,
                      onChanged: (value) {
                        setState(() {
                          taxReport = value ?? false;
                        });
                      },
                    ),
                    const Text('Tax Report'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Cart Table
          Expanded(child: _buildCartTable()),

          const SizedBox(height: 16),

          // Totals Row
          _buildTotalsRow(),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(child: _buildHoldButton()),
              const SizedBox(width: 12),
              Expanded(child: _buildCashButton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Category and Brand Dropdowns
          _buildCategoryDropdown(),
          const SizedBox(height: 12),
          _buildBrandDropdown(),
          const SizedBox(height: 12),

          // Item Name Search
          TextField(
            controller: itemNameController,
            decoration: InputDecoration(
              labelText: 'Search Item Name',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 20),

          // Item Images Grid
          const Text(
            'Items',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildItemImagesGrid()),
        ],
      ),
    );
  }

  Widget _buildWarehouseDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedWarehouse,
      decoration: InputDecoration(
        labelText: 'Select Warehouse',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: warehouses.map((warehouse) {
        return DropdownMenuItem(value: warehouse, child: Text(warehouse));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedWarehouse = value;
        });
      },
    );
  }

  Widget _buildCustomerDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCustomer,
      decoration: InputDecoration(
        labelText: 'Select Customer',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: customers.map((customer) {
        return DropdownMenuItem(value: customer, child: Text(customer));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCustomer = value;
        });
      },
    );
  }

  Widget _buildItemNameDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedItemName,
      decoration: InputDecoration(
        labelText: 'Item Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: itemNames.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedItemName = value;
        });
      },
    );
  }

  Widget _buildBarcodeField() {
    return TextField(
      controller: barcodeController,
      decoration: InputDecoration(
        labelText: 'Barcode/Item Code',
        prefixIcon: const Icon(Icons.qr_code_scanner),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      onSubmitted: (value) {
        _addItemToCart();
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
    );
  }

  Widget _buildBrandDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBrand,
      decoration: InputDecoration(
        labelText: 'Brand',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: brands.map((brand) {
        return DropdownMenuItem(value: brand, child: Text(brand));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedBrand = value;
        });
      },
    );
  }

  Widget _buildCartTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('Item Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Qty',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Price',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Discount',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Subtotal',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 40),
              ],
            ),
          ),
          // Table Body
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items added to cart',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(item.name)),
                            Expanded(child: Text('${item.quantity}')),
                            Expanded(
                                child:
                                    Text('₹${item.price.toStringAsFixed(2)}')),
                            Expanded(
                                child: Text(
                                    '₹${item.discount.toStringAsFixed(2)}')),
                            Expanded(
                                child: Text(
                                    '₹${item.subtotal.toStringAsFixed(2)}')),
                            IconButton(
                              onPressed: () => _removeItem(index),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsRow() {
    double totalQuantity =
        cartItems.fold(0, (sum, item) => sum + item.quantity);
    double totalAmount =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double totalDiscount =
        cartItems.fold(0, (sum, item) => sum + item.discount);
    double grandTotal = totalAmount - totalDiscount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTotalItem('Total Qty', totalQuantity.toString()),
          _buildTotalItem('Total Amount', '₹${totalAmount.toStringAsFixed(2)}'),
          _buildTotalItem(
              'Total Discount', '₹${totalDiscount.toStringAsFixed(2)}'),
          _buildTotalItem('Grand Total', '₹${grandTotal.toStringAsFixed(2)}',
              isGrandTotal: true),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value,
      {bool isGrandTotal = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isGrandTotal ? 18 : 16,
            fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.w600,
            color: isGrandTotal ? Colors.indigo : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldButton() {
    return ElevatedButton(
      onPressed: () {
        // Hold functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bill held successfully')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('HOLD',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCashButton() {
    return ElevatedButton(
      onPressed: () {
        // Cash payment functionality
        _showPaymentDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('CASH',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildItemImagesGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: productImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _addQuickItem('Product ${index + 1}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                productImages[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _addItemToCart() {
    if (selectedItemName != null || barcodeController.text.isNotEmpty) {
      String itemName = selectedItemName ?? 'Item-${barcodeController.text}';
      setState(() {
        cartItems.add(CartItem(
          name: itemName,
          quantity: 1,
          price: 100.0 + (cartItems.length * 25), // Sample price
          discount: 5.0,
        ));
      });
      barcodeController.clear();
    }
  }

  void _addQuickItem(String itemName) {
    setState(() {
      cartItems.add(CartItem(
        name: itemName,
        quantity: 1,
        price: 150.0 + (cartItems.length * 30), // Sample price
        discount: 10.0,
      ));
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void _showPaymentDialog() {
    double grandTotal = cartItems.fold(0, (sum, item) => sum + item.subtotal);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment'),
        content: Text(
            'Grand Total: ₹${grandTotal.toStringAsFixed(2)}\n\nConfirm cash payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartItems.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Payment completed successfully!')),
              );
            },
            child: const Text('Confirm Payment'),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final int quantity;
  final double price;
  final double discount;

  CartItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.discount,
  });

  double get subtotal => (price * quantity) - discount;
}

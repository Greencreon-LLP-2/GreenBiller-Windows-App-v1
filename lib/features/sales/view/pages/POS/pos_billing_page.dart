import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:intl/intl.dart';

class POSBillingPage extends StatefulWidget {
  const POSBillingPage({Key? key}) : super(key: key);

  @override
  State<POSBillingPage> createState() => _POSBillingPageState();
}

class _POSBillingPageState extends State<POSBillingPage> {
  // Controllers
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();

  String? selectedWarehouse;
  String? selectedCustomer;
  String? selectedItemName;
  String? selectedCategory;
  String? selectedBrand;
  String selectedPaymentMethod = 'Cash';

  bool taxReport = false;
  double previousDue = 0.0;
  List<CartItem> cartItems = [];
  List<String> filteredItemNames = [];

  final currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

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
  final List<String> paymentMethods = ['Cash', 'Card', 'UPI', 'Credit'];

  final List<Map<String, dynamic>> productData = [
    {
      'name': 'Product 1',
      'image':
          'https://via.placeholder.com/150x150/4CAF50/FFFFFF?text=Product+1',
      'price': 150.0,
      'stock': 25,
    },
    {
      'name': 'Product 2',
      'image':
          'https://via.placeholder.com/150x150/2196F3/FFFFFF?text=Product+2',
      'price': 180.0,
      'stock': 15,
    },
    {
      'name': 'Product 3',
      'image':
          'https://via.placeholder.com/150x150/FF9800/FFFFFF?text=Product+3',
      'price': 200.0,
      'stock': 10,
    },
    {
      'name': 'Product 4',
      'image':
          'https://via.placeholder.com/150x150/9C27B0/FFFFFF?text=Product+4',
      'price': 220.0,
      'stock': 8,
    },
    {
      'name': 'Product 5',
      'image':
          'https://via.placeholder.com/150x150/F44336/FFFFFF?text=Product+5',
      'price': 170.0,
      'stock': 20,
    },
    {
      'name': 'Product 6',
      'image':
          'https://via.placeholder.com/150x150/795548/FFFFFF?text=Product+6',
      'price': 190.0,
      'stock': 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredItemNames = itemNames;
    itemNameController.addListener(_filterItems);
  }

  @override
  void dispose() {
    barcodeController.dispose();
    itemNameController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = itemNameController.text.toLowerCase();
    setState(() {
      filteredItemNames = itemNames
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  void _showSuccessSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 100),
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

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
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

  Widget _buildModernSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 15),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

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
                color: accentColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POS Billing System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    _buildActionButton(
                      'Clear Cart',
                      Icons.delete_sweep,
                      accentColor,
                      () {
                        setState(() {
                          cartItems.clear();
                          productData.forEach((product) {
                            product['stock'] = product['stock'] +
                                cartItems.fold<int>(
                                    0,
                                    (sum, item) => item.name == product['name']
                                        ? sum + item.quantity
                                        : sum);
                          });
                        });
                        _showSuccessSnackBar(
                            'Cart cleared successfully!', Icons.delete);
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      'Generate Receipt',
                      Icons.receipt_long,
                      secondaryColor,
                      _generateReceipt,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Fixed Summary Cards
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildModernSummaryCard(
                    'Total Items',
                    cartItems.length.toString(),
                    const Color(0xFF3B82F6),
                    Icons.shopping_cart_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernSummaryCard(
                    'Total Amount',
                    currencyFormatter.format(cartItems.fold(0.0,
                        (sum, item) => sum + (item.price * item.quantity))),
                    const Color(0xFF8B5CF6),
                    Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernSummaryCard(
                    'Total Discount',
                    currencyFormatter.format(cartItems.fold(
                        0.0, (sum, item) => sum + item.discount)),
                    const Color(0xFFEF4444),
                    Icons.discount_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernSummaryCard(
                    'Grand Total',
                    currencyFormatter.format(cartItems.fold(
                        0.0, (sum, item) => sum + item.subtotal)),
                    accentColor,
                    Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.maxWidth > 900
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 3, child: _buildBillingContainer()),
                              const SizedBox(width: 16),
                              Expanded(
                                  flex: 2, child: _buildInventoryContainer()),
                            ],
                          )
                        : Column(
                            children: [
                              _buildBillingContainer(),
                              const SizedBox(height: 16),
                              _buildInventoryContainer(),
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingContainer() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Billing Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF475569),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${cartItems.length} items',
                  style: const TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildWarehouseDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildCustomerDropdown()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildItemNameDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildBarcodeField()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Previous Due: ${currencyFormatter.format(previousDue)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
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
                        _showSuccessSnackBar(
                            'Tax report ${value! ? 'enabled' : 'disabled'}',
                            Icons.taxi_alert);
                      },
                      activeColor: accentColor,
                    ),
                    const Text(
                      'Tax Report',
                      style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Cart table with fixed height to show only 5 items at a time
          Container(
            height: 360, // Height to show exactly 5 rows
            child: _buildCartTable(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildHoldButton()),
              const SizedBox(width: 16),
              Expanded(child: _buildCashButton()),
              const SizedBox(width: 16),
              Expanded(child: _buildPaymentMethodDropdown()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryContainer() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildCategoryDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildBrandDropdown()),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: itemNameController,
            decoration: InputDecoration(
              labelText: 'Search Item Name',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: const TextStyle(color: Color(0xFF1E293B)),
            onChanged: (value) => _filterItems(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 16),
          // Inventory grid with fixed height
          Container(
            height: 400, // Fixed height for inventory grid
            child: _buildItemImagesGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildWarehouseDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedWarehouse,
      decoration: InputDecoration(
        labelText: 'Select Warehouse',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: warehouses.map((warehouse) {
        return DropdownMenuItem(value: warehouse, child: Text(warehouse));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedWarehouse = value;
        });
        _showSuccessSnackBar('Warehouse set to $value', Icons.warehouse);
      },
    );
  }

  Widget _buildCustomerDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCustomer,
      decoration: InputDecoration(
        labelText: 'Select Customer',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: customers.map((customer) {
        return DropdownMenuItem(value: customer, child: Text(customer));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCustomer = value;
        });
        _showSuccessSnackBar('Customer set to $value', Icons.person);
      },
    );
  }

  Widget _buildItemNameDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedItemName,
      decoration: InputDecoration(
        labelText: 'Item Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: filteredItemNames.map((item) {
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
        prefixIcon: const Icon(Icons.qr_code_scanner, color: Color(0xFF64748B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
        _showSuccessSnackBar('Category set to $value', Icons.category);
      },
    );
  }

  Widget _buildBrandDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBrand,
      decoration: InputDecoration(
        labelText: 'Brand',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: brands.map((brand) {
        return DropdownMenuItem(value: brand, child: Text(brand));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedBrand = value;
        });
        _showSuccessSnackBar('Brand set to $value', Icons.branding_watermark);
      },
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedPaymentMethod,
      decoration: InputDecoration(
        labelText: 'Payment Method',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: paymentMethods.map((method) {
        return DropdownMenuItem(value: method, child: Text(method));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedPaymentMethod = value!;
        });
        _showSuccessSnackBar('Payment method set to $value', Icons.payment);
      },
    );
  }

  Widget _buildCartTable() {
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 40,
        horizontalMargin: 20,
        headingRowHeight: 60,
        dataRowHeight: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        headingTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        columns: const [
          DataColumn(label: Text('Item Name')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Discount')),
          DataColumn(label: Text('Subtotal')),
          DataColumn(label: Text('')),
        ],
        rows: cartItems.asMap().entries.map<DataRow>((entry) {
          final index = entry.key;
          final item = entry.value;
          final isEven = index % 2 == 0;
          return DataRow(
            color: MaterialStateProperty.all(
              isEven ? const Color(0xFFFAFAFA) : Colors.white,
            ),
            cells: [
              DataCell(
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.remove,
                            size: 18, color: secondaryColor),
                        onPressed: () => _updateQuantity(index, -1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add,
                            size: 18, color: secondaryColor),
                        onPressed: () => _updateQuantity(index, 1),
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  currencyFormatter.format(item.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              DataCell(
                Text(
                  currencyFormatter.format(item.discount),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
              DataCell(
                Text(
                  currencyFormatter.format(item.subtotal),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              DataCell(
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHoldButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showSuccessSnackBar('Bill held successfully', Icons.pause);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'HOLD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCashButton() {
    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _showPaymentDialog,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'PAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemImagesGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: productData.length,
      itemBuilder: (context, index) {
        final product = productData[index];
        return GestureDetector(
          onTap: () {
            if (product['stock'] > 0) {
              _addQuickItem(product['name'], product['price']);
            } else {
              _showErrorSnackBar('Item out of stock');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Stack(
                      children: [
                        Image.network(
                          product['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFFF8FAFC),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: accentColor)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Container(
                                color: const Color(0xFFF8FAFC),
                                child: const Icon(Icons.image_not_supported,
                                    color: Color(0xFF94A3B8)),
                              ),
                            );
                          },
                        ),
                        if (product['stock'] == 0)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: const Center(
                                child: Text(
                                  'Out of Stock',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormatter.format(product['price']),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stock: ${product['stock']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: product['stock'] <= 5
                              ? Colors.red[700]
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          price: 100.0 + (cartItems.length * 25),
          discount: 5.0,
        ));
      });
      barcodeController.clear();
      selectedItemName = null;
      _showSuccessSnackBar('Item added to cart', Icons.add_shopping_cart);
    } else {
      _showErrorSnackBar('Please select an item or enter a barcode');
    }
  }

  void _addQuickItem(String itemName, double price) {
    final product = productData.firstWhere((p) => p['name'] == itemName);
    if (product['stock'] <= 0) {
      _showErrorSnackBar('Item out of stock');
      return;
    }
    setState(() {
      cartItems.add(CartItem(
        name: itemName,
        quantity: 1,
        price: price,
        discount: 10.0,
      ));
      product['stock'] = (product['stock'] as int) - 1;
    });
    _showSuccessSnackBar('$itemName added to cart', Icons.add_shopping_cart);
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = cartItems[index].quantity + change;
      final product = productData.firstWhere(
          (p) => p['name'] == cartItems[index].name,
          orElse: () => {'stock': 0});
      if (newQuantity > product['stock']) {
        _showErrorSnackBar('Not enough stock available');
        return;
      }
      if (newQuantity > 0) {
        cartItems[index] = CartItem(
          name: cartItems[index].name,
          quantity: newQuantity,
          price: cartItems[index].price,
          discount: cartItems[index].discount,
        );
        product['stock'] = (product['stock'] as int) - change;
      } else {
        product['stock'] =
            (product['stock'] as int) + cartItems[index].quantity;
        cartItems.removeAt(index);
      }
    });
    _showSuccessSnackBar('Quantity updated', Icons.update);
  }

  void _removeItem(int index) {
    final itemName = cartItems[index].name;
    setState(() {
      final product = productData.firstWhere(
          (p) => p['name'] == cartItems[index].name,
          orElse: () => {'stock': 0});
      product['stock'] = (product['stock'] as int) + cartItems[index].quantity;
      cartItems.removeAt(index);
    });
    _showSuccessSnackBar('$itemName removed from cart', Icons.delete);
  }

  void _showPaymentDialog() {
    double grandTotal = cartItems.fold(0, (sum, item) => sum + item.subtotal);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grand Total: ${currencyFormatter.format(grandTotal)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Payment Method: $selectedPaymentMethod'),
            const SizedBox(height: 16),
            const Text('Confirm payment?'),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartItems.clear();
              });
              _showSuccessSnackBar(
                  'Payment completed successfully via $selectedPaymentMethod!',
                  Icons.check_circle);
              _generateReceipt();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Confirm Payment'),
          ),
        ],
      ),
    );
  }

  void _generateReceipt() {
    if (cartItems.isEmpty) {
      _showErrorSnackBar('No items in cart to generate receipt');
      return;
    }

    double totalAmount =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double totalDiscount =
        cartItems.fold(0, (sum, item) => sum + item.discount);
    double grandTotal = totalAmount - totalDiscount;

    String receipt = '''
POS Receipt
----------------------------------------
Date: ${DateTime.now().toString()}
Customer: ${selectedCustomer ?? 'Not selected'}
Warehouse: ${selectedWarehouse ?? 'Not selected'}
----------------------------------------
Items:
${cartItems.map((item) => '${item.name} x${item.quantity} @ ${currencyFormatter.format(item.price)} - Discount: ${currencyFormatter.format(item.discount)} = ${currencyFormatter.format(item.subtotal)}').join('\n')}
----------------------------------------
Total Amount: ${currencyFormatter.format(totalAmount)}
Total Discount: ${currencyFormatter.format(totalDiscount)}
Grand Total: ${currencyFormatter.format(grandTotal)}
Payment Method: $selectedPaymentMethod
Tax Report: ${taxReport ? 'Yes' : 'No'}
----------------------------------------
Thank you for your purchase!
''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt'),
        content: SingleChildScrollView(
          child: Text(receipt, style: const TextStyle(fontSize: 12)),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: receipt));
              _showSuccessSnackBar('Receipt copied to clipboard', Icons.copy);
            },
            child:
                const Text('Copy', style: TextStyle(color: Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Color(0xFF64748B))),
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

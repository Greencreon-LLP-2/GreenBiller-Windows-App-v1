import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/view_brand_controller.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/item/services/item/view_all_item_services.dart';
import 'package:green_biller/features/store/controllers/view_parties_controller.dart';
import 'package:green_biller/features/store/controllers/view_store_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:green_biller/features/item/controller/view_all_items_controller.dart';
import 'package:green_biller/features/item/services/category/view_categories_service.dart';

class POSBillingPage extends ConsumerStatefulWidget {
  const POSBillingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<POSBillingPage> createState() => _POSBillingPageState();
}

class _POSBillingPageState extends ConsumerState<POSBillingPage> {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();

  String? selectedWarehouse;
  String? selectedWarehouseId;
  String? selectedCustomer;
  String? selectedCustomerId;
  String? selectedItemName;
  String? selectedItemId;
  String? selectedCategory;
  String? selectedCategoryId;
  String? selectedBrand;
  String? selectedBrandId;
  String selectedPaymentMethod = 'Cash';

  bool taxReport = false;
  double previousDue = 0.0;
  List<CartItem> cartItems = [];
  Map<String, String> warehouseList = {};
  Map<String, String> customerList = {'Walk-in Customer': ''};
  Map<String, String> itemList = {};
  List<Map<String, dynamic>> productData = [];
  Map<String, String> categoryList = {};
  Map<String, String> brandList = {};
  bool isLoadingWarehouses = false;
  bool isLoadingCustomers = false;
  bool isLoadingItems = false;
  bool isLoadingCategories = false;
  bool isLoadingBrands = false;

  final currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
  final List<String> paymentMethods = ['Cash', 'Card', 'UPI', 'Credit'];

  @override
  void initState() {
    super.initState();
    itemNameController.addListener(_filterItems);
    _fetchInitialData();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    itemNameController.dispose();
    super.dispose();
  }

  void _fetchInitialData() async {
    final userModel = ref.read(userProvider);
    final accessToken = userModel?.accessToken;
    if (accessToken == null) {
      _showErrorSnackBar('No access token available');
      return;
    }
    await _fetchWarehouses(accessToken);
  }

  Future<void> _fetchWarehouses(String accessToken) async {
    setState(() {
      isLoadingWarehouses = true;
    });
    try {
      final map =
          await ViewStoreController(accessToken: accessToken, storeId: 0)
              .getStoreList();
      setState(() {
        warehouseList = map;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to fetch warehouses: $e');
    } finally {
      setState(() {
        isLoadingWarehouses = false;
      });
    }
  }

  Future<void> _fetchCustomers(String storeId) async {
    setState(() {
      isLoadingCustomers = true;
    });
    try {
      final userModel = ref.read(userProvider);
      final accessToken = userModel?.accessToken;
      if (accessToken != null) {
        final customers =
            await ViewPartiesController().customerList(accessToken, storeId);
        setState(() {
          customerList = {'Walk-in Customer': '', ...customers};
          selectedCustomer = 'Walk-in Customer';
          selectedCustomerId = '';
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch customers: $e');
      setState(() {
        customerList = {'Walk-in Customer': ''};
        selectedCustomer = 'Walk-in Customer';
        selectedCustomerId = '';
      });
    } finally {
      setState(() {
        isLoadingCustomers = false;
      });
    }
  }

  Future<void> _fetchItems(String storeId) async {
    setState(() {
      isLoadingItems = true;
    });
    try {
      final userModel = ref.read(userProvider);
      final accessToken = userModel?.accessToken;
      if (accessToken != null) {
        final controller = ViewAllItemsController(accessToken: accessToken);
        final itemModel = await controller.getAllItems(storeId);
        final Map<String, String> fetchedItemList = {};
        final List<Map<String, dynamic>> fetchedProducts = [];

        if (itemModel.data != null) {
          for (var item in itemModel.data!) {
            fetchedItemList[item.itemName] = item.id.toString();
            fetchedProducts.add({
              'itemId': item.id.toString(),
              'itemName': item.itemName,
              'itemCode': item.itemCode,
              'barcode': item.barcode,
              'stock': item.openingStock ?? '0',
              'price': double.tryParse(item.salesPrice) ?? 0.0,
              'mrp': item.mrp,
              'unit': item.unit,
              'sku': item.sku,
              'taxType': item.taxType,
              'discountType': item.discountType,
              'discount': double.tryParse(item.discount) ?? 0.0,
              'categoryName': item.categoryName,
              'brandName': item.brandName,
              'storeName': item.storeName,
              'alertQuantity': item.alertQuantity,
              'profitMargin': double.tryParse(item.profitMargin) ?? 0.0,
              'taxRate': double.tryParse(item.taxRate) ?? 0.0,
              'imageUrl': item.itemImage,
              'category': item.categoryId ?? 0,
              'brand': item.brandId ?? 0,
            });
          }
        }

        setState(() {
          itemList = fetchedItemList;
          productData = fetchedProducts;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch items: $e');
      setState(() {
        itemList = {};
        productData = [];
      });
    } finally {
      setState(() {
        isLoadingItems = false;
      });
    }
  }

  Future<void> _fetchCategories(String storeId) async {
    setState(() {
      isLoadingCategories = true;
    });
    try {
      final userModel = ref.read(userProvider);
      final accessToken = userModel?.accessToken;
      if (accessToken != null) {
        final controller = ViewCategoriesController();
        await controller.fetchCategoryList(accessToken, int.parse(storeId));
        final categories = controller.categoryList;
        final Map<String, String> fetchedCategories = {};
        for (var category in categories) {
          fetchedCategories[category] = category;
        }
        setState(() {
          categoryList = fetchedCategories;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch categories: $e');
      setState(() {
        categoryList = {};
      });
    } finally {
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> _fetchBrands(String storeId) async {
    setState(() {
      isLoadingBrands = true;
    });
    try {
      final userModel = ref.read(userProvider);
      final accessToken = userModel?.accessToken;
      if (accessToken != null) {
        final controller = ViewBrandController(accessToken: accessToken);
        final brands =
            await controller.viewBrandByIdController(int.parse(storeId));
        final Map<String, String> fetchedBrands = {};
        for (var brand in brands) {
          if (brand.keys.first != null && brand.values.first != null) {
            fetchedBrands[brand.keys.first!] = brand.values.first!;
          }
        }
        setState(() {
          brandList = fetchedBrands;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch brands: $e');
      setState(() {
        brandList = {};
      });
    } finally {
      setState(() {
        isLoadingBrands = false;
      });
    }
  }

  void _filterItems() {
    final query = itemNameController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        itemList = Map.fromEntries(productData
            .map((item) => MapEntry(item['itemName'], item['itemId'])));
      } else {
        itemList = Map.fromEntries(
          productData
              .where((item) => item['itemName'].toLowerCase().contains(query))
              .map((item) => MapEntry(item['itemName'], item['itemId'])),
        );
      }
      selectedItemName = null;
      selectedItemId = null;
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
        duration: const Duration(seconds: 2),
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
                            product['stock'] =
                                (int.tryParse(product['stock'].toString()) ??
                                        0) +
                                    cartItems.fold<int>(
                                        0,
                                        (sum, item) =>
                                            item.name == product['itemName']
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
          Container(
            height: 360,
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
          Container(
            height: 400,
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
        labelText: 'Select Store (Required)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: isLoadingWarehouses
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: accentColor),
                ),
              )
            : const Icon(Icons.store_outlined, color: Color(0xFF64748B)),
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: warehouseList.keys.map((warehouse) {
        return DropdownMenuItem(value: warehouse, child: Text(warehouse));
      }).toList(),
      onChanged: isLoadingWarehouses
          ? null
          : (value) async {
              setState(() {
                selectedWarehouse = value;
                selectedWarehouseId =
                    value != null ? warehouseList[value] : null;
              });
              if (selectedWarehouseId != null) {
                await _fetchCustomers(selectedWarehouseId!);
                await _fetchItems(selectedWarehouseId!);
                await _fetchCategories(selectedWarehouseId!);
                await _fetchBrands(selectedWarehouseId!);
              }
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
        suffixIcon: isLoadingCustomers
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: accentColor),
                ),
              )
            : const Icon(Icons.person_outline, color: Color(0xFF64748B)),
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: customerList.keys.map((customer) {
        return DropdownMenuItem(value: customer, child: Text(customer));
      }).toList(),
      onChanged: isLoadingCustomers
          ? null
          : (value) {
              setState(() {
                selectedCustomer = value;
                selectedCustomerId = value != null ? customerList[value] : null;
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
        suffixIcon: isLoadingItems
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: accentColor),
                ),
              )
            : const Icon(Icons.inventory_2_outlined, color: Color(0xFF64748B)),
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: itemList.keys.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: isLoadingItems
          ? null
          : (value) {
              setState(() {
                selectedItemName = value;
                selectedItemId = value != null ? itemList[value] : null;
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
        suffixIcon: isLoadingCategories
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: accentColor),
                ),
              )
            : const Icon(Icons.category, color: Color(0xFF64748B)),
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: categoryList.keys.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      }).toList(),
      onChanged: isLoadingCategories
          ? null
          : (value) {
              setState(() {
                selectedCategory = value;
                selectedCategoryId = value != null ? categoryList[value] : null;
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
        suffixIcon: isLoadingBrands
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: accentColor),
                ),
              )
            : const Icon(Icons.branding_watermark, color: Color(0xFF64748B)),
      ),
      style: const TextStyle(color: Color(0xFF1E293B)),
      items: brandList.keys.map((brand) {
        return DropdownMenuItem(value: brand, child: Text(brand));
      }).toList(),
      onChanged: isLoadingBrands
          ? null
          : (value) {
              setState(() {
                selectedBrand = value;
                selectedBrandId = value != null ? brandList[value] : null;
              });
              _showSuccessSnackBar(
                  'Brand set to $value', Icons.branding_watermark);
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
        columnSpacing: 50,
        horizontalMargin: 20,
        headingRowHeight: 60,
        dataRowHeight: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        headingTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        columns: const [
          DataColumn(label: Text('Image')),
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

          final product = productData.firstWhere(
            (p) => p['itemName'] == item.name,
            orElse: () => {
              'imageUrl':
                  'https://via.placeholder.com/80x80/CCCCCC/FFFFFF?text=No+Image'
            },
          );

          return DataRow(
            color: MaterialStateProperty.all(
              isEven ? const Color(0xFFFAFAFA) : Colors.white,
            ),
            cells: [
              DataCell(
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product['imageUrl'] ??
                        'https://via.placeholder.com/80x80/CCCCCC/FFFFFF?text=No+Image',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFF8FAFC),
                        child: const Center(
                          child: CircularProgressIndicator(color: accentColor),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFF8FAFC),
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Color(0xFF94A3B8)),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
    final filteredProducts = productData.where((product) {
      final matchesCategory = selectedCategoryId == null ||
          product['categoryName'] == selectedCategoryId;
      final matchesBrand = selectedBrandId == null ||
          product['brand'].toString() == selectedBrandId;
      return matchesCategory && matchesBrand;
    }).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return OldPOSCard(
          itemName: product['itemName'],
          stock: int.tryParse(product['stock'].toString()) ?? 0,
          imageUrl: product['imageUrl'],
          onTap: () {
            // final stock = int.tryParse(product['stock'].toString()) ?? 0;
            // if (stock > 0) {
            _addQuickItem(
              product['itemName'],
              double.tryParse(product['price'].toString()) ?? 100.0,
              product['discount'].toString(),
            );
            // } else {
            //   _showErrorSnackBar('Item out of stock');
            // }
          },
        );
      },
    );
  }

  void _addItemToCart() async {
    if (selectedWarehouseId == null) {
      _showErrorSnackBar('Please select a store first');
      return;
    }
    if (selectedItemId != null || barcodeController.text.isNotEmpty) {
      String? itemName;
      String? itemId;
      double price = 100.0;
      int stock = 0;
      double discount = 0.0;

      if (selectedItemId != null) {
        itemName = selectedItemName;
        itemId = selectedItemId;
        final product =
            productData.firstWhere((p) => p['itemName'] == itemName);
        price = double.tryParse(product['price'].toString()) ?? 100.0;
        stock = int.tryParse(product['stock'].toString()) ?? 0;
        discount = double.tryParse(product['discount'].toString()) ?? 0.0;
      } else {
        itemId = barcodeController.text;
        final product = productData.firstWhere(
          (p) => p['barcode'] == itemId || p['itemCode'] == itemId,
          orElse: () => {},
        );
        if (product.isEmpty) {
          _showErrorSnackBar('Item not found for barcode: $itemId');
          return;
        }
        itemName = product['itemName'];
        price = double.tryParse(product['price'].toString()) ?? 100.0;
        stock = int.tryParse(product['stock'].toString()) ?? 0;
        discount = double.tryParse(product['discount'].toString()) ?? 0.0;
      }
      // if (stock <= 0) {
      //   _showErrorSnackBar('Item out of stock');
      //   return;
      // }
      setState(() {
        cartItems.add(CartItem(
          name: itemName!,
          quantity: 1,
          price: price,
          discount: discount,
        ));
        final product =
            productData.firstWhere((p) => p['itemName'] == itemName);
        product['stock'] = (int.tryParse(product['stock'].toString()) ?? 0) - 1;
      });
      barcodeController.clear();
      setState(() {
        selectedItemName = null;
        selectedItemId = null;
      });
      _showSuccessSnackBar('Item added to cart', Icons.add_shopping_cart);
    } else {
      _showErrorSnackBar('Please select an item or enter a barcode');
    }
  }

  void _addQuickItem(String itemName, double price, String discount) {
    final product = productData.firstWhere((p) => p['itemName'] == itemName);
    final stock = int.tryParse(product['stock'].toString()) ?? 0;
    final discountValue = double.tryParse(discount) ?? 0.0;
    // if (stock <= 0) {
    //   _showErrorSnackBar('Item out of stock');
    //   return;
    // }
    setState(() {
      cartItems.add(CartItem(
        name: itemName,
        quantity: 1,
        price: price,
        discount: discountValue,
      ));
      product['stock'] = stock - 1;
    });
    _showSuccessSnackBar('$itemName added to cart', Icons.add_shopping_cart);
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = cartItems[index].quantity + change;
      final product = productData.firstWhere(
          (p) => p['itemName'] == cartItems[index].name,
          orElse: () => {'stock': '0'});
      final currentStock = int.tryParse(product['stock'].toString()) ?? 0;
      if (newQuantity > currentStock) {
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
        product['stock'] = currentStock - change;
      } else {
        product['stock'] = currentStock + cartItems[index].quantity;
        cartItems.removeAt(index);
      }
    });
    _showSuccessSnackBar('Quantity updated', Icons.update);
  }

  void _removeItem(int index) {
    final itemName = cartItems[index].name;
    setState(() {
      final product = productData.firstWhere(
          (p) => p['itemName'] == cartItems[index].name,
          orElse: () => {'stock': '0'});
      product['stock'] = (int.tryParse(product['stock'].toString()) ?? 0) +
          cartItems[index].quantity;
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
Customer ID: ${selectedCustomerId ?? 'Not selected'}
Warehouse: ${selectedWarehouse ?? 'Not selected'}
Warehouse ID: ${selectedWarehouseId ?? 'Not selected'}
----------------------------------------
Items:
${cartItems.map((item) {
      final product = productData.firstWhere((p) => p['itemName'] == item.name,
          orElse: () => {});
      return '${item.name} x${item.quantity} @ ${currencyFormatter.format(item.price)} (MRP: ${product['mrp'] ?? 'N/A'}, Tax: ${product['taxRate'] ?? '0'}%) - Discount: ${currencyFormatter.format(item.discount)} = ${currencyFormatter.format(item.subtotal)}';
    }).join('\n')}
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

class ViewCategoriesController {
  List<String> _categoryList = [];

  List<String> get categoryList => _categoryList;

  Future<void> fetchCategoryList(String accessToken, int storeId) async {
    final response =
        await viewCategoriesService(accessToken, storeId.toString());
    _categoryList = response.categories?.map((e) => e.name!).toList() ?? [];
  }
}

class OldPOSCard extends StatelessWidget {
  final String itemName;
  final int stock;
  final String imageUrl;
  final VoidCallback onTap;

  const OldPOSCard({
    Key? key,
    required this.itemName,
    required this.stock,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl.isNotEmpty
                      ? imageUrl
                      : 'https://via.placeholder.com/150x150/CCCCCC/FFFFFF?text=No+Image',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFF8FAFC),
                      child: const Center(
                        child: CircularProgressIndicator(color: accentColor),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF8FAFC),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Color(0xFF94A3B8),
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: $stock',
                    style: TextStyle(
                      fontSize: 14,
                      color: stock > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
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
}

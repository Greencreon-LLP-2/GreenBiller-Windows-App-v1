import 'dart:io';
import 'dart:ui';
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
import 'package:pdf/pdf.dart' show PdfPageFormat, PdfColors;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

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

  Widget _buildTaxTable() {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Item Name')),
          DataColumn(label: Text('Tax Rate (%)')),
        ],
        rows: productData.map<DataRow>((product) {
          return DataRow(
            cells: [
              DataCell(Text(product['itemName'] ?? 'Unknown')),
              DataCell(Text('${product['taxRate'] ?? 0.0}%')),
            ],
          );
        }).toList(),
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
            backgroundColor: accentColor,
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
                    //  const SizedBox(width: 12),
                    // _buildActionButton(
                    //   'Generate Receipt',
                    //   Icons.receipt_long,
                    //   secondaryColor,
                    //   _generateReceipt,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                        Expanded(flex: 3, child: _buildBillingContainer()),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: _buildInventoryContainer()),
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
    );
  }

  Widget _buildReceiptPreview(List<CartItem> receiptItems) {
    // Build a receipt preview matching the attached sample (no extra features)
    const companyName = 'Green Biller';
    const companyMobile = '+91 1234567890';
    const companyEmail = 'contact@greenbiller.com';
    const companyLogoUrl = 'https://via.placeholder.com/100x100';

    final invoiceNo = 'INV-${DateTime.now().millisecondsSinceEpoch}';
    final invoiceDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final customerName = selectedCustomer ?? 'Walk-in Customer';
    final customerId = selectedCustomerId ?? 'N/A';

    final totalAmount = receiptItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
    final totalDiscount =
        receiptItems.fold(0.0, (sum, item) => sum + item.discount);
    final totalTax = receiptItems.fold(0.0, (sum, item) {
      final product = productData.firstWhere((p) => p['itemName'] == item.name,
          orElse: () => {'taxRate': 0.0});
      final taxRate = double.tryParse(product['taxRate'].toString()) ?? 0.0;
      return sum + ((item.price * item.quantity) * taxRate / 100);
    });
    const shipping = 0.0;
    final grandTotal = totalAmount - totalDiscount + totalTax + shipping;
    const dueAmount = 0.0;
    final totalPayable = grandTotal;

    // determine dominant tax rate for display (falls back to 0)
    final Map<double, int> taxCount = {};
    for (var it in receiptItems) {
      final prod = productData.firstWhere((p) => p['itemName'] == it.name,
          orElse: () => {'taxRate': 0.0});
      final r = double.tryParse(prod['taxRate'].toString()) ?? 0.0;
      taxCount[r] = (taxCount[r] ?? 0) + 1;
    }
    final displayTaxRate = taxCount.isNotEmpty
        ? taxCount.entries.reduce((a, b) => a.value >= b.value ? a : b).key
        : 0.0;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 380,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                companyLogoUrl,
                width: 96,
                height: 64,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),
              Text(companyName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Phone Number: $companyMobile',
                  style: const TextStyle(fontSize: 12)),
              Text('Email: $companyEmail',
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),

              // Tax Invoice center with dashed lines
              Row(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // left side line
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(
                            (constraints.maxWidth / 6.64).floor(), // dash count
                            (index) => const Text("-"),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Tax Invoice",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // right side line
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            (constraints.maxWidth / 6.64).floor(),
                            (index) => const Text("-"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Name and Customer Id (left / right)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: $customerName',
                      style: const TextStyle(fontSize: 13)),
                  Text('Customer Id: $customerId',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),

              // Invoice No and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice No: $invoiceNo',
                      style: const TextStyle(fontSize: 13)),
                  Text('Date: $invoiceDate',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Approx width of one dash char
                      double dashWidth = 6.6;
                      // how many dashes can fit in one line
                      int dashCount =
                          (constraints.maxWidth / dashWidth).floor();

                      return Text(List.filled(dashCount, "-").join());
                    },
                  )),
                ],
              ),

              // Header row for items
              Row(
                children: const [
                  Expanded(
                      flex: 6,
                      child: Text('# Item',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('Price',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('Qty',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('Total',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13))),
                ],
              ),
              Row(
                children: [
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Approx width of one dash char
                      double dashWidth = 6.6;
                      // how many dashes can fit in one line
                      int dashCount =
                          (constraints.maxWidth / dashWidth).floor();

                      return Text(List.filled(dashCount, "-").join());
                    },
                  )),
                ],
              ),

              // Items with numbering
              ...receiptItems.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final item = entry.value;
                final product = productData.firstWhere(
                    (p) => p['itemName'] == item.name,
                    orElse: () => {'taxRate': 0.0});
                final taxRate =
                    double.tryParse(product['taxRate'].toString()) ?? 0.0;
                final itemTotal = (item.price * item.quantity) -
                    item.discount +
                    ((item.price * item.quantity) * taxRate / 100);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 6,
                          child: Text('$idx. ${item.name}',
                              style: const TextStyle(fontSize: 13))),
                      Expanded(
                          flex: 2,
                          child: Text(currencyFormatter.format(item.price),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 13))),
                      Expanded(
                          flex: 2,
                          child: Text('${item.quantity}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 13))),
                      Expanded(
                          flex: 2,
                          child: Text(currencyFormatter.format(itemTotal),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                );
              }).toList(),

              Row(
                children: [
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Approx width of one dash char
                      double dashWidth = 6.6;
                      // how many dashes can fit in one line
                      int dashCount =
                          (constraints.maxWidth / dashWidth).floor();

                      return Text(List.filled(dashCount, "-").join());
                    },
                  )),
                ],
              ),

              // Totals aligned to right
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sub Total :',
                            style: const TextStyle(fontSize: 13)),
                        Text(currencyFormatter.format(totalAmount),
                            style: const TextStyle(fontSize: 13))
                      ]),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount :',
                            style: const TextStyle(fontSize: 13)),
                        Text('-' + currencyFormatter.format(totalDiscount),
                            style: const TextStyle(
                              fontSize: 13,
                            ))
                      ]),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping :',
                            style: const TextStyle(fontSize: 13)),
                        Text(currencyFormatter.format(shipping),
                            style: const TextStyle(fontSize: 13))
                      ]),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax (${displayTaxRate.toStringAsFixed(0)}%) :',
                            style: const TextStyle(fontSize: 13)),
                        Text(currencyFormatter.format(totalTax),
                            style: const TextStyle(fontSize: 13))
                      ]),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Bill :',
                            style: const TextStyle(
                              fontSize: 13,
                            )),
                        Text(currencyFormatter.format(grandTotal),
                            style: const TextStyle(
                              fontSize: 13,
                            ))
                      ]),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Due :', style: const TextStyle(fontSize: 13)),
                        Text(currencyFormatter.format(dueAmount),
                            style: const TextStyle(fontSize: 13))
                      ]),
                  const SizedBox(height: 6),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Payable :',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(currencyFormatter.format(totalPayable),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                ],
              ),

              Row(
                children: [
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Approx width of one dash char
                      double dashWidth = 6.6;
                      // how many dashes can fit in one line
                      int dashCount =
                          (constraints.maxWidth / dashWidth).floor();

                      return Text(List.filled(dashCount, "-").join());
                    },
                  )),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                  '**VAT against this challan is payable through central registration. Thank you for your business!',
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
            ],
          ),
        ),
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
          SizedBox(
            height: 360,
            child: _buildCartTable(),
          ),
          const SizedBox(height: 16),
          _buildMinimalSummary(),
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

  Widget _buildMinimalSummary() {
    final totalItems = cartItems.length;
    final totalAmount =
        cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    final totalDiscount =
        cartItems.fold(0.0, (sum, item) => sum + item.discount);
    final grandTotal = cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 1,
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                '$totalItems',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                currencyFormatter.format(totalAmount),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Discount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                currencyFormatter.format(totalDiscount),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                currencyFormatter.format(grandTotal),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
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
        columnSpacing: 40,
        horizontalMargin: 10,
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
        dataTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          verticalInside: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          left: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          right: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        columns: const [
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Item Name')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Discount')),
          DataColumn(label: Text('Tax (%)')),
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
                  'https://via.placeholder.com/80x80/CCCCCC/FFFFFF?text=No+Image',
              'taxRate': 0.0,
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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Text(
                    currencyFormatter.format(item.price),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Text(
                    currencyFormatter.format(item.discount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEF4444),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: Text(
                    '${product['taxRate'] ?? 0.0}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 100),
                  child: Text(
                    currencyFormatter.format(item.subtotal),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
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
            _addQuickItem(
              product['itemName'],
              double.tryParse(product['price'].toString()) ?? 100.0,
              product['discount'].toString(),
            );
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
              _showPrintDialog();
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

  void _showPrintDialog() {
    final List<CartItem> receiptItems = List.from(cartItems);
    setState(() {
      cartItems.clear();
    });
    _showSuccessSnackBar(
        'Payment completed successfully via $selectedPaymentMethod!',
        Icons.check_circle);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Would you like to preview the receipt or proceed to the next order?'),
            const SizedBox(height: 16),
            SizedBox(
              height: 400, // Adjust height as needed

              width: 400,
              child: _buildReceiptPreview(
                  receiptItems), // Show receipt preview widget
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selectedItemName = null;
                selectedItemId = null;
                barcodeController.clear();
              });
              _showSuccessSnackBar('Ready for next order', Icons.arrow_forward);
            },
            child: const Text('Next Order',
                style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _printReceipt(receiptItems); // Print after preview
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt(List<CartItem> receiptItems) async {
    try {
      final pdfBytes = await generateReceiptPDF(receiptItems);
      final directory = await getTemporaryDirectory();
      final file = File(
          '${directory.path}/Receipt_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(pdfBytes);

      await Printing.layoutPdf(
        onLayout: (format) => pdfBytes,
        name: 'Receipt_${DateTime.now().millisecondsSinceEpoch}',
      );
      _showSuccessSnackBar('Receipt printed successfully', Icons.print);
    } catch (e) {
      _showErrorSnackBar('Failed to print receipt: $e');
    }
  }

  Future<Uint8List> generateReceiptPDF(List<CartItem> receiptItems) async {
    final pdf = pw.Document();
    final userModel = ref.read(userProvider);

    final companyName = 'Green Biller';
    final companyMobile = '+91 1234567890';
    final companyEmail = 'contact@greenbiller.com';
    final companyLogoUrl = 'https://via.placeholder.com/100x100';

    pw.Widget logoWidget;
    try {
      final logoImage = await networkImage(companyLogoUrl);
      logoWidget = pw.Image(logoImage, width: 80, height: 80);
    } catch (e) {
      logoWidget = pw.Text('[Company Logo]', style: pw.TextStyle(fontSize: 12));
    }

    // Invoice details
    final invoiceNo = 'INV-${DateTime.now().millisecondsSinceEpoch}';
    final invoiceDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final customerName = selectedCustomer ?? 'Walk-in Customer';
    final customerId = selectedCustomerId ?? 'N/A';

    // Calculate totals
    final totalAmount = receiptItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
    final totalDiscount =
        receiptItems.fold(0.0, (sum, item) => sum + item.discount);
    final totalTax = receiptItems.fold(0.0, (sum, item) {
      final product = productData.firstWhere((p) => p['itemName'] == item.name,
          orElse: () => {'taxRate': 0.0});
      final taxRate = double.tryParse(product['taxRate'].toString()) ?? 0.0;
      return sum + ((item.price * item.quantity) * taxRate / 100);
    });
    final shipping = 0.0;
    final grandTotal = totalAmount - totalDiscount + totalTax + shipping;
    final dueAmount = 0.0;
    final totalPayable = grandTotal;

    // Item list for PDF
    final items = receiptItems.map((item) {
      final product = productData.firstWhere((p) => p['itemName'] == item.name,
          orElse: () => {'taxRate': 0.0, 'mrp': '0.0'});
      final taxRate = double.tryParse(product['taxRate'].toString()) ?? 0.0;
      final itemTotal = (item.price * item.quantity) -
          item.discount +
          ((item.price * item.quantity) * taxRate / 100);
      return [
        item.name,
        currencyFormatter.format(item.price),
        item.quantity.toString(),
        '${taxRate.toStringAsFixed(2)}%',
        currencyFormatter.format(itemTotal),
      ];
    }).toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Company Details
                pw.Center(
                  child: pw.Column(
                    children: [
                      logoWidget,
                      pw.SizedBox(height: 4),
                      pw.Text(
                        companyName,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Mobile: $companyMobile',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Email: $companyEmail',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Divider(thickness: 1),
                    ],
                  ),
                ),
                // Invoice Details
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Invoice: $invoiceNo',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Date: ${invoiceDate.toString().split(' ')[0]}',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Customer: $customerName',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Customer ID: $customerId',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
                pw.Divider(thickness: 0.5),
                // Item Header
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        'Item',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Qty',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Price',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Divider(thickness: 0.3),
                // Item List
                for (var item in items)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                item[0],
                                style: const pw.TextStyle(fontSize: 7),
                              ),
                              pw.Text(
                                'Tax: ${item[3]}',
                                style: const pw.TextStyle(
                                  fontSize: 6,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            item[2],
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            item[1],
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                            item[4],
                            style: const pw.TextStyle(fontSize: 7),
                          ),
                        ),
                      ],
                    ),
                  ),
                pw.Divider(thickness: 0.5),
                // Totals
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Subtotal',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            currencyFormatter.format(totalAmount),
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Discount',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            currencyFormatter.format(totalDiscount),
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Shipping',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            currencyFormatter.format(shipping),
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total Tax',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            currencyFormatter.format(totalTax),
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total Bill',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            currencyFormatter.format(grandTotal),
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Due',
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            currencyFormatter.format(dueAmount),
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total Payable',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            currencyFormatter.format(totalPayable),
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Column(
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Payment Method:',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6,
                                  ),
                                ),
                                pw.Text(
                                  'Cash',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.blue700,
                                    fontSize: 6,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Amount Paid:',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6,
                                  ),
                                ),
                                pw.Text(
                                  currencyFormatter.format(totalPayable),
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 4),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Balance Due:',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6,
                                  ),
                                ),
                                pw.Text(
                                  currencyFormatter.format(dueAmount),
                                  style: const pw.TextStyle(fontSize: 8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Thank you for your purchase!',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'For any queries, contact us at $companyEmail.',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Software by Green Biller',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  // void _generateReceipt() {
  //   if (cartItems.isEmpty) {
  //     _showErrorSnackBar('No items in cart to generate receipt');
  //     return;
  //   }
  //   final List<CartItem> receiptItems = List.from(cartItems);
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text(
  //         'Receipt Preview',
  //         style: TextStyle(color: Colors.black),
  //       ),
  //       content: SizedBox(
  //         child: _buildReceiptPreview(receiptItems),
  //       ),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text(
  //             'Cancel',
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             Navigator.pop(context);
  //             await _printReceipt(receiptItems);
  //             _showPrintDialog(); // Show post-print dialog
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: accentColor,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8)),
  //           ),
  //           child: const Text(
  //             'Print Receipt',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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

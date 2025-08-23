import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/item/controller/add_category_controller.dart';
import 'package:green_biller/features/item/controller/add_item_controller.dart';
import 'package:green_biller/features/item/controller/unit_controller.dart';
import 'package:green_biller/features/item/controller/view_brand_controller.dart';
import 'package:green_biller/features/item/services/category/view_categories_service.dart';
import 'package:green_biller/features/store/controllers/view_warehouse_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';

/// ! AddItemsPage is responsible for creating and editing inventory items
/// ! It uses a tabbed interface to organize item details into Basic Info, Pricing, and Stock
class AddItemsPage extends StatefulWidget {
  const AddItemsPage({super.key});

  @override
  State<AddItemsPage> createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage>
    with SingleTickerProviderStateMixin {
  final _logger = Logger();

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _brandController = TextEditingController();
  final _skuController = TextEditingController();
  final _hsnCodeController = TextEditingController();
  final _itemCodeController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _unitController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _taxRateController = TextEditingController();
  final _salesPriceController = TextEditingController();
  final _mrpController = TextEditingController();
  final _discountController = TextEditingController();
  final _profitMarginController = TextEditingController();
  final _openingStockController = TextEditingController();
  final _alertQuantityController = TextEditingController();
  final TextEditingController _subUnitController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTaxType;
  String? _selectedDiscountType;
  String? _selectedWarehouse;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isProcessing = false;

  final Map<String, int> _storeMap = {};
  String? _selectedStore;
  final Map<String, int> _categoryMap = {};
  final Map<String, int> _unitMap = {};
  int? _selectedStoreId;
  bool _isLoadingStores = false;
  bool _isLoadingCategories = false;
  bool _isLoadingUnits = false;
  bool _isInitialized = false;

  double _calculatedProfit = 0.0;

  final Map<String, int> _brandMap = {};
  String? _selectedBrand;
  bool _isLoadingBrands = false;

  final Map<String, String> _warehouseMap = {};
  bool _isLoadingWarehouses = false;

  Map<String, dynamic>? _importedFile;

  @override
  void initState() {
    super.initState();
    _logger.d('Initializing AddItemsPage');
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      _logger.d('Tab changed to index: ${_tabController.index}');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadStores();
      _loadCategories();
      _loadUnits();
      _loadWarehouses();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _logger.d('Disposing AddItemsPage');
    _tabController.dispose();
    // Dispose all controllers
    _itemNameController.dispose();
    _brandController.dispose();
    _skuController.dispose();
    _hsnCodeController.dispose();
    _itemCodeController.dispose();
    _barcodeController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _taxRateController.dispose();
    _salesPriceController.dispose();
    _mrpController.dispose();
    _discountController.dispose();
    _profitMarginController.dispose();
    _openingStockController.dispose();
    _alertQuantityController.dispose();
    _subUnitController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      _logger.d('Opening file picker for Excel/CSV');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
      );

      if (result != null &&
          result.files.single.name != null &&
          result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final file = File(filePath);
        if (await file.exists()) {
          setState(() {
            _importedFile = {
              'name': result.files.single.name,
              'file': file,
            };
            _logger.i(
                'File selected: ${_importedFile!['name']} at path: $filePath');
          });
        } else {
          _logger.w('File does not exist at path: $filePath');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Selected file does not exist'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        _logger.w('No file selected');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file selected'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      _logger.e('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openFile() async {
    if (_importedFile != null && _importedFile!['file'] != null) {
      try {
        final file = _importedFile!['file'] as File;
        final filePath = file.path;
        _logger.d(
            'Attempting to open file: ${_importedFile!['name']} at path: $filePath');

        if (await file.exists()) {
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            _logger.w('Failed to open file: ${result.message}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to open file: ${result.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            _logger.i('File opened successfully: ${_importedFile!['name']}');
          }
        } else {
          _logger.w('File does not exist at path: $filePath');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File does not exist'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        _logger.e('Error opening file: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error opening file: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      _logger.w('No file to open');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected to open'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Add Item",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: _calculatedProfit < 0 ? errorColor : accentColor,
        foregroundColor: Colors.white,
        actions: [
          Tooltip(
            message: _importedFile != null && _importedFile!['name'] != null
                ? 'Open ${_importedFile!['name']}'
                : 'No file selected',
            child: TextButton(
              onPressed: _openFile,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Colors.white), // Matches AppBar theme
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.white.withOpacity(0.2);
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.white.withOpacity(0.3);
                    }
                    return null;
                  },
                ),
                backgroundColor: MaterialStateProperty.all(
                  _importedFile != null && _importedFile!['name'] != null
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.1),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_importedFile != null &&
                      _importedFile!['name'] != null) ...[
                    const Icon(
                      Icons.insert_drive_file,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      _importedFile != null && _importedFile!['name'] != null
                          ? _importedFile!['name']
                          : 'No File',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _importedFile != null &&
                                _importedFile!['name'] != null
                            ? Colors.white
                            : Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_sharp),
            onPressed: _pickFile,
            tooltip: 'Import File',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
            tooltip: 'Help',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildDesktopLayout(context),
    );
  }

  /// Modern desktop layout with sidebar navigation and content area
  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left sidebar with navigation
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Item Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textPrimaryColor,
                            ),
                          ),
                          Text(
                            "Add new inventory item",
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Navigation list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildNavItem("Basic Info", Icons.info_outline, 0),
                        _buildNavItem("Pricing", Icons.attach_money, 1),
                        _buildNavItem("Stock", Icons.inventory, 2),
                      ],
                    ),
                  ),
                ),

                // Action buttons at bottom
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: errorColor,
                            side: const BorderSide(color: errorColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSubmitButton(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Main content area
          Expanded(
            child: Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _tabController.index == 0
                                ? "Basic Information"
                                : _tabController.index == 1
                                    ? "Pricing Details"
                                    : "Stock Information",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.help_outline, size: 18),
                            label: const Text("Help"),
                            style: TextButton.styleFrom(
                              foregroundColor: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: IndexedStack(
                        index: _tabController.index,
                        children: [
                          _buildDesktopBasicInfoContent(),
                          _buildDesktopPricingContent(),
                          _buildDesktopStockContent(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation item for desktop sidebar
  Widget _buildNavItem(String title, IconData icon, int tabIndex) {
    final isSelected = _tabController.index == tabIndex;

    return InkWell(
      onTap: () {
        setState(() {
          _tabController.animateTo(tabIndex);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected ? accentColor.withOpacity(0.3) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? accentColor : textSecondaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? accentColor : textPrimaryColor,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Basic info content for desktop view
  Widget _buildDesktopBasicInfoContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and primary info section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image upload
              SizedBox(
                width: 250,
                child: _buildImageSection(),
              ),
              const SizedBox(width: 24),
              // Primary fields
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: "Item Name",
                      hint: "Enter item name",
                      prefixIcon: Icons.inventory,
                      required: true,
                      controller: _itemNameController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStoreDropdown(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCategoryDropdown(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildBrandDropdown(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Divider with label
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Product Identification",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          // Identification codes section
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: "SKU",
                  hint: "Enter SKU",
                  prefixIcon: Icons.qr_code,
                  controller: _skuController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: "HSN Code",
                  hint: "Enter HSN code",
                  prefixIcon: Icons.qr_code,
                  controller: _hsnCodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: "Barcode",
                  hint: "Enter barcode number",
                  prefixIcon: Icons.crop_free,
                  controller: _barcodeController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: "Item Code",
                  hint: "Enter item code",
                  prefixIcon: Icons.code,
                  controller: _itemCodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildUnitDropdown(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: _unitController.text.isEmpty
                      ? "Sub Unit"
                      : "Quantity (${_unitController.text})",
                  hint: _unitController.text.isEmpty
                      ? "Enter subunit"
                      : "Enter ${_unitController.text} quantity",
                  prefixIcon: Icons.numbers_outlined,
                  controller: _subUnitController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          _buildInputField(
            label: "Description",
            hint: "Enter item description",
            prefixIcon: Icons.description,
            controller: _descriptionController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Pricing content for desktop view
  Widget _buildDesktopPricingContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Purchase section
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Purchase Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Purchase Price",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: _purchasePriceController,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: "Tax Type",
                                items: ["GST", "VAT", "None"],
                                prefixIcon: Icons.receipt_long,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: "Tax Rate (%)",
                                hint: "0.00",
                                prefixIcon: Icons.percent,
                                controller: _taxRateController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Sales section
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.point_of_sale,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Sales Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Sales Price",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: _salesPriceController,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                        _buildInputField(
                          label: "MRP",
                          hint: "0.00",
                          prefixIcon: Icons.currency_rupee,
                          controller: _mrpController,
                          keyboardType: TextInputType.number,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: "Discount Type",
                                items: ["Percentage", "Fixed Amount", "None"],
                                prefixIcon: Icons.local_offer,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInputField(
                                label: "Discount",
                                hint: "0.00",
                                prefixIcon: Icons.money_off,
                                controller: _discountController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Profit calculation section
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: accentColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Profit Calculation",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: "Profit Margin (%)",
                          hint: "0.00",
                          prefixIcon: _calculatedProfit < 0
                              ? Icons.trending_down
                              : Icons.trending_up,
                          iconColor: _calculatedProfit < 0
                              ? Colors.red
                              : null,
                          controller: _profitMarginController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Calculated Profit",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "₹${_calculatedProfit.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _calculatedProfit < 0
                                        ? Colors.red
                                        : accentColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Calculate profit based on purchase price and sales price
                      final purchasePrice =
                          double.tryParse(_purchasePriceController.text) ?? 0.0;
                      final salesPrice =
                          double.tryParse(_salesPriceController.text) ?? 0.0;

                      if (purchasePrice > 0 && salesPrice > 0) {
                        setState(() {
                          _calculatedProfit = salesPrice - purchasePrice;

                          // Calculate and set profit margin percentage
                          final profitMargin =
                              (_calculatedProfit / purchasePrice) * 100;
                          _profitMarginController.text =
                              profitMargin.toStringAsFixed(2);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Profit calculated: ₹${_calculatedProfit.toStringAsFixed(2)}'),
                            backgroundColor: _calculatedProfit < 0
                                ? errorColor
                                : accentColor,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please enter valid purchase and sales prices'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text("Calculate Profit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _calculatedProfit < 0 ? errorColor : accentColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      elevation: 2,
                      shadowColor: accentColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Stock content for desktop view
  Widget _buildDesktopStockContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*=================================================================================Stock management section
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                color: Colors.purple,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Stock Management",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildWarehouseDropdown(),
                        _buildInputField(
                          label: "Opening Stock",
                          hint: "10",
                          prefixIcon: Icons.inventory,
                          controller: _openingStockController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Stock alert section
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.warning_amber,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Stock Alerts",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: "Alert Quantity",
                          hint: "0",
                          prefixIcon: Icons.warning,
                          controller: _alertQuantityController,
                          keyboardType: TextInputType.number,
                        ),
                        // SwitchListTile(
                        //   title: const Text("Enable Low Stock Alerts"),
                        //   subtitle:
                        //       const Text("Get notified when stock is low"),
                        //   value: true,
                        //   onChanged: (value) {},
                        //   contentPadding: EdgeInsets.zero,
                        // ),
                      ],
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

  // Original mobile/tablet layout
  Widget _buildMobileTabletLayout(BuildContext context, bool isSmallScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSmallScreen)
          Container(
            width: 300,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildImageSection(),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: "Item Name",
                    hint: "Enter item name",
                    prefixIcon: Icons.inventory,
                    required: true,
                    controller: _itemNameController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Category",
                          items: ["Category 1", "Category 2", "Category 3"],
                          prefixIcon: Icons.category,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBrandDropdown(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(isSmallScreen),
                _buildPricingTab(),
                _buildStockTab(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the Basic Info tab containing general item information
  /// Including: Image, Name, Category, Code, Unit, and Description
  Widget _buildBasicInfoTab(bool isSmallScreen) {
    _logger.d('Building Basic Info tab');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isSmallScreen) ...[
            _buildImageSection(),
            const SizedBox(height: 20),
            _buildInputField(
              label: "Item Name",
              hint: "Enter item name",
              prefixIcon: Icons.inventory,
              required: true,
              controller: _itemNameController,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildStoreDropdown(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCategoryDropdown(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBrandDropdown(),
                ),
              ],
            ),
          ],
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: "SKU",
                  hint: "Enter SKU",
                  prefixIcon: Icons.qr_code,
                  controller: _skuController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: "HSN Code",
                  hint: "Enter HSN code",
                  prefixIcon: Icons.qr_code,
                  controller: _hsnCodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: "Barcode",
                  hint: "Enter barcode number",
                  prefixIcon: Icons.crop_free,
                  controller: _barcodeController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: "Item Code",
                  hint: "Enter item code",
                  prefixIcon: Icons.code,
                  controller: _itemCodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildUnitDropdown(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(), // Empty container for alignment
              ),
            ],
          ),
          _buildInputField(
            label: "Description",
            hint: "Enter item description",
            prefixIcon: Icons.description,
            controller: _descriptionController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Builds the Pricing tab containing purchase and sales information
  /// Including: Purchase Price, Sales Price, and MRP
  Widget _buildPricingTab() {
    _logger.d('Building Pricing tab');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Purchase Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: "Purchase Price",
                    hint: "0.00",
                    prefixIcon: Icons.currency_rupee,
                    controller: _purchasePriceController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Tax Type",
                          items: ["GST", "VAT", "None"],
                          prefixIcon: Icons.receipt_long,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          label: "Tax Rate (%)",
                          hint: "0.00",
                          prefixIcon: Icons.percent,
                          controller: _taxRateController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sales Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: "Sales Price",
                    hint: "0.00",
                    prefixIcon: Icons.currency_rupee,
                    controller: _salesPriceController,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                  _buildInputField(
                    label: "MRP",
                    hint: "0.00",
                    prefixIcon: Icons.currency_rupee,
                    controller: _mrpController,
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: "Discount Type",
                          items: ["Percentage", "Fixed Amount", "None"],
                          prefixIcon: Icons.local_offer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          label: "Discount",
                          hint: "0.00",
                          prefixIcon: Icons.money_off,
                          controller: _discountController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profit Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    label: "Profit Margin (%)",
                    hint: "0.00",
                    prefixIcon: _calculatedProfit < 0
                        ? Icons.trending_down
                        : Icons.trending_up,
                    controller: _profitMarginController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Stock tab containing inventory management information
  /// Including: Warehouse selection, Opening Stock, and Alert Quantity
  Widget _buildStockTab() {
    _logger.d('Building Stock tab');
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildWarehouseDropdown(),
                  _buildInputField(
                    label: "Opening Stock",
                    hint: "0",
                    prefixIcon: Icons.inventory,
                    controller: _openingStockController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildInputField(
                    label: "Alert Quantity",
                    hint: "0",
                    prefixIcon: Icons.warning,
                    controller: _alertQuantityController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows dialog to choose between camera and gallery
  Future<void> _showImageSourceDialog() async {
    _logger.d('Showing image source selection dialog');
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a picture'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handles image selection from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      _logger.d('Picking image from: ${source.toString()}');
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _logger.i('Image selected successfully: ${pickedFile.path}');
        });
      } else {
        _logger.w('No image selected');
      }
    } catch (e) {
      _logger.e('Error picking image: $e');
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // handle selected file
      }
    }
  }

  /// Creates an image upload section with preview functionality
  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFile = null;
                            _logger.d('Image removed');
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: errorColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Text(
                          "Item Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                      color: accentColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Add Item Image",
                    style: TextStyle(
                      color: textPrimaryColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Tap to browse",
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }


  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData prefixIcon,
    IconData? suffixIcon,
    Color? iconColor, 
    required TextEditingController controller,
    bool required = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          _logger.d('$label field changed: $value');
        },
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 13,
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              prefixIcon,
              color: iconColor ??
                  accentColor,
              size: 20,
            ),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: iconColor ??
                      accentColor.withOpacity(
                          0.7), 
                  size: 20,
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(
            color: errorColor,
            fontSize: 12,
          ),
        ),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$label is required'),
                      backgroundColor: Colors.redAccent,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return '$label is required';
                }
                if (keyboardType == TextInputType.number) {
                  if (double.tryParse(value) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter valid number'),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return 'Enter valid number';
                  }
                }
                return null;
              }
            : null,
      ),
    );
  }


  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required IconData prefixIcon,
  }) {
    String? selectedValue;
    void Function(String?) onChanged;

    switch (label) {
      case "Category":
        selectedValue = _selectedCategory;
        onChanged = (value) {
          setState(() {
            _selectedCategory = value;
            _logger.d('$label dropdown changed to: $value');
          });
        };
        break;
      case "Tax Type":
        selectedValue = _selectedTaxType;
        onChanged = (value) {
          setState(() {
            _selectedTaxType = value;
            if (value == "None") {
              _taxRateController.text = "0";
            }
            _logger.d('$label dropdown changed to: $value');
          });
        };
        break;
      case "Discount Type":
        selectedValue = _selectedDiscountType;
        onChanged = (value) {
          setState(() {
            _selectedDiscountType = value;
            if (value == "None") {
              _discountController.text = "0";
            }
            _logger.d('$label dropdown changed to: $value');
          });
        };
        break;
      case "Warehouse":
        selectedValue = _selectedWarehouse;
        onChanged = (value) {
          setState(() {
            _selectedWarehouse = value;
            _logger.d('$label dropdown changed to: $value');
          });
        };
        break;
      default:
        selectedValue = null;
        onChanged = (value) {
          _logger.d('$label dropdown changed to: $value');
        };
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        iconEnabledColor: accentColor.withOpacity(0.7),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              prefixIcon,
              color: accentColor.withOpacity(0.7),
              size: 20,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: accentColor, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        borderRadius: BorderRadius.circular(12),
        dropdownColor: Colors.white,
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textPrimaryColor,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer(
      builder: (context, ref, child) {
        final userNotifier = ref.watch(userProvider.notifier);

        return SizedBox(
          width: 200,
          height: 35,
          child: ElevatedButton(
            onPressed: _isProcessing || _selectedStoreId == null
                ? null
                : () async {
                    setState(() {
                      _isProcessing = true;
                    });

                    if (_formKey.currentState!.validate()) {
                      _logger.i('Form validated successfully - saving item');

                      try {
                        // Validate all required fields before proceeding
                        if (_itemNameController.text.isEmpty) {
                          throw Exception('Item name is required');
                        }

                        if (_barcodeController.text.isNotEmpty &&
                            _barcodeController.text.length != 13) {
                          throw Exception(
                              'Barcode legnth should be 13 characters');
                        }

                        if (_unitController.text.isEmpty) {
                          throw Exception('Unit is required');
                        }
                        if (_purchasePriceController.text.isEmpty) {
                          throw Exception('Purchase price is required');
                        }
                        if (_salesPriceController.text.isEmpty) {
                          throw Exception('Sales price is required');
                        }
                        if (_selectedTaxType == null) {
                          throw Exception('Tax type is required');
                        }
                        if (_taxRateController.text.isEmpty) {
                          throw Exception('Tax rate is required');
                        }
                        if (_selectedWarehouse == null) {
                          throw Exception('Warehouse is required');
                        }

                        // Validate numeric fields
                        final purchasePrice =
                            int.tryParse(_purchasePriceController.text);
                        final salesPrice =
                            int.tryParse(_salesPriceController.text);
                        final taxRate = int.tryParse(_taxRateController.text);
                        final discount = int.tryParse(_discountController.text);
                        final alertQuantity =
                            int.tryParse(_alertQuantityController.text);
                        final profitMargin =
                            double.tryParse(_profitMarginController.text);

                        if (purchasePrice == null || purchasePrice <= 0) {
                          throw Exception('Invalid purchase price');
                        }
                        if (salesPrice == null || salesPrice <= 0) {
                          throw Exception('Invalid sales price');
                        }
                        if (taxRate == null || taxRate < 0) {
                          throw Exception('Invalid tax rate');
                        }
                        if (discount != null && discount < 0) {
                          throw Exception('Discount cannot be negative');
                        }
                        if (alertQuantity != null && alertQuantity < 0) {
                          throw Exception('Alert quantity cannot be negative');
                        }
                        if (profitMargin != null && profitMargin < 0) {
                          throw Exception('Profit margin cannot be negative');
                        }

                        // Log all values before sending

                        final result = await AddItemController(
                          accessToken: (userNotifier.state?.accessToken ?? '')
                              .toString(),
                          userId: userNotifier.state?.user?.id ?? 22,
                          storeId: _selectedStoreId ?? 1,
                          categoryId: _categoryMap[_selectedCategory],
                          brandId: _brandMap[_selectedBrand],
                          itemName: _itemNameController.text,
                          itemImage: _imageFile,
                          sku: _skuController.text,
                          hsnCode: _hsnCodeController.text,
                          itemCode: _itemCodeController.text,
                          barcode: _barcodeController.text,
                          unit: _unitController.text,
                          purchasePrice: purchasePrice,
                          taxType: _selectedTaxType!,
                          taxRate: taxRate,
                          salesPrice: salesPrice,
                          mrp: _mrpController.text,
                          discountType: _selectedDiscountType ?? '',
                          discount: discount ?? 0,
                          profitMargin: profitMargin ?? 0.0,
                          alertQuantity: alertQuantity ?? 0,
                          warehouse: _selectedWarehouse!,
                          openingStock: _openingStockController.text,
                        ).addItemController(context, ref);

                        if (result) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item added successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } else {
                          throw Exception('Failed to add item');
                        }
                      } catch (e, stack) {
                        print(stack);
                        log(e.toString());
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                      }
                    } else {
                      _logger.w('Form validation failed');
                      setState(() {
                        _isProcessing = false;
                      });
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: accentColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isProcessing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Save Item',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// Creates the bottom action bar with save functionality
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSubmitButton(),
          ),
        ],
      ),
    );
  }

  // Add method to load stores
  Future<void> _loadStores() async {
    if (!mounted) return;

    setState(() {
      _isLoadingStores = true;
    });

    try {
      // Get the container from the nearest ProviderScope
      final container = ProviderScope.containerOf(context);
      final user = container.read(userProvider);
      final accessToken = user?.accessToken;

      if (accessToken != null) {
        final storeList =
            await AddCategoryController().getStoreList(accessToken);
        final newMap = <String, int>{};

        // Process store list
        for (var store in storeList) {
          store.forEach((id, name) {
            newMap[name] = id;
          });
        }

        if (mounted) {
          setState(() {
            _storeMap.clear();
            _storeMap.addAll(newMap);

            // Only load categories if we have a selected store
            if (_selectedStoreId != null) {
              _loadCategories();
            }
          });
        }
      }
    } catch (e) {
      _logger.e('Error loading stores: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading stores: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStores = false;
        });
      }
    }
  }

  // Add method to load categories
  Future<void> _loadCategories() async {
    if (!mounted) return;

    setState(() {
      _isLoadingCategories = true;
    });

    try {
      // Get the container from the nearest ProviderScope
      final container = ProviderScope.containerOf(context);
      final user = container.read(userProvider);
      final accessToken = user?.accessToken;

      if (accessToken != null && _selectedStoreId != null) {
        final categories = await viewCategoriesService(
            accessToken, _selectedStoreId.toString());
        final newMap = <String, int>{};

        if (categories.categories != null) {
          for (var category in categories.categories!) {
            if (category.id != null && category.name != null) {
              newMap[category.name!] = category.id!;
            }
          }
        }

        if (mounted) {
          setState(() {
            _categoryMap.clear();
            _categoryMap.addAll(newMap);
          });
        }
      }
    } catch (e, stack) {
      print(stack);
      _logger.e('Error loading categories: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading categories: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  // Add method to load units
  Future<void> _loadUnits() async {
    if (!mounted) return;

    setState(() {
      _isLoadingUnits = true;
    });

    try {
      // Get the container from the nearest ProviderScope
      final container = ProviderScope.containerOf(context);
      final user = container.read(userProvider);
      final accessToken = user?.accessToken;

      if (accessToken != null) {
        final unitList =
            await UnitController(accessToken: accessToken).getUnitData();
        final newMap = <String, int>{};

        if (unitList.data != null) {
          for (var unit in unitList.data!) {
            if (unit.id != null && unit.unitName != null) {
              newMap[unit.unitName!] = unit.id!;
            }
          }
        }

        if (mounted) {
          setState(() {
            _unitMap.clear();
            _unitMap.addAll(newMap);
          });
        }
      }
    } catch (e) {
      _logger.e('Error loading units: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading units: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUnits = false;
        });
      }
    }
  }

  // Add method to load warehouses
  Future<void> _loadWarehouses() async {
    if (!mounted) return;

    setState(() {
      _isLoadingWarehouses = true;
    });

    try {
      final container = ProviderScope.containerOf(context);
      final user = container.read(userProvider);
      final accessToken = user?.accessToken;

      if (accessToken != null) {
        final viewWarehouseController =
            ViewWarehouseController(accessToken: accessToken);
        final warehouseMap =
            await viewWarehouseController.warehouseListController();

        if (mounted) {
          setState(() {
            _warehouseMap.clear();
            _warehouseMap.addAll(warehouseMap);
          });
        }
      }
    } catch (e) {
      _logger.e('Error loading warehouses: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading warehouses: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingWarehouses = false;
        });
      }
    }
  }

  // Update the store dropdown field to trigger category loading
  Widget _buildStoreDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedStore,
        decoration: InputDecoration(
          labelText: 'Select Store',
          labelStyle: const TextStyle(
            color: textSecondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.store,
              color: accentColor.withOpacity(0.85),
              size: 22,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text(
              'Select a Store',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          ..._storeMap.entries.map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )),
        ],
        onChanged: (value) {
          setState(() {
            _selectedStore = value;
            _selectedStoreId = value != null ? _storeMap[value] : null;
            _selectedCategory = null; // Reset category when store changes
            _selectedBrand = null; // Reset brand when store changes
            _logger
                .d('Store selected: $_selectedStore (ID: $_selectedStoreId)');

            // Load categories and brands when store is selected
            if (_selectedStoreId != null) {
              _loadCategories();
              _loadBrands();
            }
          });
        },
        icon: _isLoadingStores
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 26,
                color: accentColor.withOpacity(0.85),
              ),
        iconEnabledColor: accentColor.withOpacity(0.7),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        borderRadius: BorderRadius.circular(16),
        dropdownColor: Colors.white,
        isExpanded: true,
        menuMaxHeight: 300, // Optional: limits dropdown height for better UX
      ),
    );
  }

  // Update the category dropdown field
  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Select Category',
          labelStyle: const TextStyle(
            color: textSecondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.category,
              color: accentColor.withOpacity(0.85),
              size: 22,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: accentColor, width: 2),
          ),
          filled: true,
          fillColor:
              _selectedStoreId == null ? Colors.grey.shade50 : Colors.white,
        ),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text(
              'Select a Category',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          ..._categoryMap.entries.map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )),
        ],
        onChanged: _selectedStoreId == null
            ? null
            : (value) {
                setState(() {
                  _selectedCategory = value;
                  _logger.d(
                      'Category selected: $_selectedCategory (ID: ${value != null ? _categoryMap[value] : null})');
                });
              },
        icon: _isLoadingCategories
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 26,
                color: accentColor.withOpacity(0.85),
              ),
        iconEnabledColor: accentColor.withOpacity(0.7),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _selectedStoreId == null
              ? Colors.grey.shade400
              : textPrimaryColor,
        ),
        borderRadius: BorderRadius.circular(16),
        dropdownColor: Colors.white,
        isExpanded: true,
        hint: Text(
          _selectedStoreId == null
              ? 'Select a store first'
              : 'Select a Category',
          style: TextStyle(
            color: _selectedStoreId == null
                ? Colors.grey.shade400
                : textSecondaryColor,
            fontStyle: FontStyle.italic,
          ),
        ),
        menuMaxHeight: 300, // Optional: limits dropdown height for better UX
      ),
    );
  }

  // Add method to load brands
  Future<void> _loadBrands() async {
    if (!mounted) return;

    setState(() {
      _isLoadingBrands = true;
    });

    try {
      final container = ProviderScope.containerOf(context);
      final user = container.read(userProvider);
      final accessToken = user?.accessToken;

      if (accessToken != null && _selectedStoreId != null) {
        final viewBrandController =
            ViewBrandController(accessToken: accessToken);
        final brandList = await viewBrandController
            .viewBrandByIdController(_selectedStoreId!);
        final newMap = <String, int>{};

        for (var brand in brandList) {
          brand.forEach((name, id) {
            if (name != null && id != null) {
              newMap[name] = int.parse(id);
            }
          });
        }

        if (mounted) {
          setState(() {
            _brandMap.clear();
            _brandMap.addAll(newMap);
          });
        }
      }
    } catch (e) {
      _logger.e('Error loading brands: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading brands: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBrands = false;
        });
      }
    }
  }

  // Add brand dropdown widget
  Widget _buildBrandDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: DropdownButtonFormField<String>(
          value: _selectedBrand,
          decoration: InputDecoration(
            labelText: 'Select Brand',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.business_rounded,
                color: accentColor.withOpacity(0.8),
                size: 22,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            filled: true,
            fillColor:
                _selectedStoreId == null ? Colors.grey.shade100 : Colors.white,
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select a Brand',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            ..._brandMap.entries.map((entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(Icons.business,
                          color: accentColor.withOpacity(0.5), size: 18),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                )),
          ],
          onChanged: _selectedStoreId == null
              ? null
              : (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
          icon: _isLoadingBrands
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                )
              : const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
          iconEnabledColor: accentColor.withOpacity(0.8),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _selectedStoreId == null
                ? Colors.grey.shade400
                : textPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: Text(
            _selectedStoreId == null
                ? 'Select a store first'
                : 'Select a Brand',
            style: TextStyle(
              color: _selectedStoreId == null
                  ? Colors.grey.shade400
                  : textSecondaryColor,
              fontStyle: _selectedStoreId == null
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Add method to build unit dropdown
  Widget _buildUnitDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: DropdownButtonFormField<String>(
          value: _unitController.text.isEmpty ? null : _unitController.text,
          decoration: InputDecoration(
            labelText: 'Select Unit',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.straighten_rounded,
                color: accentColor.withOpacity(0.8),
                size: 22,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select a Unit',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            ..._unitMap.entries.map((entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(Icons.straighten,
                          color: accentColor.withOpacity(0.5), size: 18),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                )),
          ],
          onChanged: (value) {
            setState(() {
              _unitController.text = value ?? '';
              _subUnitController.clear();
              _logger.d('Unit selected: ${_unitController.text}');
            });
          },
          icon: _isLoadingUnits
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                )
              : const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
          iconEnabledColor: accentColor.withOpacity(0.8),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildWarehouseDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: DropdownButtonFormField<String>(
          value: _selectedWarehouse,
          decoration: InputDecoration(
            labelText: 'Select Warehouse',
            labelStyle: const TextStyle(
              color: textSecondaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.warehouse_rounded,
                color: accentColor.withOpacity(0.8),
                size: 22,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: accentColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Select a Warehouse',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            ..._warehouseMap.entries.map((entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(Icons.location_on,
                          color: accentColor.withOpacity(0.5), size: 18),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedWarehouse = value;
              _logger.d('Warehouse selected: $_selectedWarehouse');
            });
          },
          icon: _isLoadingWarehouses
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                )
              : const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
          iconEnabledColor: accentColor.withOpacity(0.8),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          borderRadius: BorderRadius.circular(16),
          dropdownColor: Colors.white,
          isExpanded: true,
        ),
      ),
    );
  }
}

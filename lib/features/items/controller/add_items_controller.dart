import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/core/gloabl_widgets/alerts/app_snackbar.dart';
import 'package:greenbiller/core/utils/common_api_functions_controller.dart';
import 'package:greenbiller/features/items/model/unit_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';

import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:greenbiller/core/colors.dart';

class AddItemController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Services
  late DioClient dioClient;
  late CommonApiFunctionsController commonApi;
  late AuthController authController;
  late DropdownController storeDropdownController;
  late ImagePicker picker;
  final _logger = Logger();

  // Tab state
  late TabController tabController;
  RxInt currentIndex = 0.obs;

  // Reactive state
  final RxInt userId = 0.obs;
  final isProcessing = false.obs;

  // final selectedTaxType = Rxn<String>();
  final selectedTaxRate = Rxn<String>();
  final selectedDiscountType = Rxn<String>();
  final calculatedProfit = 0.0.obs;

  final importedFile = Rxn<Map<String, dynamic>>();
  final imageFile = Rxn<File>();
  final isLoadingCategories = false.obs;
  final isLoadingUnits = false.obs;
  final isLoadingBrands = false.obs;
  final isLoadingWarehouses = false.obs;

  final taxMap = <String, double>{}.obs; // tax_name -> tax value
  final taxRateList = <String>[].obs; // dropdown options
  final List<String> taxTypeList = ['Inclusive Tax', 'Exclusive Tax'];
  final selectedTaxType = 'Exclusive Tax'.obs;
  final unitList = <UnitItem>[].obs;
  final selectedUnit = Rxn<UnitItem>();
  final selectedSubUnit = Rxn<UnitItem>();
  final subUnitValueText = ''.obs;
  final isShowSubUnit = false.obs;
  late TextEditingController unitValueController;

  // Form controllers
  late TextEditingController itemNameController;
  late TextEditingController brandController;
  late TextEditingController skuController;
  late TextEditingController hsnCodeController;
  late TextEditingController itemCodeController;
  late TextEditingController barcodeController;

  late TextEditingController descriptionController;
  late TextEditingController purchasePriceController;
  late TextEditingController wholesalePriceController;

  late TextEditingController salesPriceController;
  late TextEditingController mrpController;
  late TextEditingController discountController;
  late TextEditingController profitMarginController;
  late TextEditingController openingStockController;
  late TextEditingController alertQuantityController;
  late TextEditingController subUnitController;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    commonApi = CommonApiFunctionsController();
    authController = Get.find<AuthController>();
    storeDropdownController = Get.find<DropdownController>();
    picker = ImagePicker();
    userId.value = authController.user.value?.userId ?? 0;
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentIndex.value = tabController.index;
      }
    });

    // Init controllers
    itemNameController = TextEditingController();
    brandController = TextEditingController();
    skuController = TextEditingController();
    hsnCodeController = TextEditingController();
    itemCodeController = TextEditingController();
    barcodeController = TextEditingController();

    descriptionController = TextEditingController();
    purchasePriceController = TextEditingController();

    salesPriceController = TextEditingController();
    mrpController = TextEditingController();
    discountController = TextEditingController();
    profitMarginController = TextEditingController();
    openingStockController = TextEditingController();
    alertQuantityController = TextEditingController();
    subUnitController = TextEditingController();
    unitValueController = TextEditingController();
    wholesalePriceController = TextEditingController(text: '0.0');
    subUnitController.addListener(() {
      subUnitValueText.value = subUnitController.text;
    });
    loadAwaitData();
    loadTaxList();
    loadUnits();
  }

  @override
  void onClose() {
    _logger.d('Disposing AddItemController');
    tabController.dispose();
    itemNameController.dispose();
    brandController.dispose();
    skuController.dispose();
    hsnCodeController.dispose();
    itemCodeController.dispose();
    barcodeController.dispose();

    descriptionController.dispose();
    purchasePriceController.dispose();

    salesPriceController.dispose();
    mrpController.dispose();
    discountController.dispose();
    profitMarginController.dispose();
    openingStockController.dispose();
    alertQuantityController.dispose();
    subUnitController.dispose();
    wholesalePriceController.dispose();
    super.onClose();
  }

  Future<void> loadUnits() async {
    final unitModel = await commonApi.viewUnit();
    unitList.assignAll(unitModel.data ?? []);
  }

  Future<void> loadAwaitData() async {
    await storeDropdownController.loadStores();
    await storeDropdownController.loadUnits();
  }

  Future<void> loadTaxList() async {
    try {
      final taxes = await commonApi.fetchTaxList();
      taxMap.clear();
      taxRateList.clear();

      // Always append "None"
      taxMap["None"] = 0;
      taxRateList.add("None");

      for (final tax in taxes) {
        final name = tax['tax_name'] as String;
        final value = double.tryParse(tax['tax'].toString()) ?? 0;
        taxMap[name] = value;
        taxRateList.add(name);
      }
    } catch (e) {
      _logger.e("Error loading tax list: $e");
    }
  }

  Future<void> pickFile() async {
    try {
      _logger.d('Opening file picker for Excel/CSV');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final file = File(filePath);
        if (await file.exists()) {
          importedFile.value = {'name': result.files.single.name, 'file': file};
          _logger.i(
            'File selected: ${importedFile.value!['name']} at path: $filePath',
          );
        } else {
          _logger.w('File does not exist at path: $filePath');
          AppSnackbar.show(
            title: 'Error',
            message: 'Selected file does not exist',
            color: Colors.red,
            icon: Icons.error_outline,
          );
        }
      } else {
        _logger.w('No file selected');
        AppSnackbar.show(
          title: 'Error',
          message: 'No file selected',
          color: Colors.red,
          icon: Icons.error_outline,
        );
      }
    } catch (e, stackTrace) {
      _logger.e('Error picking file: $e', stackTrace);
      AppSnackbar.show(
        title: 'Error',
        message: 'Error selecting file: $e',
        color: Colors.red,
        icon: Icons.error_outline,
      );
    }
  }

  Future<void> openFile() async {
    if (importedFile.value != null && importedFile.value!['file'] != null) {
      try {
        final file = importedFile.value!['file'] as File;
        final filePath = file.path;
        _logger.d(
          'Attempting to open file: ${importedFile.value!['name']} at path: $filePath',
        );

        if (await file.exists()) {
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            _logger.w('Failed to open file: ${result.message}');
            AppSnackbar.show(
              title: 'Error',
              message: 'Failed to open file: ${result.message}',
              color: Colors.red,
              icon: Icons.error_outline,
            );
          } else {
            _logger.i(
              'File opened successfully: ${importedFile.value!['name']}',
            );
          }
        } else {
          _logger.w('File does not exist at path: $filePath');
          AppSnackbar.show(
            title: 'Error',
            message: 'File does not exist',
            color: Colors.red,
            icon: Icons.error_outline,
          );
        }
      } catch (e, stackTrace) {
        _logger.e('Error opening file: $e', stackTrace);
        AppSnackbar.show(
          title: 'Error',
          message: 'Error opening file: $e',
          color: Colors.red,
          icon: Icons.error_outline,
        );
      }
    } else {
      _logger.w('No file to open');
      AppSnackbar.show(
        title: 'Error',
        message: 'No file selected to open',
        color: Colors.red,
        icon: Icons.error_outline,
      );
    }
  }

  void genereateItemCode(val) {
    final unixTime = DateTime.now().millisecondsSinceEpoch;
    itemCodeController.text = "ST-$val-Item-$unixTime";
  }

  Future<bool> addItem(GlobalKey<FormState> formKey) async {
    isProcessing.value = true;

    try {
      if (formKey.currentState!.validate()) {
       
        if (skuController.text.isNotEmpty) {
          if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(skuController.text)) {
            throw Exception(
              'SKU must be alphanumeric (letters, numbers, _ or -)',
            );
          }
        }

        if (hsnCodeController.text.isNotEmpty) {
          if (!RegExp(r'^\d{4,8}$').hasMatch(hsnCodeController.text)) {
            throw Exception('HSN code must be 4–8 digits');
          }
        }

        if (itemCodeController.text.isNotEmpty) {
          if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(itemCodeController.text)) {
            throw Exception(
              'Item code must be alphanumeric (letters, numbers, _ or -)',
            );
          }
        }

        if (barcodeController.text.isNotEmpty) {
          if (barcodeController.text.length < 6) {
            throw Exception('Barcode must be at least 6 characters');
          }
          if (!barcodeController.text.runes.every((c) => c >= 0 && c <= 127)) {
            throw Exception(
              'Barcode must contain only ASCII characters (Code128)',
            );
          }
        }
        if (itemCodeController.text.isEmpty) {
          throw Exception('Item-Code is required');
        }
        if (selectedUnit.value == null) {
          throw Exception('Unit is required');
        }
        if (isShowSubUnit.value) {
          if (selectedSubUnit.value == null) {
            throw Exception('Subunit is required');
          }
          if (subUnitController.text.isEmpty ||
              double.tryParse(subUnitController.text) == null ||
              double.parse(subUnitController.text) <= 0) {
            throw Exception('Valid subunit value is required');
          }
        }

        if (purchasePriceController.text.isEmpty) {
          throw Exception('Purchase price is required');
        }

        if (salesPriceController.text.isEmpty) {
          throw Exception('Sales price is required');
        }
        if (selectedTaxType.value.isEmpty) {
          throw Exception('Tax type is required');
        }
        if (selectedTaxRate.value == null || selectedTaxRate.value!.isEmpty) {
          throw Exception('Tax rate is required');
        }
        if (openingStockController.text.isEmpty) {
          throw Exception('Opening Stock is required');
        }
        if (storeDropdownController.selectedStoreId.value == null) {
          throw Exception('Warehouse is required');
        }
        if (itemNameController.text.isEmpty) {
          throw Exception('Item name is required');
        }

        final purchasePrice = double.tryParse(purchasePriceController.text);
        final salesPrice = double.tryParse(salesPriceController.text);
        final taxRate = taxMap[selectedTaxRate.value];
        final wholeSalePrice = double.tryParse(wholesalePriceController.text);
        final discount = double.tryParse(discountController.text);
        final alertQuantity = int.tryParse(alertQuantityController.text);
        final profitMargin = double.tryParse(profitMarginController.text);

        if (purchasePrice == null || purchasePrice <= 0) {
          throw Exception('Invalid purchase price');
        }
        if (salesPrice == null || salesPrice <= 0) {
          throw Exception('Invalid sales price');
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
        print(selectedUnit.value!.id.toString());
        final formData = dio.FormData.fromMap({
          'store_id': storeDropdownController.selectedStoreId.value.toString(),
          'user_id': userId.value.toString(),
          'category_id': storeDropdownController.selectedCategoryId.value
              .toString(),
          'brand_id': storeDropdownController.selectedBrandId.toString(),
          'item_name': itemNameController.text,
          'SKU': skuController.text,
          'HSN_code': hsnCodeController.text,
          'Item_code': itemCodeController.text,
          'Barcode': barcodeController.text,
          'unit_id': selectedUnit.value!.id.toString(),
          'subunit_id': isShowSubUnit.value
              ? (selectedSubUnit.value?.id ?? 0)
              : null,
          'subunit_value': isShowSubUnit.value ? subUnitController.text : null,
          'Purchase_price': purchasePrice.toString(),
          'Tax_type': selectedTaxType.value,
          'Tax_rate': taxRate.toString(),
          'Sales_Price': salesPrice.toString(),
          'MRP': mrpController.text,
          'Discount_type': selectedDiscountType.value ?? '',
          'Discount': discount?.toString() ?? '0',
          'Profit_margin': profitMargin?.toString() ?? '0.0',
          'Warehouse': storeDropdownController.selectedWarehouseId.value
              .toString(),
          'Opening_Stock': openingStockController.text,
          'Alert_Quantity': alertQuantity?.toString() ?? '0',
          'wholesale_price': wholeSalePrice.toString(),
        });

        if (imageFile.value != null) {
          formData.files.add(
            MapEntry(
              'item_image',
              await dio.MultipartFile.fromFile(imageFile.value!.path),
            ),
          );
        }

        final response = await dioClient.dio.post(addItemUrl, data: formData);

        if (response.statusCode == 201) {
          AppSnackbar.show(
            title: 'Success',
            message: response.data['message'] ?? 'Item added successfully',
            color: Colors.green,
            icon: Icons.error_outline,
          );
          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
          });
          return true;
        } else {
          throw Exception(response.data['message'] ?? 'Failed to add item');
        }
      } else {
        _logger.w('Form validation failed');
        return false;
      }
    } catch (e, stackTrace) {
      _logger.e('Error adding item: $e');
      AppSnackbar.show(
        title: 'Error',
        message: 'Error: $e',
        color: Colors.red,
        icon: Icons.error_outline,
      );
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  void calculateProfit() {
    final purchasePrice = double.tryParse(purchasePriceController.text) ?? 0.0;
    final salesPrice = double.tryParse(salesPriceController.text) ?? 0.0;

    if (purchasePrice > 0 && salesPrice > 0) {
      calculatedProfit.value = salesPrice - purchasePrice;
      final profitMargin = (calculatedProfit.value / purchasePrice) * 100;
      profitMarginController.text = profitMargin.toStringAsFixed(2);
      AppSnackbar.show(
        title: 'Profit Calculated',
        message: 'Profit: ₹${calculatedProfit.value.toStringAsFixed(2)}',
        color: calculatedProfit.value < 0 ? errorColor : accentColor,
        icon: calculatedProfit.value < 0
            ? Icons.error_outline
            : Icons.analytics,
      );
    } else {
      AppSnackbar.show(
        title: 'Error',
        message: 'Please enter valid purchase and sales prices',
        color: Colors.red,
        icon: Icons.error_outline,
      );
    }
  }
}

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
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

  final selectedTaxType = Rxn<String>();
  final selectedDiscountType = Rxn<String>();
  final calculatedProfit = 0.0.obs;

  final importedFile = Rxn<Map<String, dynamic>>();
  final imageFile = Rxn<File>();
  final isLoadingCategories = false.obs;
  final isLoadingUnits = false.obs;
  final isLoadingBrands = false.obs;
  final isLoadingWarehouses = false.obs;

  final taxMap = <String, double>{}.obs; // tax_name -> tax value
  final taxList = <String>[].obs; // dropdown options
  final unitList = <UnitItem>[].obs;
  final selectedUnit = Rxn<UnitItem>();
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
  late TextEditingController taxRateController;
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
    taxRateController = TextEditingController();
    salesPriceController = TextEditingController();
    mrpController = TextEditingController();
    discountController = TextEditingController();
    profitMarginController = TextEditingController();
    openingStockController = TextEditingController();
    alertQuantityController = TextEditingController();
    subUnitController = TextEditingController();
    unitValueController = TextEditingController();
    wholesalePriceController = TextEditingController(text: '0.0');

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
    taxRateController.dispose();
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
      taxList.clear();

      // Always append "None"
      taxMap["None"] = 0;
      taxList.add("None");

      for (final tax in taxes) {
        final name = tax['tax_name'] as String;
        final value = double.tryParse(tax['tax'].toString()) ?? 0;
        taxMap[name] = value;
        taxList.add(name);
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
          Get.snackbar(
            'Error',
            'Selected file does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        _logger.w('No file selected');
        Get.snackbar(
          'Error',
          'No file selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      _logger.e('Error picking file: $e', stackTrace);
      Get.snackbar(
        'Error',
        'Error selecting file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
            Get.snackbar(
              'Error',
              'Failed to open file: ${result.message}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            _logger.i(
              'File opened successfully: ${importedFile.value!['name']}',
            );
          }
        } else {
          _logger.w('File does not exist at path: $filePath');
          Get.snackbar(
            'Error',
            'File does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e, stackTrace) {
        _logger.e('Error opening file: $e', stackTrace);
        Get.snackbar(
          'Error',
          'Error opening file: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      _logger.w('No file to open');
      Get.snackbar(
        'Error',
        'No file selected to open',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> addItem(GlobalKey<FormState> formKey) async {
    isProcessing.value = true;
    try {
      if (formKey.currentState!.validate()) {
        if (itemNameController.text.isEmpty) {
          throw Exception('Item name is required');
        }
        if (barcodeController.text.isNotEmpty &&
            barcodeController.text.length != 13) {
          throw Exception('Barcode length should be 13 characters');
        }
        if (selectedUnit.value == null) {
          throw Exception('Unit is required');
        }
        if (subUnitController.text.isEmpty) {
          throw Exception('SubUnit is required');
        }
        if (purchasePriceController.text.isEmpty) {
          throw Exception('Purchase price is required');
        }
        if (wholesalePriceController.text.isEmpty) {
          throw Exception('Wholesale price is required');
        }
        if (salesPriceController.text.isEmpty) {
          throw Exception('Sales price is required');
        }
        if (selectedTaxType.value == null) {
          throw Exception('Tax type is required');
        }
        if (taxRateController.text.isEmpty) {
          throw Exception('Tax rate is required');
        }

        if (storeDropdownController.selectedStoreId.value == null) {
          throw Exception('Warehouse is required');
        }

        final purchasePrice = double.tryParse(purchasePriceController.text);
        final salesPrice = double.tryParse(salesPriceController.text);
        final taxRate = double.tryParse(taxRateController.text);
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
          'Unit': selectedUnit.value?.id ?? 0,
          'Sub_unit': subUnitController.text.toString(),
          'Purchase_price': purchasePrice.toString(),
          'Tax_type': selectedTaxType.value!,
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
          Get.snackbar(
            'Success',
            response.data['message'] ?? 'Item added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
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
      Get.snackbar(
        'Error',
        'Error: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
      Get.snackbar(
        'Profit Calculated',
        'Profit: ₹${calculatedProfit.value.toStringAsFixed(2)}',
        backgroundColor: calculatedProfit.value < 0 ? errorColor : accentColor,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please enter valid purchase and sales prices',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/api_constants.dart';
import 'package:greenbiller/core/app_handler/dio_client.dart';
import 'package:greenbiller/core/app_handler/dropdown_controller.dart';
import 'package:greenbiller/features/auth/controller/auth_controller.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class BulkUpdateImportController extends GetxController {
  // Services
  late DioClient dioClient;
  late AuthController authController;
  late Logger logger;
  late DropdownController storeDropdownController;

  final Rxn<Map<String, dynamic>> importedFile = Rxn<Map<String, dynamic>>();
  final selectedStoreIdForFileUpload = Rxn<int>();
  final RxBool isProcessing = false.obs;
  final recentUploadResult = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    dioClient = DioClient();
    authController = Get.find<AuthController>();
    logger = Logger();
    storeDropdownController = Get.find<DropdownController>();
    storeDropdownController.loadStores();
    storeDropdownController.selectedStoreId.value = null;
  }

  Future<void> pickFile() async {
    selectedStoreIdForFileUpload.value = null;
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Excel/CSV files',
        extensions: ['csv', 'xls', 'xlsx'], // desktop
        mimeTypes: [
          'text/csv',
          'application/vnd.ms-excel',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ], // mobile/web
        uniformTypeIdentifiers: ['public.comma-separated-values-text'], // Apple
        webWildCards: ['.csv', '.xls', '.xlsx'], // Web
      );
      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
        confirmButtonText: "Select upload file",
      );
      // #enddocregion SingleOpen
      if (result == null) {
        // Operation was canceled by the user.
        return;
      }
      if (result.path.isNotEmpty) {
        final filePath = result.path;
        final file = File(filePath);
        if (await file.exists()) {
          importedFile.value = {'name': result.path, 'file': file};
        } else {
          Get.snackbar(
            'Error',
            'Selected file does not exist',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'No file selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error selecting file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadSelectedFile() async {
    try {
      if (importedFile.value != null && importedFile.value!['file'] != null) {
        final file = importedFile.value!['file'] as File;
        print("Trying to open: ${file.absolute.path}");

        if (await file.exists()) {
          final result = await OpenFile.open(
            file.absolute.path,
            // Pick ONE depending on your Linux setup
            linuxUseGio: true, // try gio first
            linuxByProcess: false, // disable process method
          );

          if (result.type != ResultType.done) {
            Get.snackbar(
              'Error',
              'Failed to open file: ${result.message}',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'File not found',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'No file selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Exception: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> processImportedFile() async {
    if (importedFile.value == null || isProcessing.value) return;
    print(selectedStoreIdForFileUpload.value);
    isProcessing.value = true;
    try {
      if (selectedStoreIdForFileUpload.value == null) {
        Get.snackbar(
          'Error',
          'Please select a store before importing',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final file = importedFile.value!['file'] as File;
      final formData = dio.FormData.fromMap({
        'store_id': selectedStoreIdForFileUpload.value,
        'file': await dio.MultipartFile.fromFile(
          file.path,
          filename: importedFile.value!['name'],
        ),
      });

      final response = await dioClient.dio.post(bulkItemUpdate, data: formData);

      if (response.statusCode == 201 && response.data['status'] == true) {
        recentUploadResult.value = Map<String, dynamic>.from(response.data);
;
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Items imported successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        importedFile.value = null;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to import items');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error importing items: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> downloadTemplate() async {
    try {
      final response = await dioClient.dio.get(
        sampleCategoryExcellTemplateUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/brand_bulk_template.xlsx');
        await file.writeAsBytes(response.data);
        Get.snackbar(
          'Success',
          'Template downloaded: ${file.path}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await OpenFile.open(file.path);
      } else {
        throw Exception('Failed to download template');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download template: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

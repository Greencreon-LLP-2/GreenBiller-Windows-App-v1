import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/dropdowns/custom_dropdown.dart';
import 'package:greenbiller/features/utilities/controller/bulk_update_import_controller.dart';

class BulkUpdatePage extends GetView<BulkUpdateImportController> {
  const BulkUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.category, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Bulk Update',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STEP 1: Download Template
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Icon(Icons.download, color: accentColor, size: 32),
                  title: const Text(
                    "Download Template",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    "Get the Excel/CSV format to fill your items",
                  ),
                  trailing: ElevatedButton(
                    onPressed: controller.downloadTemplate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Download"),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // STEP 2: Upload File
              Obx(() {
                final fileData = controller.importedFile.value;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: fileData == null
                        ? Row(
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: accentColor,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Upload File",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Choose your Excel/CSV file to import",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: controller.pickFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Upload"),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Selected File",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fileData['name'] ?? '',
                                      style: const TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: accentColor,
                                    ),
                                    onPressed: controller.loadSelectedFile,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        controller.importedFile.value = null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // STEP 3: Select Store & Process
              Obx(() {
                if (controller.importedFile.value == null) {
                  return const SizedBox.shrink();
                }
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        AppDropdown(
                          label: "Select Store",
                          placeHolderText: "Choose store to upload",
                          selectedValue: controller
                              .storeDropdownController
                              .selectedStoreId,
                          options: controller.storeDropdownController.storeMap,
                          isLoading: controller
                              .storeDropdownController
                              .isLoadingStores,
                          onChanged: (val) =>
                              controller.selectedStoreIdForFileUpload.value =
                                  val,
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => ElevatedButton.icon(
                            onPressed: controller.isProcessing.value
                                ? null
                                : controller.processImportedFile,
                            icon: controller.isProcessing.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.cloud_upload),
                            label: const Text("Process File"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // STEP 4: Show Upload Result
              Obx(() {
                if (controller.recentUploadResult.isEmpty) {
                  return const SizedBox.shrink();
                }
                final result = controller.recentUploadResult;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                result['message'] ?? 'Upload Completed',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Inserted: ${result['inserted_count'] ?? 0}"),
                            Text("Skipped: ${result['skipped_count'] ?? 0}"),
                          ],
                        ),
                        if ((result['skipped'] as List).isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            "Skipped Items:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          ...List.generate(
                            (result['skipped'] as List).length,
                            (i) => Text("- ${result['skipped'][i]}"),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

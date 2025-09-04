import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/core/gloabl_widgets/text_fields/text_field_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddStoreDialog extends GetView<AddStoreController> {
  final VoidCallback? callback;

  const AddStoreDialog({super.key, this.callback});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: textPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.store, color: textPrimaryColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Add New Store',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Obx(() => InkWell(
                            onTap: () => controller.pickImage(),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: textLightColor, width: 1),
                                image: controller.storeImage.value != null
                                    ? DecorationImage(
                                        image: FileImage(File(controller.storeImage.value!)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: controller.storeImage.value == null
                                  ? const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate_outlined,
                                            size: 32, color: textSecondaryColor),
                                        SizedBox(height: 8),
                                        Text(
                                          'Add Logo',
                                          style: TextStyle(
                                            color: textSecondaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          )),
                      const SizedBox(height: 8),
                      const Text(
                        'Recommended size: 200x200px',
                        style: TextStyle(color: textSecondaryColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextfieldWidget(
                  label: 'Store Name',
                  hint: 'Enter store name',
                  controller: controller.storeNameController,
                  icon: Icons.store_outlined,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  label: 'Website',
                  hint: 'Enter Website name',
                  icon: Icons.web,
                  controller: controller.storeWebsiteController,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  label: 'Address',
                  hint: 'Enter Store Address',
                  icon: Icons.location_city_sharp,
                  controller: controller.storeAddressController,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  label: 'Phone',
                  hint: 'Enter Store Phone Number',
                  icon: Icons.call,
                  controller: controller.storePhoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextfieldWidget(
                  label: 'Email',
                  hint: 'Enter Store Email',
                  icon: Icons.mail_outline,
                  controller: controller.storeEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: textSecondaryColor)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => controller.addStore(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Add Store', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddStoreController extends GetxController {
  final storeNameController = TextEditingController();
  final storeWebsiteController = TextEditingController();
  final storeAddressController = TextEditingController();
  final storePhoneController = TextEditingController();
  final storeEmailController = TextEditingController();
  final storeImage = Rxn<String>();
  final formKey = GlobalKey<FormState>();


  @override
  void onInit() {
    super.onInit();
   
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        storeImage.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error picking image: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void addStore() async {
    if (storeNameController.text.isEmpty) {
      Get.snackbar('Error', 'Store name is required', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(storePhoneController.text)) {
      Get.snackbar('Error', 'Invalid phone number (10 digits required)', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(storeEmailController.text)) {
      Get.snackbar('Error', 'Invalid email address', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    
    if (storeImage.value == null) {
      Get.snackbar('Error', 'Please select an image', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // final file = File(storeImage.value!);
      // final response = await addStoreService(
      //   user.value!.accessToken!,
      //   user.value!.user!.id.toString(),
      //   'store-${DateTime.now().millisecondsSinceEpoch}',
      //   file,
      //   storeNameController.text,
      //   storeWebsiteController.text,
      //   storeAddressController.text,
      //   storePhoneController.text,
      //   storeEmailController.text,
      // );
      // if (response == 'Store added successfully') {
      //   Get.snackbar('Success', 'Store added successfully', backgroundColor: Colors.green, colorText: Colors.white);
      //   // Get.find<ViewStoreController>().fetchStores();
      //   Get.back();
      // } else {
      //   Get.snackbar('Error', 'Failed to add store: $response', backgroundColor: Colors.red, colorText: Colors.white);
      // }
    } catch (e) {
      Get.snackbar('Error', 'Error: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    storeNameController.dispose();
    storeWebsiteController.dispose();
    storeAddressController.dispose();
    storePhoneController.dispose();
    storeEmailController.dispose();
    super.onClose();
  }
}
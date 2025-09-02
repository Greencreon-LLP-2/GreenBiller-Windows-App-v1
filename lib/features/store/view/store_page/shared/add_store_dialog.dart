// Add this new widget class
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/view/widgets/textfield_widget.dart';
import 'package:green_biller/features/store/services/add_store_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddStoreDialog extends HookConsumerWidget {
  VoidCallback? callback;
  AddStoreDialog({super.key, required this.callback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = useState<File?>(null);
    final signatureImage = useState<File?>(null);
    final hasChanges = useState(false);
    final picker = ImagePicker();

    // Text controllers
    final storeNameController = useTextEditingController();
    final storeWebsiteController = useTextEditingController();
    final storeAddressController = useTextEditingController();
    final storePhoneController = useTextEditingController();
    final storeEmailController = useTextEditingController();
    final storeImage = useState<String?>(null);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Get user data
    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;

    // Snackbar helper
    void showSnackBar(String message, Color color) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
    }

    // Pick image method
    Future<void> pickImage({required bool isProfile}) async {
      try {
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );
        if (pickedFile != null) {
          if (isProfile) {
            profileImage.value = File(pickedFile.path);
          } else {
            signatureImage.value = File(pickedFile.path);
            storeImage.value = pickedFile.path; // Store image path
          }
          hasChanges.value = true;
        }
      } catch (e) {
        showSnackBar('Error picking image: $e', Colors.red);
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: textPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.store,
                        color: textPrimaryColor, size: 24),
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

              // Logo Upload Section
              Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => pickImage(isProfile: false),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: textLightColor, width: 1),
                          image: storeImage.value != null
                              ? DecorationImage(
                                  image: FileImage(File(storeImage.value!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: storeImage.value == null
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
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Recommended size: 200x200px',
                      style: TextStyle(color: textSecondaryColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Store Name
              TextfieldWidget(
                label: 'Store Name',
                hint: 'Enter store name',
                controller: storeNameController,
                icon: Icons.store_outlined,
                isRequired: true,
              ),

              const SizedBox(height: 16),

              // Website
              TextfieldWidget(
                label: 'Website',
                hint: 'Enter Website name ',
                icon: Icons.web,
                controller: storeWebsiteController,
              ),
              const SizedBox(height: 16),

              // Address
              TextfieldWidget(
                label: 'Address',
                hint: "Enter Store Address",
                icon: Icons.location_city_sharp,
                controller: storeAddressController,
              ),

              const SizedBox(height: 16),

              // Phone
              TextfieldWidget(
                label: 'Phone',
                hint: 'Enter Store Phone Number',
                icon: Icons.call,
                controller: storePhoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email
              TextfieldWidget(
                label: 'Email',
                hint: 'Enter Store Email',
                icon: Icons.mail_outline,
                controller: storeEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: textSecondaryColor)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      // Validate inputs with early returns
                      if (storeNameController.text.isEmpty) {
                        showSnackBar('Store name is required', Colors.red);
                        return; // Stop execution
                      }

                      if (!RegExp(r'^[0-9]{10}$')
                          .hasMatch(storePhoneController.text)) {
                        showSnackBar(
                            'Invalid phone number (10 digits required)',
                            Colors.red);
                        return; // Stop execution
                      }

                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                          .hasMatch(storeEmailController.text)) {
                        showSnackBar("Invalid email address", Colors.red);
                        return; // Stop execution
                      }

                      if (accessToken == null || userModel?.user?.id == null) {
                        showSnackBar('Please login first', Colors.red);
                        return; // Stop execution
                      }

                      if (storeImage.value == null) {
                        showSnackBar('Please select an image', Colors.red);
                        return; // Stop execution
                      }

                      final file = File(storeImage.value!);

                      try {
                        final response = await addStoreService(
                          accessToken,
                          userModel!.user!.id.toString(),
                          'store-${DateTime.now().millisecondsSinceEpoch}',
                          file,
                          storeNameController.text,
                          storeWebsiteController.text,
                          storeAddressController.text,
                          storePhoneController.text,
                          storeEmailController.text,
                        );

                        if (response == 'Store added successfully') {
                          showSnackBar(
                              'Store added successfully', Colors.green);
                          // Refresh store data
                          callback?.call();
                          Navigator.pop(context);
                        } else {
                          showSnackBar(
                              'Failed to add store: $response', Colors.red);
                        }
                      } catch (e) {
                        showSnackBar('Error: ${e.toString()}', Colors.red);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Add Store',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

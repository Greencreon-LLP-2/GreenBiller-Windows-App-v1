import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/features/sales/view/widgets/textfield_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddStoreDialog extends HookConsumerWidget {
  final VoidCallback? callback;
  const AddStoreDialog({super.key, required this.callback});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileImage = useState<File?>(null);
    final signatureImage = useState<File?>(null);
    final hasChanges = useState(false);
    final picker = ImagePicker();

    // Controllers (keep as-is ✅)
    final storeNameController = useTextEditingController();
    final storeWebsiteController = useTextEditingController();
    final storeAddressController = useTextEditingController();
    final storePhoneController = useTextEditingController();
    final storeEmailController = useTextEditingController();
    final storeImage = useState<String?>(null);

    final userModel = ref.watch(userProvider);
    final accessToken = userModel?.accessToken;

    void showSnackBar(String message, Color color) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
    }

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
            storeImage.value = pickedFile.path;
          }
          hasChanges.value = true;
        }
      } catch (e) {
        showSnackBar('Error picking image: $e', Colors.red);
      }
    }

    // ✅ Correct: return a Dialog widget, not a showDialog function
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Store",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Store Logo
            InkWell(
              onTap: () => pickImage(isProfile: false),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: textLightColor),
                  image: storeImage.value != null
                      ? DecorationImage(
                          image: FileImage(File(storeImage.value!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: storeImage.value == null
                    ? const Icon(Icons.add_a_photo, size: 32, color: Colors.grey)
                    : null,
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
              hint: 'Enter Website',
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

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (storeNameController.text.isEmpty) {
                      showSnackBar('Store name is required', Colors.red);
                      return;
                    }
                    // TODO: Add validation + API call
                    showSnackBar("Store Added!", Colors.green);
                    callback?.call();
                    Navigator.pop(context);
                  },
                  child: const Text("Add Store"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

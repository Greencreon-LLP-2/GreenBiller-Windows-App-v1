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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 460, // ✅ reduced width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER (accentColor background)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    "Add New Store",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  )
                ],
              ),
            ),

            /// BODY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Store Logo
                  const Text("Store Logo",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => pickImage(isProfile: true),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: storeImage.value == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_camera_outlined,
                                      size: 26, color: Colors.grey),
                                  const SizedBox(height: 4),
                                  Text("Pick Photo",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(File(storeImage.value!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  /// Store Information
                  const Text("Store Information",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildTextField(Icons.store_outlined, "Store Name",
                      controller: storeNameController),
                  _buildTextField(Icons.web, "Website",
                      controller: storeWebsiteController),
                  _buildTextField(Icons.location_city, "Address",
                      controller: storeAddressController),
                  _buildTextField(Icons.phone, "Phone",
                      controller: storePhoneController,
                      keyboardType: TextInputType.phone),
                  _buildTextField(Icons.email_outlined, "Email",
                      controller: storeEmailController,
                      keyboardType: TextInputType.emailAddress),
                ],
              ),
            ),

            /// FOOTER BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    icon: const Icon(Icons.close, color: Colors.white, size: 16),
                    label: const Text("Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Add store logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    icon: const Icon(Icons.save, size: 16, color: Colors.white),
                    label: const Text("Add Store",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint,
      {TextEditingController? controller, TextInputType? keyboardType}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: accentColor, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

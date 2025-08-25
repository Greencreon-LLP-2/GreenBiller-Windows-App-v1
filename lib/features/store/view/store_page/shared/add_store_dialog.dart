import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/auth/login/model/user_model.dart';
import 'package:green_biller/utils/dialog.dart';
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

    // Controllers
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

    // ✅ Show custom dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomEditDialog(
        context: context,
        title: 'Add New Store',
        subtitle: 'Enter store details below',
        sections: [
          // 👆 Store Logo section first
          DialogSection(
            title: 'Store Logo',
            icon: Icons.image_outlined,
            fields: [
              DialogField(
                label: 'Upload Logo',
                icon: Icons.add_a_photo,
                fieldType: FieldType.imagePicker,
              ),
            ],
          ),

          // Store Information
          DialogSection(
            title: 'Store Information',
            icon: Icons.store,
            fields: [
              DialogField(
                label: 'Store Name',
                icon: Icons.store_outlined,
                controller: storeNameController,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Required' : null,
              ),
              DialogField(
                label: 'Website',
                icon: Icons.web,
                controller: storeWebsiteController,
                keyboardType: TextInputType.url,
              ),
              DialogField(
                label: 'Address',
                icon: Icons.location_city_outlined,
                controller: storeAddressController,
                maxLines: 2,
              ),
              DialogField(
                label: 'Phone',
                icon: Icons.phone_outlined,
                controller: storePhoneController,
                keyboardType: TextInputType.phone,
              ),
              DialogField(
                label: 'Email',
                icon: Icons.email_outlined,
                controller: storeEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ],
        onSave: () async {
          if (storeNameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Store name is required'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // TODO: API call
          showSnackBar("Store Added!", Colors.green);
          callback?.call();
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
        saveButtonText: 'Add Store',
        primaryColor: accentColor,
      );
    });

    return const SizedBox.shrink();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/store/controller/store_controller.dart';

class EditStorePage extends GetView<StoreController> {
  const EditStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.editStoreId.value = int.parse(
      Get.parameters['storeEditId'] ?? '0',
    );
    // Initialize controllers with existing store data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final store = controller.stores.firstWhereOrNull(
          (s) => s.id == controller.editStoreId.value,
        );
        if (store != null) {
          controller.storeCodeController.text = store.storeCode ?? '';
          controller.storeNameController.text = store.storeName ?? '';
          controller.storeEmailController.text = store.storeEmail ?? '';
          controller.storePhoneController.text = store.storePhone ?? '';
          controller.storeWebsiteController.text = store.website ?? '';
          controller.storeAddressController.text = store.storeAddress ?? '';
          controller.storeCityController.text = store.storeCity ?? '';
          controller.storeStateController.text = store.storeState ?? '';
          controller.storePostcodeController.text = store.storePostalCode ?? '';
          controller.storeCountryController.text = store.storeCountry ?? '';
          controller.storeTimezoneController.text = store.timezone ?? '';
          controller.storeCurrencyController.text = store.currency ?? '';
          controller.storeLanguageController.text = store.language ?? '';
          controller.storeImage.value = store.storeLogo;
        } else {
          Get.snackbar(
            'Error',
            'Store not found',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to load store data: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Store"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings, color: accentColor, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'Store Settings',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: accentLightColor, thickness: 2),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 32,
                  runSpacing: 20,
                  children: [
                    _buildField(
                      "Store Name",
                      controller.storeNameController,
                      icon: Icons.store,
                    ),
                    _buildField(
                      "Store Code",
                      controller.storeCodeController,
                      icon: Icons.code,
                    ),
                    _buildField(
                      "Email",
                      controller.storeEmailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),
                    _buildField(
                      "Phone",
                      controller.storePhoneController,
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone,
                    ),
                    _buildField(
                      "Website",
                      controller.storeWebsiteController,
                      icon: Icons.web,
                    ),
                    _buildField(
                      "Address",
                      controller.storeAddressController,
                      maxLines: 2,
                      icon: Icons.location_on,
                    ),
                    _buildField(
                      "City",
                      controller.storeCityController,
                      icon: Icons.location_city,
                    ),
                    _buildField(
                      "State",
                      controller.storeStateController,
                      icon: Icons.map,
                    ),
                    _buildField(
                      "Postal Code",
                      controller.storePostcodeController,
                      icon: Icons.markunread_mailbox,
                    ),
                    _buildField(
                      "Country",
                      controller.storeCountryController,
                      icon: Icons.public,
                    ),
                    _buildField(
                      "Timezone",
                      controller.storeTimezoneController,
                      icon: Icons.access_time,
                    ),
                    _buildField(
                      "Currency",
                      controller.storeCurrencyController,
                      icon: Icons.attach_money,
                    ),
                    _buildField(
                      "Language",
                      controller.storeLanguageController,
                      icon: Icons.language,
                    ),
                  ].map((child) => SizedBox(width: 400, child: child)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () =>
                  controller.editStore(controller.editStoreId.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, color: accentColor) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: accentLightColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: accentColor, width: 2),
              ),
              filled: true,
              fillColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

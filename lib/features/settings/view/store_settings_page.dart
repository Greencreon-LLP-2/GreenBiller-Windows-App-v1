import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';

class EditStorePage extends GetView<EditStoreController> {
  const EditStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Store"),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: Colors.black,
          unselectedLabelColor: const Color.fromARGB(179, 66, 66, 66),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: "General"),
            Tab(icon: Icon(Icons.language), text: "System"),
            Tab(icon: Icon(Icons.point_of_sale), text: "Sales"),
            Tab(icon: Icon(Icons.tag), text: "Prefixes"),
          ],
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: controller.tabController,
                children: [
                  _buildSection("General Settings", [
                    _buildField(
                      "Email",
                      controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                    ),
                    _buildField(
                      "Mobile",
                      controller.mobileController,
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone_android,
                    ),
                    _buildField(
                      "Phone",
                      controller.phoneController,
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone,
                    ),
                    _buildField(
                      "GST Number",
                      controller.gstController,
                      icon: Icons.confirmation_number,
                    ),
                    _buildField(
                      "PAN Number",
                      controller.panController,
                      icon: Icons.credit_card,
                    ),
                    _buildField(
                      "VAT Number",
                      controller.vatController,
                      icon: Icons.receipt_long,
                    ),
                    _buildField(
                      "Store Website",
                      controller.websiteController,
                      icon: Icons.web,
                    ),
                    _buildField(
                      "Bank Details",
                      controller.bankDetailsController,
                      maxLines: 2,
                      icon: Icons.account_balance,
                    ),
                    _buildField(
                      "Address",
                      controller.addressController,
                      maxLines: 2,
                      icon: Icons.location_on,
                    ),
                    _buildField(
                      "City",
                      controller.cityController,
                      icon: Icons.location_city,
                    ),
                    _buildField(
                      "State",
                      controller.stateController,
                      icon: Icons.map,
                    ),
                    _buildField(
                      "Postcode",
                      controller.postcodeController,
                      icon: Icons.markunread_mailbox,
                    ),
                    _buildField(
                      "Country",
                      controller.countryController,
                      icon: Icons.public,
                    ),
                    Obx(
                      () => SwitchListTile(
                        title: const Text("Show Signature on Invoice"),
                        value: controller.showSignature.value,
                        onChanged: (v) => controller.showSignature.value = v,
                        activeColor: accentColor,
                      ),
                    ),
                    Obx(
                      () => controller.showSignature.value
                          ? _buildField(
                              "Signature",
                              controller.signatureController,
                              maxLines: 2,
                              icon: Icons.edit,
                            )
                          : const SizedBox.shrink(),
                    ),
                    _buildField(
                      "Store Logo",
                      controller.storeLogoController,
                      icon: Icons.image,
                    ),
                  ], icon: Icons.settings),
                  _buildSection("System Settings", [
                    _buildField(
                      "Timezone",
                      controller.timezoneController,
                      icon: Icons.access_time,
                    ),
                    _buildField(
                      "Currency",
                      controller.currencyController,
                      icon: Icons.attach_money,
                    ),
                    _buildField(
                      "Decimals",
                      controller.decimalsController,
                      keyboardType: TextInputType.number,
                      icon: Icons.exposure,
                    ),
                    _buildField(
                      "Decimals for Quantity",
                      controller.decimalsQtyController,
                      keyboardType: TextInputType.number,
                      icon: Icons.numbers,
                    ),
                    _buildField(
                      "Language",
                      controller.languageController,
                      icon: Icons.language,
                    ),
                  ], icon: Icons.language),
                  _buildSection("Sales Settings", [
                    _buildField(
                      "Default Account",
                      controller.defaultAccountController,
                      icon: Icons.account_balance_wallet,
                    ),
                    _buildField(
                      "Sales Invoice Formats",
                      controller.salesInvoiceFormatController,
                      icon: Icons.receipt,
                    ),
                    _buildField(
                      "POS Invoice Formats",
                      controller.posInvoiceFormatController,
                      icon: Icons.point_of_sale,
                    ),
                  ], icon: Icons.point_of_sale),
                  _buildSection(
                    "Prefixes",
                    controller.prefixControllers.entries
                        .map(
                          (entry) => _buildField(
                            '${entry.key} Prefix',
                            entry.value,
                            icon: Icons.label,
                          ),
                        )
                        .toList(),
                    icon: Icons.tag,
                  ),
                ],
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
              onPressed: controller.saveChanges,
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

  Widget _buildSection(String title, List<Widget> children, {IconData? icon}) {
    return SingleChildScrollView(
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
              Row(
                children: [
                  if (icon != null) Icon(icon, color: accentColor, size: 28),
                  if (icon != null) const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
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
                children: children
                    .map((child) => SizedBox(width: 400, child: child))
                    .toList(),
              ),
            ],
          ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/features/settings/controller/store_settings_controller.dart';

class StoreSettingsPage extends GetView<StoreSettingsController> {
  const StoreSettingsPage({super.key});

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
        () => controller.isLoadingStores.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: _buildStoreSelector(),
                  ),
                  Expanded(
                    child: controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : controller.selectedStoreId.value == null
                        ? _buildNoStoreSelected()
                        : TabBarView(
                            controller: controller.tabController,
                            children: [
                              _buildSection("General Settings", [
                                _buildField(
                                  "Mobile",
                                  controller.mobileController,
                                  keyboardType: TextInputType.phone,
                                  icon: Icons.phone_android,
                                ),
                                _buildToggle("GST Enabled", controller.ifGst),
                                _buildField(
                                  "GST Number",
                                  controller.gstController,
                                  icon: Icons.confirmation_number,
                                ),
                                _buildToggle("VAT Enabled", controller.ifVat),
                                _buildField(
                                  "VAT Number",
                                  controller.vatController,
                                  icon: Icons.receipt_long,
                                ),
                                _buildField(
                                  "PAN Number",
                                  controller.panController,
                                  icon: Icons.credit_card,
                                ),
                                _buildField(
                                  "UPI ID",
                                  controller.upiIdController,
                                  icon: Icons.payment,
                                ),
                                _buildField(
                                  "UPI Code",
                                  controller.upiCodeController,
                                  icon: Icons.qr_code,
                                ),
                                _buildField(
                                  "Bank Details",
                                  controller.bankDetailsController,
                                  maxLines: 2,
                                  icon: Icons.account_balance,
                                ),
                                _buildToggle(
                                  "Show Signature on Invoice",
                                  controller.showSignature,
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
                                  "Slug",
                                  controller.slugController,
                                  icon: Icons.link,
                                ),
                                _buildField(
                                  "CID",
                                  controller.cidController,
                                  icon: Icons.perm_identity,
                                ),
                                _buildField(
                                  "Status",
                                  controller.statusController,
                                  icon: Icons.info,
                                ),
                                _buildField(
                                  "Created By",
                                  controller.createdByController,
                                  icon: Icons.person,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Default Printer",
                                      style: const TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value:
                                            controller
                                                .selectedPrinter
                                                .value
                                                .isEmpty
                                            ? null
                                            : controller.selectedPrinter.value,
                                        onChanged: (value) {
                                          controller.selectedPrinter.value =
                                              value ?? '';
                                        },
                                        hint: const Text('Tax Type'),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                        ),
                                        iconEnabledColor: accentColor
                                            .withOpacity(0.7),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: textPrimaryColor,
                                        ),
                                        decoration: InputDecoration(
                                          prefixIcon: Container(
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            child: Icon(
                                              Icons.receipt_long,
                                              color: accentColor.withOpacity(
                                                0.7,
                                              ),
                                              size: 20,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),

                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: accentColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        dropdownColor: Colors.white,
                                        isExpanded: true,
                                        items: controller.defaultPrinterList
                                            .map(
                                              (item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: textPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ], icon: Icons.settings),
                              _buildSection("System Settings", [
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
                                  "Default Account",
                                  controller.defaultAccountController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.account_balance_wallet,
                                ),
                                _buildToggle(
                                  "SMS Status",
                                  controller.smsStatus,
                                ),
                                _buildToggle(
                                  "SMTP Status",
                                  controller.smtpStatus,
                                ),
                                _buildToggle(
                                  "MSG91 Enabled",
                                  controller.ifMsg91,
                                ),
                                _buildToggle("OTP Enabled", controller.ifOtp),
                                _buildField(
                                  "SMTP Host",
                                  controller.smtpHostController,
                                  icon: Icons.dns,
                                ),
                                _buildField(
                                  "SMTP Port",
                                  controller.smtpPortController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.network_check,
                                ),
                                _buildField(
                                  "SMTP User",
                                  controller.smtpUserController,
                                  icon: Icons.person,
                                ),
                                _buildField(
                                  "SMTP Password",
                                  controller.smtpPassController,
                                  icon: Icons.lock,
                                ),
                                _buildField(
                                  "SMS URL",
                                  controller.smsUrlController,
                                  icon: Icons.sms,
                                ),
                                _buildField(
                                  "MSG91 API Key",
                                  controller.msg91ApikeyController,
                                  icon: Icons.vpn_key,
                                ),
                                _buildField(
                                  "SMS Sender ID",
                                  controller.smsSenderidController,
                                  icon: Icons.send,
                                ),
                                _buildField(
                                  "SMS DLT ID",
                                  controller.smsDltidController,
                                  icon: Icons.sms,
                                ),
                                _buildField(
                                  "SMS Message",
                                  controller.smsMsgController,
                                  maxLines: 2,
                                  icon: Icons.message,
                                ),
                                _buildToggle(
                                  "Model Number Enabled",
                                  controller.ifModelNo,
                                ),
                                _buildToggle(
                                  "Serial Number Enabled",
                                  controller.ifSerialNo,
                                ),
                                _buildToggle(
                                  "Expiry Enabled",
                                  controller.ifExpiry,
                                ),
                                _buildToggle(
                                  "Batch Number Enabled",
                                  controller.ifBatchNo,
                                ),
                                _buildToggle(
                                  "OneSignal Enabled",
                                  controller.ifOneSignal,
                                ),
                                _buildField(
                                  "OneSignal ID",
                                  controller.onesignalIdController,
                                  icon: Icons.notifications,
                                ),
                                _buildField(
                                  "OneSignal Key",
                                  controller.onesignalKeyController,
                                  icon: Icons.vpn_key,
                                ),
                                _buildToggle(
                                  "Customer App Enabled",
                                  controller.ifCustomerApp,
                                ),
                                _buildToggle(
                                  "Delivery App Enabled",
                                  controller.ifDeliveryApp,
                                ),
                                _buildToggle(
                                  "Executive App Enabled",
                                  controller.ifExecutiveApp,
                                ),
                                _buildField(
                                  "Currency Symbol ID",
                                  controller.currencywsymbolIdController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.currency_exchange,
                                ),
                                _buildField(
                                  "Current Subscription ID",
                                  controller.currentSubscriptionIdController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.subscriptions,
                                ),
                              ], icon: Icons.language),
                              _buildSection("Sales Settings", [
                                _buildField(
                                  "Sales Invoice Format ID",
                                  controller.salesInvoiceFormatController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.receipt,
                                ),
                                _buildField(
                                  "POS Invoice Format ID",
                                  controller.posInvoiceFormatController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.point_of_sale,
                                ),
                                _buildField(
                                  "Default Sales Discount",
                                  controller.defaultSalesDiscountController,
                                  icon: Icons.discount,
                                ),
                                _buildField(
                                  "Round Off",
                                  controller.roundOffController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.roundabout_right,
                                ),
                                _buildField(
                                  "Change Return",
                                  controller.changeReturnController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.money,
                                ),
                                _buildField(
                                  "Sales Invoice Footer Text",
                                  controller.salesInvoiceFooterTextController,
                                  maxLines: 2,
                                  icon: Icons.text_fields,
                                ),
                                _buildToggle("COD Enabled", controller.ifCod),
                                _buildToggle(
                                  "Pickup at Store Enabled",
                                  controller.ifPickupAtStore,
                                ),
                                _buildToggle(
                                  "Fixed Delivery Enabled",
                                  controller.ifFixedDelivery,
                                ),
                                _buildField(
                                  "Delivery Charge",
                                  controller.deliveryChargeController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.local_shipping,
                                ),
                                _buildToggle(
                                  "Handling Charge Enabled",
                                  controller.ifHandlingCharge,
                                ),
                                _buildField(
                                  "Handling Charge",
                                  controller.handlingChargeController,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.work,
                                ),
                                _buildToggle(
                                  "T&C Status",
                                  controller.tAndCStatus,
                                ),
                                _buildToggle(
                                  "T&C Status for POS",
                                  controller.tAndCStatusPos,
                                ),
                                _buildToggle(
                                  "Number to Words",
                                  controller.numberToWords,
                                ),
                                _buildToggle(
                                  "Previous Balance Bit",
                                  controller.previousBalanceBit,
                                ),
                                _buildField(
                                  "Registration Key",
                                  controller.regnoKeyController,
                                  icon: Icons.key,
                                ),
                                _buildField(
                                  "Favicon",
                                  controller.favIconController,
                                  icon: Icons.image,
                                ),
                                _buildField(
                                  "Purchase Code",
                                  controller.purchaseCodeController,
                                  icon: Icons.code,
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
            Obx(
              () => ElevatedButton.icon(
                onPressed: controller.selectedStoreId.value == null
                    ? null
                    : controller.saveChanges,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoStoreSelected() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Please select a store to configure invoice settings',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSelector() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedStore.value,
        decoration: InputDecoration(
          labelText: 'Select Store',
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.store,
              color: accentColor.withOpacity(0.85),
              size: 18,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: accentColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text(
              'Select a Store',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          ...controller.storeMap.entries.map(
            (entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text(
                entry.key,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
        onChanged: controller.onStoreChanged,
        icon: controller.isLoadingStores.value
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: accentColor.withOpacity(0.85),
              ),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Colors.white,
        isExpanded: true,
        menuMaxHeight: 250,
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

  Widget _buildToggle(String label, RxBool value) {
    return Obx(
      () => SwitchListTile(
        title: Text(
          label,
          style: const TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        value: value.value,
        onChanged: (v) => value.value = v,
        activeColor: accentColor,
      ),
    );
  }
}

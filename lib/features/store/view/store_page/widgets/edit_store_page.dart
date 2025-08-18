import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/store/controllers/edit_store_controller.dart';
import 'package:green_biller/features/store/services/view_store_service.dart';

class EditStorePage extends HookWidget {
  final String storeId;
  final String accessToken;

  const EditStorePage({
    super.key,
    required this.storeId,
    required this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 4);
    final isLoading = useState<bool>(true);

    final storeCodeController = useTextEditingController();
    final storeNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final mobileController = useTextEditingController();
    final phoneController = useTextEditingController();
    final gstController = useTextEditingController();
    final panController = useTextEditingController();
    final vatController = useTextEditingController();
    final websiteController = useTextEditingController();
    final bankDetailsController = useTextEditingController();
    final addressController = useTextEditingController();
    final cityController = useTextEditingController();
    final stateController = useTextEditingController();
    final postcodeController = useTextEditingController();
    final countryController = useTextEditingController();
    final signatureController = useTextEditingController();
    final storeLogoController = useTextEditingController();
    final showSignature = useState<bool>(false);

    final timezoneController = useTextEditingController();
    final currencyController = useTextEditingController();
    final decimalsController = useTextEditingController();
    final decimalsQtyController = useTextEditingController();
    final languageController = useTextEditingController();

    final defaultAccountController = useTextEditingController();
    final salesInvoiceFormatController = useTextEditingController();
    final posInvoiceFormatController = useTextEditingController();

    final prefixControllers = {
      'Category': useTextEditingController(),
      'Item': useTextEditingController(),
      'Supplier': useTextEditingController(),
      'Purchase': useTextEditingController(),
      'Purchase Return': useTextEditingController(),
      'Customer': useTextEditingController(),
      'Sales': useTextEditingController(),
      'Sales Return': useTextEditingController(),
      'Expense': useTextEditingController(),
      'Accounts': useTextEditingController(),
      'Quotation': useTextEditingController(),
      'Money Transfer': useTextEditingController(),
      'Sales Payment': useTextEditingController(),
      'Sales Return Payment': useTextEditingController(),
      'Purchase Payment': useTextEditingController(),
      'Purchase Return Payment': useTextEditingController(),
      'Expense Payment': useTextEditingController(),
      'Customers Advance Payments': useTextEditingController(),
    };

    useEffect(() {
      Future<void> loadoldData() async {
        try {
          final response = await newViewStoreServiceByStoreId(
              accessToken, int.parse(storeId));
          // if (response. == null || response.data!.isEmpty) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //     content: Text("Error Loading Data"),
          //     backgroundColor: Colors.red,
          //   ));
          // } else {
          final store = response;
          storeCodeController.text = store.storeCode ?? "0";
          storeNameController.text = store.storeName ?? "0";
          emailController.text = store.email ?? "0";
          mobileController.text = store.mobile ?? "0";
          phoneController.text = store.phone ?? "0";
          gstController.text = store.gstNo ?? "0";
          panController.text = store.panNo ?? "0";
          vatController.text = store.vatNo ?? "0";
          websiteController.text = store.storeWebsite ?? "0";
          bankDetailsController.text = store.bankDetails ?? "0";
          addressController.text = store.address ?? "0";
          cityController.text = store.city ?? "0";
          stateController.text = store.state?.toString() ?? "0";
          postcodeController.text = store.postcode?.toString() ?? "0";
          countryController.text = store.country ?? "0";
          signatureController.text = store.signature ?? "0";
          storeLogoController.text = store.storeLogo ?? "0";
          showSignature.value = store.showSignature == 1;

          timezoneController.text = store.timezone ?? "UTC";
          currencyController.text = store.currencyId?.toString() ?? "1";
          decimalsController.text = store.decimals?.toString() ?? "2";
          decimalsQtyController.text = store.qtyDecimals?.toString() ?? "2";
          languageController.text = store.languageId?.toString() ?? "1";

          defaultAccountController.text =
              store.defaultAccountId?.toString() ?? "1";
          salesInvoiceFormatController.text =
              store.salesInvoiceFormatId?.toString() ?? "1";
          posInvoiceFormatController.text =
              store.posInvoiceFormatId?.toString() ?? "1";

          // Set prefix values with default "0" if null
          prefixControllers['Category']!.text = store.categoryInit ?? "0";
          prefixControllers['Item']!.text = store.itemInit ?? "0";
          prefixControllers['Supplier']!.text = store.supplierInit ?? "0";
          prefixControllers['Purchase']!.text = store.purchaseInit ?? "0";
          prefixControllers['Purchase Return']!.text =
              store.purchaseReturnInit ?? "0";
          prefixControllers['Customer']!.text = store.customerInit ?? "0";
          prefixControllers['Sales']!.text = store.salesInit ?? "0";
          prefixControllers['Sales Return']!.text =
              store.salesReturnInit ?? "0";
          prefixControllers['Expense']!.text = store.expenseInit ?? "0";
          prefixControllers['Accounts']!.text = store.accountsInit ?? "0";
          prefixControllers['Quotation']!.text = store.quotationInit ?? "0";
          prefixControllers['Money Transfer']!.text =
              store.moneyTransferInit ?? "0";
          prefixControllers['Sales Payment']!.text =
              store.salesPaymentInit ?? "0";
          prefixControllers['Sales Return Payment']!.text =
              store.salesReturnPaymentInit ?? "0";
          prefixControllers['Purchase Payment']!.text =
              store.purchasePaymentInit ?? "0";
          prefixControllers['Purchase Return Payment']!.text =
              store.purchaseReturnPaymentInit ?? "0";
          prefixControllers['Expense Payment']!.text =
              store.expensePaymentInit ?? "0";
          prefixControllers['Customers Advance Payments']!.text =
              store.custAdvanceInit ?? "0";
          // }
        } catch (e) {
          debugPrint("Error loading store data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error loading store data: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          isLoading.value = false;
        }
      }

      loadoldData();
      return null;
    }, []);

    Future<void> saveChanges() async {
      try {
        final controller = EditStoreController(
          storeId: storeId,
          accesToken: accessToken,
          name: storeNameController.text,
          address: addressController.text,
          phone: phoneController.text,
          email: emailController.text,
          country: countryController.text,
          city: cityController.text,
          postcode: postcodeController.text,
          gstNo: gstController.text,
          panNo: panController.text,
          userId: "1",
          storeCode: storeCodeController.text,
          slug: "store-${storeCodeController.text}",
          storeName: storeNameController.text,
          storeWebsite: websiteController.text,
          mobile: mobileController.text,
          storeLogo: storeLogoController.text,
          vatNo: vatController.text,
          upiId: "0",
          upiCode: "0",
          bankDetails: bankDetailsController.text,
          cid: "1",
          categoryInit: prefixControllers['Category']!.text.isEmpty
              ? "0"
              : prefixControllers['Category']!.text,
          itemInit: prefixControllers['Item']!.text.isEmpty
              ? "0"
              : prefixControllers['Item']!.text,
          supplierInit: prefixControllers['Supplier']!.text.isEmpty
              ? "0"
              : prefixControllers['Supplier']!.text,
          purchaseInit: prefixControllers['Purchase']!.text.isEmpty
              ? "0"
              : prefixControllers['Purchase']!.text,
          purchaseReturnInit: prefixControllers['Purchase Return']!.text.isEmpty
              ? "0"
              : prefixControllers['Purchase Return']!.text,
          customerInit: prefixControllers['Customer']!.text.isEmpty
              ? "0"
              : prefixControllers['Customer']!.text,
          salesInit: prefixControllers['Sales']!.text.isEmpty
              ? "0"
              : prefixControllers['Sales']!.text,
          salesReturnInit: prefixControllers['Sales Return']!.text.isEmpty
              ? "0"
              : prefixControllers['Sales Return']!.text,
          expenseInit: prefixControllers['Expense']!.text.isEmpty
              ? "0"
              : prefixControllers['Expense']!.text,
          accountsInit: prefixControllers['Accounts']!.text.isEmpty
              ? "0"
              : prefixControllers['Accounts']!.text,
          journalInit: "0",
          custAdvanceInit:
              prefixControllers['Customers Advance Payments']!.text.isEmpty
                  ? "0"
                  : prefixControllers['Customers Advance Payments']!.text,
          quotationInit: prefixControllers['Quotation']!.text.isEmpty
              ? "0"
              : prefixControllers['Quotation']!.text,
          moneyTransferInit: prefixControllers['Money Transfer']!.text.isEmpty
              ? "0"
              : prefixControllers['Money Transfer']!.text,
          salesPaymentInit: prefixControllers['Sales Payment']!.text.isEmpty
              ? "0"
              : prefixControllers['Sales Payment']!.text,
          salesReturnPaymentInit:
              prefixControllers['Sales Return Payment']!.text.isEmpty
                  ? "0"
                  : prefixControllers['Sales Return Payment']!.text,
          purchasePaymentInit:
              prefixControllers['Purchase Payment']!.text.isEmpty
                  ? "0"
                  : prefixControllers['Purchase Payment']!.text,
          purchaseReturnPaymentInit:
              prefixControllers['Purchase Return Payment']!.text.isEmpty
                  ? "0"
                  : prefixControllers['Purchase Return Payment']!.text,
          expensePaymentInit: prefixControllers['Expense Payment']!.text.isEmpty
              ? "0"
              : prefixControllers['Expense Payment']!.text,
          smsStatus: "0",
          languageId:
              languageController.text.isEmpty ? "1" : languageController.text,
          currencyId:
              currencyController.text.isEmpty ? "1" : currencyController.text,
          currencyPlacement: "before",
          timezone:
              timezoneController.text.isEmpty ? "UTC" : timezoneController.text,
          dateFormat: "Y-m-d",
          timeFormat: "H:i",
          defaultSalesDiscount: "0",
          currencywsymbolId: "0",
          regnoKey: "0",
          favIcon: "0",
          purchaseCode: "0",
          changeReturn: "0",
          salesInvoiceFormatId: salesInvoiceFormatController.text.isEmpty
              ? "1"
              : salesInvoiceFormatController.text,
          posInvoiceFormatId: posInvoiceFormatController.text.isEmpty
              ? "1"
              : posInvoiceFormatController.text,
          salesInvoiceFooterText: "0",
          roundOff: "0",
          decimals:
              decimalsController.text.isEmpty ? "2" : decimalsController.text,
          qtyDecimals: decimalsQtyController.text.isEmpty
              ? "2"
              : decimalsQtyController.text,
          smtpHost: "0",
          smtpPort: "0",
          smtpUser: "0",
          smtpPass: "0",
          smtpStatus: "0",
          smsUrl: "0",
          ifMsg91: "0",
          msg91Apikey: "0",
          smsSenderid: "0",
          smsDltid: "0",
          smsMsg: "0",
          ifModelNo: "1",
          ifSerialno: "1",
          ifCod: "0",
          ifPickupatestore: "0",
          ifFixeddelivery: "0",
          deliveryCharge: "0",
          ifHandlingcharge: "0",
          handlingCharge: "0",
          signature: signatureController.text,
          showSignature: showSignature.value ? "1" : "0",
          tAndCStatus: "0",
          tAndCStatusPos: "0",
          numberToWords: "0",
          ifCustomerapp: "1",
          ifDeliveryapp: "1",
          ifOnesignal: "1",
          onesignalId: "0",
          onesignalKey: "0",
          ifOtp: "0",
          currentSubscriptionId: "1",
          invoiceView: "0",
          previousBalancebit: "0",
          defaultAccountId: defaultAccountController.text.isEmpty
              ? "1"
              : defaultAccountController.text,
        );

        final result = await controller.editStoreController(context);
        if (result == "Store Updated Successfully") {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Store"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottom: TabBar(
          controller: tabController,
          labelColor: const Color.fromARGB(255, 0, 0, 0),
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
      body: TabBarView(
        controller: tabController,
        children: [
          _buildSection(
              "General Settings",
              [
                _buildField("Store Name", storeNameController,
                    icon: Icons.code),
                _buildField("Store Code", storeCodeController,
                    icon: Icons.store),
                _buildField("Email", emailController,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email),
                _buildField("Mobile", mobileController,
                    keyboardType: TextInputType.phone,
                    icon: Icons.phone_android),
                _buildField("Phone", phoneController,
                    keyboardType: TextInputType.phone, icon: Icons.phone),
                _buildField("GST Number", gstController,
                    icon: Icons.confirmation_number),
                _buildField("PAN Number", panController,
                    icon: Icons.credit_card),
                _buildField("VAT Number", vatController,
                    icon: Icons.receipt_long),
                _buildField("Store Website", websiteController,
                    icon: Icons.web),
                _buildField("Bank Details", bankDetailsController,
                    maxLines: 2, icon: Icons.account_balance),
                _buildField("Address", addressController,
                    maxLines: 2, icon: Icons.location_on),
                _buildField("City", cityController, icon: Icons.location_city),
                _buildField("State", stateController, icon: Icons.map),
                _buildField("Postcode", postcodeController,
                    icon: Icons.markunread_mailbox),
                _buildField("Country", countryController, icon: Icons.public),
                SwitchListTile(
                  title: const Text("Show Signature on Invoice"),
                  value: showSignature.value,
                  onChanged: (v) => showSignature.value = v,
                  activeColor: accentColor,
                ),
                if (showSignature.value)
                  _buildField("Signature", signatureController,
                      maxLines: 2, icon: Icons.edit),
                _buildField("Store Logo", storeLogoController,
                    icon: Icons.image),
              ],
              icon: Icons.settings),
          _buildSection(
              "System Settings",
              [
                _buildField("Timezone", timezoneController,
                    icon: Icons.access_time),
                _buildField("Currency", currencyController,
                    icon: Icons.attach_money),
                _buildField("Decimals", decimalsController,
                    keyboardType: TextInputType.number, icon: Icons.exposure),
                _buildField("Decimals for Quantity", decimalsQtyController,
                    keyboardType: TextInputType.number, icon: Icons.numbers),
                _buildField("Language", languageController,
                    icon: Icons.language),
              ],
              icon: Icons.language),
          _buildSection(
              "Sales Settings",
              [
                _buildField("Default Account", defaultAccountController,
                    icon: Icons.account_balance_wallet),
                _buildField(
                    "Sales Invoice Formats", salesInvoiceFormatController,
                    icon: Icons.receipt),
                _buildField("POS Invoice Formats", posInvoiceFormatController,
                    icon: Icons.point_of_sale),
              ],
              icon: Icons.point_of_sale),
          _buildSection(
              "Prefixes",
              prefixControllers.entries
                  .map((entry) => _buildField(
                      '${entry.key} Prefix', entry.value,
                      icon: Icons.label))
                  .toList(),
              icon: Icons.tag),
        ],
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
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    .map((child) => SizedBox(
                          width: 400,
                          child: child,
                        ))
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

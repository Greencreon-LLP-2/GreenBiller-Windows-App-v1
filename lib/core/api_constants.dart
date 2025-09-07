//!======================================================================================================
//!======================================================================================================
//* ====                                      Api Urls                                              ===//
//!======================================================================================================
//!======================================================================================================

const String baseUrl = "http://127.0.0.1:8000/api";
const String publicUrl = "http://127.0.0.1:8000";
// const String onesignal = "rfpuvfb7pfgr3pvi2ns4izmlhugjfq7fpfcel7nmsrhch5jxtgca5r2hgnwo3z7cdionapma4ukgkrx7qyzvi6tl7rpxkg7plmhx3wa";
  // const String baseUrl = "https://greenbiller.in/api";
  // const String publicUrl = "https://greenbiller.in/public";

//!===================================auth====================================&//

const String loginUrl = "$baseUrl/login";
const String countryCodeUrl = "$baseUrl/country/settings-view";
const String signUpUrl = "$baseUrl/register";
const String sendOtpUrl = "$baseUrl/sendotp";
const String verifyOtpUrl = "$baseUrl/verifyotp";
const String userSessionCheckUrl = "$baseUrl/check-session";
const String passwordResetUrl = "$baseUrl/reset-password";

//&===================================warehouse================================&//
const String addWarehouseUrl = "$baseUrl/warehouse-create";
const String viewWarehouseUrl = "$baseUrl/warehouse-view";
const String viewSingleWarehouseUrl = "$baseUrl/warehouse/ind-view";
const String editWarehouseUrl = "$baseUrl/warehouse-update";
const String deleteWarehouseUrl = "$baseUrl/warehouse-delete/";
//*===================================store====================================*//
const String addStoreUrl = "$baseUrl/store-create";
const String viewStoreUrl = "$baseUrl/store-view";
const String editStoreUrl = "$baseUrl/store-update";
const String deleteStoreUrl = "$baseUrl/store-delete/";
const String storeusersUrl = "$baseUrl/store-users";

//^===================================category=================================^//
const String addCategoriesUrl = "$baseUrl/category-create";
const String viewCategoriesUrl = "$baseUrl/category-view";
const String deleteCategoriesUrl = "$baseUrl/category-delete";
const String getItemsBasedOnCateIdUrl = "$baseUrl//category/{categoryId}/items";

//^===================================brand====================================^//
const String addBrandUrl = "$baseUrl/brand-create";
const String viewBrandUrl = "$baseUrl/brand-view";

//^===================================item=====================================^//

const String addItemUrl = "$baseUrl/items-create";
const String viewAllItemUrl = "$baseUrl/items-view";
const String editItemUrl = "$baseUrl/items-update";
const String deleteItemUrl = "$baseUrl/items-delete";
const String bulkItemUpdate = "$baseUrl/item-bulk";

//^===================================supplier=================================^//
const String addSupplierUrl = "$baseUrl/supplier-create";
const String viewSupplierUrl = "$baseUrl/supplier-view";
const String editSupplierUrl = "$baseUrl/supplier-update";
const String deleteSupplierUrl = "$baseUrl/supplier-delete";

//^===================================customer=================================^//
const String addCustomerUrl = "$baseUrl/customer-create";
const String viewCustomerUrl = "$baseUrl/customer-view";
const String editCustomerUrl = "$baseUrl/customer-update";
const String deleteCustomerUrl = "$baseUrl/customer-delete";

//*===================================unit=====================================*//
const String viewUnitUrl = "$baseUrl/unit-view";
const String createUnitUrl = "$baseUrl/unit-create";
const String deleteUnitUrl = "$baseUrl/unit-delete";

//~===================================Packages==================================//
const String viewPackageUrl = "$baseUrl/packages-view";

//!===================================purchase==================================*//
const String createPurchaseUrl = "$baseUrl/purchase-create";
const String viewPurchaseUrl = "$baseUrl/purchase-view";
const String purchaseItemCreateUrl = "$baseUrl/purchaseitem-create";
const String purchasePaymentCreateUrl = "$baseUrl/purchasepayment-create";
const String purchaseItemViewUrl = "$baseUrl/purchaseitem-view";
const String purchaseReturnCreateUrl = "$baseUrl/purchaseitem-create";
const String purchaseReturnViewUrl = "$baseUrl/purchasereturn-view";

//*====================================Tax======================================*//
const String viewTaxUrl = "$baseUrl/tax-view";

//!===================================sales====================================*//
const String createSalesUrl = "$baseUrl/sales-create";
const String salesItemCreateUrl = "$baseUrl/salesitem-create";
const String salesPaymentCreateUrl = "$baseUrl/salespayment-create";
const String viewSalesUrl = "$baseUrl/sales-view";

//*===================================Account===================================*//
const String createAccountUrl = "$baseUrl/accountsettings-create";
const String viewAccountUrl = "$baseUrl/accountsettings-view";
const String editAccountUrl = "$baseUrl/accountsettings-update";

//*===================================Reports===================================*//
const String purchaseSummaryUrl = "$baseUrl/timeline/report-view";
const String purchaseSupplierSummaryUrl = "$baseUrl/purchase/report-view";
const String salesCustomerSummaryUrl = "$baseUrl/sales/report-view";
const String salesSummaryUrl = "$baseUrl/reports/sales-report";
const String purchaseItemSummaryUrl = "$baseUrl/purchaseitem/report-view";
const String salesItemSummaryUrl = "$baseUrl/reports/sales-item-report";

const String businessProfileCreateUrl = '$baseUrl/profile-create';
const String businessProfileViewUrl = '$baseUrl/profile-view';
const String businessProfileEditUrl = '$baseUrl/profile-update';

const String updatePasswordUrl = '$baseUrl/update-password';
//*===================================Others===================================*//
const String sampleExcellTemplateUrl = '$baseUrl/item-bulk/csv/items';

class StoreModel {
  final String? message;
  final List<StoreData>? data;
  final int? totalstore;
  final int? status;

  StoreModel({this.message, this.data, this.totalstore, this.status});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      message: json['message'] as String?,
      data: (json['data'] as List?)
          ?.map((e) => StoreData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalstore: json['totalstore'] is int
          ? json['totalstore']
          : int.tryParse(json['totalstore']?.toString() ?? ''),
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? ''),
    );
  }
}

class StoreData {
  final int? id;
  final String? storeName;
  final String? storeCode;
  final String? storeLogo;
  final String? storePhone;
  final String? storeEmail;
  final String? storeAddress;
  final String? storeCity;
  final String? storeState;
  final String? storeCountry;
  final String? storePostalCode;
  final String? currency;
  final String? currencySymbol;
  final String? currencyPosition;
  final String? timezone;
  final String? language;
  final String? dateFormat;
  final String? timeFormat;
  final String? fiscalYear;
  final String? taxNumber;
  final String? website;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? ownerName;
  final String? ownerEmail;
  final String? defaultPrinter;
  final int? suppliersCount;
  final int? customersCount;
  final int? purchasesCount;
  final int? purchaseReturnsCount;
  final int? salesCount;
  final int? salesReturnsCount;
  final int? warehousesCount;
  final int? categoriesCount;

  StoreData({
    this.id,
    this.storeName,
    this.storeCode,
    this.storeLogo,
    this.storePhone,
    this.storeEmail,
    this.storeAddress,
    this.storeCity,
    this.storeState,
    this.storeCountry,
    this.storePostalCode,
    this.currency,
    this.currencySymbol,
    this.currencyPosition,
    this.timezone,
    this.language,
    this.dateFormat,
    this.timeFormat,
    this.fiscalYear,
    this.taxNumber,
    this.website,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.ownerName,
    this.ownerEmail,
    this.suppliersCount,
    this.customersCount,
    this.purchasesCount,
    this.purchaseReturnsCount,
    this.salesCount,
    this.salesReturnsCount,
    this.warehousesCount,
    this.categoriesCount,
    this.defaultPrinter,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      storeName: json['store_name']?.toString(),
      storeCode: json['store_code']?.toString(),
      storeLogo: json['store_logo']?.toString(),
      storePhone: json['store_phone']?.toString(),
      storeEmail: json['store_email']?.toString(),
      storeAddress: json['store_address']?.toString(),
      storeCity: json['store_city']?.toString(),
      storeState: json['store_state']?.toString(),
      storeCountry: json['store_country']?.toString(),
      storePostalCode: json['store_postal_code']?.toString(),
      currency: json['currency']?.toString(),
      currencySymbol: json['currency_symbol']?.toString(),
      currencyPosition: json['currency_position']?.toString(),
      timezone: json['timezone']?.toString(),
      language: json['language']?.toString(),
      dateFormat: json['date_format']?.toString(),
      timeFormat: json['time_format']?.toString(),
      fiscalYear: json['fiscal_year']?.toString(),
      taxNumber: json['tax_number']?.toString(),
      website: json['website']?.toString(),
      status: json['status']?.toString(),
      defaultPrinter: json['default_printer']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      ownerName: json['owner_name']?.toString(),
      ownerEmail: json['owner_email']?.toString(),
      suppliersCount: json['suppliers_count'] is int
          ? json['suppliers_count']
          : int.tryParse(json['suppliers_count']?.toString() ?? '0'),
      customersCount: json['customers_count'] is int
          ? json['customers_count']
          : int.tryParse(json['customers_count']?.toString() ?? '0'),
      purchasesCount: json['purchases_count'] is int
          ? json['purchases_count']
          : int.tryParse(json['purchases_count']?.toString() ?? '0'),
      purchaseReturnsCount: json['purchase_returns_count'] is int
          ? json['purchase_returns_count']
          : int.tryParse(json['purchase_returns_count']?.toString() ?? '0'),
      salesCount: json['sales_count'] is int
          ? json['sales_count']
          : int.tryParse(json['sales_count']?.toString() ?? '0'),
      salesReturnsCount: json['sales_returns_count'] is int
          ? json['sales_returns_count']
          : int.tryParse(json['sales_returns_count']?.toString() ?? '0'),
      warehousesCount: json['warehouses_count'] is int
          ? json['warehouses_count']
          : int.tryParse(json['warehouses_count']?.toString() ?? '0'),
      categoriesCount: json['categories_count'] is int
          ? json['categories_count']
          : int.tryParse(json['categories_count']?.toString() ?? '0'),
    );
  }
}

class StoreModel {
  final String? message;
  final List<StoreData>? data;
  final int? totalstore;
  final int? status;

  StoreModel({this.message, this.data, this.totalstore, this.status});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      message: json['message'],
      data: (json['data'] as List?)?.map((e) => StoreData.fromJson(e)).toList(),
      totalstore: json['totalstore'],
      status: json['status'],
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
    this.purchaseReturnsCount,
    this.purchasesCount,
    this.salesCount,
    this.salesReturnsCount,
    this.warehousesCount,
    this.categoriesCount,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
      id: json['id'],
      storeName: json['store_name'],
      storeCode: json['store_code'],
      storeLogo: json['store_logo'],
      storePhone: json['store_phone'],
      storeEmail: json['store_email'],
      storeAddress: json['store_address'],
      storeCity: json['store_city'],
      storeState: json['store_state'],
      storeCountry: json['store_country'],
      storePostalCode: json['store_postal_code'],
      currency: json['currency'],
      currencySymbol: json['currency_symbol'],
      currencyPosition: json['currency_position'],
      timezone: json['timezone'],
      language: json['language'],
      dateFormat: json['date_format'],
      timeFormat: json['time_format'],
      fiscalYear: json['fiscal_year'],
      taxNumber: json['tax_number'],
      website: json['website'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      ownerName: json['owner_name'],
      ownerEmail: json['owner_email'],
      suppliersCount: json['suppliers_count'] ?? 0,
      customersCount: json['customers_count'] ?? 0,
      purchaseReturnsCount: json['purchase_returns_count'] ?? 0,
      purchasesCount: json['purchases_count'] ?? 0,
      salesCount: json['sales_count'] ?? 0,
      salesReturnsCount: json['sales_returns_count'] ?? 0,
      warehousesCount: json['warehouses_count'] ?? 0,
      categoriesCount: json['categories_count'] ?? 0,
    );
  }
}

class ItemModel {
  final String message;
  final List<Item> data;
  final int status;

  ItemModel({required this.message, required this.data, required this.status});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      message: json['message'],
      data: List<Item>.from(json['data'].map((x) => Item.fromJson(x))),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
  };
}

class Item {
  final int id;
  final int? userId;
  final String itemImage;
  final String? storeId;
  final String itemName;
  final int? categoryId;
  final int? brandId;
  final String sku;
  final String hsnCode;
  final String itemCode;
  final String barcode;
  final String? unitId;
  final String? subunitId;
  final String? subunitValue;
  final String? unitConversion;
  final String? description;
  final String purchasePrice;
  final String taxType;
  final String taxRate;
  final String salesPrice;
  final String mrp;
  final String wholesalePrice;
  final String discountType;
  final String discount;
  final String profitMargin;
  final String? warehouse;
  final String? openingStock;
  final String? quantity;
  final String alertQuantity;
  final String? batchNo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String storeName;
  final String categoryName;
  final String brandName;
  final int status;
  Item({
    required this.id,
    this.userId,
    required this.itemImage,
    this.storeId,
    required this.itemName,
    this.categoryId,
    this.brandId,
    required this.sku,
    required this.hsnCode,
    required this.itemCode,
    required this.barcode,
    this.unitId,
    this.subunitId,
    this.subunitValue,
    this.unitConversion,
    this.description,
    required this.purchasePrice,
    required this.taxType,
    required this.taxRate,
    required this.salesPrice,
    required this.mrp,
    required this.wholesalePrice,
    required this.discountType,
    required this.discount,
    required this.profitMargin,
    this.warehouse,
    this.openingStock,
    this.quantity,
    required this.alertQuantity,
    this.batchNo,
    required this.createdAt,
    required this.updatedAt,
    required this.storeName,
    required this.categoryName,
    required this.brandName,
    required this.status,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      userId: json['user_id'],
      itemImage: json['item_image'] ?? '',
      storeId: json['store_id']?.toString(),
      itemName: json['item_name'] ?? '',
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      sku: json['SKU'] ?? '',
      hsnCode: json['HSN_code'] ?? '',
      itemCode: json['Item_code'] ?? '',
      barcode: json['Barcode'] ?? '',
      unitId: json['unit_id']?.toString(),
      subunitId: json['Subunit_id']?.toString(),
      subunitValue: json['subunit_value']?.toString(),
      unitConversion: json['Unit_conversion']?.toString(),
      description: json['Description'],
      purchasePrice: json['Purchase_price']?.toString() ?? '0.0',
      taxType: json['Tax_type'] ?? '',
      taxRate: json['Tax_rate']?.toString() ?? '0.0',
      salesPrice: json['Sales_Price']?.toString() ?? '0.0',
      mrp: json['MRP']?.toString() ?? '0.0',
      wholesalePrice: json['wholesale_price']?.toString() ?? '0.0',
      discountType: json['Discount_type'] ?? '',
      discount: json['Discount']?.toString() ?? '0.0',
      profitMargin: json['Profit_margin']?.toString() ?? '0.0',
      warehouse: json['Warehouse']?.toString(),
      openingStock: json['Opening_Stock']?.toString(),
      quantity: json['quantity']?.toString(),
      alertQuantity: json['Alert_Quantity']?.toString() ?? '0',
      batchNo: json['batch_no']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      storeName: json['store_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      brandName: json['brand_name'] ?? '',
      status: int.tryParse(json['status']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "item_image": itemImage,
    "store_id": storeId,
    "item_name": itemName,
    "category_id": categoryId,
    "brand_id": brandId,
    "SKU": sku,
    "HSN_code": hsnCode,
    "Item_code": itemCode,
    "Barcode": barcode,
    "unit_id": unitId,
    "Subunit_id": subunitId,
    "subunit_value": subunitValue,
    "Unit_conversion": unitConversion,
    "Description": description,
    "Purchase_price": purchasePrice,
    "Tax_type": taxType,
    "Tax_rate": taxRate,
    "Sales_Price": salesPrice,
    "MRP": mrp,
    "wholesale_price": wholesalePrice,
    "Discount_type": discountType,
    "Discount": discount,
    "Profit_margin": profitMargin,
    "Warehouse": warehouse,
    "Opening_Stock": openingStock,
    "quantity": quantity,
    "Alert_Quantity": alertQuantity,
    "batch_no": batchNo,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "store_name": storeName,
    "category_name": categoryName,
    "brand_name": brandName,
    "status": status,
  };
}

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
  final dynamic storeId;
  final String itemName;
  final int? categoryId;
  final int? brandId;
  final String sku;
  final String hsnCode;
  final String itemCode;
  final String barcode;
  final String unit;
  final dynamic description;
  final String purchasePrice;
  final String taxType;
  final String taxRate;
  final String salesPrice;
  final String mrp;
  final String discountType;
  final String discount;
  final String profitMargin;
  final dynamic warehouse;
  final dynamic openingStock;
  final String alertQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String storeName;
  final String categoryName;
  final String brandName;
  final int status;
  Item({
    required this.id,
    required this.userId,
    required this.itemImage,
    required this.storeId,
    required this.itemName,
    required this.categoryId,
    required this.brandId,
    required this.sku,
    required this.hsnCode,
    required this.itemCode,
    required this.barcode,
    required this.unit,
    required this.description,
    required this.purchasePrice,
    required this.taxType,
    required this.taxRate,
    required this.salesPrice,
    required this.mrp,
    required this.discountType,
    required this.discount,
    required this.profitMargin,
    required this.warehouse,
    required this.openingStock,
    required this.alertQuantity,
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
      userId: json['user_id'] ?? 0,
      itemImage: json['item_image'] ?? '',
      storeId: json['store_id'],
      itemName: json['item_name'] ?? '',
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      sku: json['SKU'] ?? '',
      hsnCode: json['HSN_code'] ?? '',
      itemCode: json['Item_code'] ?? '',
      barcode: json['Barcode'] ?? '',
      unit: json['Unit'] ?? '',
      description: json['Description'] ?? '',
      purchasePrice: json['Purchase_price']?.toString() ?? '',
      taxType: json['Tax_type'] ?? '',
      taxRate: json['Tax_rate']?.toString() ?? '',
      salesPrice: json['Sales_Price']?.toString() ?? '',
      mrp: json['MRP']?.toString() ?? '',
      discountType: json['Discount_type'] ?? '',
      discount: json['Discount']?.toString() ?? '',
      profitMargin: json['Profit_margin']?.toString() ?? '',
      warehouse: json['Warehouse'] ?? '',
      openingStock: json['Opening_Stock']?.toString() ?? '',
      alertQuantity: json['Alert_Quantity']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      storeName: json['store_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      brandName: json['brand_name'] ?? '',
      status: json['status'] ?? 1,
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
    "Unit": unit,
    "Description": description,
    "Purchase_price": purchasePrice,
    "Tax_type": taxType,
    "Tax_rate": taxRate,
    "Sales_Price": salesPrice,
    "MRP": mrp,
    "Discount_type": discountType,
    "Discount": discount,
    "Profit_margin": profitMargin,
    "Warehouse": warehouse,
    "Opening_Stock": openingStock,
    "Alert_Quantity": alertQuantity,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "store_name": storeName,
    "category_name": categoryName,
    "brand_name": brandName,
    "status": status,
  };
}

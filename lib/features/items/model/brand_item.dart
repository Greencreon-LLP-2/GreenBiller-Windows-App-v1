class BrandItem {
  final int id;
  final String brandName;
  final String storeId;

  BrandItem({required this.id, required this.brandName, required this.storeId});

  factory BrandItem.fromJson(Map<String, dynamic> json) {
    return BrandItem(
      id: json['id'] ?? 0,
      brandName: json['brand_name'] ?? '',
      storeId: json['store_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'brand_name': brandName, 'store_id': storeId};
  }
}

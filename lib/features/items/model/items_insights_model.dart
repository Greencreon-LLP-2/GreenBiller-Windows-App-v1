class InsightsBrand {
  final int? id;
  final String? storeId;
  final String? slug;
  final String? countId;
  final String? brandCode;
  final String? brandName;
  final String? brandImage;
  final String? description;
  final int? status;
  final String? inappView;
  final String? createdAt;
  final String? updatedAt;

  InsightsBrand({
    this.id,
    this.storeId,
    this.slug,
    this.countId,
    this.brandCode,
    this.brandName,
    this.brandImage,
    this.description,
    this.status,
    this.inappView,
    this.createdAt,
    this.updatedAt,
  });

  factory InsightsBrand.fromJson(Map<String, dynamic> json) {
    return InsightsBrand(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      slug: json['slug'] as String?,
      countId: json['count_id'] as String?,
      brandCode: json['brand_code'] as String?,
      brandName: json['brand_name'] as String?,
      brandImage: json['brand_image'] as String?,
      description: json['description'] as String?,
      status: json['status'] as int?,
      inappView: json['inapp_view'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'slug': slug,
      'count_id': countId,
      'brand_code': brandCode,
      'brand_name': brandName,
      'brand_image': brandImage,
      'description': description,
      'status': status,
      'inapp_view': inappView,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class InsightsCategory {
  final int? id;
  final String? storeId;
  final String? parentId;
  final String? slug;
  final String? countId;
  final String? categoryCode;
  final String? categoryName;
  final String? image;
  final String? description;
  final int? status;
  final String? inappView;
  final String? createdAt;
  final String? updatedAt;

  InsightsCategory({
    this.id,
    this.storeId,
    this.parentId,
    this.slug,
    this.countId,
    this.categoryCode,
    this.categoryName,
    this.image,
    this.description,
    this.status,
    this.inappView,
    this.createdAt,
    this.updatedAt,
  });

  factory InsightsCategory.fromJson(Map<String, dynamic> json) {
    return InsightsCategory(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      parentId: json['parent_id'] as String?,
      slug: json['slug'] as String?,
      countId: json['count_id'] as String?,
      categoryCode: json['category_code'] as String?,
      categoryName: json['category_name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      status: json['status'] as int?,
      inappView: json['inapp_view'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'parent_id': parentId,
      'slug': slug,
      'count_id': countId,
      'category_code': categoryCode,
      'category_name': categoryName,
      'image': image,
      'description': description,
      'status': status,
      'inapp_view': inappView,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class InsightsUnits {
  final int? id;
  final String? storeId;
  final String? parentId;
  final String? unitName;
  final String? unitValue;
  final String? description;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  InsightsUnits({
    this.id,
    this.storeId,
    this.parentId,
    this.unitName,
    this.unitValue,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory InsightsUnits.fromJson(Map<String, dynamic> json) {
    return InsightsUnits(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      parentId: json['parent_id'] as String?,
      unitName: json['unit_name'] as String?,
      unitValue: json['unit_value'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'parent_id': parentId,
      'unit_name': unitName,
      'unit_value': unitValue,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

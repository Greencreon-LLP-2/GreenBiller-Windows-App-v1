class BrandModel {
  final String? message;
  final List<BrandItemData>? data;
  final int? status;

  BrandModel({
    this.message,
    this.data,
    this.status,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BrandItemData.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class BrandItemData {
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandItemData({
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

  factory BrandItemData.fromJson(Map<String, dynamic> json) {
    return BrandItemData(
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
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class UnitModel {
  final String? message;
  final List<UnitItem>? data;
  final int? status;

  UnitModel({this.message, this.data, this.status});

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UnitItem.fromJson(e as Map<String, dynamic>))
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

class UnitItem {
  final int? id;
  final String? storeId;
  final String? parentId;
  final String? unitName;
  final String? unitValue;
  final String? description;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UnitItem({
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

  factory UnitItem.fromJson(Map<String, dynamic> json) {
    return UnitItem(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      parentId: json['parent_id'] as String?,
      unitName: json['unit_name'] as String?,
      unitValue: json['unit_value'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
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
      'parent_id': parentId,
      'unit_name': unitName,
      'unit_value': unitValue,
      'description': description,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

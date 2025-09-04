class WarehouseModel {
  final String? message;
  final List<WarehouseData>? data;
  final int? status;

  WarehouseModel({
    this.message,
    this.data,
    this.status,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => WarehouseData.fromJson(e))
          .toList(),
      status: json['status'],
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

class WarehouseData {
  final int? id;
  final String? userId;
  final String? storeId;
  final String? warehouseType;
  final String? warehouseName;
  final String? address;
  final String? mobile;
  final String? email;
  final String? status;
  final int? itemsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WarehouseData({
    this.id,
    this.userId,
    this.storeId,
    this.warehouseType,
    this.warehouseName,
    this.address,
    this.mobile,
    this.email,
    this.status,
    this.itemsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory WarehouseData.fromJson(Map<String, dynamic> json) {
    return WarehouseData(
      id: json['id'],
      userId: json['user_id'],
      storeId: json['store_id'],
      warehouseType: json['warehouse_type'],
      warehouseName: json['warehouse_name'],
      address: json['address'],
      mobile: json['mobile'],
      email: json['email'],
      status: json['status'],
      itemsCount: json['items_count'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_id': storeId,
      'warehouse_type': warehouseType,
      'warehouse_name': warehouseName,
      'address': address,
      'mobile': mobile,
      'email': email,
      'status': status,
      'items_count': itemsCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

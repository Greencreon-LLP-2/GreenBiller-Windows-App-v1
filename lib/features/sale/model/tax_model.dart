class TaxModel {
  final String? message;
  final List<SingleTaxModel>? data;
  final int? status;

  TaxModel({
    this.message,
    this.data,
    this.status,
  });

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SingleTaxModel.fromJson(e as Map<String, dynamic>))
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

class SingleTaxModel {
  final int? id;
  final String? storeId;
  final String? taxName;
  final String? tax;
  final String? ifGroup;
  final String? subtaxIds;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SingleTaxModel({
    this.id,
    this.storeId,
    this.taxName,
    this.tax,
    this.ifGroup,
    this.subtaxIds,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleTaxModel.fromJson(Map<String, dynamic> json) {
    return SingleTaxModel(
      id: json['id'] as int?,
      storeId: json['store_id'] as String?,
      taxName: json['tax_name'] as String?,
      tax: json['tax'] as String?,
      ifGroup: json['if_group'] as String?,
      subtaxIds: json['subtax_ids'] as String?,
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
      'tax_name': taxName,
      'tax': tax,
      'if_group': ifGroup,
      'subtax_ids': subtaxIds,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

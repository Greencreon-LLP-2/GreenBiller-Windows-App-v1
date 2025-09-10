class SupplierModel {
  final String? message;
  final List<SupplierData>? data;
  final int? total;
  final int? status;
  final SupplierInsights? insights;

  SupplierModel({
    this.message,
    this.data,
    this.total,
    this.status,
    this.insights,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => SupplierData.fromJson(e)).toList()
          : null,
      total: json['total'],
      status: json['status'],
      insights: json['insights'] != null
          ? SupplierInsights.fromJson(json['insights'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
    'total': total,
    'status': status,
    'insights': insights?.toJson(),
  };
}

class SupplierData {
  final int? id;
  final String? storeId;
  final dynamic coundId;
  final dynamic supplierCode;
  final String? supplierName;
  final String? mobile;
  final dynamic phone;
  final String? email;
  final String? gstin;
  final dynamic taxNumber;
  final dynamic vatin;
  final dynamic openingBalance;
  final dynamic purchaseDue;
  final dynamic purchaseReturnDue;
  final dynamic countryId;
  final dynamic stateId;
  final dynamic state;
  final dynamic city;
  final dynamic postcode;
  final String? address;
  final dynamic companyId;
  final dynamic status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? storeName;

  SupplierData({
    this.id,
    this.storeId,
    this.coundId,
    this.supplierCode,
    this.supplierName,
    this.mobile,
    this.phone,
    this.email,
    this.gstin,
    this.taxNumber,
    this.vatin,
    this.openingBalance,
    this.purchaseDue,
    this.purchaseReturnDue,
    this.countryId,
    this.stateId,
    this.state,
    this.city,
    this.postcode,
    this.address,
    this.companyId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.storeName,
  });

  factory SupplierData.fromJson(Map<String, dynamic> json) {
    return SupplierData(
      id: json['id'],
      storeId: json['store_id'],
      coundId: json['cound_id'],
      supplierCode: json['supplier_code'],
      supplierName: json['supplier_name'],
      mobile: json['mobile'],
      phone: json['phone'],
      email: json['email'],
      gstin: json['gstin'],
      taxNumber: json['tax_number'],
      vatin: json['vatin'],
      openingBalance: json['opening_balance'],
      purchaseDue: json['purchase_due'],
      purchaseReturnDue: json['purchase_return_due'],
      countryId: json['country_id'],
      stateId: json['state_id'],
      state: json['state'],
      city: json['city'],
      postcode: json['postcode'],
      address: json['address'],
      companyId: json['company_id'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      storeName: json['store_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'cound_id': coundId,
    'supplier_code': supplierCode,
    'supplier_name': supplierName,
    'mobile': mobile,
    'phone': phone,
    'email': email,
    'gstin': gstin,
    'tax_number': taxNumber,
    'vatin': vatin,
    'opening_balance': openingBalance,
    'purchase_due': purchaseDue,
    'purchase_return_due': purchaseReturnDue,
    'country_id': countryId,
    'state_id': stateId,
    'state': state,
    'city': city,
    'postcode': postcode,
    'address': address,
    'company_id': companyId,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'store_name': storeName,
  };
}

class SupplierInsights {
  final int? totalSuppliers;
  final int? newSuppliersLast30Days;

  SupplierInsights({this.totalSuppliers, this.newSuppliersLast30Days});

  factory SupplierInsights.fromJson(Map<String, dynamic> json) {
    return SupplierInsights(
      totalSuppliers: json['total_suppliers'],
      newSuppliersLast30Days: json['new_suppliers_last_30_days'],
    );
  }

  Map<String, dynamic> toJson() => {
    'total_suppliers': totalSuppliers,
    'new_suppliers_last_30_days': newSuppliersLast30Days,
  };
}

class CustomerModel {
  final String? message;
  final List<CustomerData>? data;
  final int? total;
  final int? status;
  final CustomerInsights? insights;

  CustomerModel({
    this.message,
    this.data,
    this.total,
    this.status,
    this.insights,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => CustomerData.fromJson(e))
              .toList()
          : null,
      total: json['total'],
      status: json['status'],
      insights: json['insights'] != null
          ? CustomerInsights.fromJson(json['insights'])
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

class CustomerData {
  final int? id;
  final String? storeId;
  final String? userId;
  final dynamic countId;
  final dynamic customerCode;
  final String? customerName;
  final String? mobile;
  final dynamic phone;
  final String? email;
  final String? gstin;
  final dynamic taxNumber;
  final dynamic vatin;
  final dynamic openingBalance;
  final dynamic salesDue;
  final dynamic salesReturnDue;
  final dynamic countryId;
  final dynamic state;
  final dynamic city;
  final dynamic postcode;
  final String? address;
  final dynamic locationLink;
  final dynamic attachment1;
  final dynamic priceLevelType;
  final dynamic priceLevel;
  final dynamic deleteBit;
  final dynamic totAdvance;
  final dynamic creditLimit;
  final dynamic status;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? storeName;
  final dynamic country;

  CustomerData({
    this.id,
    this.storeId,
    this.userId,
    this.countId,
    this.customerCode,
    this.customerName,
    this.mobile,
    this.phone,
    this.email,
    this.gstin,
    this.taxNumber,
    this.vatin,
    this.openingBalance,
    this.salesDue,
    this.salesReturnDue,
    this.countryId,
    this.state,
    this.city,
    this.postcode,
    this.address,
    this.locationLink,
    this.attachment1,
    this.priceLevelType,
    this.priceLevel,
    this.deleteBit,
    this.totAdvance,
    this.creditLimit,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.storeName,
    this.country,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'],
      storeId: json['store_id'],
      userId: json['user_id'],
      countId: json['count_id'],
      customerCode: json['customer_code'],
      customerName: json['customer_name'],
      mobile: json['mobile'],
      phone: json['phone'],
      email: json['email'],
      gstin: json['gstin'],
      taxNumber: json['tax_number'],
      vatin: json['vatin'],
      openingBalance: json['opening_balance'],
      salesDue: json['sales_due'],
      salesReturnDue: json['sales_return_due'],
      countryId: json['country_id'],
      state: json['state'],
      city: json['city'],
      postcode: json['postcode'],
      address: json['address'],
      locationLink: json['location_link'],
      attachment1: json['attachment_1'],
      priceLevelType: json['price_level_type'],
      priceLevel: json['price_level'],
      deleteBit: json['delete_bit'],
      totAdvance: json['tot_advance'],
      creditLimit: json['credit_limit'],
      status: json['status'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      storeName: json['store_name'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_id': storeId,
        'user_id': userId,
        'count_id': countId,
        'customer_code': customerCode,
        'customer_name': customerName,
        'mobile': mobile,
        'phone': phone,
        'email': email,
        'gstin': gstin,
        'tax_number': taxNumber,
        'vatin': vatin,
        'opening_balance': openingBalance,
        'sales_due': salesDue,
        'sales_return_due': salesReturnDue,
        'country_id': countryId,
        'state': state,
        'city': city,
        'postcode': postcode,
        'address': address,
        'location_link': locationLink,
        'attachment_1': attachment1,
        'price_level_type': priceLevelType,
        'price_level': priceLevel,
        'delete_bit': deleteBit,
        'tot_advance': totAdvance,
        'credit_limit': creditLimit,
        'status': status,
        'created_by': createdBy,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'store_name': storeName,
        'country': country,
      };
}

class CustomerInsights {
  final int? totalCustomers;
  final int? newCustomersLast30Days;

  CustomerInsights({
    this.totalCustomers,
    this.newCustomersLast30Days,
  });

  factory CustomerInsights.fromJson(Map<String, dynamic> json) {
    return CustomerInsights(
      totalCustomers: json['total_customers'],
      newCustomersLast30Days: json['new_customers_last_30_days'],
    );
  }

  Map<String, dynamic> toJson() => {
        'total_customers': totalCustomers,
        'new_customers_last_30_days': newCustomersLast30Days,
      };
}

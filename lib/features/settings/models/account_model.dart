import 'dart:convert';

class AccountModel {
  final String? message;
  final List<SingleAccount>? data;
  final int? status;

  AccountModel({
    this.message,
    this.data,
    this.status,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => SingleAccount.fromJson(e)).toList()
          : null,
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

class SingleAccount {
  final int? id;
  final String? accountName;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiId;
  final String? balance;
  final String? userId;
  final String? storeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SingleAccount({
    this.id,
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.upiId,
    this.balance,
    this.userId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  factory SingleAccount.fromJson(Map<String, dynamic> json) {
    return SingleAccount(
      id: json['id'] as int?,
      accountName: json['account_name'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      upiId: json['upi_id'] as String?,
      balance: json['balance'] as String?,
      userId: json['user_id'] as String?,
      storeId: json['store_id'] as String?,
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
      'account_name': accountName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'upi_id': upiId,
      'balance': balance,
      'user_id': userId,
      'store_id': storeId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part "account_model.freezed.dart";
part "account_model.g.dart";

@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _AccountModel;
  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "account_name") String? accountName,
    @JsonKey(name: "bank_name") String? bankName,
    @JsonKey(name: "account_number") String? accountNumber,
    @JsonKey(name: "ifsc_code") String? ifscCode,
    @JsonKey(name: "upi_id") String? upiId,
    @JsonKey(name: "balance") String? balance,
    @JsonKey(name: "user_id") String? userId,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _Datum;
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

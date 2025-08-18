import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'tax_model.freezed.dart';
part 'tax_model.g.dart';

@freezed
abstract class TaxModel with _$TaxModel {
  const factory TaxModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _TaxModel;
  factory TaxModel.fromJson(Map<String, dynamic> json) =>
      _$TaxModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "tax_name") String? taxName,
    @JsonKey(name: "tax") String? tax,
    @JsonKey(name: "if_group") String? ifGroup,
    @JsonKey(name: "subtax_ids") String? subtaxIds,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _Datum;
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

final taxProvider = StateProvider<TaxModel?>((ref) => null);

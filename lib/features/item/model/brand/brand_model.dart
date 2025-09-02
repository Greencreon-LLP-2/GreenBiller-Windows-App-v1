// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

@freezed
abstract class BrandModel with _$BrandModel {
  const factory BrandModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _BrandModel;
  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    @JsonKey(name: "id") int? id,
    @JsonKey(name: "store_id") String? storeId,
    @JsonKey(name: "slug") String? slug,
    @JsonKey(name: "count_id") String? countId,
    @JsonKey(name: "brand_code") String? brandCode,
    @JsonKey(name: "brand_name") String? brandName,
    @JsonKey(name: "brand_image") String? brandImage,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "status") int? status,
    @JsonKey(name: "inapp_view") String? inappView,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "updated_at") DateTime? updatedAt,
  }) = _Datum;
  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

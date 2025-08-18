import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_model.freezed.dart';
part 'unit_model.g.dart';

@freezed
abstract class UnitModel with _$UnitModel {
    const factory UnitModel({
        @JsonKey(name: "message")
        String? message,
        @JsonKey(name: "data")
        List<Datum>? data,
        @JsonKey(name: "status")
        int? status,
    }) = _UnitModel;
    factory UnitModel.fromJson(Map<String, dynamic> json) => _$UnitModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
    const factory Datum({
        @JsonKey(name: "id")
        int? id,
        @JsonKey(name: "store_id")
        String? storeId,
        @JsonKey(name: "parent_id")
        String? parentId,
        @JsonKey(name: "unit_name")
        String? unitName,
        @JsonKey(name: "unit_value")
        String? unitValue,
        @JsonKey(name: "description")
        String? description,
        @JsonKey(name: "status")
        String? status,
        @JsonKey(name: "created_at")
        DateTime? createdAt,
        @JsonKey(name: "updated_at")
        DateTime? updatedAt,
    }) = _Datum;
    factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

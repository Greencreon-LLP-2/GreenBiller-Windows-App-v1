import 'package:freezed_annotation/freezed_annotation.dart';

part 'package_model.freezed.dart';
part 'package_model.g.dart';

@freezed
abstract class PackageModel with _$PackageModel {
  const factory PackageModel({
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "data") List<Datum>? data,
    @JsonKey(name: "status") int? status,
  }) = _PackageModel;
  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);
}

@freezed
abstract class Datum with _$Datum {
  const factory Datum({
    int? id,
    @JsonKey(name: "package_name") String? packageName,
    String? description,
    @JsonKey(name: "validity_date") String? validityDate,
    @JsonKey(name: "if_webpanel") String? ifWebpanel,
    @JsonKey(name: "if_android") String? ifAndroid,
    @JsonKey(name: "if_ios") String? ifIos,
    @JsonKey(name: "if_windows") String? ifWindows,
    String? price,
    String? image,
    @JsonKey(name: "if_customerapp") String? ifCustomerApp,
    @JsonKey(name: "if_deliveryapp") String? ifDeliveryApp,
    @JsonKey(name: "if_exicutiveapp") String? ifExecutiveApp,
    @JsonKey(name: "if_multistore") String? ifMultistore,
    @JsonKey(name: "price_per_store") String? pricePerStore,
    @JsonKey(name: "if_numberof_store") String? ifNumberOfStore,
    String? status,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _Datum;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
}

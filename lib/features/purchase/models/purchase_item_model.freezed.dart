// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseItemModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "data") List<Datum>? get data;@JsonKey(name: "status") int? get status;
/// Create a copy of PurchaseItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseItemModelCopyWith<PurchaseItemModel> get copyWith => _$PurchaseItemModelCopyWithImpl<PurchaseItemModel>(this as PurchaseItemModel, _$identity);

  /// Serializes this PurchaseItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseItemModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data),status);

@override
String toString() {
  return 'PurchaseItemModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class $PurchaseItemModelCopyWith<$Res>  {
  factory $PurchaseItemModelCopyWith(PurchaseItemModel value, $Res Function(PurchaseItemModel) _then) = _$PurchaseItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class _$PurchaseItemModelCopyWithImpl<$Res>
    implements $PurchaseItemModelCopyWith<$Res> {
  _$PurchaseItemModelCopyWithImpl(this._self, this._then);

  final PurchaseItemModel _self;
  final $Res Function(PurchaseItemModel) _then;

/// Create a copy of PurchaseItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,Object? data = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseItemModel].
extension PurchaseItemModelPatterns on PurchaseItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseItemModel value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<Datum>? data, @JsonKey(name: "status")  int? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseItemModel() when $default != null:
return $default(_that.message,_that.data,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<Datum>? data, @JsonKey(name: "status")  int? status)  $default,) {final _that = this;
switch (_that) {
case _PurchaseItemModel():
return $default(_that.message,_that.data,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<Datum>? data, @JsonKey(name: "status")  int? status)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseItemModel() when $default != null:
return $default(_that.message,_that.data,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseItemModel implements PurchaseItemModel {
  const _PurchaseItemModel({@JsonKey(name: "message") this.message, @JsonKey(name: "data") final  List<Datum>? data, @JsonKey(name: "status") this.status}): _data = data;
  factory _PurchaseItemModel.fromJson(Map<String, dynamic> json) => _$PurchaseItemModelFromJson(json);

@override@JsonKey(name: "message") final  String? message;
 final  List<Datum>? _data;
@override@JsonKey(name: "data") List<Datum>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "status") final  int? status;

/// Create a copy of PurchaseItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseItemModelCopyWith<_PurchaseItemModel> get copyWith => __$PurchaseItemModelCopyWithImpl<_PurchaseItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseItemModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data),status);

@override
String toString() {
  return 'PurchaseItemModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PurchaseItemModelCopyWith<$Res> implements $PurchaseItemModelCopyWith<$Res> {
  factory _$PurchaseItemModelCopyWith(_PurchaseItemModel value, $Res Function(_PurchaseItemModel) _then) = __$PurchaseItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class __$PurchaseItemModelCopyWithImpl<$Res>
    implements _$PurchaseItemModelCopyWith<$Res> {
  __$PurchaseItemModelCopyWithImpl(this._self, this._then);

  final _PurchaseItemModel _self;
  final $Res Function(_PurchaseItemModel) _then;

/// Create a copy of PurchaseItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,Object? status = freezed,}) {
  return _then(_PurchaseItemModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Datum {

@JsonKey(name: "id") int? get id;@JsonKey(name: "store_id") String? get storeId;@JsonKey(name: "purchase_id") String? get purchaseId;@JsonKey(name: "purchase_status") String? get purchaseStatus;@JsonKey(name: "item_id") String? get itemId;@JsonKey(name: "item_name") String get itemName;@JsonKey(name: "bar_code") String? get barCode;@JsonKey(name: "purchase_qty") String? get purchaseQty;@JsonKey(name: "price_per_unit") String get pricePerUnit;@JsonKey(name: "tax_type") String? get taxType;@JsonKey(name: "tax_id") String? get taxId;@JsonKey(name: "tax_amt") String? get taxAmt;@JsonKey(name: "discount_type") String? get discountType;@JsonKey(name: "discount_input") String? get discountInput;@JsonKey(name: "discount_amt") String? get discountAmt;@JsonKey(name: "unit_total_cost") String? get unitTotalCost;@JsonKey(name: "total_cost") String? get totalCost;@JsonKey(name: "profit_margin_per") String? get profitMarginPer;@JsonKey(name: "unit_sales_price") String? get unitSalesPrice;@JsonKey(name: "stock") String? get stock;@JsonKey(name: "if_batch") String? get ifBatch;@JsonKey(name: "batch_no") String? get batchNo;@JsonKey(name: "if_expirydate") String? get ifExpirydate;@JsonKey(name: "expire_date") dynamic get expireDate;@JsonKey(name: "description") String? get description;@JsonKey(name: "status") String? get status;@JsonKey(name: "created_at") DateTime? get createdAt;@JsonKey(name: "updated_at") DateTime? get updatedAt;@JsonKey(name: "unit") String? get unit;
/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatumCopyWith<Datum> get copyWith => _$DatumCopyWithImpl<Datum>(this as Datum, _$identity);

  /// Serializes this Datum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.purchaseId, purchaseId) || other.purchaseId == purchaseId)&&(identical(other.purchaseStatus, purchaseStatus) || other.purchaseStatus == purchaseStatus)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.barCode, barCode) || other.barCode == barCode)&&(identical(other.purchaseQty, purchaseQty) || other.purchaseQty == purchaseQty)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.taxType, taxType) || other.taxType == taxType)&&(identical(other.taxId, taxId) || other.taxId == taxId)&&(identical(other.taxAmt, taxAmt) || other.taxAmt == taxAmt)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountInput, discountInput) || other.discountInput == discountInput)&&(identical(other.discountAmt, discountAmt) || other.discountAmt == discountAmt)&&(identical(other.unitTotalCost, unitTotalCost) || other.unitTotalCost == unitTotalCost)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.profitMarginPer, profitMarginPer) || other.profitMarginPer == profitMarginPer)&&(identical(other.unitSalesPrice, unitSalesPrice) || other.unitSalesPrice == unitSalesPrice)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.ifBatch, ifBatch) || other.ifBatch == ifBatch)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.ifExpirydate, ifExpirydate) || other.ifExpirydate == ifExpirydate)&&const DeepCollectionEquality().equals(other.expireDate, expireDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,purchaseId,purchaseStatus,itemId,itemName,barCode,purchaseQty,pricePerUnit,taxType,taxId,taxAmt,discountType,discountInput,discountAmt,unitTotalCost,totalCost,profitMarginPer,unitSalesPrice,stock,ifBatch,batchNo,ifExpirydate,const DeepCollectionEquality().hash(expireDate),description,status,createdAt,updatedAt,unit]);

@override
String toString() {
  return 'Datum(id: $id, storeId: $storeId, purchaseId: $purchaseId, purchaseStatus: $purchaseStatus, itemId: $itemId, itemName: $itemName, barCode: $barCode, purchaseQty: $purchaseQty, pricePerUnit: $pricePerUnit, taxType: $taxType, taxId: $taxId, taxAmt: $taxAmt, discountType: $discountType, discountInput: $discountInput, discountAmt: $discountAmt, unitTotalCost: $unitTotalCost, totalCost: $totalCost, profitMarginPer: $profitMarginPer, unitSalesPrice: $unitSalesPrice, stock: $stock, ifBatch: $ifBatch, batchNo: $batchNo, ifExpirydate: $ifExpirydate, expireDate: $expireDate, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res>  {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) = _$DatumCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "purchase_id") String? purchaseId,@JsonKey(name: "purchase_status") String? purchaseStatus,@JsonKey(name: "item_id") String? itemId,@JsonKey(name: "item_name") String itemName,@JsonKey(name: "bar_code") String? barCode,@JsonKey(name: "purchase_qty") String? purchaseQty,@JsonKey(name: "price_per_unit") String pricePerUnit,@JsonKey(name: "tax_type") String? taxType,@JsonKey(name: "tax_id") String? taxId,@JsonKey(name: "tax_amt") String? taxAmt,@JsonKey(name: "discount_type") String? discountType,@JsonKey(name: "discount_input") String? discountInput,@JsonKey(name: "discount_amt") String? discountAmt,@JsonKey(name: "unit_total_cost") String? unitTotalCost,@JsonKey(name: "total_cost") String? totalCost,@JsonKey(name: "profit_margin_per") String? profitMarginPer,@JsonKey(name: "unit_sales_price") String? unitSalesPrice,@JsonKey(name: "stock") String? stock,@JsonKey(name: "if_batch") String? ifBatch,@JsonKey(name: "batch_no") String? batchNo,@JsonKey(name: "if_expirydate") String? ifExpirydate,@JsonKey(name: "expire_date") dynamic expireDate,@JsonKey(name: "description") String? description,@JsonKey(name: "status") String? status,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "unit") String? unit
});




}
/// @nodoc
class _$DatumCopyWithImpl<$Res>
    implements $DatumCopyWith<$Res> {
  _$DatumCopyWithImpl(this._self, this._then);

  final Datum _self;
  final $Res Function(Datum) _then;

/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? storeId = freezed,Object? purchaseId = freezed,Object? purchaseStatus = freezed,Object? itemId = freezed,Object? itemName = null,Object? barCode = freezed,Object? purchaseQty = freezed,Object? pricePerUnit = null,Object? taxType = freezed,Object? taxId = freezed,Object? taxAmt = freezed,Object? discountType = freezed,Object? discountInput = freezed,Object? discountAmt = freezed,Object? unitTotalCost = freezed,Object? totalCost = freezed,Object? profitMarginPer = freezed,Object? unitSalesPrice = freezed,Object? stock = freezed,Object? ifBatch = freezed,Object? batchNo = freezed,Object? ifExpirydate = freezed,Object? expireDate = freezed,Object? description = freezed,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? unit = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,purchaseId: freezed == purchaseId ? _self.purchaseId : purchaseId // ignore: cast_nullable_to_non_nullable
as String?,purchaseStatus: freezed == purchaseStatus ? _self.purchaseStatus : purchaseStatus // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,barCode: freezed == barCode ? _self.barCode : barCode // ignore: cast_nullable_to_non_nullable
as String?,purchaseQty: freezed == purchaseQty ? _self.purchaseQty : purchaseQty // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as String,taxType: freezed == taxType ? _self.taxType : taxType // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,taxAmt: freezed == taxAmt ? _self.taxAmt : taxAmt // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountInput: freezed == discountInput ? _self.discountInput : discountInput // ignore: cast_nullable_to_non_nullable
as String?,discountAmt: freezed == discountAmt ? _self.discountAmt : discountAmt // ignore: cast_nullable_to_non_nullable
as String?,unitTotalCost: freezed == unitTotalCost ? _self.unitTotalCost : unitTotalCost // ignore: cast_nullable_to_non_nullable
as String?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as String?,profitMarginPer: freezed == profitMarginPer ? _self.profitMarginPer : profitMarginPer // ignore: cast_nullable_to_non_nullable
as String?,unitSalesPrice: freezed == unitSalesPrice ? _self.unitSalesPrice : unitSalesPrice // ignore: cast_nullable_to_non_nullable
as String?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as String?,ifBatch: freezed == ifBatch ? _self.ifBatch : ifBatch // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,ifExpirydate: freezed == ifExpirydate ? _self.ifExpirydate : ifExpirydate // ignore: cast_nullable_to_non_nullable
as String?,expireDate: freezed == expireDate ? _self.expireDate : expireDate // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Datum].
extension DatumPatterns on Datum {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Datum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Datum value)  $default,){
final _that = this;
switch (_that) {
case _Datum():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Datum value)?  $default,){
final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "purchase_id")  String? purchaseId, @JsonKey(name: "purchase_status")  String? purchaseStatus, @JsonKey(name: "item_id")  String? itemId, @JsonKey(name: "item_name")  String itemName, @JsonKey(name: "bar_code")  String? barCode, @JsonKey(name: "purchase_qty")  String? purchaseQty, @JsonKey(name: "price_per_unit")  String pricePerUnit, @JsonKey(name: "tax_type")  String? taxType, @JsonKey(name: "tax_id")  String? taxId, @JsonKey(name: "tax_amt")  String? taxAmt, @JsonKey(name: "discount_type")  String? discountType, @JsonKey(name: "discount_input")  String? discountInput, @JsonKey(name: "discount_amt")  String? discountAmt, @JsonKey(name: "unit_total_cost")  String? unitTotalCost, @JsonKey(name: "total_cost")  String? totalCost, @JsonKey(name: "profit_margin_per")  String? profitMarginPer, @JsonKey(name: "unit_sales_price")  String? unitSalesPrice, @JsonKey(name: "stock")  String? stock, @JsonKey(name: "if_batch")  String? ifBatch, @JsonKey(name: "batch_no")  String? batchNo, @JsonKey(name: "if_expirydate")  String? ifExpirydate, @JsonKey(name: "expire_date")  dynamic expireDate, @JsonKey(name: "description")  String? description, @JsonKey(name: "status")  String? status, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "unit")  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.storeId,_that.purchaseId,_that.purchaseStatus,_that.itemId,_that.itemName,_that.barCode,_that.purchaseQty,_that.pricePerUnit,_that.taxType,_that.taxId,_that.taxAmt,_that.discountType,_that.discountInput,_that.discountAmt,_that.unitTotalCost,_that.totalCost,_that.profitMarginPer,_that.unitSalesPrice,_that.stock,_that.ifBatch,_that.batchNo,_that.ifExpirydate,_that.expireDate,_that.description,_that.status,_that.createdAt,_that.updatedAt,_that.unit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "purchase_id")  String? purchaseId, @JsonKey(name: "purchase_status")  String? purchaseStatus, @JsonKey(name: "item_id")  String? itemId, @JsonKey(name: "item_name")  String itemName, @JsonKey(name: "bar_code")  String? barCode, @JsonKey(name: "purchase_qty")  String? purchaseQty, @JsonKey(name: "price_per_unit")  String pricePerUnit, @JsonKey(name: "tax_type")  String? taxType, @JsonKey(name: "tax_id")  String? taxId, @JsonKey(name: "tax_amt")  String? taxAmt, @JsonKey(name: "discount_type")  String? discountType, @JsonKey(name: "discount_input")  String? discountInput, @JsonKey(name: "discount_amt")  String? discountAmt, @JsonKey(name: "unit_total_cost")  String? unitTotalCost, @JsonKey(name: "total_cost")  String? totalCost, @JsonKey(name: "profit_margin_per")  String? profitMarginPer, @JsonKey(name: "unit_sales_price")  String? unitSalesPrice, @JsonKey(name: "stock")  String? stock, @JsonKey(name: "if_batch")  String? ifBatch, @JsonKey(name: "batch_no")  String? batchNo, @JsonKey(name: "if_expirydate")  String? ifExpirydate, @JsonKey(name: "expire_date")  dynamic expireDate, @JsonKey(name: "description")  String? description, @JsonKey(name: "status")  String? status, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "unit")  String? unit)  $default,) {final _that = this;
switch (_that) {
case _Datum():
return $default(_that.id,_that.storeId,_that.purchaseId,_that.purchaseStatus,_that.itemId,_that.itemName,_that.barCode,_that.purchaseQty,_that.pricePerUnit,_that.taxType,_that.taxId,_that.taxAmt,_that.discountType,_that.discountInput,_that.discountAmt,_that.unitTotalCost,_that.totalCost,_that.profitMarginPer,_that.unitSalesPrice,_that.stock,_that.ifBatch,_that.batchNo,_that.ifExpirydate,_that.expireDate,_that.description,_that.status,_that.createdAt,_that.updatedAt,_that.unit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "purchase_id")  String? purchaseId, @JsonKey(name: "purchase_status")  String? purchaseStatus, @JsonKey(name: "item_id")  String? itemId, @JsonKey(name: "item_name")  String itemName, @JsonKey(name: "bar_code")  String? barCode, @JsonKey(name: "purchase_qty")  String? purchaseQty, @JsonKey(name: "price_per_unit")  String pricePerUnit, @JsonKey(name: "tax_type")  String? taxType, @JsonKey(name: "tax_id")  String? taxId, @JsonKey(name: "tax_amt")  String? taxAmt, @JsonKey(name: "discount_type")  String? discountType, @JsonKey(name: "discount_input")  String? discountInput, @JsonKey(name: "discount_amt")  String? discountAmt, @JsonKey(name: "unit_total_cost")  String? unitTotalCost, @JsonKey(name: "total_cost")  String? totalCost, @JsonKey(name: "profit_margin_per")  String? profitMarginPer, @JsonKey(name: "unit_sales_price")  String? unitSalesPrice, @JsonKey(name: "stock")  String? stock, @JsonKey(name: "if_batch")  String? ifBatch, @JsonKey(name: "batch_no")  String? batchNo, @JsonKey(name: "if_expirydate")  String? ifExpirydate, @JsonKey(name: "expire_date")  dynamic expireDate, @JsonKey(name: "description")  String? description, @JsonKey(name: "status")  String? status, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "unit")  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.storeId,_that.purchaseId,_that.purchaseStatus,_that.itemId,_that.itemName,_that.barCode,_that.purchaseQty,_that.pricePerUnit,_that.taxType,_that.taxId,_that.taxAmt,_that.discountType,_that.discountInput,_that.discountAmt,_that.unitTotalCost,_that.totalCost,_that.profitMarginPer,_that.unitSalesPrice,_that.stock,_that.ifBatch,_that.batchNo,_that.ifExpirydate,_that.expireDate,_that.description,_that.status,_that.createdAt,_that.updatedAt,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Datum implements Datum {
  const _Datum({@JsonKey(name: "id") this.id, @JsonKey(name: "store_id") this.storeId, @JsonKey(name: "purchase_id") this.purchaseId, @JsonKey(name: "purchase_status") this.purchaseStatus, @JsonKey(name: "item_id") this.itemId, @JsonKey(name: "item_name") required this.itemName, @JsonKey(name: "bar_code") this.barCode, @JsonKey(name: "purchase_qty") this.purchaseQty, @JsonKey(name: "price_per_unit") required this.pricePerUnit, @JsonKey(name: "tax_type") this.taxType, @JsonKey(name: "tax_id") this.taxId, @JsonKey(name: "tax_amt") this.taxAmt, @JsonKey(name: "discount_type") this.discountType, @JsonKey(name: "discount_input") this.discountInput, @JsonKey(name: "discount_amt") this.discountAmt, @JsonKey(name: "unit_total_cost") this.unitTotalCost, @JsonKey(name: "total_cost") this.totalCost, @JsonKey(name: "profit_margin_per") this.profitMarginPer, @JsonKey(name: "unit_sales_price") this.unitSalesPrice, @JsonKey(name: "stock") this.stock, @JsonKey(name: "if_batch") this.ifBatch, @JsonKey(name: "batch_no") this.batchNo, @JsonKey(name: "if_expirydate") this.ifExpirydate, @JsonKey(name: "expire_date") this.expireDate, @JsonKey(name: "description") this.description, @JsonKey(name: "status") this.status, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt, @JsonKey(name: "unit") this.unit});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

@override@JsonKey(name: "id") final  int? id;
@override@JsonKey(name: "store_id") final  String? storeId;
@override@JsonKey(name: "purchase_id") final  String? purchaseId;
@override@JsonKey(name: "purchase_status") final  String? purchaseStatus;
@override@JsonKey(name: "item_id") final  String? itemId;
@override@JsonKey(name: "item_name") final  String itemName;
@override@JsonKey(name: "bar_code") final  String? barCode;
@override@JsonKey(name: "purchase_qty") final  String? purchaseQty;
@override@JsonKey(name: "price_per_unit") final  String pricePerUnit;
@override@JsonKey(name: "tax_type") final  String? taxType;
@override@JsonKey(name: "tax_id") final  String? taxId;
@override@JsonKey(name: "tax_amt") final  String? taxAmt;
@override@JsonKey(name: "discount_type") final  String? discountType;
@override@JsonKey(name: "discount_input") final  String? discountInput;
@override@JsonKey(name: "discount_amt") final  String? discountAmt;
@override@JsonKey(name: "unit_total_cost") final  String? unitTotalCost;
@override@JsonKey(name: "total_cost") final  String? totalCost;
@override@JsonKey(name: "profit_margin_per") final  String? profitMarginPer;
@override@JsonKey(name: "unit_sales_price") final  String? unitSalesPrice;
@override@JsonKey(name: "stock") final  String? stock;
@override@JsonKey(name: "if_batch") final  String? ifBatch;
@override@JsonKey(name: "batch_no") final  String? batchNo;
@override@JsonKey(name: "if_expirydate") final  String? ifExpirydate;
@override@JsonKey(name: "expire_date") final  dynamic expireDate;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "status") final  String? status;
@override@JsonKey(name: "created_at") final  DateTime? createdAt;
@override@JsonKey(name: "updated_at") final  DateTime? updatedAt;
@override@JsonKey(name: "unit") final  String? unit;

/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatumCopyWith<_Datum> get copyWith => __$DatumCopyWithImpl<_Datum>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.purchaseId, purchaseId) || other.purchaseId == purchaseId)&&(identical(other.purchaseStatus, purchaseStatus) || other.purchaseStatus == purchaseStatus)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.barCode, barCode) || other.barCode == barCode)&&(identical(other.purchaseQty, purchaseQty) || other.purchaseQty == purchaseQty)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.taxType, taxType) || other.taxType == taxType)&&(identical(other.taxId, taxId) || other.taxId == taxId)&&(identical(other.taxAmt, taxAmt) || other.taxAmt == taxAmt)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountInput, discountInput) || other.discountInput == discountInput)&&(identical(other.discountAmt, discountAmt) || other.discountAmt == discountAmt)&&(identical(other.unitTotalCost, unitTotalCost) || other.unitTotalCost == unitTotalCost)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.profitMarginPer, profitMarginPer) || other.profitMarginPer == profitMarginPer)&&(identical(other.unitSalesPrice, unitSalesPrice) || other.unitSalesPrice == unitSalesPrice)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.ifBatch, ifBatch) || other.ifBatch == ifBatch)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.ifExpirydate, ifExpirydate) || other.ifExpirydate == ifExpirydate)&&const DeepCollectionEquality().equals(other.expireDate, expireDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,purchaseId,purchaseStatus,itemId,itemName,barCode,purchaseQty,pricePerUnit,taxType,taxId,taxAmt,discountType,discountInput,discountAmt,unitTotalCost,totalCost,profitMarginPer,unitSalesPrice,stock,ifBatch,batchNo,ifExpirydate,const DeepCollectionEquality().hash(expireDate),description,status,createdAt,updatedAt,unit]);

@override
String toString() {
  return 'Datum(id: $id, storeId: $storeId, purchaseId: $purchaseId, purchaseStatus: $purchaseStatus, itemId: $itemId, itemName: $itemName, barCode: $barCode, purchaseQty: $purchaseQty, pricePerUnit: $pricePerUnit, taxType: $taxType, taxId: $taxId, taxAmt: $taxAmt, discountType: $discountType, discountInput: $discountInput, discountAmt: $discountAmt, unitTotalCost: $unitTotalCost, totalCost: $totalCost, profitMarginPer: $profitMarginPer, unitSalesPrice: $unitSalesPrice, stock: $stock, ifBatch: $ifBatch, batchNo: $batchNo, ifExpirydate: $ifExpirydate, expireDate: $expireDate, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$DatumCopyWith<$Res> implements $DatumCopyWith<$Res> {
  factory _$DatumCopyWith(_Datum value, $Res Function(_Datum) _then) = __$DatumCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "purchase_id") String? purchaseId,@JsonKey(name: "purchase_status") String? purchaseStatus,@JsonKey(name: "item_id") String? itemId,@JsonKey(name: "item_name") String itemName,@JsonKey(name: "bar_code") String? barCode,@JsonKey(name: "purchase_qty") String? purchaseQty,@JsonKey(name: "price_per_unit") String pricePerUnit,@JsonKey(name: "tax_type") String? taxType,@JsonKey(name: "tax_id") String? taxId,@JsonKey(name: "tax_amt") String? taxAmt,@JsonKey(name: "discount_type") String? discountType,@JsonKey(name: "discount_input") String? discountInput,@JsonKey(name: "discount_amt") String? discountAmt,@JsonKey(name: "unit_total_cost") String? unitTotalCost,@JsonKey(name: "total_cost") String? totalCost,@JsonKey(name: "profit_margin_per") String? profitMarginPer,@JsonKey(name: "unit_sales_price") String? unitSalesPrice,@JsonKey(name: "stock") String? stock,@JsonKey(name: "if_batch") String? ifBatch,@JsonKey(name: "batch_no") String? batchNo,@JsonKey(name: "if_expirydate") String? ifExpirydate,@JsonKey(name: "expire_date") dynamic expireDate,@JsonKey(name: "description") String? description,@JsonKey(name: "status") String? status,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "unit") String? unit
});




}
/// @nodoc
class __$DatumCopyWithImpl<$Res>
    implements _$DatumCopyWith<$Res> {
  __$DatumCopyWithImpl(this._self, this._then);

  final _Datum _self;
  final $Res Function(_Datum) _then;

/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? storeId = freezed,Object? purchaseId = freezed,Object? purchaseStatus = freezed,Object? itemId = freezed,Object? itemName = null,Object? barCode = freezed,Object? purchaseQty = freezed,Object? pricePerUnit = null,Object? taxType = freezed,Object? taxId = freezed,Object? taxAmt = freezed,Object? discountType = freezed,Object? discountInput = freezed,Object? discountAmt = freezed,Object? unitTotalCost = freezed,Object? totalCost = freezed,Object? profitMarginPer = freezed,Object? unitSalesPrice = freezed,Object? stock = freezed,Object? ifBatch = freezed,Object? batchNo = freezed,Object? ifExpirydate = freezed,Object? expireDate = freezed,Object? description = freezed,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? unit = freezed,}) {
  return _then(_Datum(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,purchaseId: freezed == purchaseId ? _self.purchaseId : purchaseId // ignore: cast_nullable_to_non_nullable
as String?,purchaseStatus: freezed == purchaseStatus ? _self.purchaseStatus : purchaseStatus // ignore: cast_nullable_to_non_nullable
as String?,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,barCode: freezed == barCode ? _self.barCode : barCode // ignore: cast_nullable_to_non_nullable
as String?,purchaseQty: freezed == purchaseQty ? _self.purchaseQty : purchaseQty // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as String,taxType: freezed == taxType ? _self.taxType : taxType // ignore: cast_nullable_to_non_nullable
as String?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,taxAmt: freezed == taxAmt ? _self.taxAmt : taxAmt // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discountInput: freezed == discountInput ? _self.discountInput : discountInput // ignore: cast_nullable_to_non_nullable
as String?,discountAmt: freezed == discountAmt ? _self.discountAmt : discountAmt // ignore: cast_nullable_to_non_nullable
as String?,unitTotalCost: freezed == unitTotalCost ? _self.unitTotalCost : unitTotalCost // ignore: cast_nullable_to_non_nullable
as String?,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as String?,profitMarginPer: freezed == profitMarginPer ? _self.profitMarginPer : profitMarginPer // ignore: cast_nullable_to_non_nullable
as String?,unitSalesPrice: freezed == unitSalesPrice ? _self.unitSalesPrice : unitSalesPrice // ignore: cast_nullable_to_non_nullable
as String?,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as String?,ifBatch: freezed == ifBatch ? _self.ifBatch : ifBatch // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,ifExpirydate: freezed == ifExpirydate ? _self.ifExpirydate : ifExpirydate // ignore: cast_nullable_to_non_nullable
as String?,expireDate: freezed == expireDate ? _self.expireDate : expireDate // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

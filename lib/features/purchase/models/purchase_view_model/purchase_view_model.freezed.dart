// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseViewModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "data") List<Datum>? get data;@JsonKey(name: "status") int? get status;
/// Create a copy of PurchaseViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseViewModelCopyWith<PurchaseViewModel> get copyWith => _$PurchaseViewModelCopyWithImpl<PurchaseViewModel>(this as PurchaseViewModel, _$identity);

  /// Serializes this PurchaseViewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseViewModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data),status);

@override
String toString() {
  return 'PurchaseViewModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class $PurchaseViewModelCopyWith<$Res>  {
  factory $PurchaseViewModelCopyWith(PurchaseViewModel value, $Res Function(PurchaseViewModel) _then) = _$PurchaseViewModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class _$PurchaseViewModelCopyWithImpl<$Res>
    implements $PurchaseViewModelCopyWith<$Res> {
  _$PurchaseViewModelCopyWithImpl(this._self, this._then);

  final PurchaseViewModel _self;
  final $Res Function(PurchaseViewModel) _then;

/// Create a copy of PurchaseViewModel
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


/// Adds pattern-matching-related methods to [PurchaseViewModel].
extension PurchaseViewModelPatterns on PurchaseViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseViewModel value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseViewModel() when $default != null:
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
case _PurchaseViewModel() when $default != null:
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
case _PurchaseViewModel():
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
case _PurchaseViewModel() when $default != null:
return $default(_that.message,_that.data,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseViewModel implements PurchaseViewModel {
  const _PurchaseViewModel({@JsonKey(name: "message") this.message, @JsonKey(name: "data") final  List<Datum>? data, @JsonKey(name: "status") this.status}): _data = data;
  factory _PurchaseViewModel.fromJson(Map<String, dynamic> json) => _$PurchaseViewModelFromJson(json);

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

/// Create a copy of PurchaseViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseViewModelCopyWith<_PurchaseViewModel> get copyWith => __$PurchaseViewModelCopyWithImpl<_PurchaseViewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseViewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseViewModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data),status);

@override
String toString() {
  return 'PurchaseViewModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PurchaseViewModelCopyWith<$Res> implements $PurchaseViewModelCopyWith<$Res> {
  factory _$PurchaseViewModelCopyWith(_PurchaseViewModel value, $Res Function(_PurchaseViewModel) _then) = __$PurchaseViewModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class __$PurchaseViewModelCopyWithImpl<$Res>
    implements _$PurchaseViewModelCopyWith<$Res> {
  __$PurchaseViewModelCopyWithImpl(this._self, this._then);

  final _PurchaseViewModel _self;
  final $Res Function(_PurchaseViewModel) _then;

/// Create a copy of PurchaseViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,Object? status = freezed,}) {
  return _then(_PurchaseViewModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Datum {

@JsonKey(name: "id") int? get id;@JsonKey(name: "store_id") String? get storeId;@JsonKey(name: "warehouse_id") String? get warehouseId;@JsonKey(name: "count_id") dynamic get countId;@JsonKey(name: "purchase_code") String? get purchaseCode;@JsonKey(name: "reference_no") String? get referenceNo;@JsonKey(name: "serial_no") dynamic get serialNo;@JsonKey(name: "purchase_date") DateTime? get purchaseDate;@JsonKey(name: "supplier_id") String? get supplierId;@JsonKey(name: "other_charges_input") dynamic get otherChargesInput;@JsonKey(name: "other_charges_tax_id") dynamic get otherChargesTaxId;@JsonKey(name: "other_charges_amt") dynamic get otherChargesAmt;@JsonKey(name: "discount_to_all_input") dynamic get discountToAllInput;@JsonKey(name: "discount_to_all_type") dynamic get discountToAllType;@JsonKey(name: "tot_discount_to_all_amt") String? get totDiscountToAllAmt;@JsonKey(name: "subtotal") String? get subtotal;@JsonKey(name: "unit") dynamic get unit;@JsonKey(name: "round_off") String? get roundOff;@JsonKey(name: "grand_total") String? get grandTotal;@JsonKey(name: "purchase_note") String? get purchaseNote;@JsonKey(name: "payment_status") String? get paymentStatus;@JsonKey(name: "paid_amount") String? get paidAmount;@JsonKey(name: "company_id") String? get companyId;@JsonKey(name: "status") String? get status;@JsonKey(name: "return_bit") String? get returnBit;@JsonKey(name: "created_by") String? get createdBy;@JsonKey(name: "created_at") DateTime? get createdAt;@JsonKey(name: "updated_at") DateTime? get updatedAt;
/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatumCopyWith<Datum> get copyWith => _$DatumCopyWithImpl<Datum>(this as Datum, _$identity);

  /// Serializes this Datum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&const DeepCollectionEquality().equals(other.countId, countId)&&(identical(other.purchaseCode, purchaseCode) || other.purchaseCode == purchaseCode)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&const DeepCollectionEquality().equals(other.serialNo, serialNo)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&const DeepCollectionEquality().equals(other.otherChargesInput, otherChargesInput)&&const DeepCollectionEquality().equals(other.otherChargesTaxId, otherChargesTaxId)&&const DeepCollectionEquality().equals(other.otherChargesAmt, otherChargesAmt)&&const DeepCollectionEquality().equals(other.discountToAllInput, discountToAllInput)&&const DeepCollectionEquality().equals(other.discountToAllType, discountToAllType)&&(identical(other.totDiscountToAllAmt, totDiscountToAllAmt) || other.totDiscountToAllAmt == totDiscountToAllAmt)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&const DeepCollectionEquality().equals(other.unit, unit)&&(identical(other.roundOff, roundOff) || other.roundOff == roundOff)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.purchaseNote, purchaseNote) || other.purchaseNote == purchaseNote)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.status, status) || other.status == status)&&(identical(other.returnBit, returnBit) || other.returnBit == returnBit)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,warehouseId,const DeepCollectionEquality().hash(countId),purchaseCode,referenceNo,const DeepCollectionEquality().hash(serialNo),purchaseDate,supplierId,const DeepCollectionEquality().hash(otherChargesInput),const DeepCollectionEquality().hash(otherChargesTaxId),const DeepCollectionEquality().hash(otherChargesAmt),const DeepCollectionEquality().hash(discountToAllInput),const DeepCollectionEquality().hash(discountToAllType),totDiscountToAllAmt,subtotal,const DeepCollectionEquality().hash(unit),roundOff,grandTotal,purchaseNote,paymentStatus,paidAmount,companyId,status,returnBit,createdBy,createdAt,updatedAt]);

@override
String toString() {
  return 'Datum(id: $id, storeId: $storeId, warehouseId: $warehouseId, countId: $countId, purchaseCode: $purchaseCode, referenceNo: $referenceNo, serialNo: $serialNo, purchaseDate: $purchaseDate, supplierId: $supplierId, otherChargesInput: $otherChargesInput, otherChargesTaxId: $otherChargesTaxId, otherChargesAmt: $otherChargesAmt, discountToAllInput: $discountToAllInput, discountToAllType: $discountToAllType, totDiscountToAllAmt: $totDiscountToAllAmt, subtotal: $subtotal, unit: $unit, roundOff: $roundOff, grandTotal: $grandTotal, purchaseNote: $purchaseNote, paymentStatus: $paymentStatus, paidAmount: $paidAmount, companyId: $companyId, status: $status, returnBit: $returnBit, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res>  {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) = _$DatumCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "warehouse_id") String? warehouseId,@JsonKey(name: "count_id") dynamic countId,@JsonKey(name: "purchase_code") String? purchaseCode,@JsonKey(name: "reference_no") String? referenceNo,@JsonKey(name: "serial_no") dynamic serialNo,@JsonKey(name: "purchase_date") DateTime? purchaseDate,@JsonKey(name: "supplier_id") String? supplierId,@JsonKey(name: "other_charges_input") dynamic otherChargesInput,@JsonKey(name: "other_charges_tax_id") dynamic otherChargesTaxId,@JsonKey(name: "other_charges_amt") dynamic otherChargesAmt,@JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,@JsonKey(name: "discount_to_all_type") dynamic discountToAllType,@JsonKey(name: "tot_discount_to_all_amt") String? totDiscountToAllAmt,@JsonKey(name: "subtotal") String? subtotal,@JsonKey(name: "unit") dynamic unit,@JsonKey(name: "round_off") String? roundOff,@JsonKey(name: "grand_total") String? grandTotal,@JsonKey(name: "purchase_note") String? purchaseNote,@JsonKey(name: "payment_status") String? paymentStatus,@JsonKey(name: "paid_amount") String? paidAmount,@JsonKey(name: "company_id") String? companyId,@JsonKey(name: "status") String? status,@JsonKey(name: "return_bit") String? returnBit,@JsonKey(name: "created_by") String? createdBy,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? storeId = freezed,Object? warehouseId = freezed,Object? countId = freezed,Object? purchaseCode = freezed,Object? referenceNo = freezed,Object? serialNo = freezed,Object? purchaseDate = freezed,Object? supplierId = freezed,Object? otherChargesInput = freezed,Object? otherChargesTaxId = freezed,Object? otherChargesAmt = freezed,Object? discountToAllInput = freezed,Object? discountToAllType = freezed,Object? totDiscountToAllAmt = freezed,Object? subtotal = freezed,Object? unit = freezed,Object? roundOff = freezed,Object? grandTotal = freezed,Object? purchaseNote = freezed,Object? paymentStatus = freezed,Object? paidAmount = freezed,Object? companyId = freezed,Object? status = freezed,Object? returnBit = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,countId: freezed == countId ? _self.countId : countId // ignore: cast_nullable_to_non_nullable
as dynamic,purchaseCode: freezed == purchaseCode ? _self.purchaseCode : purchaseCode // ignore: cast_nullable_to_non_nullable
as String?,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as dynamic,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,otherChargesInput: freezed == otherChargesInput ? _self.otherChargesInput : otherChargesInput // ignore: cast_nullable_to_non_nullable
as dynamic,otherChargesTaxId: freezed == otherChargesTaxId ? _self.otherChargesTaxId : otherChargesTaxId // ignore: cast_nullable_to_non_nullable
as dynamic,otherChargesAmt: freezed == otherChargesAmt ? _self.otherChargesAmt : otherChargesAmt // ignore: cast_nullable_to_non_nullable
as dynamic,discountToAllInput: freezed == discountToAllInput ? _self.discountToAllInput : discountToAllInput // ignore: cast_nullable_to_non_nullable
as dynamic,discountToAllType: freezed == discountToAllType ? _self.discountToAllType : discountToAllType // ignore: cast_nullable_to_non_nullable
as dynamic,totDiscountToAllAmt: freezed == totDiscountToAllAmt ? _self.totDiscountToAllAmt : totDiscountToAllAmt // ignore: cast_nullable_to_non_nullable
as String?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as dynamic,roundOff: freezed == roundOff ? _self.roundOff : roundOff // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as String?,purchaseNote: freezed == purchaseNote ? _self.purchaseNote : purchaseNote // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as String?,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,returnBit: freezed == returnBit ? _self.returnBit : returnBit // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "warehouse_id")  String? warehouseId, @JsonKey(name: "count_id")  dynamic countId, @JsonKey(name: "purchase_code")  String? purchaseCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "serial_no")  dynamic serialNo, @JsonKey(name: "purchase_date")  DateTime? purchaseDate, @JsonKey(name: "supplier_id")  String? supplierId, @JsonKey(name: "other_charges_input")  dynamic otherChargesInput, @JsonKey(name: "other_charges_tax_id")  dynamic otherChargesTaxId, @JsonKey(name: "other_charges_amt")  dynamic otherChargesAmt, @JsonKey(name: "discount_to_all_input")  dynamic discountToAllInput, @JsonKey(name: "discount_to_all_type")  dynamic discountToAllType, @JsonKey(name: "tot_discount_to_all_amt")  String? totDiscountToAllAmt, @JsonKey(name: "subtotal")  String? subtotal, @JsonKey(name: "unit")  dynamic unit, @JsonKey(name: "round_off")  String? roundOff, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "purchase_note")  String? purchaseNote, @JsonKey(name: "payment_status")  String? paymentStatus, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "company_id")  String? companyId, @JsonKey(name: "status")  String? status, @JsonKey(name: "return_bit")  String? returnBit, @JsonKey(name: "created_by")  String? createdBy, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.storeId,_that.warehouseId,_that.countId,_that.purchaseCode,_that.referenceNo,_that.serialNo,_that.purchaseDate,_that.supplierId,_that.otherChargesInput,_that.otherChargesTaxId,_that.otherChargesAmt,_that.discountToAllInput,_that.discountToAllType,_that.totDiscountToAllAmt,_that.subtotal,_that.unit,_that.roundOff,_that.grandTotal,_that.purchaseNote,_that.paymentStatus,_that.paidAmount,_that.companyId,_that.status,_that.returnBit,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "warehouse_id")  String? warehouseId, @JsonKey(name: "count_id")  dynamic countId, @JsonKey(name: "purchase_code")  String? purchaseCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "serial_no")  dynamic serialNo, @JsonKey(name: "purchase_date")  DateTime? purchaseDate, @JsonKey(name: "supplier_id")  String? supplierId, @JsonKey(name: "other_charges_input")  dynamic otherChargesInput, @JsonKey(name: "other_charges_tax_id")  dynamic otherChargesTaxId, @JsonKey(name: "other_charges_amt")  dynamic otherChargesAmt, @JsonKey(name: "discount_to_all_input")  dynamic discountToAllInput, @JsonKey(name: "discount_to_all_type")  dynamic discountToAllType, @JsonKey(name: "tot_discount_to_all_amt")  String? totDiscountToAllAmt, @JsonKey(name: "subtotal")  String? subtotal, @JsonKey(name: "unit")  dynamic unit, @JsonKey(name: "round_off")  String? roundOff, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "purchase_note")  String? purchaseNote, @JsonKey(name: "payment_status")  String? paymentStatus, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "company_id")  String? companyId, @JsonKey(name: "status")  String? status, @JsonKey(name: "return_bit")  String? returnBit, @JsonKey(name: "created_by")  String? createdBy, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Datum():
return $default(_that.id,_that.storeId,_that.warehouseId,_that.countId,_that.purchaseCode,_that.referenceNo,_that.serialNo,_that.purchaseDate,_that.supplierId,_that.otherChargesInput,_that.otherChargesTaxId,_that.otherChargesAmt,_that.discountToAllInput,_that.discountToAllType,_that.totDiscountToAllAmt,_that.subtotal,_that.unit,_that.roundOff,_that.grandTotal,_that.purchaseNote,_that.paymentStatus,_that.paidAmount,_that.companyId,_that.status,_that.returnBit,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "warehouse_id")  String? warehouseId, @JsonKey(name: "count_id")  dynamic countId, @JsonKey(name: "purchase_code")  String? purchaseCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "serial_no")  dynamic serialNo, @JsonKey(name: "purchase_date")  DateTime? purchaseDate, @JsonKey(name: "supplier_id")  String? supplierId, @JsonKey(name: "other_charges_input")  dynamic otherChargesInput, @JsonKey(name: "other_charges_tax_id")  dynamic otherChargesTaxId, @JsonKey(name: "other_charges_amt")  dynamic otherChargesAmt, @JsonKey(name: "discount_to_all_input")  dynamic discountToAllInput, @JsonKey(name: "discount_to_all_type")  dynamic discountToAllType, @JsonKey(name: "tot_discount_to_all_amt")  String? totDiscountToAllAmt, @JsonKey(name: "subtotal")  String? subtotal, @JsonKey(name: "unit")  dynamic unit, @JsonKey(name: "round_off")  String? roundOff, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "purchase_note")  String? purchaseNote, @JsonKey(name: "payment_status")  String? paymentStatus, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "company_id")  String? companyId, @JsonKey(name: "status")  String? status, @JsonKey(name: "return_bit")  String? returnBit, @JsonKey(name: "created_by")  String? createdBy, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.storeId,_that.warehouseId,_that.countId,_that.purchaseCode,_that.referenceNo,_that.serialNo,_that.purchaseDate,_that.supplierId,_that.otherChargesInput,_that.otherChargesTaxId,_that.otherChargesAmt,_that.discountToAllInput,_that.discountToAllType,_that.totDiscountToAllAmt,_that.subtotal,_that.unit,_that.roundOff,_that.grandTotal,_that.purchaseNote,_that.paymentStatus,_that.paidAmount,_that.companyId,_that.status,_that.returnBit,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Datum implements Datum {
  const _Datum({@JsonKey(name: "id") this.id, @JsonKey(name: "store_id") this.storeId, @JsonKey(name: "warehouse_id") this.warehouseId, @JsonKey(name: "count_id") this.countId, @JsonKey(name: "purchase_code") this.purchaseCode, @JsonKey(name: "reference_no") this.referenceNo, @JsonKey(name: "serial_no") this.serialNo, @JsonKey(name: "purchase_date") this.purchaseDate, @JsonKey(name: "supplier_id") this.supplierId, @JsonKey(name: "other_charges_input") this.otherChargesInput, @JsonKey(name: "other_charges_tax_id") this.otherChargesTaxId, @JsonKey(name: "other_charges_amt") this.otherChargesAmt, @JsonKey(name: "discount_to_all_input") this.discountToAllInput, @JsonKey(name: "discount_to_all_type") this.discountToAllType, @JsonKey(name: "tot_discount_to_all_amt") this.totDiscountToAllAmt, @JsonKey(name: "subtotal") this.subtotal, @JsonKey(name: "unit") this.unit, @JsonKey(name: "round_off") this.roundOff, @JsonKey(name: "grand_total") this.grandTotal, @JsonKey(name: "purchase_note") this.purchaseNote, @JsonKey(name: "payment_status") this.paymentStatus, @JsonKey(name: "paid_amount") this.paidAmount, @JsonKey(name: "company_id") this.companyId, @JsonKey(name: "status") this.status, @JsonKey(name: "return_bit") this.returnBit, @JsonKey(name: "created_by") this.createdBy, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

@override@JsonKey(name: "id") final  int? id;
@override@JsonKey(name: "store_id") final  String? storeId;
@override@JsonKey(name: "warehouse_id") final  String? warehouseId;
@override@JsonKey(name: "count_id") final  dynamic countId;
@override@JsonKey(name: "purchase_code") final  String? purchaseCode;
@override@JsonKey(name: "reference_no") final  String? referenceNo;
@override@JsonKey(name: "serial_no") final  dynamic serialNo;
@override@JsonKey(name: "purchase_date") final  DateTime? purchaseDate;
@override@JsonKey(name: "supplier_id") final  String? supplierId;
@override@JsonKey(name: "other_charges_input") final  dynamic otherChargesInput;
@override@JsonKey(name: "other_charges_tax_id") final  dynamic otherChargesTaxId;
@override@JsonKey(name: "other_charges_amt") final  dynamic otherChargesAmt;
@override@JsonKey(name: "discount_to_all_input") final  dynamic discountToAllInput;
@override@JsonKey(name: "discount_to_all_type") final  dynamic discountToAllType;
@override@JsonKey(name: "tot_discount_to_all_amt") final  String? totDiscountToAllAmt;
@override@JsonKey(name: "subtotal") final  String? subtotal;
@override@JsonKey(name: "unit") final  dynamic unit;
@override@JsonKey(name: "round_off") final  String? roundOff;
@override@JsonKey(name: "grand_total") final  String? grandTotal;
@override@JsonKey(name: "purchase_note") final  String? purchaseNote;
@override@JsonKey(name: "payment_status") final  String? paymentStatus;
@override@JsonKey(name: "paid_amount") final  String? paidAmount;
@override@JsonKey(name: "company_id") final  String? companyId;
@override@JsonKey(name: "status") final  String? status;
@override@JsonKey(name: "return_bit") final  String? returnBit;
@override@JsonKey(name: "created_by") final  String? createdBy;
@override@JsonKey(name: "created_at") final  DateTime? createdAt;
@override@JsonKey(name: "updated_at") final  DateTime? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&const DeepCollectionEquality().equals(other.countId, countId)&&(identical(other.purchaseCode, purchaseCode) || other.purchaseCode == purchaseCode)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&const DeepCollectionEquality().equals(other.serialNo, serialNo)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&const DeepCollectionEquality().equals(other.otherChargesInput, otherChargesInput)&&const DeepCollectionEquality().equals(other.otherChargesTaxId, otherChargesTaxId)&&const DeepCollectionEquality().equals(other.otherChargesAmt, otherChargesAmt)&&const DeepCollectionEquality().equals(other.discountToAllInput, discountToAllInput)&&const DeepCollectionEquality().equals(other.discountToAllType, discountToAllType)&&(identical(other.totDiscountToAllAmt, totDiscountToAllAmt) || other.totDiscountToAllAmt == totDiscountToAllAmt)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&const DeepCollectionEquality().equals(other.unit, unit)&&(identical(other.roundOff, roundOff) || other.roundOff == roundOff)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.purchaseNote, purchaseNote) || other.purchaseNote == purchaseNote)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.status, status) || other.status == status)&&(identical(other.returnBit, returnBit) || other.returnBit == returnBit)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,warehouseId,const DeepCollectionEquality().hash(countId),purchaseCode,referenceNo,const DeepCollectionEquality().hash(serialNo),purchaseDate,supplierId,const DeepCollectionEquality().hash(otherChargesInput),const DeepCollectionEquality().hash(otherChargesTaxId),const DeepCollectionEquality().hash(otherChargesAmt),const DeepCollectionEquality().hash(discountToAllInput),const DeepCollectionEquality().hash(discountToAllType),totDiscountToAllAmt,subtotal,const DeepCollectionEquality().hash(unit),roundOff,grandTotal,purchaseNote,paymentStatus,paidAmount,companyId,status,returnBit,createdBy,createdAt,updatedAt]);

@override
String toString() {
  return 'Datum(id: $id, storeId: $storeId, warehouseId: $warehouseId, countId: $countId, purchaseCode: $purchaseCode, referenceNo: $referenceNo, serialNo: $serialNo, purchaseDate: $purchaseDate, supplierId: $supplierId, otherChargesInput: $otherChargesInput, otherChargesTaxId: $otherChargesTaxId, otherChargesAmt: $otherChargesAmt, discountToAllInput: $discountToAllInput, discountToAllType: $discountToAllType, totDiscountToAllAmt: $totDiscountToAllAmt, subtotal: $subtotal, unit: $unit, roundOff: $roundOff, grandTotal: $grandTotal, purchaseNote: $purchaseNote, paymentStatus: $paymentStatus, paidAmount: $paidAmount, companyId: $companyId, status: $status, returnBit: $returnBit, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DatumCopyWith<$Res> implements $DatumCopyWith<$Res> {
  factory _$DatumCopyWith(_Datum value, $Res Function(_Datum) _then) = __$DatumCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "warehouse_id") String? warehouseId,@JsonKey(name: "count_id") dynamic countId,@JsonKey(name: "purchase_code") String? purchaseCode,@JsonKey(name: "reference_no") String? referenceNo,@JsonKey(name: "serial_no") dynamic serialNo,@JsonKey(name: "purchase_date") DateTime? purchaseDate,@JsonKey(name: "supplier_id") String? supplierId,@JsonKey(name: "other_charges_input") dynamic otherChargesInput,@JsonKey(name: "other_charges_tax_id") dynamic otherChargesTaxId,@JsonKey(name: "other_charges_amt") dynamic otherChargesAmt,@JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,@JsonKey(name: "discount_to_all_type") dynamic discountToAllType,@JsonKey(name: "tot_discount_to_all_amt") String? totDiscountToAllAmt,@JsonKey(name: "subtotal") String? subtotal,@JsonKey(name: "unit") dynamic unit,@JsonKey(name: "round_off") String? roundOff,@JsonKey(name: "grand_total") String? grandTotal,@JsonKey(name: "purchase_note") String? purchaseNote,@JsonKey(name: "payment_status") String? paymentStatus,@JsonKey(name: "paid_amount") String? paidAmount,@JsonKey(name: "company_id") String? companyId,@JsonKey(name: "status") String? status,@JsonKey(name: "return_bit") String? returnBit,@JsonKey(name: "created_by") String? createdBy,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? storeId = freezed,Object? warehouseId = freezed,Object? countId = freezed,Object? purchaseCode = freezed,Object? referenceNo = freezed,Object? serialNo = freezed,Object? purchaseDate = freezed,Object? supplierId = freezed,Object? otherChargesInput = freezed,Object? otherChargesTaxId = freezed,Object? otherChargesAmt = freezed,Object? discountToAllInput = freezed,Object? discountToAllType = freezed,Object? totDiscountToAllAmt = freezed,Object? subtotal = freezed,Object? unit = freezed,Object? roundOff = freezed,Object? grandTotal = freezed,Object? purchaseNote = freezed,Object? paymentStatus = freezed,Object? paidAmount = freezed,Object? companyId = freezed,Object? status = freezed,Object? returnBit = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Datum(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as String?,countId: freezed == countId ? _self.countId : countId // ignore: cast_nullable_to_non_nullable
as dynamic,purchaseCode: freezed == purchaseCode ? _self.purchaseCode : purchaseCode // ignore: cast_nullable_to_non_nullable
as String?,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as dynamic,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,supplierId: freezed == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String?,otherChargesInput: freezed == otherChargesInput ? _self.otherChargesInput : otherChargesInput // ignore: cast_nullable_to_non_nullable
as dynamic,otherChargesTaxId: freezed == otherChargesTaxId ? _self.otherChargesTaxId : otherChargesTaxId // ignore: cast_nullable_to_non_nullable
as dynamic,otherChargesAmt: freezed == otherChargesAmt ? _self.otherChargesAmt : otherChargesAmt // ignore: cast_nullable_to_non_nullable
as dynamic,discountToAllInput: freezed == discountToAllInput ? _self.discountToAllInput : discountToAllInput // ignore: cast_nullable_to_non_nullable
as dynamic,discountToAllType: freezed == discountToAllType ? _self.discountToAllType : discountToAllType // ignore: cast_nullable_to_non_nullable
as dynamic,totDiscountToAllAmt: freezed == totDiscountToAllAmt ? _self.totDiscountToAllAmt : totDiscountToAllAmt // ignore: cast_nullable_to_non_nullable
as String?,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as dynamic,roundOff: freezed == roundOff ? _self.roundOff : roundOff // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as String?,purchaseNote: freezed == purchaseNote ? _self.purchaseNote : purchaseNote // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as String?,companyId: freezed == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,returnBit: freezed == returnBit ? _self.returnBit : returnBit // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

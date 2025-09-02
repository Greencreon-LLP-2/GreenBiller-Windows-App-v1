// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_customer_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesSummaryCustomerModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "data") List<Datum>? get data;
/// Create a copy of SalesSummaryCustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesSummaryCustomerModelCopyWith<SalesSummaryCustomerModel> get copyWith => _$SalesSummaryCustomerModelCopyWithImpl<SalesSummaryCustomerModel>(this as SalesSummaryCustomerModel, _$identity);

  /// Serializes this SalesSummaryCustomerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesSummaryCustomerModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'SalesSummaryCustomerModel(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $SalesSummaryCustomerModelCopyWith<$Res>  {
  factory $SalesSummaryCustomerModelCopyWith(SalesSummaryCustomerModel value, $Res Function(SalesSummaryCustomerModel) _then) = _$SalesSummaryCustomerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data
});




}
/// @nodoc
class _$SalesSummaryCustomerModelCopyWithImpl<$Res>
    implements $SalesSummaryCustomerModelCopyWith<$Res> {
  _$SalesSummaryCustomerModelCopyWithImpl(this._self, this._then);

  final SalesSummaryCustomerModel _self;
  final $Res Function(SalesSummaryCustomerModel) _then;

/// Create a copy of SalesSummaryCustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesSummaryCustomerModel].
extension SalesSummaryCustomerModelPatterns on SalesSummaryCustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesSummaryCustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesSummaryCustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesSummaryCustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _SalesSummaryCustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesSummaryCustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalesSummaryCustomerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<Datum>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesSummaryCustomerModel() when $default != null:
return $default(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<Datum>? data)  $default,) {final _that = this;
switch (_that) {
case _SalesSummaryCustomerModel():
return $default(_that.message,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<Datum>? data)?  $default,) {final _that = this;
switch (_that) {
case _SalesSummaryCustomerModel() when $default != null:
return $default(_that.message,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesSummaryCustomerModel implements SalesSummaryCustomerModel {
  const _SalesSummaryCustomerModel({@JsonKey(name: "message") this.message, @JsonKey(name: "data") final  List<Datum>? data}): _data = data;
  factory _SalesSummaryCustomerModel.fromJson(Map<String, dynamic> json) => _$SalesSummaryCustomerModelFromJson(json);

@override@JsonKey(name: "message") final  String? message;
 final  List<Datum>? _data;
@override@JsonKey(name: "data") List<Datum>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SalesSummaryCustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesSummaryCustomerModelCopyWith<_SalesSummaryCustomerModel> get copyWith => __$SalesSummaryCustomerModelCopyWithImpl<_SalesSummaryCustomerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesSummaryCustomerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesSummaryCustomerModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'SalesSummaryCustomerModel(message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SalesSummaryCustomerModelCopyWith<$Res> implements $SalesSummaryCustomerModelCopyWith<$Res> {
  factory _$SalesSummaryCustomerModelCopyWith(_SalesSummaryCustomerModel value, $Res Function(_SalesSummaryCustomerModel) _then) = __$SalesSummaryCustomerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data
});




}
/// @nodoc
class __$SalesSummaryCustomerModelCopyWithImpl<$Res>
    implements _$SalesSummaryCustomerModelCopyWith<$Res> {
  __$SalesSummaryCustomerModelCopyWithImpl(this._self, this._then);

  final _SalesSummaryCustomerModel _self;
  final $Res Function(_SalesSummaryCustomerModel) _then;

/// Create a copy of SalesSummaryCustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,}) {
  return _then(_SalesSummaryCustomerModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,
  ));
}


}


/// @nodoc
mixin _$Datum {

@JsonKey(name: "id") int? get id;@JsonKey(name: "store_id") String? get storeId;@JsonKey(name: "store_name") String? get storeName;@JsonKey(name: "customer_id") String? get customerId;@JsonKey(name: "customer_name") String? get customerName;@JsonKey(name: "sales_code") dynamic get salesCode;@JsonKey(name: "reference_no") String? get referenceNo;@JsonKey(name: "grand_total") String? get grandTotal;@JsonKey(name: "paid_amount") String? get paidAmount;@JsonKey(name: "balance") int? get balance;@JsonKey(name: "sales_date") DateTime? get salesDate;
/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatumCopyWith<Datum> get copyWith => _$DatumCopyWithImpl<Datum>(this as Datum, _$identity);

  /// Serializes this Datum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&const DeepCollectionEquality().equals(other.salesCode, salesCode)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.salesDate, salesDate) || other.salesDate == salesDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,storeName,customerId,customerName,const DeepCollectionEquality().hash(salesCode),referenceNo,grandTotal,paidAmount,balance,salesDate);

@override
String toString() {
  return 'Datum(id: $id, storeId: $storeId, storeName: $storeName, customerId: $customerId, customerName: $customerName, salesCode: $salesCode, referenceNo: $referenceNo, grandTotal: $grandTotal, paidAmount: $paidAmount, balance: $balance, salesDate: $salesDate)';
}


}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res>  {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) = _$DatumCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "store_name") String? storeName,@JsonKey(name: "customer_id") String? customerId,@JsonKey(name: "customer_name") String? customerName,@JsonKey(name: "sales_code") dynamic salesCode,@JsonKey(name: "reference_no") String? referenceNo,@JsonKey(name: "grand_total") String? grandTotal,@JsonKey(name: "paid_amount") String? paidAmount,@JsonKey(name: "balance") int? balance,@JsonKey(name: "sales_date") DateTime? salesDate
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? storeId = freezed,Object? storeName = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? salesCode = freezed,Object? referenceNo = freezed,Object? grandTotal = freezed,Object? paidAmount = freezed,Object? balance = freezed,Object? salesDate = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,salesCode: freezed == salesCode ? _self.salesCode : salesCode // ignore: cast_nullable_to_non_nullable
as dynamic,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int?,salesDate: freezed == salesDate ? _self.salesDate : salesDate // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "customer_id")  String? customerId, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "sales_code")  dynamic salesCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "balance")  int? balance, @JsonKey(name: "sales_date")  DateTime? salesDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.storeId,_that.storeName,_that.customerId,_that.customerName,_that.salesCode,_that.referenceNo,_that.grandTotal,_that.paidAmount,_that.balance,_that.salesDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "customer_id")  String? customerId, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "sales_code")  dynamic salesCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "balance")  int? balance, @JsonKey(name: "sales_date")  DateTime? salesDate)  $default,) {final _that = this;
switch (_that) {
case _Datum():
return $default(_that.id,_that.storeId,_that.storeName,_that.customerId,_that.customerName,_that.salesCode,_that.referenceNo,_that.grandTotal,_that.paidAmount,_that.balance,_that.salesDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "customer_id")  String? customerId, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "sales_code")  dynamic salesCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "balance")  int? balance, @JsonKey(name: "sales_date")  DateTime? salesDate)?  $default,) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.storeId,_that.storeName,_that.customerId,_that.customerName,_that.salesCode,_that.referenceNo,_that.grandTotal,_that.paidAmount,_that.balance,_that.salesDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Datum implements Datum {
  const _Datum({@JsonKey(name: "id") this.id, @JsonKey(name: "store_id") this.storeId, @JsonKey(name: "store_name") this.storeName, @JsonKey(name: "customer_id") this.customerId, @JsonKey(name: "customer_name") this.customerName, @JsonKey(name: "sales_code") this.salesCode, @JsonKey(name: "reference_no") this.referenceNo, @JsonKey(name: "grand_total") this.grandTotal, @JsonKey(name: "paid_amount") this.paidAmount, @JsonKey(name: "balance") this.balance, @JsonKey(name: "sales_date") this.salesDate});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

@override@JsonKey(name: "id") final  int? id;
@override@JsonKey(name: "store_id") final  String? storeId;
@override@JsonKey(name: "store_name") final  String? storeName;
@override@JsonKey(name: "customer_id") final  String? customerId;
@override@JsonKey(name: "customer_name") final  String? customerName;
@override@JsonKey(name: "sales_code") final  dynamic salesCode;
@override@JsonKey(name: "reference_no") final  String? referenceNo;
@override@JsonKey(name: "grand_total") final  String? grandTotal;
@override@JsonKey(name: "paid_amount") final  String? paidAmount;
@override@JsonKey(name: "balance") final  int? balance;
@override@JsonKey(name: "sales_date") final  DateTime? salesDate;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&const DeepCollectionEquality().equals(other.salesCode, salesCode)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.salesDate, salesDate) || other.salesDate == salesDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,storeName,customerId,customerName,const DeepCollectionEquality().hash(salesCode),referenceNo,grandTotal,paidAmount,balance,salesDate);

@override
String toString() {
  return 'Datum(id: $id, storeId: $storeId, storeName: $storeName, customerId: $customerId, customerName: $customerName, salesCode: $salesCode, referenceNo: $referenceNo, grandTotal: $grandTotal, paidAmount: $paidAmount, balance: $balance, salesDate: $salesDate)';
}


}

/// @nodoc
abstract mixin class _$DatumCopyWith<$Res> implements $DatumCopyWith<$Res> {
  factory _$DatumCopyWith(_Datum value, $Res Function(_Datum) _then) = __$DatumCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "store_name") String? storeName,@JsonKey(name: "customer_id") String? customerId,@JsonKey(name: "customer_name") String? customerName,@JsonKey(name: "sales_code") dynamic salesCode,@JsonKey(name: "reference_no") String? referenceNo,@JsonKey(name: "grand_total") String? grandTotal,@JsonKey(name: "paid_amount") String? paidAmount,@JsonKey(name: "balance") int? balance,@JsonKey(name: "sales_date") DateTime? salesDate
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? storeId = freezed,Object? storeName = freezed,Object? customerId = freezed,Object? customerName = freezed,Object? salesCode = freezed,Object? referenceNo = freezed,Object? grandTotal = freezed,Object? paidAmount = freezed,Object? balance = freezed,Object? salesDate = freezed,}) {
  return _then(_Datum(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,salesCode: freezed == salesCode ? _self.salesCode : salesCode // ignore: cast_nullable_to_non_nullable
as dynamic,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as String?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int?,salesDate: freezed == salesDate ? _self.salesDate : salesDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

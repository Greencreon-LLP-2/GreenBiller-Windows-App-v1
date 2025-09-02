// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesSummaryModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "data") List<Datum>? get data;@JsonKey(name: "status") int? get status;
/// Create a copy of SalesSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesSummaryModelCopyWith<SalesSummaryModel> get copyWith => _$SalesSummaryModelCopyWithImpl<SalesSummaryModel>(this as SalesSummaryModel, _$identity);

  /// Serializes this SalesSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesSummaryModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data),status);

@override
String toString() {
  return 'SalesSummaryModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class $SalesSummaryModelCopyWith<$Res>  {
  factory $SalesSummaryModelCopyWith(SalesSummaryModel value, $Res Function(SalesSummaryModel) _then) = _$SalesSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class _$SalesSummaryModelCopyWithImpl<$Res>
    implements $SalesSummaryModelCopyWith<$Res> {
  _$SalesSummaryModelCopyWithImpl(this._self, this._then);

  final SalesSummaryModel _self;
  final $Res Function(SalesSummaryModel) _then;

/// Create a copy of SalesSummaryModel
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


/// Adds pattern-matching-related methods to [SalesSummaryModel].
extension SalesSummaryModelPatterns on SalesSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _SalesSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _SalesSummaryModel() when $default != null:
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
case _SalesSummaryModel() when $default != null:
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
case _SalesSummaryModel():
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
case _SalesSummaryModel() when $default != null:
return $default(_that.message,_that.data,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesSummaryModel implements SalesSummaryModel {
  const _SalesSummaryModel({@JsonKey(name: "message") this.message, @JsonKey(name: "data") final  List<Datum>? data, @JsonKey(name: "status") this.status}): _data = data;
  factory _SalesSummaryModel.fromJson(Map<String, dynamic> json) => _$SalesSummaryModelFromJson(json);

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

/// Create a copy of SalesSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesSummaryModelCopyWith<_SalesSummaryModel> get copyWith => __$SalesSummaryModelCopyWithImpl<_SalesSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesSummaryModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data),status);

@override
String toString() {
  return 'SalesSummaryModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SalesSummaryModelCopyWith<$Res> implements $SalesSummaryModelCopyWith<$Res> {
  factory _$SalesSummaryModelCopyWith(_SalesSummaryModel value, $Res Function(_SalesSummaryModel) _then) = __$SalesSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class __$SalesSummaryModelCopyWithImpl<$Res>
    implements _$SalesSummaryModelCopyWith<$Res> {
  __$SalesSummaryModelCopyWithImpl(this._self, this._then);

  final _SalesSummaryModel _self;
  final $Res Function(_SalesSummaryModel) _then;

/// Create a copy of SalesSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,Object? status = freezed,}) {
  return _then(_SalesSummaryModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Datum {

@JsonKey(name: "id") int? get id;@JsonKey(name: "store_id") String? get storeId;@JsonKey(name: "store_name") String? get storeName;@JsonKey(name: "customer_id") String? get customerId;@JsonKey(name: "customer_name") String? get customerName;@JsonKey(name: "sales_code") dynamic get salesCode;@JsonKey(name: "reference_no") String? get referenceNo;@JsonKey(name: "grand_total") String? get grandTotal;@JsonKey(name: "paid_amount") String? get paidAmount;@JsonKey(name: "balance") double? get balance;@JsonKey(name: "sales_date") DateTime? get salesDate;
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
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "store_name") String? storeName,@JsonKey(name: "customer_id") String? customerId,@JsonKey(name: "customer_name") String? customerName,@JsonKey(name: "sales_code") dynamic salesCode,@JsonKey(name: "reference_no") String? referenceNo,@JsonKey(name: "grand_total") String? grandTotal,@JsonKey(name: "paid_amount") String? paidAmount,@JsonKey(name: "balance") double? balance,@JsonKey(name: "sales_date") DateTime? salesDate
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
as double?,salesDate: freezed == salesDate ? _self.salesDate : salesDate // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "customer_id")  String? customerId, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "sales_code")  dynamic salesCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "balance")  double? balance, @JsonKey(name: "sales_date")  DateTime? salesDate)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "customer_id")  String? customerId, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "sales_code")  dynamic salesCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "balance")  double? balance, @JsonKey(name: "sales_date")  DateTime? salesDate)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "customer_id")  String? customerId, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "sales_code")  dynamic salesCode, @JsonKey(name: "reference_no")  String? referenceNo, @JsonKey(name: "grand_total")  String? grandTotal, @JsonKey(name: "paid_amount")  String? paidAmount, @JsonKey(name: "balance")  double? balance, @JsonKey(name: "sales_date")  DateTime? salesDate)?  $default,) {final _that = this;
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
@override@JsonKey(name: "balance") final  double? balance;
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
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "store_name") String? storeName,@JsonKey(name: "customer_id") String? customerId,@JsonKey(name: "customer_name") String? customerName,@JsonKey(name: "sales_code") dynamic salesCode,@JsonKey(name: "reference_no") String? referenceNo,@JsonKey(name: "grand_total") String? grandTotal,@JsonKey(name: "paid_amount") String? paidAmount,@JsonKey(name: "balance") double? balance,@JsonKey(name: "sales_date") DateTime? salesDate
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
as double?,salesDate: freezed == salesDate ? _self.salesDate : salesDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

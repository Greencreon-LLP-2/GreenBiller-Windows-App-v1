// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "data") List<CustomerData>? get data;@JsonKey(name: "total") int? get total;@JsonKey(name: "status") int? get status;@JsonKey(name: "insights") CustomerInsights? get insights;
/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<CustomerModel> get copyWith => _$CustomerModelCopyWithImpl<CustomerModel>(this as CustomerModel, _$identity);

  /// Serializes this CustomerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.total, total) || other.total == total)&&(identical(other.status, status) || other.status == status)&&(identical(other.insights, insights) || other.insights == insights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data),total,status,insights);

@override
String toString() {
  return 'CustomerModel(message: $message, data: $data, total: $total, status: $status, insights: $insights)';
}


}

/// @nodoc
abstract mixin class $CustomerModelCopyWith<$Res>  {
  factory $CustomerModelCopyWith(CustomerModel value, $Res Function(CustomerModel) _then) = _$CustomerModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<CustomerData>? data,@JsonKey(name: "total") int? total,@JsonKey(name: "status") int? status,@JsonKey(name: "insights") CustomerInsights? insights
});


$CustomerInsightsCopyWith<$Res>? get insights;

}
/// @nodoc
class _$CustomerModelCopyWithImpl<$Res>
    implements $CustomerModelCopyWith<$Res> {
  _$CustomerModelCopyWithImpl(this._self, this._then);

  final CustomerModel _self;
  final $Res Function(CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,Object? data = freezed,Object? total = freezed,Object? status = freezed,Object? insights = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<CustomerData>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,insights: freezed == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as CustomerInsights?,
  ));
}
/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInsightsCopyWith<$Res>? get insights {
    if (_self.insights == null) {
    return null;
  }

  return $CustomerInsightsCopyWith<$Res>(_self.insights!, (value) {
    return _then(_self.copyWith(insights: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomerModel].
extension CustomerModelPatterns on CustomerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<CustomerData>? data, @JsonKey(name: "total")  int? total, @JsonKey(name: "status")  int? status, @JsonKey(name: "insights")  CustomerInsights? insights)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.message,_that.data,_that.total,_that.status,_that.insights);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<CustomerData>? data, @JsonKey(name: "total")  int? total, @JsonKey(name: "status")  int? status, @JsonKey(name: "insights")  CustomerInsights? insights)  $default,) {final _that = this;
switch (_that) {
case _CustomerModel():
return $default(_that.message,_that.data,_that.total,_that.status,_that.insights);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "message")  String? message, @JsonKey(name: "data")  List<CustomerData>? data, @JsonKey(name: "total")  int? total, @JsonKey(name: "status")  int? status, @JsonKey(name: "insights")  CustomerInsights? insights)?  $default,) {final _that = this;
switch (_that) {
case _CustomerModel() when $default != null:
return $default(_that.message,_that.data,_that.total,_that.status,_that.insights);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CustomerModel implements CustomerModel {
  const _CustomerModel({@JsonKey(name: "message") this.message, @JsonKey(name: "data") final  List<CustomerData>? data, @JsonKey(name: "total") this.total, @JsonKey(name: "status") this.status, @JsonKey(name: "insights") this.insights}): _data = data;
  factory _CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

@override@JsonKey(name: "message") final  String? message;
 final  List<CustomerData>? _data;
@override@JsonKey(name: "data") List<CustomerData>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "total") final  int? total;
@override@JsonKey(name: "status") final  int? status;
@override@JsonKey(name: "insights") final  CustomerInsights? insights;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerModelCopyWith<_CustomerModel> get copyWith => __$CustomerModelCopyWithImpl<_CustomerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.total, total) || other.total == total)&&(identical(other.status, status) || other.status == status)&&(identical(other.insights, insights) || other.insights == insights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data),total,status,insights);

@override
String toString() {
  return 'CustomerModel(message: $message, data: $data, total: $total, status: $status, insights: $insights)';
}


}

/// @nodoc
abstract mixin class _$CustomerModelCopyWith<$Res> implements $CustomerModelCopyWith<$Res> {
  factory _$CustomerModelCopyWith(_CustomerModel value, $Res Function(_CustomerModel) _then) = __$CustomerModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<CustomerData>? data,@JsonKey(name: "total") int? total,@JsonKey(name: "status") int? status,@JsonKey(name: "insights") CustomerInsights? insights
});


@override $CustomerInsightsCopyWith<$Res>? get insights;

}
/// @nodoc
class __$CustomerModelCopyWithImpl<$Res>
    implements _$CustomerModelCopyWith<$Res> {
  __$CustomerModelCopyWithImpl(this._self, this._then);

  final _CustomerModel _self;
  final $Res Function(_CustomerModel) _then;

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,Object? total = freezed,Object? status = freezed,Object? insights = freezed,}) {
  return _then(_CustomerModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<CustomerData>?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,insights: freezed == insights ? _self.insights : insights // ignore: cast_nullable_to_non_nullable
as CustomerInsights?,
  ));
}

/// Create a copy of CustomerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInsightsCopyWith<$Res>? get insights {
    if (_self.insights == null) {
    return null;
  }

  return $CustomerInsightsCopyWith<$Res>(_self.insights!, (value) {
    return _then(_self.copyWith(insights: value));
  });
}
}


/// @nodoc
mixin _$CustomerData {

@JsonKey(name: "id") int? get id;@JsonKey(name: "store_id") String? get storeId;@JsonKey(name: "user_id") String? get userId;@JsonKey(name: "count_id") dynamic get countId;@JsonKey(name: "customer_code") dynamic get customerCode;@JsonKey(name: "customer_name") String? get customerName;@JsonKey(name: "mobile") String? get mobile;@JsonKey(name: "phone") dynamic get phone;@JsonKey(name: "email") String? get email;@JsonKey(name: "gstin") String? get gstin;@JsonKey(name: "tax_number") dynamic get taxNumber;@JsonKey(name: "vatin") dynamic get vatin;@JsonKey(name: "opening_balance") dynamic get openingBalance;@JsonKey(name: "sales_due") dynamic get salesDue;@JsonKey(name: "sales_return_due") dynamic get salesReturnDue;@JsonKey(name: "country_id") dynamic get countryId;@JsonKey(name: "state") dynamic get state;@JsonKey(name: "city") dynamic get city;@JsonKey(name: "postcode") dynamic get postcode;@JsonKey(name: "address") String? get address;@JsonKey(name: "location_link") dynamic get locationLink;@JsonKey(name: "attachment_1") dynamic get attachment1;@JsonKey(name: "price_level_type") dynamic get priceLevelType;@JsonKey(name: "price_level") dynamic get priceLevel;@JsonKey(name: "delete_bit") dynamic get deleteBit;@JsonKey(name: "tot_advance") dynamic get totAdvance;@JsonKey(name: "credit_limit") dynamic get creditLimit;@JsonKey(name: "status") dynamic get status;@JsonKey(name: "created_by") String? get createdBy;@JsonKey(name: "created_at") DateTime? get createdAt;@JsonKey(name: "updated_at") DateTime? get updatedAt;@JsonKey(name: "store_name") String? get storeName;@JsonKey(name: "country") dynamic get country;
/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDataCopyWith<CustomerData> get copyWith => _$CustomerDataCopyWithImpl<CustomerData>(this as CustomerData, _$identity);

  /// Serializes this CustomerData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerData&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.countId, countId)&&const DeepCollectionEquality().equals(other.customerCode, customerCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&const DeepCollectionEquality().equals(other.phone, phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&const DeepCollectionEquality().equals(other.taxNumber, taxNumber)&&const DeepCollectionEquality().equals(other.vatin, vatin)&&const DeepCollectionEquality().equals(other.openingBalance, openingBalance)&&const DeepCollectionEquality().equals(other.salesDue, salesDue)&&const DeepCollectionEquality().equals(other.salesReturnDue, salesReturnDue)&&const DeepCollectionEquality().equals(other.countryId, countryId)&&const DeepCollectionEquality().equals(other.state, state)&&const DeepCollectionEquality().equals(other.city, city)&&const DeepCollectionEquality().equals(other.postcode, postcode)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.locationLink, locationLink)&&const DeepCollectionEquality().equals(other.attachment1, attachment1)&&const DeepCollectionEquality().equals(other.priceLevelType, priceLevelType)&&const DeepCollectionEquality().equals(other.priceLevel, priceLevel)&&const DeepCollectionEquality().equals(other.deleteBit, deleteBit)&&const DeepCollectionEquality().equals(other.totAdvance, totAdvance)&&const DeepCollectionEquality().equals(other.creditLimit, creditLimit)&&const DeepCollectionEquality().equals(other.status, status)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&const DeepCollectionEquality().equals(other.country, country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,userId,const DeepCollectionEquality().hash(countId),const DeepCollectionEquality().hash(customerCode),customerName,mobile,const DeepCollectionEquality().hash(phone),email,gstin,const DeepCollectionEquality().hash(taxNumber),const DeepCollectionEquality().hash(vatin),const DeepCollectionEquality().hash(openingBalance),const DeepCollectionEquality().hash(salesDue),const DeepCollectionEquality().hash(salesReturnDue),const DeepCollectionEquality().hash(countryId),const DeepCollectionEquality().hash(state),const DeepCollectionEquality().hash(city),const DeepCollectionEquality().hash(postcode),address,const DeepCollectionEquality().hash(locationLink),const DeepCollectionEquality().hash(attachment1),const DeepCollectionEquality().hash(priceLevelType),const DeepCollectionEquality().hash(priceLevel),const DeepCollectionEquality().hash(deleteBit),const DeepCollectionEquality().hash(totAdvance),const DeepCollectionEquality().hash(creditLimit),const DeepCollectionEquality().hash(status),createdBy,createdAt,updatedAt,storeName,const DeepCollectionEquality().hash(country)]);

@override
String toString() {
  return 'CustomerData(id: $id, storeId: $storeId, userId: $userId, countId: $countId, customerCode: $customerCode, customerName: $customerName, mobile: $mobile, phone: $phone, email: $email, gstin: $gstin, taxNumber: $taxNumber, vatin: $vatin, openingBalance: $openingBalance, salesDue: $salesDue, salesReturnDue: $salesReturnDue, countryId: $countryId, state: $state, city: $city, postcode: $postcode, address: $address, locationLink: $locationLink, attachment1: $attachment1, priceLevelType: $priceLevelType, priceLevel: $priceLevel, deleteBit: $deleteBit, totAdvance: $totAdvance, creditLimit: $creditLimit, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, storeName: $storeName, country: $country)';
}


}

/// @nodoc
abstract mixin class $CustomerDataCopyWith<$Res>  {
  factory $CustomerDataCopyWith(CustomerData value, $Res Function(CustomerData) _then) = _$CustomerDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "user_id") String? userId,@JsonKey(name: "count_id") dynamic countId,@JsonKey(name: "customer_code") dynamic customerCode,@JsonKey(name: "customer_name") String? customerName,@JsonKey(name: "mobile") String? mobile,@JsonKey(name: "phone") dynamic phone,@JsonKey(name: "email") String? email,@JsonKey(name: "gstin") String? gstin,@JsonKey(name: "tax_number") dynamic taxNumber,@JsonKey(name: "vatin") dynamic vatin,@JsonKey(name: "opening_balance") dynamic openingBalance,@JsonKey(name: "sales_due") dynamic salesDue,@JsonKey(name: "sales_return_due") dynamic salesReturnDue,@JsonKey(name: "country_id") dynamic countryId,@JsonKey(name: "state") dynamic state,@JsonKey(name: "city") dynamic city,@JsonKey(name: "postcode") dynamic postcode,@JsonKey(name: "address") String? address,@JsonKey(name: "location_link") dynamic locationLink,@JsonKey(name: "attachment_1") dynamic attachment1,@JsonKey(name: "price_level_type") dynamic priceLevelType,@JsonKey(name: "price_level") dynamic priceLevel,@JsonKey(name: "delete_bit") dynamic deleteBit,@JsonKey(name: "tot_advance") dynamic totAdvance,@JsonKey(name: "credit_limit") dynamic creditLimit,@JsonKey(name: "status") dynamic status,@JsonKey(name: "created_by") String? createdBy,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "store_name") String? storeName,@JsonKey(name: "country") dynamic country
});




}
/// @nodoc
class _$CustomerDataCopyWithImpl<$Res>
    implements $CustomerDataCopyWith<$Res> {
  _$CustomerDataCopyWithImpl(this._self, this._then);

  final CustomerData _self;
  final $Res Function(CustomerData) _then;

/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? storeId = freezed,Object? userId = freezed,Object? countId = freezed,Object? customerCode = freezed,Object? customerName = freezed,Object? mobile = freezed,Object? phone = freezed,Object? email = freezed,Object? gstin = freezed,Object? taxNumber = freezed,Object? vatin = freezed,Object? openingBalance = freezed,Object? salesDue = freezed,Object? salesReturnDue = freezed,Object? countryId = freezed,Object? state = freezed,Object? city = freezed,Object? postcode = freezed,Object? address = freezed,Object? locationLink = freezed,Object? attachment1 = freezed,Object? priceLevelType = freezed,Object? priceLevel = freezed,Object? deleteBit = freezed,Object? totAdvance = freezed,Object? creditLimit = freezed,Object? status = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? storeName = freezed,Object? country = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,countId: freezed == countId ? _self.countId : countId // ignore: cast_nullable_to_non_nullable
as dynamic,customerCode: freezed == customerCode ? _self.customerCode : customerCode // ignore: cast_nullable_to_non_nullable
as dynamic,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as dynamic,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,taxNumber: freezed == taxNumber ? _self.taxNumber : taxNumber // ignore: cast_nullable_to_non_nullable
as dynamic,vatin: freezed == vatin ? _self.vatin : vatin // ignore: cast_nullable_to_non_nullable
as dynamic,openingBalance: freezed == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as dynamic,salesDue: freezed == salesDue ? _self.salesDue : salesDue // ignore: cast_nullable_to_non_nullable
as dynamic,salesReturnDue: freezed == salesReturnDue ? _self.salesReturnDue : salesReturnDue // ignore: cast_nullable_to_non_nullable
as dynamic,countryId: freezed == countryId ? _self.countryId : countryId // ignore: cast_nullable_to_non_nullable
as dynamic,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as dynamic,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as dynamic,postcode: freezed == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as dynamic,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,locationLink: freezed == locationLink ? _self.locationLink : locationLink // ignore: cast_nullable_to_non_nullable
as dynamic,attachment1: freezed == attachment1 ? _self.attachment1 : attachment1 // ignore: cast_nullable_to_non_nullable
as dynamic,priceLevelType: freezed == priceLevelType ? _self.priceLevelType : priceLevelType // ignore: cast_nullable_to_non_nullable
as dynamic,priceLevel: freezed == priceLevel ? _self.priceLevel : priceLevel // ignore: cast_nullable_to_non_nullable
as dynamic,deleteBit: freezed == deleteBit ? _self.deleteBit : deleteBit // ignore: cast_nullable_to_non_nullable
as dynamic,totAdvance: freezed == totAdvance ? _self.totAdvance : totAdvance // ignore: cast_nullable_to_non_nullable
as dynamic,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as dynamic,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as dynamic,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerData].
extension CustomerDataPatterns on CustomerData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerData value)  $default,){
final _that = this;
switch (_that) {
case _CustomerData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerData value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "user_id")  String? userId, @JsonKey(name: "count_id")  dynamic countId, @JsonKey(name: "customer_code")  dynamic customerCode, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "mobile")  String? mobile, @JsonKey(name: "phone")  dynamic phone, @JsonKey(name: "email")  String? email, @JsonKey(name: "gstin")  String? gstin, @JsonKey(name: "tax_number")  dynamic taxNumber, @JsonKey(name: "vatin")  dynamic vatin, @JsonKey(name: "opening_balance")  dynamic openingBalance, @JsonKey(name: "sales_due")  dynamic salesDue, @JsonKey(name: "sales_return_due")  dynamic salesReturnDue, @JsonKey(name: "country_id")  dynamic countryId, @JsonKey(name: "state")  dynamic state, @JsonKey(name: "city")  dynamic city, @JsonKey(name: "postcode")  dynamic postcode, @JsonKey(name: "address")  String? address, @JsonKey(name: "location_link")  dynamic locationLink, @JsonKey(name: "attachment_1")  dynamic attachment1, @JsonKey(name: "price_level_type")  dynamic priceLevelType, @JsonKey(name: "price_level")  dynamic priceLevel, @JsonKey(name: "delete_bit")  dynamic deleteBit, @JsonKey(name: "tot_advance")  dynamic totAdvance, @JsonKey(name: "credit_limit")  dynamic creditLimit, @JsonKey(name: "status")  dynamic status, @JsonKey(name: "created_by")  String? createdBy, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "country")  dynamic country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
return $default(_that.id,_that.storeId,_that.userId,_that.countId,_that.customerCode,_that.customerName,_that.mobile,_that.phone,_that.email,_that.gstin,_that.taxNumber,_that.vatin,_that.openingBalance,_that.salesDue,_that.salesReturnDue,_that.countryId,_that.state,_that.city,_that.postcode,_that.address,_that.locationLink,_that.attachment1,_that.priceLevelType,_that.priceLevel,_that.deleteBit,_that.totAdvance,_that.creditLimit,_that.status,_that.createdBy,_that.createdAt,_that.updatedAt,_that.storeName,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "user_id")  String? userId, @JsonKey(name: "count_id")  dynamic countId, @JsonKey(name: "customer_code")  dynamic customerCode, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "mobile")  String? mobile, @JsonKey(name: "phone")  dynamic phone, @JsonKey(name: "email")  String? email, @JsonKey(name: "gstin")  String? gstin, @JsonKey(name: "tax_number")  dynamic taxNumber, @JsonKey(name: "vatin")  dynamic vatin, @JsonKey(name: "opening_balance")  dynamic openingBalance, @JsonKey(name: "sales_due")  dynamic salesDue, @JsonKey(name: "sales_return_due")  dynamic salesReturnDue, @JsonKey(name: "country_id")  dynamic countryId, @JsonKey(name: "state")  dynamic state, @JsonKey(name: "city")  dynamic city, @JsonKey(name: "postcode")  dynamic postcode, @JsonKey(name: "address")  String? address, @JsonKey(name: "location_link")  dynamic locationLink, @JsonKey(name: "attachment_1")  dynamic attachment1, @JsonKey(name: "price_level_type")  dynamic priceLevelType, @JsonKey(name: "price_level")  dynamic priceLevel, @JsonKey(name: "delete_bit")  dynamic deleteBit, @JsonKey(name: "tot_advance")  dynamic totAdvance, @JsonKey(name: "credit_limit")  dynamic creditLimit, @JsonKey(name: "status")  dynamic status, @JsonKey(name: "created_by")  String? createdBy, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "country")  dynamic country)  $default,) {final _that = this;
switch (_that) {
case _CustomerData():
return $default(_that.id,_that.storeId,_that.userId,_that.countId,_that.customerCode,_that.customerName,_that.mobile,_that.phone,_that.email,_that.gstin,_that.taxNumber,_that.vatin,_that.openingBalance,_that.salesDue,_that.salesReturnDue,_that.countryId,_that.state,_that.city,_that.postcode,_that.address,_that.locationLink,_that.attachment1,_that.priceLevelType,_that.priceLevel,_that.deleteBit,_that.totAdvance,_that.creditLimit,_that.status,_that.createdBy,_that.createdAt,_that.updatedAt,_that.storeName,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  int? id, @JsonKey(name: "store_id")  String? storeId, @JsonKey(name: "user_id")  String? userId, @JsonKey(name: "count_id")  dynamic countId, @JsonKey(name: "customer_code")  dynamic customerCode, @JsonKey(name: "customer_name")  String? customerName, @JsonKey(name: "mobile")  String? mobile, @JsonKey(name: "phone")  dynamic phone, @JsonKey(name: "email")  String? email, @JsonKey(name: "gstin")  String? gstin, @JsonKey(name: "tax_number")  dynamic taxNumber, @JsonKey(name: "vatin")  dynamic vatin, @JsonKey(name: "opening_balance")  dynamic openingBalance, @JsonKey(name: "sales_due")  dynamic salesDue, @JsonKey(name: "sales_return_due")  dynamic salesReturnDue, @JsonKey(name: "country_id")  dynamic countryId, @JsonKey(name: "state")  dynamic state, @JsonKey(name: "city")  dynamic city, @JsonKey(name: "postcode")  dynamic postcode, @JsonKey(name: "address")  String? address, @JsonKey(name: "location_link")  dynamic locationLink, @JsonKey(name: "attachment_1")  dynamic attachment1, @JsonKey(name: "price_level_type")  dynamic priceLevelType, @JsonKey(name: "price_level")  dynamic priceLevel, @JsonKey(name: "delete_bit")  dynamic deleteBit, @JsonKey(name: "tot_advance")  dynamic totAdvance, @JsonKey(name: "credit_limit")  dynamic creditLimit, @JsonKey(name: "status")  dynamic status, @JsonKey(name: "created_by")  String? createdBy, @JsonKey(name: "created_at")  DateTime? createdAt, @JsonKey(name: "updated_at")  DateTime? updatedAt, @JsonKey(name: "store_name")  String? storeName, @JsonKey(name: "country")  dynamic country)?  $default,) {final _that = this;
switch (_that) {
case _CustomerData() when $default != null:
return $default(_that.id,_that.storeId,_that.userId,_that.countId,_that.customerCode,_that.customerName,_that.mobile,_that.phone,_that.email,_that.gstin,_that.taxNumber,_that.vatin,_that.openingBalance,_that.salesDue,_that.salesReturnDue,_that.countryId,_that.state,_that.city,_that.postcode,_that.address,_that.locationLink,_that.attachment1,_that.priceLevelType,_that.priceLevel,_that.deleteBit,_that.totAdvance,_that.creditLimit,_that.status,_that.createdBy,_that.createdAt,_that.updatedAt,_that.storeName,_that.country);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CustomerData implements CustomerData {
  const _CustomerData({@JsonKey(name: "id") this.id, @JsonKey(name: "store_id") this.storeId, @JsonKey(name: "user_id") this.userId, @JsonKey(name: "count_id") this.countId, @JsonKey(name: "customer_code") this.customerCode, @JsonKey(name: "customer_name") this.customerName, @JsonKey(name: "mobile") this.mobile, @JsonKey(name: "phone") this.phone, @JsonKey(name: "email") this.email, @JsonKey(name: "gstin") this.gstin, @JsonKey(name: "tax_number") this.taxNumber, @JsonKey(name: "vatin") this.vatin, @JsonKey(name: "opening_balance") this.openingBalance, @JsonKey(name: "sales_due") this.salesDue, @JsonKey(name: "sales_return_due") this.salesReturnDue, @JsonKey(name: "country_id") this.countryId, @JsonKey(name: "state") this.state, @JsonKey(name: "city") this.city, @JsonKey(name: "postcode") this.postcode, @JsonKey(name: "address") this.address, @JsonKey(name: "location_link") this.locationLink, @JsonKey(name: "attachment_1") this.attachment1, @JsonKey(name: "price_level_type") this.priceLevelType, @JsonKey(name: "price_level") this.priceLevel, @JsonKey(name: "delete_bit") this.deleteBit, @JsonKey(name: "tot_advance") this.totAdvance, @JsonKey(name: "credit_limit") this.creditLimit, @JsonKey(name: "status") this.status, @JsonKey(name: "created_by") this.createdBy, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt, @JsonKey(name: "store_name") this.storeName, @JsonKey(name: "country") this.country});
  factory _CustomerData.fromJson(Map<String, dynamic> json) => _$CustomerDataFromJson(json);

@override@JsonKey(name: "id") final  int? id;
@override@JsonKey(name: "store_id") final  String? storeId;
@override@JsonKey(name: "user_id") final  String? userId;
@override@JsonKey(name: "count_id") final  dynamic countId;
@override@JsonKey(name: "customer_code") final  dynamic customerCode;
@override@JsonKey(name: "customer_name") final  String? customerName;
@override@JsonKey(name: "mobile") final  String? mobile;
@override@JsonKey(name: "phone") final  dynamic phone;
@override@JsonKey(name: "email") final  String? email;
@override@JsonKey(name: "gstin") final  String? gstin;
@override@JsonKey(name: "tax_number") final  dynamic taxNumber;
@override@JsonKey(name: "vatin") final  dynamic vatin;
@override@JsonKey(name: "opening_balance") final  dynamic openingBalance;
@override@JsonKey(name: "sales_due") final  dynamic salesDue;
@override@JsonKey(name: "sales_return_due") final  dynamic salesReturnDue;
@override@JsonKey(name: "country_id") final  dynamic countryId;
@override@JsonKey(name: "state") final  dynamic state;
@override@JsonKey(name: "city") final  dynamic city;
@override@JsonKey(name: "postcode") final  dynamic postcode;
@override@JsonKey(name: "address") final  String? address;
@override@JsonKey(name: "location_link") final  dynamic locationLink;
@override@JsonKey(name: "attachment_1") final  dynamic attachment1;
@override@JsonKey(name: "price_level_type") final  dynamic priceLevelType;
@override@JsonKey(name: "price_level") final  dynamic priceLevel;
@override@JsonKey(name: "delete_bit") final  dynamic deleteBit;
@override@JsonKey(name: "tot_advance") final  dynamic totAdvance;
@override@JsonKey(name: "credit_limit") final  dynamic creditLimit;
@override@JsonKey(name: "status") final  dynamic status;
@override@JsonKey(name: "created_by") final  String? createdBy;
@override@JsonKey(name: "created_at") final  DateTime? createdAt;
@override@JsonKey(name: "updated_at") final  DateTime? updatedAt;
@override@JsonKey(name: "store_name") final  String? storeName;
@override@JsonKey(name: "country") final  dynamic country;

/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDataCopyWith<_CustomerData> get copyWith => __$CustomerDataCopyWithImpl<_CustomerData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerData&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.countId, countId)&&const DeepCollectionEquality().equals(other.customerCode, customerCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&const DeepCollectionEquality().equals(other.phone, phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&const DeepCollectionEquality().equals(other.taxNumber, taxNumber)&&const DeepCollectionEquality().equals(other.vatin, vatin)&&const DeepCollectionEquality().equals(other.openingBalance, openingBalance)&&const DeepCollectionEquality().equals(other.salesDue, salesDue)&&const DeepCollectionEquality().equals(other.salesReturnDue, salesReturnDue)&&const DeepCollectionEquality().equals(other.countryId, countryId)&&const DeepCollectionEquality().equals(other.state, state)&&const DeepCollectionEquality().equals(other.city, city)&&const DeepCollectionEquality().equals(other.postcode, postcode)&&(identical(other.address, address) || other.address == address)&&const DeepCollectionEquality().equals(other.locationLink, locationLink)&&const DeepCollectionEquality().equals(other.attachment1, attachment1)&&const DeepCollectionEquality().equals(other.priceLevelType, priceLevelType)&&const DeepCollectionEquality().equals(other.priceLevel, priceLevel)&&const DeepCollectionEquality().equals(other.deleteBit, deleteBit)&&const DeepCollectionEquality().equals(other.totAdvance, totAdvance)&&const DeepCollectionEquality().equals(other.creditLimit, creditLimit)&&const DeepCollectionEquality().equals(other.status, status)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&const DeepCollectionEquality().equals(other.country, country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,storeId,userId,const DeepCollectionEquality().hash(countId),const DeepCollectionEquality().hash(customerCode),customerName,mobile,const DeepCollectionEquality().hash(phone),email,gstin,const DeepCollectionEquality().hash(taxNumber),const DeepCollectionEquality().hash(vatin),const DeepCollectionEquality().hash(openingBalance),const DeepCollectionEquality().hash(salesDue),const DeepCollectionEquality().hash(salesReturnDue),const DeepCollectionEquality().hash(countryId),const DeepCollectionEquality().hash(state),const DeepCollectionEquality().hash(city),const DeepCollectionEquality().hash(postcode),address,const DeepCollectionEquality().hash(locationLink),const DeepCollectionEquality().hash(attachment1),const DeepCollectionEquality().hash(priceLevelType),const DeepCollectionEquality().hash(priceLevel),const DeepCollectionEquality().hash(deleteBit),const DeepCollectionEquality().hash(totAdvance),const DeepCollectionEquality().hash(creditLimit),const DeepCollectionEquality().hash(status),createdBy,createdAt,updatedAt,storeName,const DeepCollectionEquality().hash(country)]);

@override
String toString() {
  return 'CustomerData(id: $id, storeId: $storeId, userId: $userId, countId: $countId, customerCode: $customerCode, customerName: $customerName, mobile: $mobile, phone: $phone, email: $email, gstin: $gstin, taxNumber: $taxNumber, vatin: $vatin, openingBalance: $openingBalance, salesDue: $salesDue, salesReturnDue: $salesReturnDue, countryId: $countryId, state: $state, city: $city, postcode: $postcode, address: $address, locationLink: $locationLink, attachment1: $attachment1, priceLevelType: $priceLevelType, priceLevel: $priceLevel, deleteBit: $deleteBit, totAdvance: $totAdvance, creditLimit: $creditLimit, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, storeName: $storeName, country: $country)';
}


}

/// @nodoc
abstract mixin class _$CustomerDataCopyWith<$Res> implements $CustomerDataCopyWith<$Res> {
  factory _$CustomerDataCopyWith(_CustomerData value, $Res Function(_CustomerData) _then) = __$CustomerDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") int? id,@JsonKey(name: "store_id") String? storeId,@JsonKey(name: "user_id") String? userId,@JsonKey(name: "count_id") dynamic countId,@JsonKey(name: "customer_code") dynamic customerCode,@JsonKey(name: "customer_name") String? customerName,@JsonKey(name: "mobile") String? mobile,@JsonKey(name: "phone") dynamic phone,@JsonKey(name: "email") String? email,@JsonKey(name: "gstin") String? gstin,@JsonKey(name: "tax_number") dynamic taxNumber,@JsonKey(name: "vatin") dynamic vatin,@JsonKey(name: "opening_balance") dynamic openingBalance,@JsonKey(name: "sales_due") dynamic salesDue,@JsonKey(name: "sales_return_due") dynamic salesReturnDue,@JsonKey(name: "country_id") dynamic countryId,@JsonKey(name: "state") dynamic state,@JsonKey(name: "city") dynamic city,@JsonKey(name: "postcode") dynamic postcode,@JsonKey(name: "address") String? address,@JsonKey(name: "location_link") dynamic locationLink,@JsonKey(name: "attachment_1") dynamic attachment1,@JsonKey(name: "price_level_type") dynamic priceLevelType,@JsonKey(name: "price_level") dynamic priceLevel,@JsonKey(name: "delete_bit") dynamic deleteBit,@JsonKey(name: "tot_advance") dynamic totAdvance,@JsonKey(name: "credit_limit") dynamic creditLimit,@JsonKey(name: "status") dynamic status,@JsonKey(name: "created_by") String? createdBy,@JsonKey(name: "created_at") DateTime? createdAt,@JsonKey(name: "updated_at") DateTime? updatedAt,@JsonKey(name: "store_name") String? storeName,@JsonKey(name: "country") dynamic country
});




}
/// @nodoc
class __$CustomerDataCopyWithImpl<$Res>
    implements _$CustomerDataCopyWith<$Res> {
  __$CustomerDataCopyWithImpl(this._self, this._then);

  final _CustomerData _self;
  final $Res Function(_CustomerData) _then;

/// Create a copy of CustomerData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? storeId = freezed,Object? userId = freezed,Object? countId = freezed,Object? customerCode = freezed,Object? customerName = freezed,Object? mobile = freezed,Object? phone = freezed,Object? email = freezed,Object? gstin = freezed,Object? taxNumber = freezed,Object? vatin = freezed,Object? openingBalance = freezed,Object? salesDue = freezed,Object? salesReturnDue = freezed,Object? countryId = freezed,Object? state = freezed,Object? city = freezed,Object? postcode = freezed,Object? address = freezed,Object? locationLink = freezed,Object? attachment1 = freezed,Object? priceLevelType = freezed,Object? priceLevel = freezed,Object? deleteBit = freezed,Object? totAdvance = freezed,Object? creditLimit = freezed,Object? status = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? storeName = freezed,Object? country = freezed,}) {
  return _then(_CustomerData(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,countId: freezed == countId ? _self.countId : countId // ignore: cast_nullable_to_non_nullable
as dynamic,customerCode: freezed == customerCode ? _self.customerCode : customerCode // ignore: cast_nullable_to_non_nullable
as dynamic,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,mobile: freezed == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as dynamic,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,taxNumber: freezed == taxNumber ? _self.taxNumber : taxNumber // ignore: cast_nullable_to_non_nullable
as dynamic,vatin: freezed == vatin ? _self.vatin : vatin // ignore: cast_nullable_to_non_nullable
as dynamic,openingBalance: freezed == openingBalance ? _self.openingBalance : openingBalance // ignore: cast_nullable_to_non_nullable
as dynamic,salesDue: freezed == salesDue ? _self.salesDue : salesDue // ignore: cast_nullable_to_non_nullable
as dynamic,salesReturnDue: freezed == salesReturnDue ? _self.salesReturnDue : salesReturnDue // ignore: cast_nullable_to_non_nullable
as dynamic,countryId: freezed == countryId ? _self.countryId : countryId // ignore: cast_nullable_to_non_nullable
as dynamic,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as dynamic,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as dynamic,postcode: freezed == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as dynamic,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,locationLink: freezed == locationLink ? _self.locationLink : locationLink // ignore: cast_nullable_to_non_nullable
as dynamic,attachment1: freezed == attachment1 ? _self.attachment1 : attachment1 // ignore: cast_nullable_to_non_nullable
as dynamic,priceLevelType: freezed == priceLevelType ? _self.priceLevelType : priceLevelType // ignore: cast_nullable_to_non_nullable
as dynamic,priceLevel: freezed == priceLevel ? _self.priceLevel : priceLevel // ignore: cast_nullable_to_non_nullable
as dynamic,deleteBit: freezed == deleteBit ? _self.deleteBit : deleteBit // ignore: cast_nullable_to_non_nullable
as dynamic,totAdvance: freezed == totAdvance ? _self.totAdvance : totAdvance // ignore: cast_nullable_to_non_nullable
as dynamic,creditLimit: freezed == creditLimit ? _self.creditLimit : creditLimit // ignore: cast_nullable_to_non_nullable
as dynamic,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as dynamic,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}


/// @nodoc
mixin _$CustomerInsights {

@JsonKey(name: "total_customers") int? get totalCustomers;@JsonKey(name: "new_customers_last_30_days") int? get newCustomersLast30Days;
/// Create a copy of CustomerInsights
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerInsightsCopyWith<CustomerInsights> get copyWith => _$CustomerInsightsCopyWithImpl<CustomerInsights>(this as CustomerInsights, _$identity);

  /// Serializes this CustomerInsights to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerInsights&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.newCustomersLast30Days, newCustomersLast30Days) || other.newCustomersLast30Days == newCustomersLast30Days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCustomers,newCustomersLast30Days);

@override
String toString() {
  return 'CustomerInsights(totalCustomers: $totalCustomers, newCustomersLast30Days: $newCustomersLast30Days)';
}


}

/// @nodoc
abstract mixin class $CustomerInsightsCopyWith<$Res>  {
  factory $CustomerInsightsCopyWith(CustomerInsights value, $Res Function(CustomerInsights) _then) = _$CustomerInsightsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "total_customers") int? totalCustomers,@JsonKey(name: "new_customers_last_30_days") int? newCustomersLast30Days
});




}
/// @nodoc
class _$CustomerInsightsCopyWithImpl<$Res>
    implements $CustomerInsightsCopyWith<$Res> {
  _$CustomerInsightsCopyWithImpl(this._self, this._then);

  final CustomerInsights _self;
  final $Res Function(CustomerInsights) _then;

/// Create a copy of CustomerInsights
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCustomers = freezed,Object? newCustomersLast30Days = freezed,}) {
  return _then(_self.copyWith(
totalCustomers: freezed == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int?,newCustomersLast30Days: freezed == newCustomersLast30Days ? _self.newCustomersLast30Days : newCustomersLast30Days // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerInsights].
extension CustomerInsightsPatterns on CustomerInsights {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerInsights value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerInsights() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerInsights value)  $default,){
final _that = this;
switch (_that) {
case _CustomerInsights():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerInsights value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerInsights() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "total_customers")  int? totalCustomers, @JsonKey(name: "new_customers_last_30_days")  int? newCustomersLast30Days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerInsights() when $default != null:
return $default(_that.totalCustomers,_that.newCustomersLast30Days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "total_customers")  int? totalCustomers, @JsonKey(name: "new_customers_last_30_days")  int? newCustomersLast30Days)  $default,) {final _that = this;
switch (_that) {
case _CustomerInsights():
return $default(_that.totalCustomers,_that.newCustomersLast30Days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "total_customers")  int? totalCustomers, @JsonKey(name: "new_customers_last_30_days")  int? newCustomersLast30Days)?  $default,) {final _that = this;
switch (_that) {
case _CustomerInsights() when $default != null:
return $default(_that.totalCustomers,_that.newCustomersLast30Days);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CustomerInsights implements CustomerInsights {
  const _CustomerInsights({@JsonKey(name: "total_customers") this.totalCustomers, @JsonKey(name: "new_customers_last_30_days") this.newCustomersLast30Days});
  factory _CustomerInsights.fromJson(Map<String, dynamic> json) => _$CustomerInsightsFromJson(json);

@override@JsonKey(name: "total_customers") final  int? totalCustomers;
@override@JsonKey(name: "new_customers_last_30_days") final  int? newCustomersLast30Days;

/// Create a copy of CustomerInsights
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerInsightsCopyWith<_CustomerInsights> get copyWith => __$CustomerInsightsCopyWithImpl<_CustomerInsights>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerInsightsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerInsights&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.newCustomersLast30Days, newCustomersLast30Days) || other.newCustomersLast30Days == newCustomersLast30Days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCustomers,newCustomersLast30Days);

@override
String toString() {
  return 'CustomerInsights(totalCustomers: $totalCustomers, newCustomersLast30Days: $newCustomersLast30Days)';
}


}

/// @nodoc
abstract mixin class _$CustomerInsightsCopyWith<$Res> implements $CustomerInsightsCopyWith<$Res> {
  factory _$CustomerInsightsCopyWith(_CustomerInsights value, $Res Function(_CustomerInsights) _then) = __$CustomerInsightsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "total_customers") int? totalCustomers,@JsonKey(name: "new_customers_last_30_days") int? newCustomersLast30Days
});




}
/// @nodoc
class __$CustomerInsightsCopyWithImpl<$Res>
    implements _$CustomerInsightsCopyWith<$Res> {
  __$CustomerInsightsCopyWithImpl(this._self, this._then);

  final _CustomerInsights _self;
  final $Res Function(_CustomerInsights) _then;

/// Create a copy of CustomerInsights
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCustomers = freezed,Object? newCustomersLast30Days = freezed,}) {
  return _then(_CustomerInsights(
totalCustomers: freezed == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int?,newCustomersLast30Days: freezed == newCustomersLast30Days ? _self.newCustomersLast30Days : newCustomersLast30Days // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

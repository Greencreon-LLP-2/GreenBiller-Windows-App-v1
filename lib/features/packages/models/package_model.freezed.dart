// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackageModel {

@JsonKey(name: "message") String? get message;@JsonKey(name: "data") List<Datum>? get data;@JsonKey(name: "status") int? get status;
/// Create a copy of PackageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageModelCopyWith<PackageModel> get copyWith => _$PackageModelCopyWithImpl<PackageModel>(this as PackageModel, _$identity);

  /// Serializes this PackageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackageModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(data),status);

@override
String toString() {
  return 'PackageModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class $PackageModelCopyWith<$Res>  {
  factory $PackageModelCopyWith(PackageModel value, $Res Function(PackageModel) _then) = _$PackageModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class _$PackageModelCopyWithImpl<$Res>
    implements $PackageModelCopyWith<$Res> {
  _$PackageModelCopyWithImpl(this._self, this._then);

  final PackageModel _self;
  final $Res Function(PackageModel) _then;

/// Create a copy of PackageModel
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


/// Adds pattern-matching-related methods to [PackageModel].
extension PackageModelPatterns on PackageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackageModel value)  $default,){
final _that = this;
switch (_that) {
case _PackageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackageModel value)?  $default,){
final _that = this;
switch (_that) {
case _PackageModel() when $default != null:
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
case _PackageModel() when $default != null:
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
case _PackageModel():
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
case _PackageModel() when $default != null:
return $default(_that.message,_that.data,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackageModel implements PackageModel {
  const _PackageModel({@JsonKey(name: "message") this.message, @JsonKey(name: "data") final  List<Datum>? data, @JsonKey(name: "status") this.status}): _data = data;
  factory _PackageModel.fromJson(Map<String, dynamic> json) => _$PackageModelFromJson(json);

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

/// Create a copy of PackageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageModelCopyWith<_PackageModel> get copyWith => __$PackageModelCopyWithImpl<_PackageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackageModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_data),status);

@override
String toString() {
  return 'PackageModel(message: $message, data: $data, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PackageModelCopyWith<$Res> implements $PackageModelCopyWith<$Res> {
  factory _$PackageModelCopyWith(_PackageModel value, $Res Function(_PackageModel) _then) = __$PackageModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "message") String? message,@JsonKey(name: "data") List<Datum>? data,@JsonKey(name: "status") int? status
});




}
/// @nodoc
class __$PackageModelCopyWithImpl<$Res>
    implements _$PackageModelCopyWith<$Res> {
  __$PackageModelCopyWithImpl(this._self, this._then);

  final _PackageModel _self;
  final $Res Function(_PackageModel) _then;

/// Create a copy of PackageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? data = freezed,Object? status = freezed,}) {
  return _then(_PackageModel(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Datum>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Datum {

 int? get id;@JsonKey(name: "package_name") String? get packageName; String? get description;@JsonKey(name: "validity_date") String? get validityDate;@JsonKey(name: "if_webpanel") String? get ifWebpanel;@JsonKey(name: "if_android") String? get ifAndroid;@JsonKey(name: "if_ios") String? get ifIos;@JsonKey(name: "if_windows") String? get ifWindows; String? get price; String? get image;@JsonKey(name: "if_customerapp") String? get ifCustomerApp;@JsonKey(name: "if_deliveryapp") String? get ifDeliveryApp;@JsonKey(name: "if_exicutiveapp") String? get ifExecutiveApp;@JsonKey(name: "if_multistore") String? get ifMultistore;@JsonKey(name: "price_per_store") String? get pricePerStore;@JsonKey(name: "if_numberof_store") String? get ifNumberOfStore; String? get status;@JsonKey(name: "created_at") String? get createdAt;@JsonKey(name: "updated_at") String? get updatedAt;
/// Create a copy of Datum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatumCopyWith<Datum> get copyWith => _$DatumCopyWithImpl<Datum>(this as Datum, _$identity);

  /// Serializes this Datum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.description, description) || other.description == description)&&(identical(other.validityDate, validityDate) || other.validityDate == validityDate)&&(identical(other.ifWebpanel, ifWebpanel) || other.ifWebpanel == ifWebpanel)&&(identical(other.ifAndroid, ifAndroid) || other.ifAndroid == ifAndroid)&&(identical(other.ifIos, ifIos) || other.ifIos == ifIos)&&(identical(other.ifWindows, ifWindows) || other.ifWindows == ifWindows)&&(identical(other.price, price) || other.price == price)&&(identical(other.image, image) || other.image == image)&&(identical(other.ifCustomerApp, ifCustomerApp) || other.ifCustomerApp == ifCustomerApp)&&(identical(other.ifDeliveryApp, ifDeliveryApp) || other.ifDeliveryApp == ifDeliveryApp)&&(identical(other.ifExecutiveApp, ifExecutiveApp) || other.ifExecutiveApp == ifExecutiveApp)&&(identical(other.ifMultistore, ifMultistore) || other.ifMultistore == ifMultistore)&&(identical(other.pricePerStore, pricePerStore) || other.pricePerStore == pricePerStore)&&(identical(other.ifNumberOfStore, ifNumberOfStore) || other.ifNumberOfStore == ifNumberOfStore)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,packageName,description,validityDate,ifWebpanel,ifAndroid,ifIos,ifWindows,price,image,ifCustomerApp,ifDeliveryApp,ifExecutiveApp,ifMultistore,pricePerStore,ifNumberOfStore,status,createdAt,updatedAt]);

@override
String toString() {
  return 'Datum(id: $id, packageName: $packageName, description: $description, validityDate: $validityDate, ifWebpanel: $ifWebpanel, ifAndroid: $ifAndroid, ifIos: $ifIos, ifWindows: $ifWindows, price: $price, image: $image, ifCustomerApp: $ifCustomerApp, ifDeliveryApp: $ifDeliveryApp, ifExecutiveApp: $ifExecutiveApp, ifMultistore: $ifMultistore, pricePerStore: $pricePerStore, ifNumberOfStore: $ifNumberOfStore, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res>  {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) = _$DatumCopyWithImpl;
@useResult
$Res call({
 int? id,@JsonKey(name: "package_name") String? packageName, String? description,@JsonKey(name: "validity_date") String? validityDate,@JsonKey(name: "if_webpanel") String? ifWebpanel,@JsonKey(name: "if_android") String? ifAndroid,@JsonKey(name: "if_ios") String? ifIos,@JsonKey(name: "if_windows") String? ifWindows, String? price, String? image,@JsonKey(name: "if_customerapp") String? ifCustomerApp,@JsonKey(name: "if_deliveryapp") String? ifDeliveryApp,@JsonKey(name: "if_exicutiveapp") String? ifExecutiveApp,@JsonKey(name: "if_multistore") String? ifMultistore,@JsonKey(name: "price_per_store") String? pricePerStore,@JsonKey(name: "if_numberof_store") String? ifNumberOfStore, String? status,@JsonKey(name: "created_at") String? createdAt,@JsonKey(name: "updated_at") String? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? packageName = freezed,Object? description = freezed,Object? validityDate = freezed,Object? ifWebpanel = freezed,Object? ifAndroid = freezed,Object? ifIos = freezed,Object? ifWindows = freezed,Object? price = freezed,Object? image = freezed,Object? ifCustomerApp = freezed,Object? ifDeliveryApp = freezed,Object? ifExecutiveApp = freezed,Object? ifMultistore = freezed,Object? pricePerStore = freezed,Object? ifNumberOfStore = freezed,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,packageName: freezed == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,validityDate: freezed == validityDate ? _self.validityDate : validityDate // ignore: cast_nullable_to_non_nullable
as String?,ifWebpanel: freezed == ifWebpanel ? _self.ifWebpanel : ifWebpanel // ignore: cast_nullable_to_non_nullable
as String?,ifAndroid: freezed == ifAndroid ? _self.ifAndroid : ifAndroid // ignore: cast_nullable_to_non_nullable
as String?,ifIos: freezed == ifIos ? _self.ifIos : ifIos // ignore: cast_nullable_to_non_nullable
as String?,ifWindows: freezed == ifWindows ? _self.ifWindows : ifWindows // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,ifCustomerApp: freezed == ifCustomerApp ? _self.ifCustomerApp : ifCustomerApp // ignore: cast_nullable_to_non_nullable
as String?,ifDeliveryApp: freezed == ifDeliveryApp ? _self.ifDeliveryApp : ifDeliveryApp // ignore: cast_nullable_to_non_nullable
as String?,ifExecutiveApp: freezed == ifExecutiveApp ? _self.ifExecutiveApp : ifExecutiveApp // ignore: cast_nullable_to_non_nullable
as String?,ifMultistore: freezed == ifMultistore ? _self.ifMultistore : ifMultistore // ignore: cast_nullable_to_non_nullable
as String?,pricePerStore: freezed == pricePerStore ? _self.pricePerStore : pricePerStore // ignore: cast_nullable_to_non_nullable
as String?,ifNumberOfStore: freezed == ifNumberOfStore ? _self.ifNumberOfStore : ifNumberOfStore // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: "package_name")  String? packageName,  String? description, @JsonKey(name: "validity_date")  String? validityDate, @JsonKey(name: "if_webpanel")  String? ifWebpanel, @JsonKey(name: "if_android")  String? ifAndroid, @JsonKey(name: "if_ios")  String? ifIos, @JsonKey(name: "if_windows")  String? ifWindows,  String? price,  String? image, @JsonKey(name: "if_customerapp")  String? ifCustomerApp, @JsonKey(name: "if_deliveryapp")  String? ifDeliveryApp, @JsonKey(name: "if_exicutiveapp")  String? ifExecutiveApp, @JsonKey(name: "if_multistore")  String? ifMultistore, @JsonKey(name: "price_per_store")  String? pricePerStore, @JsonKey(name: "if_numberof_store")  String? ifNumberOfStore,  String? status, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "updated_at")  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.packageName,_that.description,_that.validityDate,_that.ifWebpanel,_that.ifAndroid,_that.ifIos,_that.ifWindows,_that.price,_that.image,_that.ifCustomerApp,_that.ifDeliveryApp,_that.ifExecutiveApp,_that.ifMultistore,_that.pricePerStore,_that.ifNumberOfStore,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id, @JsonKey(name: "package_name")  String? packageName,  String? description, @JsonKey(name: "validity_date")  String? validityDate, @JsonKey(name: "if_webpanel")  String? ifWebpanel, @JsonKey(name: "if_android")  String? ifAndroid, @JsonKey(name: "if_ios")  String? ifIos, @JsonKey(name: "if_windows")  String? ifWindows,  String? price,  String? image, @JsonKey(name: "if_customerapp")  String? ifCustomerApp, @JsonKey(name: "if_deliveryapp")  String? ifDeliveryApp, @JsonKey(name: "if_exicutiveapp")  String? ifExecutiveApp, @JsonKey(name: "if_multistore")  String? ifMultistore, @JsonKey(name: "price_per_store")  String? pricePerStore, @JsonKey(name: "if_numberof_store")  String? ifNumberOfStore,  String? status, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "updated_at")  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Datum():
return $default(_that.id,_that.packageName,_that.description,_that.validityDate,_that.ifWebpanel,_that.ifAndroid,_that.ifIos,_that.ifWindows,_that.price,_that.image,_that.ifCustomerApp,_that.ifDeliveryApp,_that.ifExecutiveApp,_that.ifMultistore,_that.pricePerStore,_that.ifNumberOfStore,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id, @JsonKey(name: "package_name")  String? packageName,  String? description, @JsonKey(name: "validity_date")  String? validityDate, @JsonKey(name: "if_webpanel")  String? ifWebpanel, @JsonKey(name: "if_android")  String? ifAndroid, @JsonKey(name: "if_ios")  String? ifIos, @JsonKey(name: "if_windows")  String? ifWindows,  String? price,  String? image, @JsonKey(name: "if_customerapp")  String? ifCustomerApp, @JsonKey(name: "if_deliveryapp")  String? ifDeliveryApp, @JsonKey(name: "if_exicutiveapp")  String? ifExecutiveApp, @JsonKey(name: "if_multistore")  String? ifMultistore, @JsonKey(name: "price_per_store")  String? pricePerStore, @JsonKey(name: "if_numberof_store")  String? ifNumberOfStore,  String? status, @JsonKey(name: "created_at")  String? createdAt, @JsonKey(name: "updated_at")  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Datum() when $default != null:
return $default(_that.id,_that.packageName,_that.description,_that.validityDate,_that.ifWebpanel,_that.ifAndroid,_that.ifIos,_that.ifWindows,_that.price,_that.image,_that.ifCustomerApp,_that.ifDeliveryApp,_that.ifExecutiveApp,_that.ifMultistore,_that.pricePerStore,_that.ifNumberOfStore,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Datum implements Datum {
  const _Datum({this.id, @JsonKey(name: "package_name") this.packageName, this.description, @JsonKey(name: "validity_date") this.validityDate, @JsonKey(name: "if_webpanel") this.ifWebpanel, @JsonKey(name: "if_android") this.ifAndroid, @JsonKey(name: "if_ios") this.ifIos, @JsonKey(name: "if_windows") this.ifWindows, this.price, this.image, @JsonKey(name: "if_customerapp") this.ifCustomerApp, @JsonKey(name: "if_deliveryapp") this.ifDeliveryApp, @JsonKey(name: "if_exicutiveapp") this.ifExecutiveApp, @JsonKey(name: "if_multistore") this.ifMultistore, @JsonKey(name: "price_per_store") this.pricePerStore, @JsonKey(name: "if_numberof_store") this.ifNumberOfStore, this.status, @JsonKey(name: "created_at") this.createdAt, @JsonKey(name: "updated_at") this.updatedAt});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

@override final  int? id;
@override@JsonKey(name: "package_name") final  String? packageName;
@override final  String? description;
@override@JsonKey(name: "validity_date") final  String? validityDate;
@override@JsonKey(name: "if_webpanel") final  String? ifWebpanel;
@override@JsonKey(name: "if_android") final  String? ifAndroid;
@override@JsonKey(name: "if_ios") final  String? ifIos;
@override@JsonKey(name: "if_windows") final  String? ifWindows;
@override final  String? price;
@override final  String? image;
@override@JsonKey(name: "if_customerapp") final  String? ifCustomerApp;
@override@JsonKey(name: "if_deliveryapp") final  String? ifDeliveryApp;
@override@JsonKey(name: "if_exicutiveapp") final  String? ifExecutiveApp;
@override@JsonKey(name: "if_multistore") final  String? ifMultistore;
@override@JsonKey(name: "price_per_store") final  String? pricePerStore;
@override@JsonKey(name: "if_numberof_store") final  String? ifNumberOfStore;
@override final  String? status;
@override@JsonKey(name: "created_at") final  String? createdAt;
@override@JsonKey(name: "updated_at") final  String? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Datum&&(identical(other.id, id) || other.id == id)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.description, description) || other.description == description)&&(identical(other.validityDate, validityDate) || other.validityDate == validityDate)&&(identical(other.ifWebpanel, ifWebpanel) || other.ifWebpanel == ifWebpanel)&&(identical(other.ifAndroid, ifAndroid) || other.ifAndroid == ifAndroid)&&(identical(other.ifIos, ifIos) || other.ifIos == ifIos)&&(identical(other.ifWindows, ifWindows) || other.ifWindows == ifWindows)&&(identical(other.price, price) || other.price == price)&&(identical(other.image, image) || other.image == image)&&(identical(other.ifCustomerApp, ifCustomerApp) || other.ifCustomerApp == ifCustomerApp)&&(identical(other.ifDeliveryApp, ifDeliveryApp) || other.ifDeliveryApp == ifDeliveryApp)&&(identical(other.ifExecutiveApp, ifExecutiveApp) || other.ifExecutiveApp == ifExecutiveApp)&&(identical(other.ifMultistore, ifMultistore) || other.ifMultistore == ifMultistore)&&(identical(other.pricePerStore, pricePerStore) || other.pricePerStore == pricePerStore)&&(identical(other.ifNumberOfStore, ifNumberOfStore) || other.ifNumberOfStore == ifNumberOfStore)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,packageName,description,validityDate,ifWebpanel,ifAndroid,ifIos,ifWindows,price,image,ifCustomerApp,ifDeliveryApp,ifExecutiveApp,ifMultistore,pricePerStore,ifNumberOfStore,status,createdAt,updatedAt]);

@override
String toString() {
  return 'Datum(id: $id, packageName: $packageName, description: $description, validityDate: $validityDate, ifWebpanel: $ifWebpanel, ifAndroid: $ifAndroid, ifIos: $ifIos, ifWindows: $ifWindows, price: $price, image: $image, ifCustomerApp: $ifCustomerApp, ifDeliveryApp: $ifDeliveryApp, ifExecutiveApp: $ifExecutiveApp, ifMultistore: $ifMultistore, pricePerStore: $pricePerStore, ifNumberOfStore: $ifNumberOfStore, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DatumCopyWith<$Res> implements $DatumCopyWith<$Res> {
  factory _$DatumCopyWith(_Datum value, $Res Function(_Datum) _then) = __$DatumCopyWithImpl;
@override @useResult
$Res call({
 int? id,@JsonKey(name: "package_name") String? packageName, String? description,@JsonKey(name: "validity_date") String? validityDate,@JsonKey(name: "if_webpanel") String? ifWebpanel,@JsonKey(name: "if_android") String? ifAndroid,@JsonKey(name: "if_ios") String? ifIos,@JsonKey(name: "if_windows") String? ifWindows, String? price, String? image,@JsonKey(name: "if_customerapp") String? ifCustomerApp,@JsonKey(name: "if_deliveryapp") String? ifDeliveryApp,@JsonKey(name: "if_exicutiveapp") String? ifExecutiveApp,@JsonKey(name: "if_multistore") String? ifMultistore,@JsonKey(name: "price_per_store") String? pricePerStore,@JsonKey(name: "if_numberof_store") String? ifNumberOfStore, String? status,@JsonKey(name: "created_at") String? createdAt,@JsonKey(name: "updated_at") String? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? packageName = freezed,Object? description = freezed,Object? validityDate = freezed,Object? ifWebpanel = freezed,Object? ifAndroid = freezed,Object? ifIos = freezed,Object? ifWindows = freezed,Object? price = freezed,Object? image = freezed,Object? ifCustomerApp = freezed,Object? ifDeliveryApp = freezed,Object? ifExecutiveApp = freezed,Object? ifMultistore = freezed,Object? pricePerStore = freezed,Object? ifNumberOfStore = freezed,Object? status = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Datum(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,packageName: freezed == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,validityDate: freezed == validityDate ? _self.validityDate : validityDate // ignore: cast_nullable_to_non_nullable
as String?,ifWebpanel: freezed == ifWebpanel ? _self.ifWebpanel : ifWebpanel // ignore: cast_nullable_to_non_nullable
as String?,ifAndroid: freezed == ifAndroid ? _self.ifAndroid : ifAndroid // ignore: cast_nullable_to_non_nullable
as String?,ifIos: freezed == ifIos ? _self.ifIos : ifIos // ignore: cast_nullable_to_non_nullable
as String?,ifWindows: freezed == ifWindows ? _self.ifWindows : ifWindows // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,ifCustomerApp: freezed == ifCustomerApp ? _self.ifCustomerApp : ifCustomerApp // ignore: cast_nullable_to_non_nullable
as String?,ifDeliveryApp: freezed == ifDeliveryApp ? _self.ifDeliveryApp : ifDeliveryApp // ignore: cast_nullable_to_non_nullable
as String?,ifExecutiveApp: freezed == ifExecutiveApp ? _self.ifExecutiveApp : ifExecutiveApp // ignore: cast_nullable_to_non_nullable
as String?,ifMultistore: freezed == ifMultistore ? _self.ifMultistore : ifMultistore // ignore: cast_nullable_to_non_nullable
as String?,pricePerStore: freezed == pricePerStore ? _self.pricePerStore : pricePerStore // ignore: cast_nullable_to_non_nullable
as String?,ifNumberOfStore: freezed == ifNumberOfStore ? _self.ifNumberOfStore : ifNumberOfStore // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

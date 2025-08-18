// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupplierModel {
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "data")
  List<SupplierData>? get data;
  @JsonKey(name: "total")
  int? get total;
  @JsonKey(name: "status")
  int? get status;
  @JsonKey(name: "insights")
  SupplierInsights? get insights;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupplierModelCopyWith<SupplierModel> get copyWith =>
      _$SupplierModelCopyWithImpl<SupplierModel>(
          this as SupplierModel, _$identity);

  /// Serializes this SupplierModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupplierModel &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.insights, insights) ||
                other.insights == insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(data), total, status, insights);

  @override
  String toString() {
    return 'SupplierModel(message: $message, data: $data, total: $total, status: $status, insights: $insights)';
  }
}

/// @nodoc
abstract mixin class $SupplierModelCopyWith<$Res> {
  factory $SupplierModelCopyWith(
          SupplierModel value, $Res Function(SupplierModel) _then) =
      _$SupplierModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<SupplierData>? data,
      @JsonKey(name: "total") int? total,
      @JsonKey(name: "status") int? status,
      @JsonKey(name: "insights") SupplierInsights? insights});

  $SupplierInsightsCopyWith<$Res>? get insights;
}

/// @nodoc
class _$SupplierModelCopyWithImpl<$Res>
    implements $SupplierModelCopyWith<$Res> {
  _$SupplierModelCopyWithImpl(this._self, this._then);

  final SupplierModel _self;
  final $Res Function(SupplierModel) _then;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? total = freezed,
    Object? status = freezed,
    Object? insights = freezed,
  }) {
    return _then(_self.copyWith(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<SupplierData>?,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      insights: freezed == insights
          ? _self.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as SupplierInsights?,
    ));
  }

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupplierInsightsCopyWith<$Res>? get insights {
    if (_self.insights == null) {
      return null;
    }

    return $SupplierInsightsCopyWith<$Res>(_self.insights!, (value) {
      return _then(_self.copyWith(insights: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SupplierModel].
extension SupplierModelPatterns on SupplierModel {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SupplierModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SupplierModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierModel():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SupplierModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: "message") String? message,
            @JsonKey(name: "data") List<SupplierData>? data,
            @JsonKey(name: "total") int? total,
            @JsonKey(name: "status") int? status,
            @JsonKey(name: "insights") SupplierInsights? insights)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierModel() when $default != null:
        return $default(_that.message, _that.data, _that.total, _that.status,
            _that.insights);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: "message") String? message,
            @JsonKey(name: "data") List<SupplierData>? data,
            @JsonKey(name: "total") int? total,
            @JsonKey(name: "status") int? status,
            @JsonKey(name: "insights") SupplierInsights? insights)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierModel():
        return $default(_that.message, _that.data, _that.total, _that.status,
            _that.insights);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: "message") String? message,
            @JsonKey(name: "data") List<SupplierData>? data,
            @JsonKey(name: "total") int? total,
            @JsonKey(name: "status") int? status,
            @JsonKey(name: "insights") SupplierInsights? insights)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierModel() when $default != null:
        return $default(_that.message, _that.data, _that.total, _that.status,
            _that.insights);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupplierModel implements SupplierModel {
  const _SupplierModel(
      {@JsonKey(name: "message") this.message,
      @JsonKey(name: "data") final List<SupplierData>? data,
      @JsonKey(name: "total") this.total,
      @JsonKey(name: "status") this.status,
      @JsonKey(name: "insights") this.insights})
      : _data = data;
  factory _SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  @override
  @JsonKey(name: "message")
  final String? message;
  final List<SupplierData>? _data;
  @override
  @JsonKey(name: "data")
  List<SupplierData>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: "total")
  final int? total;
  @override
  @JsonKey(name: "status")
  final int? status;
  @override
  @JsonKey(name: "insights")
  final SupplierInsights? insights;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupplierModelCopyWith<_SupplierModel> get copyWith =>
      __$SupplierModelCopyWithImpl<_SupplierModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SupplierModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupplierModel &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.insights, insights) ||
                other.insights == insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(_data), total, status, insights);

  @override
  String toString() {
    return 'SupplierModel(message: $message, data: $data, total: $total, status: $status, insights: $insights)';
  }
}

/// @nodoc
abstract mixin class _$SupplierModelCopyWith<$Res>
    implements $SupplierModelCopyWith<$Res> {
  factory _$SupplierModelCopyWith(
          _SupplierModel value, $Res Function(_SupplierModel) _then) =
      __$SupplierModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<SupplierData>? data,
      @JsonKey(name: "total") int? total,
      @JsonKey(name: "status") int? status,
      @JsonKey(name: "insights") SupplierInsights? insights});

  @override
  $SupplierInsightsCopyWith<$Res>? get insights;
}

/// @nodoc
class __$SupplierModelCopyWithImpl<$Res>
    implements _$SupplierModelCopyWith<$Res> {
  __$SupplierModelCopyWithImpl(this._self, this._then);

  final _SupplierModel _self;
  final $Res Function(_SupplierModel) _then;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? total = freezed,
    Object? status = freezed,
    Object? insights = freezed,
  }) {
    return _then(_SupplierModel(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<SupplierData>?,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      insights: freezed == insights
          ? _self.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as SupplierInsights?,
    ));
  }

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SupplierInsightsCopyWith<$Res>? get insights {
    if (_self.insights == null) {
      return null;
    }

    return $SupplierInsightsCopyWith<$Res>(_self.insights!, (value) {
      return _then(_self.copyWith(insights: value));
    });
  }
}

/// @nodoc
mixin _$SupplierData {
  @JsonKey(name: "id")
  int? get id;
  @JsonKey(name: "store_id")
  String? get storeId;
  @JsonKey(name: "cound_id")
  dynamic get coundId;
  @JsonKey(name: "supplier_code")
  dynamic get supplierCode;
  @JsonKey(name: "supplier_name")
  String? get supplierName;
  @JsonKey(name: "mobile")
  String? get mobile;
  @JsonKey(name: "phone")
  dynamic get phone;
  @JsonKey(name: "email")
  String? get email;
  @JsonKey(name: "gstin")
  String? get gstin;
  @JsonKey(name: "tax_number")
  dynamic get taxNumber;
  @JsonKey(name: "vatin")
  dynamic get vatin;
  @JsonKey(name: "opening_balance")
  dynamic get openingBalance;
  @JsonKey(name: "purchase_due")
  dynamic get purchaseDue;
  @JsonKey(name: "purchase_return_due")
  dynamic get purchaseReturnDue;
  @JsonKey(name: "country_id")
  dynamic get countryId;
  @JsonKey(name: "state_id")
  dynamic get stateId;
  @JsonKey(name: "state")
  dynamic get state;
  @JsonKey(name: "city")
  dynamic get city;
  @JsonKey(name: "postcode")
  dynamic get postcode;
  @JsonKey(name: "address")
  String? get address;
  @JsonKey(name: "company_id")
  dynamic get companyId;
  @JsonKey(name: "status")
  dynamic get status;
  @JsonKey(name: "created_at")
  DateTime? get createdAt;
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt;
  @JsonKey(name: "store_name")
  String? get storeName;

  /// Create a copy of SupplierData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupplierDataCopyWith<SupplierData> get copyWith =>
      _$SupplierDataCopyWithImpl<SupplierData>(
          this as SupplierData, _$identity);

  /// Serializes this SupplierData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupplierData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            const DeepCollectionEquality().equals(other.coundId, coundId) &&
            const DeepCollectionEquality()
                .equals(other.supplierCode, supplierCode) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            const DeepCollectionEquality().equals(other.phone, phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.gstin, gstin) || other.gstin == gstin) &&
            const DeepCollectionEquality().equals(other.taxNumber, taxNumber) &&
            const DeepCollectionEquality().equals(other.vatin, vatin) &&
            const DeepCollectionEquality()
                .equals(other.openingBalance, openingBalance) &&
            const DeepCollectionEquality()
                .equals(other.purchaseDue, purchaseDue) &&
            const DeepCollectionEquality()
                .equals(other.purchaseReturnDue, purchaseReturnDue) &&
            const DeepCollectionEquality().equals(other.countryId, countryId) &&
            const DeepCollectionEquality().equals(other.stateId, stateId) &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other.city, city) &&
            const DeepCollectionEquality().equals(other.postcode, postcode) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other.companyId, companyId) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        storeId,
        const DeepCollectionEquality().hash(coundId),
        const DeepCollectionEquality().hash(supplierCode),
        supplierName,
        mobile,
        const DeepCollectionEquality().hash(phone),
        email,
        gstin,
        const DeepCollectionEquality().hash(taxNumber),
        const DeepCollectionEquality().hash(vatin),
        const DeepCollectionEquality().hash(openingBalance),
        const DeepCollectionEquality().hash(purchaseDue),
        const DeepCollectionEquality().hash(purchaseReturnDue),
        const DeepCollectionEquality().hash(countryId),
        const DeepCollectionEquality().hash(stateId),
        const DeepCollectionEquality().hash(state),
        const DeepCollectionEquality().hash(city),
        const DeepCollectionEquality().hash(postcode),
        address,
        const DeepCollectionEquality().hash(companyId),
        const DeepCollectionEquality().hash(status),
        createdAt,
        updatedAt,
        storeName
      ]);

  @override
  String toString() {
    return 'SupplierData(id: $id, storeId: $storeId, coundId: $coundId, supplierCode: $supplierCode, supplierName: $supplierName, mobile: $mobile, phone: $phone, email: $email, gstin: $gstin, taxNumber: $taxNumber, vatin: $vatin, openingBalance: $openingBalance, purchaseDue: $purchaseDue, purchaseReturnDue: $purchaseReturnDue, countryId: $countryId, stateId: $stateId, state: $state, city: $city, postcode: $postcode, address: $address, companyId: $companyId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, storeName: $storeName)';
  }
}

/// @nodoc
abstract mixin class $SupplierDataCopyWith<$Res> {
  factory $SupplierDataCopyWith(
          SupplierData value, $Res Function(SupplierData) _then) =
      _$SupplierDataCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "store_id") String? storeId,
      @JsonKey(name: "cound_id") dynamic coundId,
      @JsonKey(name: "supplier_code") dynamic supplierCode,
      @JsonKey(name: "supplier_name") String? supplierName,
      @JsonKey(name: "mobile") String? mobile,
      @JsonKey(name: "phone") dynamic phone,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "gstin") String? gstin,
      @JsonKey(name: "tax_number") dynamic taxNumber,
      @JsonKey(name: "vatin") dynamic vatin,
      @JsonKey(name: "opening_balance") dynamic openingBalance,
      @JsonKey(name: "purchase_due") dynamic purchaseDue,
      @JsonKey(name: "purchase_return_due") dynamic purchaseReturnDue,
      @JsonKey(name: "country_id") dynamic countryId,
      @JsonKey(name: "state_id") dynamic stateId,
      @JsonKey(name: "state") dynamic state,
      @JsonKey(name: "city") dynamic city,
      @JsonKey(name: "postcode") dynamic postcode,
      @JsonKey(name: "address") String? address,
      @JsonKey(name: "company_id") dynamic companyId,
      @JsonKey(name: "status") dynamic status,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt,
      @JsonKey(name: "store_name") String? storeName});
}

/// @nodoc
class _$SupplierDataCopyWithImpl<$Res> implements $SupplierDataCopyWith<$Res> {
  _$SupplierDataCopyWithImpl(this._self, this._then);

  final SupplierData _self;
  final $Res Function(SupplierData) _then;

  /// Create a copy of SupplierData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? storeId = freezed,
    Object? coundId = freezed,
    Object? supplierCode = freezed,
    Object? supplierName = freezed,
    Object? mobile = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? gstin = freezed,
    Object? taxNumber = freezed,
    Object? vatin = freezed,
    Object? openingBalance = freezed,
    Object? purchaseDue = freezed,
    Object? purchaseReturnDue = freezed,
    Object? countryId = freezed,
    Object? stateId = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? postcode = freezed,
    Object? address = freezed,
    Object? companyId = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? storeName = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      coundId: freezed == coundId
          ? _self.coundId
          : coundId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      supplierCode: freezed == supplierCode
          ? _self.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      supplierName: freezed == supplierName
          ? _self.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _self.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as dynamic,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      gstin: freezed == gstin
          ? _self.gstin
          : gstin // ignore: cast_nullable_to_non_nullable
              as String?,
      taxNumber: freezed == taxNumber
          ? _self.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as dynamic,
      vatin: freezed == vatin
          ? _self.vatin
          : vatin // ignore: cast_nullable_to_non_nullable
              as dynamic,
      openingBalance: freezed == openingBalance
          ? _self.openingBalance
          : openingBalance // ignore: cast_nullable_to_non_nullable
              as dynamic,
      purchaseDue: freezed == purchaseDue
          ? _self.purchaseDue
          : purchaseDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      purchaseReturnDue: freezed == purchaseReturnDue
          ? _self.purchaseReturnDue
          : purchaseReturnDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stateId: freezed == stateId
          ? _self.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as dynamic,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postcode: freezed == postcode
          ? _self.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _self.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeName: freezed == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SupplierData].
extension SupplierDataPatterns on SupplierData {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SupplierData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SupplierData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierData():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SupplierData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierData() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: "id") int? id,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "cound_id") dynamic coundId,
            @JsonKey(name: "supplier_code") dynamic supplierCode,
            @JsonKey(name: "supplier_name") String? supplierName,
            @JsonKey(name: "mobile") String? mobile,
            @JsonKey(name: "phone") dynamic phone,
            @JsonKey(name: "email") String? email,
            @JsonKey(name: "gstin") String? gstin,
            @JsonKey(name: "tax_number") dynamic taxNumber,
            @JsonKey(name: "vatin") dynamic vatin,
            @JsonKey(name: "opening_balance") dynamic openingBalance,
            @JsonKey(name: "purchase_due") dynamic purchaseDue,
            @JsonKey(name: "purchase_return_due") dynamic purchaseReturnDue,
            @JsonKey(name: "country_id") dynamic countryId,
            @JsonKey(name: "state_id") dynamic stateId,
            @JsonKey(name: "state") dynamic state,
            @JsonKey(name: "city") dynamic city,
            @JsonKey(name: "postcode") dynamic postcode,
            @JsonKey(name: "address") String? address,
            @JsonKey(name: "company_id") dynamic companyId,
            @JsonKey(name: "status") dynamic status,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt,
            @JsonKey(name: "store_name") String? storeName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierData() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.coundId,
            _that.supplierCode,
            _that.supplierName,
            _that.mobile,
            _that.phone,
            _that.email,
            _that.gstin,
            _that.taxNumber,
            _that.vatin,
            _that.openingBalance,
            _that.purchaseDue,
            _that.purchaseReturnDue,
            _that.countryId,
            _that.stateId,
            _that.state,
            _that.city,
            _that.postcode,
            _that.address,
            _that.companyId,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.storeName);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: "id") int? id,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "cound_id") dynamic coundId,
            @JsonKey(name: "supplier_code") dynamic supplierCode,
            @JsonKey(name: "supplier_name") String? supplierName,
            @JsonKey(name: "mobile") String? mobile,
            @JsonKey(name: "phone") dynamic phone,
            @JsonKey(name: "email") String? email,
            @JsonKey(name: "gstin") String? gstin,
            @JsonKey(name: "tax_number") dynamic taxNumber,
            @JsonKey(name: "vatin") dynamic vatin,
            @JsonKey(name: "opening_balance") dynamic openingBalance,
            @JsonKey(name: "purchase_due") dynamic purchaseDue,
            @JsonKey(name: "purchase_return_due") dynamic purchaseReturnDue,
            @JsonKey(name: "country_id") dynamic countryId,
            @JsonKey(name: "state_id") dynamic stateId,
            @JsonKey(name: "state") dynamic state,
            @JsonKey(name: "city") dynamic city,
            @JsonKey(name: "postcode") dynamic postcode,
            @JsonKey(name: "address") String? address,
            @JsonKey(name: "company_id") dynamic companyId,
            @JsonKey(name: "status") dynamic status,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt,
            @JsonKey(name: "store_name") String? storeName)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierData():
        return $default(
            _that.id,
            _that.storeId,
            _that.coundId,
            _that.supplierCode,
            _that.supplierName,
            _that.mobile,
            _that.phone,
            _that.email,
            _that.gstin,
            _that.taxNumber,
            _that.vatin,
            _that.openingBalance,
            _that.purchaseDue,
            _that.purchaseReturnDue,
            _that.countryId,
            _that.stateId,
            _that.state,
            _that.city,
            _that.postcode,
            _that.address,
            _that.companyId,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.storeName);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: "id") int? id,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "cound_id") dynamic coundId,
            @JsonKey(name: "supplier_code") dynamic supplierCode,
            @JsonKey(name: "supplier_name") String? supplierName,
            @JsonKey(name: "mobile") String? mobile,
            @JsonKey(name: "phone") dynamic phone,
            @JsonKey(name: "email") String? email,
            @JsonKey(name: "gstin") String? gstin,
            @JsonKey(name: "tax_number") dynamic taxNumber,
            @JsonKey(name: "vatin") dynamic vatin,
            @JsonKey(name: "opening_balance") dynamic openingBalance,
            @JsonKey(name: "purchase_due") dynamic purchaseDue,
            @JsonKey(name: "purchase_return_due") dynamic purchaseReturnDue,
            @JsonKey(name: "country_id") dynamic countryId,
            @JsonKey(name: "state_id") dynamic stateId,
            @JsonKey(name: "state") dynamic state,
            @JsonKey(name: "city") dynamic city,
            @JsonKey(name: "postcode") dynamic postcode,
            @JsonKey(name: "address") String? address,
            @JsonKey(name: "company_id") dynamic companyId,
            @JsonKey(name: "status") dynamic status,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt,
            @JsonKey(name: "store_name") String? storeName)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierData() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.coundId,
            _that.supplierCode,
            _that.supplierName,
            _that.mobile,
            _that.phone,
            _that.email,
            _that.gstin,
            _that.taxNumber,
            _that.vatin,
            _that.openingBalance,
            _that.purchaseDue,
            _that.purchaseReturnDue,
            _that.countryId,
            _that.stateId,
            _that.state,
            _that.city,
            _that.postcode,
            _that.address,
            _that.companyId,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.storeName);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupplierData implements SupplierData {
  const _SupplierData(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "store_id") this.storeId,
      @JsonKey(name: "cound_id") this.coundId,
      @JsonKey(name: "supplier_code") this.supplierCode,
      @JsonKey(name: "supplier_name") this.supplierName,
      @JsonKey(name: "mobile") this.mobile,
      @JsonKey(name: "phone") this.phone,
      @JsonKey(name: "email") this.email,
      @JsonKey(name: "gstin") this.gstin,
      @JsonKey(name: "tax_number") this.taxNumber,
      @JsonKey(name: "vatin") this.vatin,
      @JsonKey(name: "opening_balance") this.openingBalance,
      @JsonKey(name: "purchase_due") this.purchaseDue,
      @JsonKey(name: "purchase_return_due") this.purchaseReturnDue,
      @JsonKey(name: "country_id") this.countryId,
      @JsonKey(name: "state_id") this.stateId,
      @JsonKey(name: "state") this.state,
      @JsonKey(name: "city") this.city,
      @JsonKey(name: "postcode") this.postcode,
      @JsonKey(name: "address") this.address,
      @JsonKey(name: "company_id") this.companyId,
      @JsonKey(name: "status") this.status,
      @JsonKey(name: "created_at") this.createdAt,
      @JsonKey(name: "updated_at") this.updatedAt,
      @JsonKey(name: "store_name") this.storeName});
  factory _SupplierData.fromJson(Map<String, dynamic> json) =>
      _$SupplierDataFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "store_id")
  final String? storeId;
  @override
  @JsonKey(name: "cound_id")
  final dynamic coundId;
  @override
  @JsonKey(name: "supplier_code")
  final dynamic supplierCode;
  @override
  @JsonKey(name: "supplier_name")
  final String? supplierName;
  @override
  @JsonKey(name: "mobile")
  final String? mobile;
  @override
  @JsonKey(name: "phone")
  final dynamic phone;
  @override
  @JsonKey(name: "email")
  final String? email;
  @override
  @JsonKey(name: "gstin")
  final String? gstin;
  @override
  @JsonKey(name: "tax_number")
  final dynamic taxNumber;
  @override
  @JsonKey(name: "vatin")
  final dynamic vatin;
  @override
  @JsonKey(name: "opening_balance")
  final dynamic openingBalance;
  @override
  @JsonKey(name: "purchase_due")
  final dynamic purchaseDue;
  @override
  @JsonKey(name: "purchase_return_due")
  final dynamic purchaseReturnDue;
  @override
  @JsonKey(name: "country_id")
  final dynamic countryId;
  @override
  @JsonKey(name: "state_id")
  final dynamic stateId;
  @override
  @JsonKey(name: "state")
  final dynamic state;
  @override
  @JsonKey(name: "city")
  final dynamic city;
  @override
  @JsonKey(name: "postcode")
  final dynamic postcode;
  @override
  @JsonKey(name: "address")
  final String? address;
  @override
  @JsonKey(name: "company_id")
  final dynamic companyId;
  @override
  @JsonKey(name: "status")
  final dynamic status;
  @override
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @override
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;
  @override
  @JsonKey(name: "store_name")
  final String? storeName;

  /// Create a copy of SupplierData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupplierDataCopyWith<_SupplierData> get copyWith =>
      __$SupplierDataCopyWithImpl<_SupplierData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SupplierDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupplierData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            const DeepCollectionEquality().equals(other.coundId, coundId) &&
            const DeepCollectionEquality()
                .equals(other.supplierCode, supplierCode) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            const DeepCollectionEquality().equals(other.phone, phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.gstin, gstin) || other.gstin == gstin) &&
            const DeepCollectionEquality().equals(other.taxNumber, taxNumber) &&
            const DeepCollectionEquality().equals(other.vatin, vatin) &&
            const DeepCollectionEquality()
                .equals(other.openingBalance, openingBalance) &&
            const DeepCollectionEquality()
                .equals(other.purchaseDue, purchaseDue) &&
            const DeepCollectionEquality()
                .equals(other.purchaseReturnDue, purchaseReturnDue) &&
            const DeepCollectionEquality().equals(other.countryId, countryId) &&
            const DeepCollectionEquality().equals(other.stateId, stateId) &&
            const DeepCollectionEquality().equals(other.state, state) &&
            const DeepCollectionEquality().equals(other.city, city) &&
            const DeepCollectionEquality().equals(other.postcode, postcode) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other.companyId, companyId) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        storeId,
        const DeepCollectionEquality().hash(coundId),
        const DeepCollectionEquality().hash(supplierCode),
        supplierName,
        mobile,
        const DeepCollectionEquality().hash(phone),
        email,
        gstin,
        const DeepCollectionEquality().hash(taxNumber),
        const DeepCollectionEquality().hash(vatin),
        const DeepCollectionEquality().hash(openingBalance),
        const DeepCollectionEquality().hash(purchaseDue),
        const DeepCollectionEquality().hash(purchaseReturnDue),
        const DeepCollectionEquality().hash(countryId),
        const DeepCollectionEquality().hash(stateId),
        const DeepCollectionEquality().hash(state),
        const DeepCollectionEquality().hash(city),
        const DeepCollectionEquality().hash(postcode),
        address,
        const DeepCollectionEquality().hash(companyId),
        const DeepCollectionEquality().hash(status),
        createdAt,
        updatedAt,
        storeName
      ]);

  @override
  String toString() {
    return 'SupplierData(id: $id, storeId: $storeId, coundId: $coundId, supplierCode: $supplierCode, supplierName: $supplierName, mobile: $mobile, phone: $phone, email: $email, gstin: $gstin, taxNumber: $taxNumber, vatin: $vatin, openingBalance: $openingBalance, purchaseDue: $purchaseDue, purchaseReturnDue: $purchaseReturnDue, countryId: $countryId, stateId: $stateId, state: $state, city: $city, postcode: $postcode, address: $address, companyId: $companyId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, storeName: $storeName)';
  }
}

/// @nodoc
abstract mixin class _$SupplierDataCopyWith<$Res>
    implements $SupplierDataCopyWith<$Res> {
  factory _$SupplierDataCopyWith(
          _SupplierData value, $Res Function(_SupplierData) _then) =
      __$SupplierDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "store_id") String? storeId,
      @JsonKey(name: "cound_id") dynamic coundId,
      @JsonKey(name: "supplier_code") dynamic supplierCode,
      @JsonKey(name: "supplier_name") String? supplierName,
      @JsonKey(name: "mobile") String? mobile,
      @JsonKey(name: "phone") dynamic phone,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "gstin") String? gstin,
      @JsonKey(name: "tax_number") dynamic taxNumber,
      @JsonKey(name: "vatin") dynamic vatin,
      @JsonKey(name: "opening_balance") dynamic openingBalance,
      @JsonKey(name: "purchase_due") dynamic purchaseDue,
      @JsonKey(name: "purchase_return_due") dynamic purchaseReturnDue,
      @JsonKey(name: "country_id") dynamic countryId,
      @JsonKey(name: "state_id") dynamic stateId,
      @JsonKey(name: "state") dynamic state,
      @JsonKey(name: "city") dynamic city,
      @JsonKey(name: "postcode") dynamic postcode,
      @JsonKey(name: "address") String? address,
      @JsonKey(name: "company_id") dynamic companyId,
      @JsonKey(name: "status") dynamic status,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt,
      @JsonKey(name: "store_name") String? storeName});
}

/// @nodoc
class __$SupplierDataCopyWithImpl<$Res>
    implements _$SupplierDataCopyWith<$Res> {
  __$SupplierDataCopyWithImpl(this._self, this._then);

  final _SupplierData _self;
  final $Res Function(_SupplierData) _then;

  /// Create a copy of SupplierData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? storeId = freezed,
    Object? coundId = freezed,
    Object? supplierCode = freezed,
    Object? supplierName = freezed,
    Object? mobile = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? gstin = freezed,
    Object? taxNumber = freezed,
    Object? vatin = freezed,
    Object? openingBalance = freezed,
    Object? purchaseDue = freezed,
    Object? purchaseReturnDue = freezed,
    Object? countryId = freezed,
    Object? stateId = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? postcode = freezed,
    Object? address = freezed,
    Object? companyId = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? storeName = freezed,
  }) {
    return _then(_SupplierData(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      coundId: freezed == coundId
          ? _self.coundId
          : coundId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      supplierCode: freezed == supplierCode
          ? _self.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      supplierName: freezed == supplierName
          ? _self.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _self.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as dynamic,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      gstin: freezed == gstin
          ? _self.gstin
          : gstin // ignore: cast_nullable_to_non_nullable
              as String?,
      taxNumber: freezed == taxNumber
          ? _self.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
              as dynamic,
      vatin: freezed == vatin
          ? _self.vatin
          : vatin // ignore: cast_nullable_to_non_nullable
              as dynamic,
      openingBalance: freezed == openingBalance
          ? _self.openingBalance
          : openingBalance // ignore: cast_nullable_to_non_nullable
              as dynamic,
      purchaseDue: freezed == purchaseDue
          ? _self.purchaseDue
          : purchaseDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      purchaseReturnDue: freezed == purchaseReturnDue
          ? _self.purchaseReturnDue
          : purchaseReturnDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      countryId: freezed == countryId
          ? _self.countryId
          : countryId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      stateId: freezed == stateId
          ? _self.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as dynamic,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as dynamic,
      postcode: freezed == postcode
          ? _self.postcode
          : postcode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _self.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      storeName: freezed == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SupplierInsights {
  @JsonKey(name: "total_suppliers")
  int? get totalSuppliers;
  @JsonKey(name: "new_suppliers_last_30_days")
  int? get newSuppliersLast30Days;

  /// Create a copy of SupplierInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SupplierInsightsCopyWith<SupplierInsights> get copyWith =>
      _$SupplierInsightsCopyWithImpl<SupplierInsights>(
          this as SupplierInsights, _$identity);

  /// Serializes this SupplierInsights to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SupplierInsights &&
            (identical(other.totalSuppliers, totalSuppliers) ||
                other.totalSuppliers == totalSuppliers) &&
            (identical(other.newSuppliersLast30Days, newSuppliersLast30Days) ||
                other.newSuppliersLast30Days == newSuppliersLast30Days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalSuppliers, newSuppliersLast30Days);

  @override
  String toString() {
    return 'SupplierInsights(totalSuppliers: $totalSuppliers, newSuppliersLast30Days: $newSuppliersLast30Days)';
  }
}

/// @nodoc
abstract mixin class $SupplierInsightsCopyWith<$Res> {
  factory $SupplierInsightsCopyWith(
          SupplierInsights value, $Res Function(SupplierInsights) _then) =
      _$SupplierInsightsCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "total_suppliers") int? totalSuppliers,
      @JsonKey(name: "new_suppliers_last_30_days")
      int? newSuppliersLast30Days});
}

/// @nodoc
class _$SupplierInsightsCopyWithImpl<$Res>
    implements $SupplierInsightsCopyWith<$Res> {
  _$SupplierInsightsCopyWithImpl(this._self, this._then);

  final SupplierInsights _self;
  final $Res Function(SupplierInsights) _then;

  /// Create a copy of SupplierInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalSuppliers = freezed,
    Object? newSuppliersLast30Days = freezed,
  }) {
    return _then(_self.copyWith(
      totalSuppliers: freezed == totalSuppliers
          ? _self.totalSuppliers
          : totalSuppliers // ignore: cast_nullable_to_non_nullable
              as int?,
      newSuppliersLast30Days: freezed == newSuppliersLast30Days
          ? _self.newSuppliersLast30Days
          : newSuppliersLast30Days // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SupplierInsights].
extension SupplierInsightsPatterns on SupplierInsights {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SupplierInsights value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierInsights() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SupplierInsights value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierInsights():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SupplierInsights value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierInsights() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: "total_suppliers") int? totalSuppliers,
            @JsonKey(name: "new_suppliers_last_30_days")
            int? newSuppliersLast30Days)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SupplierInsights() when $default != null:
        return $default(_that.totalSuppliers, _that.newSuppliersLast30Days);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: "total_suppliers") int? totalSuppliers,
            @JsonKey(name: "new_suppliers_last_30_days")
            int? newSuppliersLast30Days)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierInsights():
        return $default(_that.totalSuppliers, _that.newSuppliersLast30Days);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: "total_suppliers") int? totalSuppliers,
            @JsonKey(name: "new_suppliers_last_30_days")
            int? newSuppliersLast30Days)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SupplierInsights() when $default != null:
        return $default(_that.totalSuppliers, _that.newSuppliersLast30Days);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _SupplierInsights implements SupplierInsights {
  const _SupplierInsights(
      {@JsonKey(name: "total_suppliers") this.totalSuppliers,
      @JsonKey(name: "new_suppliers_last_30_days")
      this.newSuppliersLast30Days});
  factory _SupplierInsights.fromJson(Map<String, dynamic> json) =>
      _$SupplierInsightsFromJson(json);

  @override
  @JsonKey(name: "total_suppliers")
  final int? totalSuppliers;
  @override
  @JsonKey(name: "new_suppliers_last_30_days")
  final int? newSuppliersLast30Days;

  /// Create a copy of SupplierInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SupplierInsightsCopyWith<_SupplierInsights> get copyWith =>
      __$SupplierInsightsCopyWithImpl<_SupplierInsights>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SupplierInsightsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SupplierInsights &&
            (identical(other.totalSuppliers, totalSuppliers) ||
                other.totalSuppliers == totalSuppliers) &&
            (identical(other.newSuppliersLast30Days, newSuppliersLast30Days) ||
                other.newSuppliersLast30Days == newSuppliersLast30Days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalSuppliers, newSuppliersLast30Days);

  @override
  String toString() {
    return 'SupplierInsights(totalSuppliers: $totalSuppliers, newSuppliersLast30Days: $newSuppliersLast30Days)';
  }
}

/// @nodoc
abstract mixin class _$SupplierInsightsCopyWith<$Res>
    implements $SupplierInsightsCopyWith<$Res> {
  factory _$SupplierInsightsCopyWith(
          _SupplierInsights value, $Res Function(_SupplierInsights) _then) =
      __$SupplierInsightsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "total_suppliers") int? totalSuppliers,
      @JsonKey(name: "new_suppliers_last_30_days")
      int? newSuppliersLast30Days});
}

/// @nodoc
class __$SupplierInsightsCopyWithImpl<$Res>
    implements _$SupplierInsightsCopyWith<$Res> {
  __$SupplierInsightsCopyWithImpl(this._self, this._then);

  final _SupplierInsights _self;
  final $Res Function(_SupplierInsights) _then;

  /// Create a copy of SupplierInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalSuppliers = freezed,
    Object? newSuppliersLast30Days = freezed,
  }) {
    return _then(_SupplierInsights(
      totalSuppliers: freezed == totalSuppliers
          ? _self.totalSuppliers
          : totalSuppliers // ignore: cast_nullable_to_non_nullable
              as int?,
      newSuppliersLast30Days: freezed == newSuppliersLast30Days
          ? _self.newSuppliersLast30Days
          : newSuppliersLast30Days // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on

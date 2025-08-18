// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_suppiler_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseSummaryBySupplierModel {
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "data")
  List<Datum>? get data;
  @JsonKey(name: "status")
  int? get status;

  /// Create a copy of PurchaseSummaryBySupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PurchaseSummaryBySupplierModelCopyWith<PurchaseSummaryBySupplierModel>
      get copyWith => _$PurchaseSummaryBySupplierModelCopyWithImpl<
              PurchaseSummaryBySupplierModel>(
          this as PurchaseSummaryBySupplierModel, _$identity);

  /// Serializes this PurchaseSummaryBySupplierModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PurchaseSummaryBySupplierModel &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(data), status);

  @override
  String toString() {
    return 'PurchaseSummaryBySupplierModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class $PurchaseSummaryBySupplierModelCopyWith<$Res> {
  factory $PurchaseSummaryBySupplierModelCopyWith(
          PurchaseSummaryBySupplierModel value,
          $Res Function(PurchaseSummaryBySupplierModel) _then) =
      _$PurchaseSummaryBySupplierModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class _$PurchaseSummaryBySupplierModelCopyWithImpl<$Res>
    implements $PurchaseSummaryBySupplierModelCopyWith<$Res> {
  _$PurchaseSummaryBySupplierModelCopyWithImpl(this._self, this._then);

  final PurchaseSummaryBySupplierModel _self;
  final $Res Function(PurchaseSummaryBySupplierModel) _then;

  /// Create a copy of PurchaseSummaryBySupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_self.copyWith(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Datum>?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PurchaseSummaryBySupplierModel].
extension PurchaseSummaryBySupplierModelPatterns
    on PurchaseSummaryBySupplierModel {
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
    TResult Function(_PurchaseSummaryBySupplierModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseSummaryBySupplierModel() when $default != null:
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
    TResult Function(_PurchaseSummaryBySupplierModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseSummaryBySupplierModel():
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
    TResult? Function(_PurchaseSummaryBySupplierModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseSummaryBySupplierModel() when $default != null:
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
            @JsonKey(name: "data") List<Datum>? data,
            @JsonKey(name: "status") int? status)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PurchaseSummaryBySupplierModel() when $default != null:
        return $default(_that.message, _that.data, _that.status);
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
            @JsonKey(name: "data") List<Datum>? data,
            @JsonKey(name: "status") int? status)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseSummaryBySupplierModel():
        return $default(_that.message, _that.data, _that.status);
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
            @JsonKey(name: "data") List<Datum>? data,
            @JsonKey(name: "status") int? status)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PurchaseSummaryBySupplierModel() when $default != null:
        return $default(_that.message, _that.data, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PurchaseSummaryBySupplierModel
    implements PurchaseSummaryBySupplierModel {
  const _PurchaseSummaryBySupplierModel(
      {@JsonKey(name: "message") this.message,
      @JsonKey(name: "data") final List<Datum>? data,
      @JsonKey(name: "status") this.status})
      : _data = data;
  factory _PurchaseSummaryBySupplierModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseSummaryBySupplierModelFromJson(json);

  @override
  @JsonKey(name: "message")
  final String? message;
  final List<Datum>? _data;
  @override
  @JsonKey(name: "data")
  List<Datum>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: "status")
  final int? status;

  /// Create a copy of PurchaseSummaryBySupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PurchaseSummaryBySupplierModelCopyWith<_PurchaseSummaryBySupplierModel>
      get copyWith => __$PurchaseSummaryBySupplierModelCopyWithImpl<
          _PurchaseSummaryBySupplierModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PurchaseSummaryBySupplierModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PurchaseSummaryBySupplierModel &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_data), status);

  @override
  String toString() {
    return 'PurchaseSummaryBySupplierModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$PurchaseSummaryBySupplierModelCopyWith<$Res>
    implements $PurchaseSummaryBySupplierModelCopyWith<$Res> {
  factory _$PurchaseSummaryBySupplierModelCopyWith(
          _PurchaseSummaryBySupplierModel value,
          $Res Function(_PurchaseSummaryBySupplierModel) _then) =
      __$PurchaseSummaryBySupplierModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class __$PurchaseSummaryBySupplierModelCopyWithImpl<$Res>
    implements _$PurchaseSummaryBySupplierModelCopyWith<$Res> {
  __$PurchaseSummaryBySupplierModelCopyWithImpl(this._self, this._then);

  final _PurchaseSummaryBySupplierModel _self;
  final $Res Function(_PurchaseSummaryBySupplierModel) _then;

  /// Create a copy of PurchaseSummaryBySupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_PurchaseSummaryBySupplierModel(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Datum>?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$Datum {
  @JsonKey(name: "id")
  int? get id;
  @JsonKey(name: "store_id")
  String? get storeId;
  @JsonKey(name: "store_name")
  String? get storeName;
  @JsonKey(name: "supplier_id")
  String? get supplierId;
  @JsonKey(name: "supplier_name")
  String? get supplierName;
  @JsonKey(name: "purchase_code")
  String? get purchaseCode;
  @JsonKey(name: "reference_no")
  String? get referenceNo;
  @JsonKey(name: "grand_total")
  String? get grandTotal;
  @JsonKey(name: "paid_amount")
  String? get paidAmount;
  @JsonKey(name: "balance")
  double? get balance;
  @JsonKey(name: "purchase_date")
  DateTime? get purchaseDate;

  /// Create a copy of Datum
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DatumCopyWith<Datum> get copyWith =>
      _$DatumCopyWithImpl<Datum>(this as Datum, _$identity);

  /// Serializes this Datum to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Datum &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.purchaseCode, purchaseCode) ||
                other.purchaseCode == purchaseCode) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      storeName,
      supplierId,
      supplierName,
      purchaseCode,
      referenceNo,
      grandTotal,
      paidAmount,
      balance,
      purchaseDate);

  @override
  String toString() {
    return 'Datum(id: $id, storeId: $storeId, storeName: $storeName, supplierId: $supplierId, supplierName: $supplierName, purchaseCode: $purchaseCode, referenceNo: $referenceNo, grandTotal: $grandTotal, paidAmount: $paidAmount, balance: $balance, purchaseDate: $purchaseDate)';
  }
}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res> {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) =
      _$DatumCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "store_id") String? storeId,
      @JsonKey(name: "store_name") String? storeName,
      @JsonKey(name: "supplier_id") String? supplierId,
      @JsonKey(name: "supplier_name") String? supplierName,
      @JsonKey(name: "purchase_code") String? purchaseCode,
      @JsonKey(name: "reference_no") String? referenceNo,
      @JsonKey(name: "grand_total") String? grandTotal,
      @JsonKey(name: "paid_amount") String? paidAmount,
      @JsonKey(name: "balance") double? balance,
      @JsonKey(name: "purchase_date") DateTime? purchaseDate});
}

/// @nodoc
class _$DatumCopyWithImpl<$Res> implements $DatumCopyWith<$Res> {
  _$DatumCopyWithImpl(this._self, this._then);

  final Datum _self;
  final $Res Function(Datum) _then;

  /// Create a copy of Datum
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? purchaseCode = freezed,
    Object? referenceNo = freezed,
    Object? grandTotal = freezed,
    Object? paidAmount = freezed,
    Object? balance = freezed,
    Object? purchaseDate = freezed,
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
      storeName: freezed == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _self.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _self.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCode: freezed == purchaseCode
          ? _self.purchaseCode
          : purchaseCode // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNo: freezed == referenceNo
          ? _self.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String?,
      grandTotal: freezed == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAmount: freezed == paidAmount
          ? _self.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double?,
      purchaseDate: freezed == purchaseDate
          ? _self.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Datum value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
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
    TResult Function(_Datum value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum():
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
    TResult? Function(_Datum value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
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
            @JsonKey(name: "store_name") String? storeName,
            @JsonKey(name: "supplier_id") String? supplierId,
            @JsonKey(name: "supplier_name") String? supplierName,
            @JsonKey(name: "purchase_code") String? purchaseCode,
            @JsonKey(name: "reference_no") String? referenceNo,
            @JsonKey(name: "grand_total") String? grandTotal,
            @JsonKey(name: "paid_amount") String? paidAmount,
            @JsonKey(name: "balance") double? balance,
            @JsonKey(name: "purchase_date") DateTime? purchaseDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.storeName,
            _that.supplierId,
            _that.supplierName,
            _that.purchaseCode,
            _that.referenceNo,
            _that.grandTotal,
            _that.paidAmount,
            _that.balance,
            _that.purchaseDate);
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
            @JsonKey(name: "store_name") String? storeName,
            @JsonKey(name: "supplier_id") String? supplierId,
            @JsonKey(name: "supplier_name") String? supplierName,
            @JsonKey(name: "purchase_code") String? purchaseCode,
            @JsonKey(name: "reference_no") String? referenceNo,
            @JsonKey(name: "grand_total") String? grandTotal,
            @JsonKey(name: "paid_amount") String? paidAmount,
            @JsonKey(name: "balance") double? balance,
            @JsonKey(name: "purchase_date") DateTime? purchaseDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum():
        return $default(
            _that.id,
            _that.storeId,
            _that.storeName,
            _that.supplierId,
            _that.supplierName,
            _that.purchaseCode,
            _that.referenceNo,
            _that.grandTotal,
            _that.paidAmount,
            _that.balance,
            _that.purchaseDate);
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
            @JsonKey(name: "store_name") String? storeName,
            @JsonKey(name: "supplier_id") String? supplierId,
            @JsonKey(name: "supplier_name") String? supplierName,
            @JsonKey(name: "purchase_code") String? purchaseCode,
            @JsonKey(name: "reference_no") String? referenceNo,
            @JsonKey(name: "grand_total") String? grandTotal,
            @JsonKey(name: "paid_amount") String? paidAmount,
            @JsonKey(name: "balance") double? balance,
            @JsonKey(name: "purchase_date") DateTime? purchaseDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.storeName,
            _that.supplierId,
            _that.supplierName,
            _that.purchaseCode,
            _that.referenceNo,
            _that.grandTotal,
            _that.paidAmount,
            _that.balance,
            _that.purchaseDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Datum implements Datum {
  const _Datum(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "store_id") this.storeId,
      @JsonKey(name: "store_name") this.storeName,
      @JsonKey(name: "supplier_id") this.supplierId,
      @JsonKey(name: "supplier_name") this.supplierName,
      @JsonKey(name: "purchase_code") this.purchaseCode,
      @JsonKey(name: "reference_no") this.referenceNo,
      @JsonKey(name: "grand_total") this.grandTotal,
      @JsonKey(name: "paid_amount") this.paidAmount,
      @JsonKey(name: "balance") this.balance,
      @JsonKey(name: "purchase_date") this.purchaseDate});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "store_id")
  final String? storeId;
  @override
  @JsonKey(name: "store_name")
  final String? storeName;
  @override
  @JsonKey(name: "supplier_id")
  final String? supplierId;
  @override
  @JsonKey(name: "supplier_name")
  final String? supplierName;
  @override
  @JsonKey(name: "purchase_code")
  final String? purchaseCode;
  @override
  @JsonKey(name: "reference_no")
  final String? referenceNo;
  @override
  @JsonKey(name: "grand_total")
  final String? grandTotal;
  @override
  @JsonKey(name: "paid_amount")
  final String? paidAmount;
  @override
  @JsonKey(name: "balance")
  final double? balance;
  @override
  @JsonKey(name: "purchase_date")
  final DateTime? purchaseDate;

  /// Create a copy of Datum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DatumCopyWith<_Datum> get copyWith =>
      __$DatumCopyWithImpl<_Datum>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DatumToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Datum &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.purchaseCode, purchaseCode) ||
                other.purchaseCode == purchaseCode) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      storeId,
      storeName,
      supplierId,
      supplierName,
      purchaseCode,
      referenceNo,
      grandTotal,
      paidAmount,
      balance,
      purchaseDate);

  @override
  String toString() {
    return 'Datum(id: $id, storeId: $storeId, storeName: $storeName, supplierId: $supplierId, supplierName: $supplierName, purchaseCode: $purchaseCode, referenceNo: $referenceNo, grandTotal: $grandTotal, paidAmount: $paidAmount, balance: $balance, purchaseDate: $purchaseDate)';
  }
}

/// @nodoc
abstract mixin class _$DatumCopyWith<$Res> implements $DatumCopyWith<$Res> {
  factory _$DatumCopyWith(_Datum value, $Res Function(_Datum) _then) =
      __$DatumCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "store_id") String? storeId,
      @JsonKey(name: "store_name") String? storeName,
      @JsonKey(name: "supplier_id") String? supplierId,
      @JsonKey(name: "supplier_name") String? supplierName,
      @JsonKey(name: "purchase_code") String? purchaseCode,
      @JsonKey(name: "reference_no") String? referenceNo,
      @JsonKey(name: "grand_total") String? grandTotal,
      @JsonKey(name: "paid_amount") String? paidAmount,
      @JsonKey(name: "balance") double? balance,
      @JsonKey(name: "purchase_date") DateTime? purchaseDate});
}

/// @nodoc
class __$DatumCopyWithImpl<$Res> implements _$DatumCopyWith<$Res> {
  __$DatumCopyWithImpl(this._self, this._then);

  final _Datum _self;
  final $Res Function(_Datum) _then;

  /// Create a copy of Datum
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? storeId = freezed,
    Object? storeName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? purchaseCode = freezed,
    Object? referenceNo = freezed,
    Object? grandTotal = freezed,
    Object? paidAmount = freezed,
    Object? balance = freezed,
    Object? purchaseDate = freezed,
  }) {
    return _then(_Datum(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _self.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _self.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseCode: freezed == purchaseCode
          ? _self.purchaseCode
          : purchaseCode // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNo: freezed == referenceNo
          ? _self.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String?,
      grandTotal: freezed == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAmount: freezed == paidAmount
          ? _self.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double?,
      purchaseDate: freezed == purchaseDate
          ? _self.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on

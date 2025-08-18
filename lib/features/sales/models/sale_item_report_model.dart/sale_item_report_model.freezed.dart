// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_item_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleItemReportModel {
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "data")
  List<Datum>? get data;

  /// Create a copy of SaleItemReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SaleItemReportModelCopyWith<SaleItemReportModel> get copyWith =>
      _$SaleItemReportModelCopyWithImpl<SaleItemReportModel>(
          this as SaleItemReportModel, _$identity);

  /// Serializes this SaleItemReportModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SaleItemReportModel &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(data));

  @override
  String toString() {
    return 'SaleItemReportModel(message: $message, data: $data)';
  }
}

/// @nodoc
abstract mixin class $SaleItemReportModelCopyWith<$Res> {
  factory $SaleItemReportModelCopyWith(
          SaleItemReportModel value, $Res Function(SaleItemReportModel) _then) =
      _$SaleItemReportModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data});
}

/// @nodoc
class _$SaleItemReportModelCopyWithImpl<$Res>
    implements $SaleItemReportModelCopyWith<$Res> {
  _$SaleItemReportModelCopyWithImpl(this._self, this._then);

  final SaleItemReportModel _self;
  final $Res Function(SaleItemReportModel) _then;

  /// Create a copy of SaleItemReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [SaleItemReportModel].
extension SaleItemReportModelPatterns on SaleItemReportModel {
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
    TResult Function(_SaleItemReportModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SaleItemReportModel() when $default != null:
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
    TResult Function(_SaleItemReportModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SaleItemReportModel():
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
    TResult? Function(_SaleItemReportModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SaleItemReportModel() when $default != null:
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
    TResult Function(@JsonKey(name: "message") String? message,
            @JsonKey(name: "data") List<Datum>? data)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SaleItemReportModel() when $default != null:
        return $default(_that.message, _that.data);
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
    TResult Function(@JsonKey(name: "message") String? message,
            @JsonKey(name: "data") List<Datum>? data)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SaleItemReportModel():
        return $default(_that.message, _that.data);
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
    TResult? Function(@JsonKey(name: "message") String? message,
            @JsonKey(name: "data") List<Datum>? data)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SaleItemReportModel() when $default != null:
        return $default(_that.message, _that.data);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SaleItemReportModel implements SaleItemReportModel {
  const _SaleItemReportModel(
      {@JsonKey(name: "message") this.message,
      @JsonKey(name: "data") final List<Datum>? data})
      : _data = data;
  factory _SaleItemReportModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemReportModelFromJson(json);

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

  /// Create a copy of SaleItemReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaleItemReportModelCopyWith<_SaleItemReportModel> get copyWith =>
      __$SaleItemReportModelCopyWithImpl<_SaleItemReportModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SaleItemReportModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaleItemReportModel &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(_data));

  @override
  String toString() {
    return 'SaleItemReportModel(message: $message, data: $data)';
  }
}

/// @nodoc
abstract mixin class _$SaleItemReportModelCopyWith<$Res>
    implements $SaleItemReportModelCopyWith<$Res> {
  factory _$SaleItemReportModelCopyWith(_SaleItemReportModel value,
          $Res Function(_SaleItemReportModel) _then) =
      __$SaleItemReportModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data});
}

/// @nodoc
class __$SaleItemReportModelCopyWithImpl<$Res>
    implements _$SaleItemReportModelCopyWith<$Res> {
  __$SaleItemReportModelCopyWithImpl(this._self, this._then);

  final _SaleItemReportModel _self;
  final $Res Function(_SaleItemReportModel) _then;

  /// Create a copy of SaleItemReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(_SaleItemReportModel(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Datum>?,
    ));
  }
}

/// @nodoc
mixin _$Datum {
  @JsonKey(name: "id")
  int? get id;
  @JsonKey(name: "store_name")
  String? get storeName;
  @JsonKey(name: "item_name")
  String? get itemName;
  @JsonKey(name: "sales_id")
  String? get salesId;
  @JsonKey(name: "price_per_unit")
  String? get pricePerUnit;
  @JsonKey(name: "sales_qty")
  String? get salesQty;
  @JsonKey(name: "discount_amt")
  String? get discountAmt;
  @JsonKey(name: "total")
  double? get total;
  @JsonKey(name: "sales_date")
  DateTime? get salesDate;

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
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.salesId, salesId) || other.salesId == salesId) &&
            (identical(other.pricePerUnit, pricePerUnit) ||
                other.pricePerUnit == pricePerUnit) &&
            (identical(other.salesQty, salesQty) ||
                other.salesQty == salesQty) &&
            (identical(other.discountAmt, discountAmt) ||
                other.discountAmt == discountAmt) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.salesDate, salesDate) ||
                other.salesDate == salesDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeName, itemName, salesId,
      pricePerUnit, salesQty, discountAmt, total, salesDate);

  @override
  String toString() {
    return 'Datum(id: $id, storeName: $storeName, itemName: $itemName, salesId: $salesId, pricePerUnit: $pricePerUnit, salesQty: $salesQty, discountAmt: $discountAmt, total: $total, salesDate: $salesDate)';
  }
}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res> {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) =
      _$DatumCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "store_name") String? storeName,
      @JsonKey(name: "item_name") String? itemName,
      @JsonKey(name: "sales_id") String? salesId,
      @JsonKey(name: "price_per_unit") String? pricePerUnit,
      @JsonKey(name: "sales_qty") String? salesQty,
      @JsonKey(name: "discount_amt") String? discountAmt,
      @JsonKey(name: "total") double? total,
      @JsonKey(name: "sales_date") DateTime? salesDate});
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
    Object? storeName = freezed,
    Object? itemName = freezed,
    Object? salesId = freezed,
    Object? pricePerUnit = freezed,
    Object? salesQty = freezed,
    Object? discountAmt = freezed,
    Object? total = freezed,
    Object? salesDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      storeName: freezed == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: freezed == itemName
          ? _self.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String?,
      salesId: freezed == salesId
          ? _self.salesId
          : salesId // ignore: cast_nullable_to_non_nullable
              as String?,
      pricePerUnit: freezed == pricePerUnit
          ? _self.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      salesQty: freezed == salesQty
          ? _self.salesQty
          : salesQty // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmt: freezed == discountAmt
          ? _self.discountAmt
          : discountAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double?,
      salesDate: freezed == salesDate
          ? _self.salesDate
          : salesDate // ignore: cast_nullable_to_non_nullable
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
            @JsonKey(name: "store_name") String? storeName,
            @JsonKey(name: "item_name") String? itemName,
            @JsonKey(name: "sales_id") String? salesId,
            @JsonKey(name: "price_per_unit") String? pricePerUnit,
            @JsonKey(name: "sales_qty") String? salesQty,
            @JsonKey(name: "discount_amt") String? discountAmt,
            @JsonKey(name: "total") double? total,
            @JsonKey(name: "sales_date") DateTime? salesDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.storeName,
            _that.itemName,
            _that.salesId,
            _that.pricePerUnit,
            _that.salesQty,
            _that.discountAmt,
            _that.total,
            _that.salesDate);
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
            @JsonKey(name: "store_name") String? storeName,
            @JsonKey(name: "item_name") String? itemName,
            @JsonKey(name: "sales_id") String? salesId,
            @JsonKey(name: "price_per_unit") String? pricePerUnit,
            @JsonKey(name: "sales_qty") String? salesQty,
            @JsonKey(name: "discount_amt") String? discountAmt,
            @JsonKey(name: "total") double? total,
            @JsonKey(name: "sales_date") DateTime? salesDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum():
        return $default(
            _that.id,
            _that.storeName,
            _that.itemName,
            _that.salesId,
            _that.pricePerUnit,
            _that.salesQty,
            _that.discountAmt,
            _that.total,
            _that.salesDate);
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
            @JsonKey(name: "store_name") String? storeName,
            @JsonKey(name: "item_name") String? itemName,
            @JsonKey(name: "sales_id") String? salesId,
            @JsonKey(name: "price_per_unit") String? pricePerUnit,
            @JsonKey(name: "sales_qty") String? salesQty,
            @JsonKey(name: "discount_amt") String? discountAmt,
            @JsonKey(name: "total") double? total,
            @JsonKey(name: "sales_date") DateTime? salesDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.storeName,
            _that.itemName,
            _that.salesId,
            _that.pricePerUnit,
            _that.salesQty,
            _that.discountAmt,
            _that.total,
            _that.salesDate);
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
      @JsonKey(name: "store_name") this.storeName,
      @JsonKey(name: "item_name") this.itemName,
      @JsonKey(name: "sales_id") this.salesId,
      @JsonKey(name: "price_per_unit") this.pricePerUnit,
      @JsonKey(name: "sales_qty") this.salesQty,
      @JsonKey(name: "discount_amt") this.discountAmt,
      @JsonKey(name: "total") this.total,
      @JsonKey(name: "sales_date") this.salesDate});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "store_name")
  final String? storeName;
  @override
  @JsonKey(name: "item_name")
  final String? itemName;
  @override
  @JsonKey(name: "sales_id")
  final String? salesId;
  @override
  @JsonKey(name: "price_per_unit")
  final String? pricePerUnit;
  @override
  @JsonKey(name: "sales_qty")
  final String? salesQty;
  @override
  @JsonKey(name: "discount_amt")
  final String? discountAmt;
  @override
  @JsonKey(name: "total")
  final double? total;
  @override
  @JsonKey(name: "sales_date")
  final DateTime? salesDate;

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
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.salesId, salesId) || other.salesId == salesId) &&
            (identical(other.pricePerUnit, pricePerUnit) ||
                other.pricePerUnit == pricePerUnit) &&
            (identical(other.salesQty, salesQty) ||
                other.salesQty == salesQty) &&
            (identical(other.discountAmt, discountAmt) ||
                other.discountAmt == discountAmt) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.salesDate, salesDate) ||
                other.salesDate == salesDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeName, itemName, salesId,
      pricePerUnit, salesQty, discountAmt, total, salesDate);

  @override
  String toString() {
    return 'Datum(id: $id, storeName: $storeName, itemName: $itemName, salesId: $salesId, pricePerUnit: $pricePerUnit, salesQty: $salesQty, discountAmt: $discountAmt, total: $total, salesDate: $salesDate)';
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
      @JsonKey(name: "store_name") String? storeName,
      @JsonKey(name: "item_name") String? itemName,
      @JsonKey(name: "sales_id") String? salesId,
      @JsonKey(name: "price_per_unit") String? pricePerUnit,
      @JsonKey(name: "sales_qty") String? salesQty,
      @JsonKey(name: "discount_amt") String? discountAmt,
      @JsonKey(name: "total") double? total,
      @JsonKey(name: "sales_date") DateTime? salesDate});
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
    Object? storeName = freezed,
    Object? itemName = freezed,
    Object? salesId = freezed,
    Object? pricePerUnit = freezed,
    Object? salesQty = freezed,
    Object? discountAmt = freezed,
    Object? total = freezed,
    Object? salesDate = freezed,
  }) {
    return _then(_Datum(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      storeName: freezed == storeName
          ? _self.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      itemName: freezed == itemName
          ? _self.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String?,
      salesId: freezed == salesId
          ? _self.salesId
          : salesId // ignore: cast_nullable_to_non_nullable
              as String?,
      pricePerUnit: freezed == pricePerUnit
          ? _self.pricePerUnit
          : pricePerUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      salesQty: freezed == salesQty
          ? _self.salesQty
          : salesQty // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmt: freezed == discountAmt
          ? _self.discountAmt
          : discountAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      total: freezed == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as double?,
      salesDate: freezed == salesDate
          ? _self.salesDate
          : salesDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on

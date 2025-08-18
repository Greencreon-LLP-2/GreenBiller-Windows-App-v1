// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tax_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaxModel {
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "data")
  List<Datum>? get data;
  @JsonKey(name: "status")
  int? get status;

  /// Create a copy of TaxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaxModelCopyWith<TaxModel> get copyWith =>
      _$TaxModelCopyWithImpl<TaxModel>(this as TaxModel, _$identity);

  /// Serializes this TaxModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaxModel &&
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
    return 'TaxModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class $TaxModelCopyWith<$Res> {
  factory $TaxModelCopyWith(TaxModel value, $Res Function(TaxModel) _then) =
      _$TaxModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class _$TaxModelCopyWithImpl<$Res> implements $TaxModelCopyWith<$Res> {
  _$TaxModelCopyWithImpl(this._self, this._then);

  final TaxModel _self;
  final $Res Function(TaxModel) _then;

  /// Create a copy of TaxModel
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

/// Adds pattern-matching-related methods to [TaxModel].
extension TaxModelPatterns on TaxModel {
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
    TResult Function(_TaxModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaxModel() when $default != null:
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
    TResult Function(_TaxModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaxModel():
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
    TResult? Function(_TaxModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaxModel() when $default != null:
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
      case _TaxModel() when $default != null:
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
      case _TaxModel():
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
      case _TaxModel() when $default != null:
        return $default(_that.message, _that.data, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TaxModel implements TaxModel {
  const _TaxModel(
      {@JsonKey(name: "message") this.message,
      @JsonKey(name: "data") final List<Datum>? data,
      @JsonKey(name: "status") this.status})
      : _data = data;
  factory _TaxModel.fromJson(Map<String, dynamic> json) =>
      _$TaxModelFromJson(json);

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

  /// Create a copy of TaxModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaxModelCopyWith<_TaxModel> get copyWith =>
      __$TaxModelCopyWithImpl<_TaxModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TaxModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaxModel &&
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
    return 'TaxModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$TaxModelCopyWith<$Res>
    implements $TaxModelCopyWith<$Res> {
  factory _$TaxModelCopyWith(_TaxModel value, $Res Function(_TaxModel) _then) =
      __$TaxModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class __$TaxModelCopyWithImpl<$Res> implements _$TaxModelCopyWith<$Res> {
  __$TaxModelCopyWithImpl(this._self, this._then);

  final _TaxModel _self;
  final $Res Function(_TaxModel) _then;

  /// Create a copy of TaxModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_TaxModel(
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
  @JsonKey(name: "tax_name")
  String? get taxName;
  @JsonKey(name: "tax")
  String? get tax;
  @JsonKey(name: "if_group")
  String? get ifGroup;
  @JsonKey(name: "subtax_ids")
  String? get subtaxIds;
  @JsonKey(name: "status")
  String? get status;
  @JsonKey(name: "created_at")
  DateTime? get createdAt;
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt;

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
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.ifGroup, ifGroup) || other.ifGroup == ifGroup) &&
            (identical(other.subtaxIds, subtaxIds) ||
                other.subtaxIds == subtaxIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeId, taxName, tax,
      ifGroup, subtaxIds, status, createdAt, updatedAt);

  @override
  String toString() {
    return 'Datum(id: $id, storeId: $storeId, taxName: $taxName, tax: $tax, ifGroup: $ifGroup, subtaxIds: $subtaxIds, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      @JsonKey(name: "tax_name") String? taxName,
      @JsonKey(name: "tax") String? tax,
      @JsonKey(name: "if_group") String? ifGroup,
      @JsonKey(name: "subtax_ids") String? subtaxIds,
      @JsonKey(name: "status") String? status,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt});
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
    Object? taxName = freezed,
    Object? tax = freezed,
    Object? ifGroup = freezed,
    Object? subtaxIds = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      taxName: freezed == taxName
          ? _self.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      tax: freezed == tax
          ? _self.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as String?,
      ifGroup: freezed == ifGroup
          ? _self.ifGroup
          : ifGroup // ignore: cast_nullable_to_non_nullable
              as String?,
      subtaxIds: freezed == subtaxIds
          ? _self.subtaxIds
          : subtaxIds // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
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
            @JsonKey(name: "tax_name") String? taxName,
            @JsonKey(name: "tax") String? tax,
            @JsonKey(name: "if_group") String? ifGroup,
            @JsonKey(name: "subtax_ids") String? subtaxIds,
            @JsonKey(name: "status") String? status,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.taxName,
            _that.tax,
            _that.ifGroup,
            _that.subtaxIds,
            _that.status,
            _that.createdAt,
            _that.updatedAt);
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
            @JsonKey(name: "tax_name") String? taxName,
            @JsonKey(name: "tax") String? tax,
            @JsonKey(name: "if_group") String? ifGroup,
            @JsonKey(name: "subtax_ids") String? subtaxIds,
            @JsonKey(name: "status") String? status,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum():
        return $default(
            _that.id,
            _that.storeId,
            _that.taxName,
            _that.tax,
            _that.ifGroup,
            _that.subtaxIds,
            _that.status,
            _that.createdAt,
            _that.updatedAt);
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
            @JsonKey(name: "tax_name") String? taxName,
            @JsonKey(name: "tax") String? tax,
            @JsonKey(name: "if_group") String? ifGroup,
            @JsonKey(name: "subtax_ids") String? subtaxIds,
            @JsonKey(name: "status") String? status,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.storeId,
            _that.taxName,
            _that.tax,
            _that.ifGroup,
            _that.subtaxIds,
            _that.status,
            _that.createdAt,
            _that.updatedAt);
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
      @JsonKey(name: "tax_name") this.taxName,
      @JsonKey(name: "tax") this.tax,
      @JsonKey(name: "if_group") this.ifGroup,
      @JsonKey(name: "subtax_ids") this.subtaxIds,
      @JsonKey(name: "status") this.status,
      @JsonKey(name: "created_at") this.createdAt,
      @JsonKey(name: "updated_at") this.updatedAt});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "store_id")
  final String? storeId;
  @override
  @JsonKey(name: "tax_name")
  final String? taxName;
  @override
  @JsonKey(name: "tax")
  final String? tax;
  @override
  @JsonKey(name: "if_group")
  final String? ifGroup;
  @override
  @JsonKey(name: "subtax_ids")
  final String? subtaxIds;
  @override
  @JsonKey(name: "status")
  final String? status;
  @override
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @override
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

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
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.ifGroup, ifGroup) || other.ifGroup == ifGroup) &&
            (identical(other.subtaxIds, subtaxIds) ||
                other.subtaxIds == subtaxIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, storeId, taxName, tax,
      ifGroup, subtaxIds, status, createdAt, updatedAt);

  @override
  String toString() {
    return 'Datum(id: $id, storeId: $storeId, taxName: $taxName, tax: $tax, ifGroup: $ifGroup, subtaxIds: $subtaxIds, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      @JsonKey(name: "tax_name") String? taxName,
      @JsonKey(name: "tax") String? tax,
      @JsonKey(name: "if_group") String? ifGroup,
      @JsonKey(name: "subtax_ids") String? subtaxIds,
      @JsonKey(name: "status") String? status,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt});
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
    Object? taxName = freezed,
    Object? tax = freezed,
    Object? ifGroup = freezed,
    Object? subtaxIds = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      taxName: freezed == taxName
          ? _self.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      tax: freezed == tax
          ? _self.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as String?,
      ifGroup: freezed == ifGroup
          ? _self.ifGroup
          : ifGroup // ignore: cast_nullable_to_non_nullable
              as String?,
      subtaxIds: freezed == subtaxIds
          ? _self.subtaxIds
          : subtaxIds // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on

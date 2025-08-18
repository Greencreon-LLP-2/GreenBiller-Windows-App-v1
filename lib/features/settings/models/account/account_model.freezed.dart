// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountModel {
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "data")
  List<Datum>? get data;
  @JsonKey(name: "status")
  int? get status;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountModelCopyWith<AccountModel> get copyWith =>
      _$AccountModelCopyWithImpl<AccountModel>(
          this as AccountModel, _$identity);

  /// Serializes this AccountModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountModel &&
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
    return 'AccountModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class $AccountModelCopyWith<$Res> {
  factory $AccountModelCopyWith(
          AccountModel value, $Res Function(AccountModel) _then) =
      _$AccountModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class _$AccountModelCopyWithImpl<$Res> implements $AccountModelCopyWith<$Res> {
  _$AccountModelCopyWithImpl(this._self, this._then);

  final AccountModel _self;
  final $Res Function(AccountModel) _then;

  /// Create a copy of AccountModel
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

/// Adds pattern-matching-related methods to [AccountModel].
extension AccountModelPatterns on AccountModel {
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
    TResult Function(_AccountModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountModel() when $default != null:
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
    TResult Function(_AccountModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountModel():
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
    TResult? Function(_AccountModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountModel() when $default != null:
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
      case _AccountModel() when $default != null:
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
      case _AccountModel():
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
      case _AccountModel() when $default != null:
        return $default(_that.message, _that.data, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountModel implements AccountModel {
  const _AccountModel(
      {@JsonKey(name: "message") this.message,
      @JsonKey(name: "data") final List<Datum>? data,
      @JsonKey(name: "status") this.status})
      : _data = data;
  factory _AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

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

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountModelCopyWith<_AccountModel> get copyWith =>
      __$AccountModelCopyWithImpl<_AccountModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountModel &&
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
    return 'AccountModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$AccountModelCopyWith<$Res>
    implements $AccountModelCopyWith<$Res> {
  factory _$AccountModelCopyWith(
          _AccountModel value, $Res Function(_AccountModel) _then) =
      __$AccountModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class __$AccountModelCopyWithImpl<$Res>
    implements _$AccountModelCopyWith<$Res> {
  __$AccountModelCopyWithImpl(this._self, this._then);

  final _AccountModel _self;
  final $Res Function(_AccountModel) _then;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_AccountModel(
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
  @JsonKey(name: "account_name")
  String? get accountName;
  @JsonKey(name: "bank_name")
  String? get bankName;
  @JsonKey(name: "account_number")
  String? get accountNumber;
  @JsonKey(name: "ifsc_code")
  String? get ifscCode;
  @JsonKey(name: "upi_id")
  String? get upiId;
  @JsonKey(name: "balance")
  String? get balance;
  @JsonKey(name: "user_id")
  String? get userId;
  @JsonKey(name: "store_id")
  String? get storeId;
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
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.ifscCode, ifscCode) ||
                other.ifscCode == ifscCode) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountName,
      bankName,
      accountNumber,
      ifscCode,
      upiId,
      balance,
      userId,
      storeId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Datum(id: $id, accountName: $accountName, bankName: $bankName, accountNumber: $accountNumber, ifscCode: $ifscCode, upiId: $upiId, balance: $balance, userId: $userId, storeId: $storeId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $DatumCopyWith<$Res> {
  factory $DatumCopyWith(Datum value, $Res Function(Datum) _then) =
      _$DatumCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "account_name") String? accountName,
      @JsonKey(name: "bank_name") String? bankName,
      @JsonKey(name: "account_number") String? accountNumber,
      @JsonKey(name: "ifsc_code") String? ifscCode,
      @JsonKey(name: "upi_id") String? upiId,
      @JsonKey(name: "balance") String? balance,
      @JsonKey(name: "user_id") String? userId,
      @JsonKey(name: "store_id") String? storeId,
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
    Object? accountName = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? ifscCode = freezed,
    Object? upiId = freezed,
    Object? balance = freezed,
    Object? userId = freezed,
    Object? storeId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      accountName: freezed == accountName
          ? _self.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _self.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      ifscCode: freezed == ifscCode
          ? _self.ifscCode
          : ifscCode // ignore: cast_nullable_to_non_nullable
              as String?,
      upiId: freezed == upiId
          ? _self.upiId
          : upiId // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
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
            @JsonKey(name: "account_name") String? accountName,
            @JsonKey(name: "bank_name") String? bankName,
            @JsonKey(name: "account_number") String? accountNumber,
            @JsonKey(name: "ifsc_code") String? ifscCode,
            @JsonKey(name: "upi_id") String? upiId,
            @JsonKey(name: "balance") String? balance,
            @JsonKey(name: "user_id") String? userId,
            @JsonKey(name: "store_id") String? storeId,
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
            _that.accountName,
            _that.bankName,
            _that.accountNumber,
            _that.ifscCode,
            _that.upiId,
            _that.balance,
            _that.userId,
            _that.storeId,
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
            @JsonKey(name: "account_name") String? accountName,
            @JsonKey(name: "bank_name") String? bankName,
            @JsonKey(name: "account_number") String? accountNumber,
            @JsonKey(name: "ifsc_code") String? ifscCode,
            @JsonKey(name: "upi_id") String? upiId,
            @JsonKey(name: "balance") String? balance,
            @JsonKey(name: "user_id") String? userId,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum():
        return $default(
            _that.id,
            _that.accountName,
            _that.bankName,
            _that.accountNumber,
            _that.ifscCode,
            _that.upiId,
            _that.balance,
            _that.userId,
            _that.storeId,
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
            @JsonKey(name: "account_name") String? accountName,
            @JsonKey(name: "bank_name") String? bankName,
            @JsonKey(name: "account_number") String? accountNumber,
            @JsonKey(name: "ifsc_code") String? ifscCode,
            @JsonKey(name: "upi_id") String? upiId,
            @JsonKey(name: "balance") String? balance,
            @JsonKey(name: "user_id") String? userId,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Datum() when $default != null:
        return $default(
            _that.id,
            _that.accountName,
            _that.bankName,
            _that.accountNumber,
            _that.ifscCode,
            _that.upiId,
            _that.balance,
            _that.userId,
            _that.storeId,
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
      @JsonKey(name: "account_name") this.accountName,
      @JsonKey(name: "bank_name") this.bankName,
      @JsonKey(name: "account_number") this.accountNumber,
      @JsonKey(name: "ifsc_code") this.ifscCode,
      @JsonKey(name: "upi_id") this.upiId,
      @JsonKey(name: "balance") this.balance,
      @JsonKey(name: "user_id") this.userId,
      @JsonKey(name: "store_id") this.storeId,
      @JsonKey(name: "created_at") this.createdAt,
      @JsonKey(name: "updated_at") this.updatedAt});
  factory _Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "account_name")
  final String? accountName;
  @override
  @JsonKey(name: "bank_name")
  final String? bankName;
  @override
  @JsonKey(name: "account_number")
  final String? accountNumber;
  @override
  @JsonKey(name: "ifsc_code")
  final String? ifscCode;
  @override
  @JsonKey(name: "upi_id")
  final String? upiId;
  @override
  @JsonKey(name: "balance")
  final String? balance;
  @override
  @JsonKey(name: "user_id")
  final String? userId;
  @override
  @JsonKey(name: "store_id")
  final String? storeId;
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
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.ifscCode, ifscCode) ||
                other.ifscCode == ifscCode) &&
            (identical(other.upiId, upiId) || other.upiId == upiId) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      accountName,
      bankName,
      accountNumber,
      ifscCode,
      upiId,
      balance,
      userId,
      storeId,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Datum(id: $id, accountName: $accountName, bankName: $bankName, accountNumber: $accountNumber, ifscCode: $ifscCode, upiId: $upiId, balance: $balance, userId: $userId, storeId: $storeId, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      @JsonKey(name: "account_name") String? accountName,
      @JsonKey(name: "bank_name") String? bankName,
      @JsonKey(name: "account_number") String? accountNumber,
      @JsonKey(name: "ifsc_code") String? ifscCode,
      @JsonKey(name: "upi_id") String? upiId,
      @JsonKey(name: "balance") String? balance,
      @JsonKey(name: "user_id") String? userId,
      @JsonKey(name: "store_id") String? storeId,
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
    Object? accountName = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? ifscCode = freezed,
    Object? upiId = freezed,
    Object? balance = freezed,
    Object? userId = freezed,
    Object? storeId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_Datum(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      accountName: freezed == accountName
          ? _self.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _self.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _self.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      ifscCode: freezed == ifscCode
          ? _self.ifscCode
          : ifscCode // ignore: cast_nullable_to_non_nullable
              as String?,
      upiId: freezed == upiId
          ? _self.upiId
          : upiId // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
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

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {
  @JsonKey(name: "status")
  bool? get status;
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "access_token")
  String? get accessToken;
  @JsonKey(name: "data")
  User? get user;
  @JsonKey(name: "redirect_to")
  String? get redirectTo;
  @JsonKey(name: "is_existing_user")
  bool? get isExistingUser;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<UserModel> get copyWith =>
      _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.redirectTo, redirectTo) ||
                other.redirectTo == redirectTo) &&
            (identical(other.isExistingUser, isExistingUser) ||
                other.isExistingUser == isExistingUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, accessToken,
      user, redirectTo, isExistingUser);

  @override
  String toString() {
    return 'UserModel(status: $status, message: $message, accessToken: $accessToken, user: $user, redirectTo: $redirectTo, isExistingUser: $isExistingUser)';
  }
}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) =
      _$UserModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "status") bool? status,
      @JsonKey(name: "message") String? message,
      @JsonKey(name: "access_token") String? accessToken,
      @JsonKey(name: "data") User? user,
      @JsonKey(name: "redirect_to") String? redirectTo,
      @JsonKey(name: "is_existing_user") bool? isExistingUser});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? message = freezed,
    Object? accessToken = freezed,
    Object? user = freezed,
    Object? redirectTo = freezed,
    Object? isExistingUser = freezed,
  }) {
    return _then(_self.copyWith(
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      redirectTo: freezed == redirectTo
          ? _self.redirectTo
          : redirectTo // ignore: cast_nullable_to_non_nullable
              as String?,
      isExistingUser: freezed == isExistingUser
          ? _self.isExistingUser
          : isExistingUser // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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
    TResult Function(_UserModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserModel() when $default != null:
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
    TResult Function(_UserModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserModel():
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
    TResult? Function(_UserModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserModel() when $default != null:
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
            @JsonKey(name: "status") bool? status,
            @JsonKey(name: "message") String? message,
            @JsonKey(name: "access_token") String? accessToken,
            @JsonKey(name: "data") User? user,
            @JsonKey(name: "redirect_to") String? redirectTo,
            @JsonKey(name: "is_existing_user") bool? isExistingUser)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserModel() when $default != null:
        return $default(_that.status, _that.message, _that.accessToken,
            _that.user, _that.redirectTo, _that.isExistingUser);
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
            @JsonKey(name: "status") bool? status,
            @JsonKey(name: "message") String? message,
            @JsonKey(name: "access_token") String? accessToken,
            @JsonKey(name: "data") User? user,
            @JsonKey(name: "redirect_to") String? redirectTo,
            @JsonKey(name: "is_existing_user") bool? isExistingUser)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserModel():
        return $default(_that.status, _that.message, _that.accessToken,
            _that.user, _that.redirectTo, _that.isExistingUser);
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
            @JsonKey(name: "status") bool? status,
            @JsonKey(name: "message") String? message,
            @JsonKey(name: "access_token") String? accessToken,
            @JsonKey(name: "data") User? user,
            @JsonKey(name: "redirect_to") String? redirectTo,
            @JsonKey(name: "is_existing_user") bool? isExistingUser)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserModel() when $default != null:
        return $default(_that.status, _that.message, _that.accessToken,
            _that.user, _that.redirectTo, _that.isExistingUser);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserModel implements UserModel {
  const _UserModel(
      {@JsonKey(name: "status") this.status,
      @JsonKey(name: "message") this.message,
      @JsonKey(name: "access_token") this.accessToken,
      @JsonKey(name: "data") this.user,
      @JsonKey(name: "redirect_to") this.redirectTo,
      @JsonKey(name: "is_existing_user") this.isExistingUser});
  factory _UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  @JsonKey(name: "status")
  final bool? status;
  @override
  @JsonKey(name: "message")
  final String? message;
  @override
  @JsonKey(name: "access_token")
  final String? accessToken;
  @override
  @JsonKey(name: "data")
  final User? user;
  @override
  @JsonKey(name: "redirect_to")
  final String? redirectTo;
  @override
  @JsonKey(name: "is_existing_user")
  final bool? isExistingUser;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserModelCopyWith<_UserModel> get copyWith =>
      __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.redirectTo, redirectTo) ||
                other.redirectTo == redirectTo) &&
            (identical(other.isExistingUser, isExistingUser) ||
                other.isExistingUser == isExistingUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, message, accessToken,
      user, redirectTo, isExistingUser);

  @override
  String toString() {
    return 'UserModel(status: $status, message: $message, accessToken: $accessToken, user: $user, redirectTo: $redirectTo, isExistingUser: $isExistingUser)';
  }
}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(
          _UserModel value, $Res Function(_UserModel) _then) =
      __$UserModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "status") bool? status,
      @JsonKey(name: "message") String? message,
      @JsonKey(name: "access_token") String? accessToken,
      @JsonKey(name: "data") User? user,
      @JsonKey(name: "redirect_to") String? redirectTo,
      @JsonKey(name: "is_existing_user") bool? isExistingUser});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$UserModelCopyWithImpl<$Res> implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = freezed,
    Object? message = freezed,
    Object? accessToken = freezed,
    Object? user = freezed,
    Object? redirectTo = freezed,
    Object? isExistingUser = freezed,
  }) {
    return _then(_UserModel(
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      redirectTo: freezed == redirectTo
          ? _self.redirectTo
          : redirectTo // ignore: cast_nullable_to_non_nullable
              as String?,
      isExistingUser: freezed == isExistingUser
          ? _self.isExistingUser
          : isExistingUser // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
mixin _$User {
  @JsonKey(name: "id")
  int? get id;
  @JsonKey(name: "user_level")
  String? get userLevel;
  @JsonKey(name: "store_id")
  String? get storeId;
  @JsonKey(name: "name")
  String? get name;
  @JsonKey(name: "email")
  String? get email;
  @JsonKey(name: "country_code")
  String? get countryCode;
  @JsonKey(name: "mobile")
  String? get mobile;
  @JsonKey(name: "whatsapp_no")
  dynamic get whatsappNo;
  @JsonKey(name: "user_card")
  dynamic get userCard;
  @JsonKey(name: "profile_image")
  dynamic get profileImage;
  @JsonKey(name: "dob")
  dynamic get dob;
  @JsonKey(name: "count_id")
  dynamic get countId;
  @JsonKey(name: "employee_code")
  dynamic get employeeCode;
  @JsonKey(name: "warehouse_id")
  dynamic get warehouseId;
  @JsonKey(name: "current_latitude")
  dynamic get currentLatitude;
  @JsonKey(name: "current_longitude")
  dynamic get currentLongitude;
  @JsonKey(name: "zone")
  dynamic get zone;
  @JsonKey(name: "otp")
  dynamic get otp;
  @JsonKey(name: "mobile_verify")
  dynamic get mobileVerify;
  @JsonKey(name: "email_verify")
  dynamic get emailVerify;
  @JsonKey(name: "status")
  dynamic get status;
  @JsonKey(name: "ban")
  dynamic get ban;
  @JsonKey(name: "created_by")
  dynamic get createdBy;
  @JsonKey(name: "subcription_id")
  dynamic get subcriptionId;
  @JsonKey(name: "created_at")
  DateTime? get createdAt;
  @JsonKey(name: "updated_at")
  DateTime? get updatedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserCopyWith<User> get copyWith =>
      _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is User &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userLevel, userLevel) ||
                other.userLevel == userLevel) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            const DeepCollectionEquality()
                .equals(other.whatsappNo, whatsappNo) &&
            const DeepCollectionEquality().equals(other.userCard, userCard) &&
            const DeepCollectionEquality()
                .equals(other.profileImage, profileImage) &&
            const DeepCollectionEquality().equals(other.dob, dob) &&
            const DeepCollectionEquality().equals(other.countId, countId) &&
            const DeepCollectionEquality()
                .equals(other.employeeCode, employeeCode) &&
            const DeepCollectionEquality()
                .equals(other.warehouseId, warehouseId) &&
            const DeepCollectionEquality()
                .equals(other.currentLatitude, currentLatitude) &&
            const DeepCollectionEquality()
                .equals(other.currentLongitude, currentLongitude) &&
            const DeepCollectionEquality().equals(other.zone, zone) &&
            const DeepCollectionEquality().equals(other.otp, otp) &&
            const DeepCollectionEquality()
                .equals(other.mobileVerify, mobileVerify) &&
            const DeepCollectionEquality()
                .equals(other.emailVerify, emailVerify) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.ban, ban) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
            const DeepCollectionEquality()
                .equals(other.subcriptionId, subcriptionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userLevel,
        storeId,
        name,
        email,
        countryCode,
        mobile,
        const DeepCollectionEquality().hash(whatsappNo),
        const DeepCollectionEquality().hash(userCard),
        const DeepCollectionEquality().hash(profileImage),
        const DeepCollectionEquality().hash(dob),
        const DeepCollectionEquality().hash(countId),
        const DeepCollectionEquality().hash(employeeCode),
        const DeepCollectionEquality().hash(warehouseId),
        const DeepCollectionEquality().hash(currentLatitude),
        const DeepCollectionEquality().hash(currentLongitude),
        const DeepCollectionEquality().hash(zone),
        const DeepCollectionEquality().hash(otp),
        const DeepCollectionEquality().hash(mobileVerify),
        const DeepCollectionEquality().hash(emailVerify),
        const DeepCollectionEquality().hash(status),
        const DeepCollectionEquality().hash(ban),
        const DeepCollectionEquality().hash(createdBy),
        const DeepCollectionEquality().hash(subcriptionId),
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'User(id: $id, userLevel: $userLevel, storeId: $storeId, name: $name, email: $email, countryCode: $countryCode, mobile: $mobile, whatsappNo: $whatsappNo, userCard: $userCard, profileImage: $profileImage, dob: $dob, countId: $countId, employeeCode: $employeeCode, warehouseId: $warehouseId, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, zone: $zone, otp: $otp, mobileVerify: $mobileVerify, emailVerify: $emailVerify, status: $status, ban: $ban, createdBy: $createdBy, subcriptionId: $subcriptionId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) _then) =
      _$UserCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "user_level") String? userLevel,
      @JsonKey(name: "store_id") String? storeId,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "country_code") String? countryCode,
      @JsonKey(name: "mobile") String? mobile,
      @JsonKey(name: "whatsapp_no") dynamic whatsappNo,
      @JsonKey(name: "user_card") dynamic userCard,
      @JsonKey(name: "profile_image") dynamic profileImage,
      @JsonKey(name: "dob") dynamic dob,
      @JsonKey(name: "count_id") dynamic countId,
      @JsonKey(name: "employee_code") dynamic employeeCode,
      @JsonKey(name: "warehouse_id") dynamic warehouseId,
      @JsonKey(name: "current_latitude") dynamic currentLatitude,
      @JsonKey(name: "current_longitude") dynamic currentLongitude,
      @JsonKey(name: "zone") dynamic zone,
      @JsonKey(name: "otp") dynamic otp,
      @JsonKey(name: "mobile_verify") dynamic mobileVerify,
      @JsonKey(name: "email_verify") dynamic emailVerify,
      @JsonKey(name: "status") dynamic status,
      @JsonKey(name: "ban") dynamic ban,
      @JsonKey(name: "created_by") dynamic createdBy,
      @JsonKey(name: "subcription_id") dynamic subcriptionId,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userLevel = freezed,
    Object? storeId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? countryCode = freezed,
    Object? mobile = freezed,
    Object? whatsappNo = freezed,
    Object? userCard = freezed,
    Object? profileImage = freezed,
    Object? dob = freezed,
    Object? countId = freezed,
    Object? employeeCode = freezed,
    Object? warehouseId = freezed,
    Object? currentLatitude = freezed,
    Object? currentLongitude = freezed,
    Object? zone = freezed,
    Object? otp = freezed,
    Object? mobileVerify = freezed,
    Object? emailVerify = freezed,
    Object? status = freezed,
    Object? ban = freezed,
    Object? createdBy = freezed,
    Object? subcriptionId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userLevel: freezed == userLevel
          ? _self.userLevel
          : userLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _self.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNo: freezed == whatsappNo
          ? _self.whatsappNo
          : whatsappNo // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userCard: freezed == userCard
          ? _self.userCard
          : userCard // ignore: cast_nullable_to_non_nullable
              as dynamic,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      dob: freezed == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as dynamic,
      countId: freezed == countId
          ? _self.countId
          : countId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      employeeCode: freezed == employeeCode
          ? _self.employeeCode
          : employeeCode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      warehouseId: freezed == warehouseId
          ? _self.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currentLatitude: freezed == currentLatitude
          ? _self.currentLatitude
          : currentLatitude // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currentLongitude: freezed == currentLongitude
          ? _self.currentLongitude
          : currentLongitude // ignore: cast_nullable_to_non_nullable
              as dynamic,
      zone: freezed == zone
          ? _self.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as dynamic,
      otp: freezed == otp
          ? _self.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mobileVerify: freezed == mobileVerify
          ? _self.mobileVerify
          : mobileVerify // ignore: cast_nullable_to_non_nullable
              as dynamic,
      emailVerify: freezed == emailVerify
          ? _self.emailVerify
          : emailVerify // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      ban: freezed == ban
          ? _self.ban
          : ban // ignore: cast_nullable_to_non_nullable
              as dynamic,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as dynamic,
      subcriptionId: freezed == subcriptionId
          ? _self.subcriptionId
          : subcriptionId // ignore: cast_nullable_to_non_nullable
              as dynamic,
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

/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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
    TResult Function(_User value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _User() when $default != null:
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
    TResult Function(_User value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _User():
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
    TResult? Function(_User value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _User() when $default != null:
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
            @JsonKey(name: "user_level") String? userLevel,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "name") String? name,
            @JsonKey(name: "email") String? email,
            @JsonKey(name: "country_code") String? countryCode,
            @JsonKey(name: "mobile") String? mobile,
            @JsonKey(name: "whatsapp_no") dynamic whatsappNo,
            @JsonKey(name: "user_card") dynamic userCard,
            @JsonKey(name: "profile_image") dynamic profileImage,
            @JsonKey(name: "dob") dynamic dob,
            @JsonKey(name: "count_id") dynamic countId,
            @JsonKey(name: "employee_code") dynamic employeeCode,
            @JsonKey(name: "warehouse_id") dynamic warehouseId,
            @JsonKey(name: "current_latitude") dynamic currentLatitude,
            @JsonKey(name: "current_longitude") dynamic currentLongitude,
            @JsonKey(name: "zone") dynamic zone,
            @JsonKey(name: "otp") dynamic otp,
            @JsonKey(name: "mobile_verify") dynamic mobileVerify,
            @JsonKey(name: "email_verify") dynamic emailVerify,
            @JsonKey(name: "status") dynamic status,
            @JsonKey(name: "ban") dynamic ban,
            @JsonKey(name: "created_by") dynamic createdBy,
            @JsonKey(name: "subcription_id") dynamic subcriptionId,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _User() when $default != null:
        return $default(
            _that.id,
            _that.userLevel,
            _that.storeId,
            _that.name,
            _that.email,
            _that.countryCode,
            _that.mobile,
            _that.whatsappNo,
            _that.userCard,
            _that.profileImage,
            _that.dob,
            _that.countId,
            _that.employeeCode,
            _that.warehouseId,
            _that.currentLatitude,
            _that.currentLongitude,
            _that.zone,
            _that.otp,
            _that.mobileVerify,
            _that.emailVerify,
            _that.status,
            _that.ban,
            _that.createdBy,
            _that.subcriptionId,
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
            @JsonKey(name: "user_level") String? userLevel,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "name") String? name,
            @JsonKey(name: "email") String? email,
            @JsonKey(name: "country_code") String? countryCode,
            @JsonKey(name: "mobile") String? mobile,
            @JsonKey(name: "whatsapp_no") dynamic whatsappNo,
            @JsonKey(name: "user_card") dynamic userCard,
            @JsonKey(name: "profile_image") dynamic profileImage,
            @JsonKey(name: "dob") dynamic dob,
            @JsonKey(name: "count_id") dynamic countId,
            @JsonKey(name: "employee_code") dynamic employeeCode,
            @JsonKey(name: "warehouse_id") dynamic warehouseId,
            @JsonKey(name: "current_latitude") dynamic currentLatitude,
            @JsonKey(name: "current_longitude") dynamic currentLongitude,
            @JsonKey(name: "zone") dynamic zone,
            @JsonKey(name: "otp") dynamic otp,
            @JsonKey(name: "mobile_verify") dynamic mobileVerify,
            @JsonKey(name: "email_verify") dynamic emailVerify,
            @JsonKey(name: "status") dynamic status,
            @JsonKey(name: "ban") dynamic ban,
            @JsonKey(name: "created_by") dynamic createdBy,
            @JsonKey(name: "subcription_id") dynamic subcriptionId,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _User():
        return $default(
            _that.id,
            _that.userLevel,
            _that.storeId,
            _that.name,
            _that.email,
            _that.countryCode,
            _that.mobile,
            _that.whatsappNo,
            _that.userCard,
            _that.profileImage,
            _that.dob,
            _that.countId,
            _that.employeeCode,
            _that.warehouseId,
            _that.currentLatitude,
            _that.currentLongitude,
            _that.zone,
            _that.otp,
            _that.mobileVerify,
            _that.emailVerify,
            _that.status,
            _that.ban,
            _that.createdBy,
            _that.subcriptionId,
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
            @JsonKey(name: "user_level") String? userLevel,
            @JsonKey(name: "store_id") String? storeId,
            @JsonKey(name: "name") String? name,
            @JsonKey(name: "email") String? email,
            @JsonKey(name: "country_code") String? countryCode,
            @JsonKey(name: "mobile") String? mobile,
            @JsonKey(name: "whatsapp_no") dynamic whatsappNo,
            @JsonKey(name: "user_card") dynamic userCard,
            @JsonKey(name: "profile_image") dynamic profileImage,
            @JsonKey(name: "dob") dynamic dob,
            @JsonKey(name: "count_id") dynamic countId,
            @JsonKey(name: "employee_code") dynamic employeeCode,
            @JsonKey(name: "warehouse_id") dynamic warehouseId,
            @JsonKey(name: "current_latitude") dynamic currentLatitude,
            @JsonKey(name: "current_longitude") dynamic currentLongitude,
            @JsonKey(name: "zone") dynamic zone,
            @JsonKey(name: "otp") dynamic otp,
            @JsonKey(name: "mobile_verify") dynamic mobileVerify,
            @JsonKey(name: "email_verify") dynamic emailVerify,
            @JsonKey(name: "status") dynamic status,
            @JsonKey(name: "ban") dynamic ban,
            @JsonKey(name: "created_by") dynamic createdBy,
            @JsonKey(name: "subcription_id") dynamic subcriptionId,
            @JsonKey(name: "created_at") DateTime? createdAt,
            @JsonKey(name: "updated_at") DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _User() when $default != null:
        return $default(
            _that.id,
            _that.userLevel,
            _that.storeId,
            _that.name,
            _that.email,
            _that.countryCode,
            _that.mobile,
            _that.whatsappNo,
            _that.userCard,
            _that.profileImage,
            _that.dob,
            _that.countId,
            _that.employeeCode,
            _that.warehouseId,
            _that.currentLatitude,
            _that.currentLongitude,
            _that.zone,
            _that.otp,
            _that.mobileVerify,
            _that.emailVerify,
            _that.status,
            _that.ban,
            _that.createdBy,
            _that.subcriptionId,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _User implements User {
  const _User(
      {@JsonKey(name: "id") this.id,
      @JsonKey(name: "user_level") this.userLevel,
      @JsonKey(name: "store_id") this.storeId,
      @JsonKey(name: "name") this.name,
      @JsonKey(name: "email") this.email,
      @JsonKey(name: "country_code") this.countryCode,
      @JsonKey(name: "mobile") this.mobile,
      @JsonKey(name: "whatsapp_no") this.whatsappNo,
      @JsonKey(name: "user_card") this.userCard,
      @JsonKey(name: "profile_image") this.profileImage,
      @JsonKey(name: "dob") this.dob,
      @JsonKey(name: "count_id") this.countId,
      @JsonKey(name: "employee_code") this.employeeCode,
      @JsonKey(name: "warehouse_id") this.warehouseId,
      @JsonKey(name: "current_latitude") this.currentLatitude,
      @JsonKey(name: "current_longitude") this.currentLongitude,
      @JsonKey(name: "zone") this.zone,
      @JsonKey(name: "otp") this.otp,
      @JsonKey(name: "mobile_verify") this.mobileVerify,
      @JsonKey(name: "email_verify") this.emailVerify,
      @JsonKey(name: "status") this.status,
      @JsonKey(name: "ban") this.ban,
      @JsonKey(name: "created_by") this.createdBy,
      @JsonKey(name: "subcription_id") this.subcriptionId,
      @JsonKey(name: "created_at") this.createdAt,
      @JsonKey(name: "updated_at") this.updatedAt});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  @JsonKey(name: "id")
  final int? id;
  @override
  @JsonKey(name: "user_level")
  final String? userLevel;
  @override
  @JsonKey(name: "store_id")
  final String? storeId;
  @override
  @JsonKey(name: "name")
  final String? name;
  @override
  @JsonKey(name: "email")
  final String? email;
  @override
  @JsonKey(name: "country_code")
  final String? countryCode;
  @override
  @JsonKey(name: "mobile")
  final String? mobile;
  @override
  @JsonKey(name: "whatsapp_no")
  final dynamic whatsappNo;
  @override
  @JsonKey(name: "user_card")
  final dynamic userCard;
  @override
  @JsonKey(name: "profile_image")
  final dynamic profileImage;
  @override
  @JsonKey(name: "dob")
  final dynamic dob;
  @override
  @JsonKey(name: "count_id")
  final dynamic countId;
  @override
  @JsonKey(name: "employee_code")
  final dynamic employeeCode;
  @override
  @JsonKey(name: "warehouse_id")
  final dynamic warehouseId;
  @override
  @JsonKey(name: "current_latitude")
  final dynamic currentLatitude;
  @override
  @JsonKey(name: "current_longitude")
  final dynamic currentLongitude;
  @override
  @JsonKey(name: "zone")
  final dynamic zone;
  @override
  @JsonKey(name: "otp")
  final dynamic otp;
  @override
  @JsonKey(name: "mobile_verify")
  final dynamic mobileVerify;
  @override
  @JsonKey(name: "email_verify")
  final dynamic emailVerify;
  @override
  @JsonKey(name: "status")
  final dynamic status;
  @override
  @JsonKey(name: "ban")
  final dynamic ban;
  @override
  @JsonKey(name: "created_by")
  final dynamic createdBy;
  @override
  @JsonKey(name: "subcription_id")
  final dynamic subcriptionId;
  @override
  @JsonKey(name: "created_at")
  final DateTime? createdAt;
  @override
  @JsonKey(name: "updated_at")
  final DateTime? updatedAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _User &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userLevel, userLevel) ||
                other.userLevel == userLevel) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            const DeepCollectionEquality()
                .equals(other.whatsappNo, whatsappNo) &&
            const DeepCollectionEquality().equals(other.userCard, userCard) &&
            const DeepCollectionEquality()
                .equals(other.profileImage, profileImage) &&
            const DeepCollectionEquality().equals(other.dob, dob) &&
            const DeepCollectionEquality().equals(other.countId, countId) &&
            const DeepCollectionEquality()
                .equals(other.employeeCode, employeeCode) &&
            const DeepCollectionEquality()
                .equals(other.warehouseId, warehouseId) &&
            const DeepCollectionEquality()
                .equals(other.currentLatitude, currentLatitude) &&
            const DeepCollectionEquality()
                .equals(other.currentLongitude, currentLongitude) &&
            const DeepCollectionEquality().equals(other.zone, zone) &&
            const DeepCollectionEquality().equals(other.otp, otp) &&
            const DeepCollectionEquality()
                .equals(other.mobileVerify, mobileVerify) &&
            const DeepCollectionEquality()
                .equals(other.emailVerify, emailVerify) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.ban, ban) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
            const DeepCollectionEquality()
                .equals(other.subcriptionId, subcriptionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userLevel,
        storeId,
        name,
        email,
        countryCode,
        mobile,
        const DeepCollectionEquality().hash(whatsappNo),
        const DeepCollectionEquality().hash(userCard),
        const DeepCollectionEquality().hash(profileImage),
        const DeepCollectionEquality().hash(dob),
        const DeepCollectionEquality().hash(countId),
        const DeepCollectionEquality().hash(employeeCode),
        const DeepCollectionEquality().hash(warehouseId),
        const DeepCollectionEquality().hash(currentLatitude),
        const DeepCollectionEquality().hash(currentLongitude),
        const DeepCollectionEquality().hash(zone),
        const DeepCollectionEquality().hash(otp),
        const DeepCollectionEquality().hash(mobileVerify),
        const DeepCollectionEquality().hash(emailVerify),
        const DeepCollectionEquality().hash(status),
        const DeepCollectionEquality().hash(ban),
        const DeepCollectionEquality().hash(createdBy),
        const DeepCollectionEquality().hash(subcriptionId),
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'User(id: $id, userLevel: $userLevel, storeId: $storeId, name: $name, email: $email, countryCode: $countryCode, mobile: $mobile, whatsappNo: $whatsappNo, userCard: $userCard, profileImage: $profileImage, dob: $dob, countId: $countId, employeeCode: $employeeCode, warehouseId: $warehouseId, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, zone: $zone, otp: $otp, mobileVerify: $mobileVerify, emailVerify: $emailVerify, status: $status, ban: $ban, createdBy: $createdBy, subcriptionId: $subcriptionId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) =
      __$UserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "id") int? id,
      @JsonKey(name: "user_level") String? userLevel,
      @JsonKey(name: "store_id") String? storeId,
      @JsonKey(name: "name") String? name,
      @JsonKey(name: "email") String? email,
      @JsonKey(name: "country_code") String? countryCode,
      @JsonKey(name: "mobile") String? mobile,
      @JsonKey(name: "whatsapp_no") dynamic whatsappNo,
      @JsonKey(name: "user_card") dynamic userCard,
      @JsonKey(name: "profile_image") dynamic profileImage,
      @JsonKey(name: "dob") dynamic dob,
      @JsonKey(name: "count_id") dynamic countId,
      @JsonKey(name: "employee_code") dynamic employeeCode,
      @JsonKey(name: "warehouse_id") dynamic warehouseId,
      @JsonKey(name: "current_latitude") dynamic currentLatitude,
      @JsonKey(name: "current_longitude") dynamic currentLongitude,
      @JsonKey(name: "zone") dynamic zone,
      @JsonKey(name: "otp") dynamic otp,
      @JsonKey(name: "mobile_verify") dynamic mobileVerify,
      @JsonKey(name: "email_verify") dynamic emailVerify,
      @JsonKey(name: "status") dynamic status,
      @JsonKey(name: "ban") dynamic ban,
      @JsonKey(name: "created_by") dynamic createdBy,
      @JsonKey(name: "subcription_id") dynamic subcriptionId,
      @JsonKey(name: "created_at") DateTime? createdAt,
      @JsonKey(name: "updated_at") DateTime? updatedAt});
}

/// @nodoc
class __$UserCopyWithImpl<$Res> implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? userLevel = freezed,
    Object? storeId = freezed,
    Object? name = freezed,
    Object? email = freezed,
    Object? countryCode = freezed,
    Object? mobile = freezed,
    Object? whatsappNo = freezed,
    Object? userCard = freezed,
    Object? profileImage = freezed,
    Object? dob = freezed,
    Object? countId = freezed,
    Object? employeeCode = freezed,
    Object? warehouseId = freezed,
    Object? currentLatitude = freezed,
    Object? currentLongitude = freezed,
    Object? zone = freezed,
    Object? otp = freezed,
    Object? mobileVerify = freezed,
    Object? emailVerify = freezed,
    Object? status = freezed,
    Object? ban = freezed,
    Object? createdBy = freezed,
    Object? subcriptionId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_User(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userLevel: freezed == userLevel
          ? _self.userLevel
          : userLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      storeId: freezed == storeId
          ? _self.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
      mobile: freezed == mobile
          ? _self.mobile
          : mobile // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNo: freezed == whatsappNo
          ? _self.whatsappNo
          : whatsappNo // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userCard: freezed == userCard
          ? _self.userCard
          : userCard // ignore: cast_nullable_to_non_nullable
              as dynamic,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as dynamic,
      dob: freezed == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as dynamic,
      countId: freezed == countId
          ? _self.countId
          : countId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      employeeCode: freezed == employeeCode
          ? _self.employeeCode
          : employeeCode // ignore: cast_nullable_to_non_nullable
              as dynamic,
      warehouseId: freezed == warehouseId
          ? _self.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currentLatitude: freezed == currentLatitude
          ? _self.currentLatitude
          : currentLatitude // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currentLongitude: freezed == currentLongitude
          ? _self.currentLongitude
          : currentLongitude // ignore: cast_nullable_to_non_nullable
              as dynamic,
      zone: freezed == zone
          ? _self.zone
          : zone // ignore: cast_nullable_to_non_nullable
              as dynamic,
      otp: freezed == otp
          ? _self.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as dynamic,
      mobileVerify: freezed == mobileVerify
          ? _self.mobileVerify
          : mobileVerify // ignore: cast_nullable_to_non_nullable
              as dynamic,
      emailVerify: freezed == emailVerify
          ? _self.emailVerify
          : emailVerify // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      ban: freezed == ban
          ? _self.ban
          : ban // ignore: cast_nullable_to_non_nullable
              as dynamic,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as dynamic,
      subcriptionId: freezed == subcriptionId
          ? _self.subcriptionId
          : subcriptionId // ignore: cast_nullable_to_non_nullable
              as dynamic,
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

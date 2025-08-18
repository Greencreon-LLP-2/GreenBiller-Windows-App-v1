// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesViewModel {
  @JsonKey(name: "message")
  String? get message;
  @JsonKey(name: "data")
  List<Datum>? get data;
  @JsonKey(name: "status")
  int? get status;

  /// Create a copy of SalesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SalesViewModelCopyWith<SalesViewModel> get copyWith =>
      _$SalesViewModelCopyWithImpl<SalesViewModel>(
          this as SalesViewModel, _$identity);

  /// Serializes this SalesViewModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SalesViewModel &&
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
    return 'SalesViewModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class $SalesViewModelCopyWith<$Res> {
  factory $SalesViewModelCopyWith(
          SalesViewModel value, $Res Function(SalesViewModel) _then) =
      _$SalesViewModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class _$SalesViewModelCopyWithImpl<$Res>
    implements $SalesViewModelCopyWith<$Res> {
  _$SalesViewModelCopyWithImpl(this._self, this._then);

  final SalesViewModel _self;
  final $Res Function(SalesViewModel) _then;

  /// Create a copy of SalesViewModel
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

/// Adds pattern-matching-related methods to [SalesViewModel].
extension SalesViewModelPatterns on SalesViewModel {
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
    TResult Function(_SalesViewModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SalesViewModel() when $default != null:
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
    TResult Function(_SalesViewModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SalesViewModel():
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
    TResult? Function(_SalesViewModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SalesViewModel() when $default != null:
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
      case _SalesViewModel() when $default != null:
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
      case _SalesViewModel():
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
      case _SalesViewModel() when $default != null:
        return $default(_that.message, _that.data, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SalesViewModel implements SalesViewModel {
  const _SalesViewModel(
      {@JsonKey(name: "message") this.message,
      @JsonKey(name: "data") final List<Datum>? data,
      @JsonKey(name: "status") this.status})
      : _data = data;
  factory _SalesViewModel.fromJson(Map<String, dynamic> json) =>
      _$SalesViewModelFromJson(json);

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

  /// Create a copy of SalesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SalesViewModelCopyWith<_SalesViewModel> get copyWith =>
      __$SalesViewModelCopyWithImpl<_SalesViewModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SalesViewModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SalesViewModel &&
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
    return 'SalesViewModel(message: $message, data: $data, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$SalesViewModelCopyWith<$Res>
    implements $SalesViewModelCopyWith<$Res> {
  factory _$SalesViewModelCopyWith(
          _SalesViewModel value, $Res Function(_SalesViewModel) _then) =
      __$SalesViewModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "message") String? message,
      @JsonKey(name: "data") List<Datum>? data,
      @JsonKey(name: "status") int? status});
}

/// @nodoc
class __$SalesViewModelCopyWithImpl<$Res>
    implements _$SalesViewModelCopyWith<$Res> {
  __$SalesViewModelCopyWithImpl(this._self, this._then);

  final _SalesViewModel _self;
  final $Res Function(_SalesViewModel) _then;

  /// Create a copy of SalesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_SalesViewModel(
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
  @JsonKey(name: "warehouse_id")
  String? get warehouseId;
  @JsonKey(name: "init_code")
  String? get initCode;
  @JsonKey(name: "count_id")
  String? get countId;
  @JsonKey(name: "sales_code")
  String? get salesCode;
  @JsonKey(name: "reference_no")
  String? get referenceNo;
  @JsonKey(name: "sales_date")
  String? get salesDate;
  @JsonKey(name: "due_date")
  String? get dueDate;
  @JsonKey(name: "sales_status")
  String? get salesStatus;
  @JsonKey(name: "customer_id")
  String? get customerId;
  @JsonKey(name: "other_charges_input")
  String? get otherChargesInput;
  @JsonKey(name: "other_charges_tax_id")
  String? get otherChargesTaxId;
  @JsonKey(name: "other_charges_amt")
  String? get otherChargesAmt;
  @JsonKey(name: "discount_to_all_input")
  dynamic get discountToAllInput;
  @JsonKey(name: "discount_to_all_type")
  dynamic get discountToAllType;
  @JsonKey(name: "tot_discount_to_all_amt")
  String? get totDiscountToAllAmt;
  @JsonKey(name: "subtotal")
  String? get subtotal;
  @JsonKey(name: "round_off")
  String? get roundOff;
  @JsonKey(name: "grand_total")
  String? get grandTotal;
  @JsonKey(name: "sales_note")
  String? get salesNote;
  @JsonKey(name: "payment_status")
  String? get paymentStatus;
  @JsonKey(name: "paid_amount")
  String? get paidAmount;
  @JsonKey(name: "company_id")
  String? get companyId;
  @JsonKey(name: "pos")
  String? get pos;
  @JsonKey(name: "return_bit")
  dynamic get returnBit;
  @JsonKey(name: "customer_previous_due")
  dynamic get customerPreviousDue;
  @JsonKey(name: "customer_total_due")
  dynamic get customerTotalDue;
  @JsonKey(name: "quotation_id")
  dynamic get quotationId;
  @JsonKey(name: "coupon_id")
  dynamic get couponId;
  @JsonKey(name: "coupon_amt")
  dynamic get couponAmt;
  @JsonKey(name: "invoice_terms")
  dynamic get invoiceTerms;
  @JsonKey(name: "status")
  String? get status;
  @JsonKey(name: "app_order")
  String? get appOrder;
  @JsonKey(name: "order_id")
  String? get orderId;
  @JsonKey(name: "tax_report")
  String? get taxReport;
  @JsonKey(name: "created_by")
  dynamic get createdBy;
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
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.initCode, initCode) ||
                other.initCode == initCode) &&
            (identical(other.countId, countId) || other.countId == countId) &&
            (identical(other.salesCode, salesCode) ||
                other.salesCode == salesCode) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.salesDate, salesDate) ||
                other.salesDate == salesDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.salesStatus, salesStatus) ||
                other.salesStatus == salesStatus) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.otherChargesInput, otherChargesInput) ||
                other.otherChargesInput == otherChargesInput) &&
            (identical(other.otherChargesTaxId, otherChargesTaxId) ||
                other.otherChargesTaxId == otherChargesTaxId) &&
            (identical(other.otherChargesAmt, otherChargesAmt) ||
                other.otherChargesAmt == otherChargesAmt) &&
            const DeepCollectionEquality()
                .equals(other.discountToAllInput, discountToAllInput) &&
            const DeepCollectionEquality()
                .equals(other.discountToAllType, discountToAllType) &&
            (identical(other.totDiscountToAllAmt, totDiscountToAllAmt) ||
                other.totDiscountToAllAmt == totDiscountToAllAmt) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.roundOff, roundOff) ||
                other.roundOff == roundOff) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.salesNote, salesNote) ||
                other.salesNote == salesNote) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            const DeepCollectionEquality().equals(other.returnBit, returnBit) &&
            const DeepCollectionEquality()
                .equals(other.customerPreviousDue, customerPreviousDue) &&
            const DeepCollectionEquality()
                .equals(other.customerTotalDue, customerTotalDue) &&
            const DeepCollectionEquality()
                .equals(other.quotationId, quotationId) &&
            const DeepCollectionEquality().equals(other.couponId, couponId) &&
            const DeepCollectionEquality().equals(other.couponAmt, couponAmt) &&
            const DeepCollectionEquality()
                .equals(other.invoiceTerms, invoiceTerms) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appOrder, appOrder) ||
                other.appOrder == appOrder) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.taxReport, taxReport) ||
                other.taxReport == taxReport) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
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
        storeId,
        warehouseId,
        initCode,
        countId,
        salesCode,
        referenceNo,
        salesDate,
        dueDate,
        salesStatus,
        customerId,
        otherChargesInput,
        otherChargesTaxId,
        otherChargesAmt,
        const DeepCollectionEquality().hash(discountToAllInput),
        const DeepCollectionEquality().hash(discountToAllType),
        totDiscountToAllAmt,
        subtotal,
        roundOff,
        grandTotal,
        salesNote,
        paymentStatus,
        paidAmount,
        companyId,
        pos,
        const DeepCollectionEquality().hash(returnBit),
        const DeepCollectionEquality().hash(customerPreviousDue),
        const DeepCollectionEquality().hash(customerTotalDue),
        const DeepCollectionEquality().hash(quotationId),
        const DeepCollectionEquality().hash(couponId),
        const DeepCollectionEquality().hash(couponAmt),
        const DeepCollectionEquality().hash(invoiceTerms),
        status,
        appOrder,
        orderId,
        taxReport,
        const DeepCollectionEquality().hash(createdBy),
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'Datum(id: $id, storeId: $storeId, warehouseId: $warehouseId, initCode: $initCode, countId: $countId, salesCode: $salesCode, referenceNo: $referenceNo, salesDate: $salesDate, dueDate: $dueDate, salesStatus: $salesStatus, customerId: $customerId, otherChargesInput: $otherChargesInput, otherChargesTaxId: $otherChargesTaxId, otherChargesAmt: $otherChargesAmt, discountToAllInput: $discountToAllInput, discountToAllType: $discountToAllType, totDiscountToAllAmt: $totDiscountToAllAmt, subtotal: $subtotal, roundOff: $roundOff, grandTotal: $grandTotal, salesNote: $salesNote, paymentStatus: $paymentStatus, paidAmount: $paidAmount, companyId: $companyId, pos: $pos, returnBit: $returnBit, customerPreviousDue: $customerPreviousDue, customerTotalDue: $customerTotalDue, quotationId: $quotationId, couponId: $couponId, couponAmt: $couponAmt, invoiceTerms: $invoiceTerms, status: $status, appOrder: $appOrder, orderId: $orderId, taxReport: $taxReport, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      @JsonKey(name: "warehouse_id") String? warehouseId,
      @JsonKey(name: "init_code") String? initCode,
      @JsonKey(name: "count_id") String? countId,
      @JsonKey(name: "sales_code") String? salesCode,
      @JsonKey(name: "reference_no") String? referenceNo,
      @JsonKey(name: "sales_date") String? salesDate,
      @JsonKey(name: "due_date") String? dueDate,
      @JsonKey(name: "sales_status") String? salesStatus,
      @JsonKey(name: "customer_id") String? customerId,
      @JsonKey(name: "other_charges_input") String? otherChargesInput,
      @JsonKey(name: "other_charges_tax_id") String? otherChargesTaxId,
      @JsonKey(name: "other_charges_amt") String? otherChargesAmt,
      @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
      @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
      @JsonKey(name: "tot_discount_to_all_amt") String? totDiscountToAllAmt,
      @JsonKey(name: "subtotal") String? subtotal,
      @JsonKey(name: "round_off") String? roundOff,
      @JsonKey(name: "grand_total") String? grandTotal,
      @JsonKey(name: "sales_note") String? salesNote,
      @JsonKey(name: "payment_status") String? paymentStatus,
      @JsonKey(name: "paid_amount") String? paidAmount,
      @JsonKey(name: "company_id") String? companyId,
      @JsonKey(name: "pos") String? pos,
      @JsonKey(name: "return_bit") dynamic returnBit,
      @JsonKey(name: "customer_previous_due") dynamic customerPreviousDue,
      @JsonKey(name: "customer_total_due") dynamic customerTotalDue,
      @JsonKey(name: "quotation_id") dynamic quotationId,
      @JsonKey(name: "coupon_id") dynamic couponId,
      @JsonKey(name: "coupon_amt") dynamic couponAmt,
      @JsonKey(name: "invoice_terms") dynamic invoiceTerms,
      @JsonKey(name: "status") String? status,
      @JsonKey(name: "app_order") String? appOrder,
      @JsonKey(name: "order_id") String? orderId,
      @JsonKey(name: "tax_report") String? taxReport,
      @JsonKey(name: "created_by") dynamic createdBy,
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
    Object? warehouseId = freezed,
    Object? initCode = freezed,
    Object? countId = freezed,
    Object? salesCode = freezed,
    Object? referenceNo = freezed,
    Object? salesDate = freezed,
    Object? dueDate = freezed,
    Object? salesStatus = freezed,
    Object? customerId = freezed,
    Object? otherChargesInput = freezed,
    Object? otherChargesTaxId = freezed,
    Object? otherChargesAmt = freezed,
    Object? discountToAllInput = freezed,
    Object? discountToAllType = freezed,
    Object? totDiscountToAllAmt = freezed,
    Object? subtotal = freezed,
    Object? roundOff = freezed,
    Object? grandTotal = freezed,
    Object? salesNote = freezed,
    Object? paymentStatus = freezed,
    Object? paidAmount = freezed,
    Object? companyId = freezed,
    Object? pos = freezed,
    Object? returnBit = freezed,
    Object? customerPreviousDue = freezed,
    Object? customerTotalDue = freezed,
    Object? quotationId = freezed,
    Object? couponId = freezed,
    Object? couponAmt = freezed,
    Object? invoiceTerms = freezed,
    Object? status = freezed,
    Object? appOrder = freezed,
    Object? orderId = freezed,
    Object? taxReport = freezed,
    Object? createdBy = freezed,
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
      warehouseId: freezed == warehouseId
          ? _self.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      initCode: freezed == initCode
          ? _self.initCode
          : initCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countId: freezed == countId
          ? _self.countId
          : countId // ignore: cast_nullable_to_non_nullable
              as String?,
      salesCode: freezed == salesCode
          ? _self.salesCode
          : salesCode // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNo: freezed == referenceNo
          ? _self.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String?,
      salesDate: freezed == salesDate
          ? _self.salesDate
          : salesDate // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      salesStatus: freezed == salesStatus
          ? _self.salesStatus
          : salesStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      otherChargesInput: freezed == otherChargesInput
          ? _self.otherChargesInput
          : otherChargesInput // ignore: cast_nullable_to_non_nullable
              as String?,
      otherChargesTaxId: freezed == otherChargesTaxId
          ? _self.otherChargesTaxId
          : otherChargesTaxId // ignore: cast_nullable_to_non_nullable
              as String?,
      otherChargesAmt: freezed == otherChargesAmt
          ? _self.otherChargesAmt
          : otherChargesAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      discountToAllInput: freezed == discountToAllInput
          ? _self.discountToAllInput
          : discountToAllInput // ignore: cast_nullable_to_non_nullable
              as dynamic,
      discountToAllType: freezed == discountToAllType
          ? _self.discountToAllType
          : discountToAllType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totDiscountToAllAmt: freezed == totDiscountToAllAmt
          ? _self.totDiscountToAllAmt
          : totDiscountToAllAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      subtotal: freezed == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as String?,
      roundOff: freezed == roundOff
          ? _self.roundOff
          : roundOff // ignore: cast_nullable_to_non_nullable
              as String?,
      grandTotal: freezed == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      salesNote: freezed == salesNote
          ? _self.salesNote
          : salesNote // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _self.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAmount: freezed == paidAmount
          ? _self.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _self.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      pos: freezed == pos
          ? _self.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String?,
      returnBit: freezed == returnBit
          ? _self.returnBit
          : returnBit // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerPreviousDue: freezed == customerPreviousDue
          ? _self.customerPreviousDue
          : customerPreviousDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerTotalDue: freezed == customerTotalDue
          ? _self.customerTotalDue
          : customerTotalDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      quotationId: freezed == quotationId
          ? _self.quotationId
          : quotationId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      couponId: freezed == couponId
          ? _self.couponId
          : couponId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      couponAmt: freezed == couponAmt
          ? _self.couponAmt
          : couponAmt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      invoiceTerms: freezed == invoiceTerms
          ? _self.invoiceTerms
          : invoiceTerms // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      appOrder: freezed == appOrder
          ? _self.appOrder
          : appOrder // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      taxReport: freezed == taxReport
          ? _self.taxReport
          : taxReport // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
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
            @JsonKey(name: "warehouse_id") String? warehouseId,
            @JsonKey(name: "init_code") String? initCode,
            @JsonKey(name: "count_id") String? countId,
            @JsonKey(name: "sales_code") String? salesCode,
            @JsonKey(name: "reference_no") String? referenceNo,
            @JsonKey(name: "sales_date") String? salesDate,
            @JsonKey(name: "due_date") String? dueDate,
            @JsonKey(name: "sales_status") String? salesStatus,
            @JsonKey(name: "customer_id") String? customerId,
            @JsonKey(name: "other_charges_input") String? otherChargesInput,
            @JsonKey(name: "other_charges_tax_id") String? otherChargesTaxId,
            @JsonKey(name: "other_charges_amt") String? otherChargesAmt,
            @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
            @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
            @JsonKey(name: "tot_discount_to_all_amt")
            String? totDiscountToAllAmt,
            @JsonKey(name: "subtotal") String? subtotal,
            @JsonKey(name: "round_off") String? roundOff,
            @JsonKey(name: "grand_total") String? grandTotal,
            @JsonKey(name: "sales_note") String? salesNote,
            @JsonKey(name: "payment_status") String? paymentStatus,
            @JsonKey(name: "paid_amount") String? paidAmount,
            @JsonKey(name: "company_id") String? companyId,
            @JsonKey(name: "pos") String? pos,
            @JsonKey(name: "return_bit") dynamic returnBit,
            @JsonKey(name: "customer_previous_due") dynamic customerPreviousDue,
            @JsonKey(name: "customer_total_due") dynamic customerTotalDue,
            @JsonKey(name: "quotation_id") dynamic quotationId,
            @JsonKey(name: "coupon_id") dynamic couponId,
            @JsonKey(name: "coupon_amt") dynamic couponAmt,
            @JsonKey(name: "invoice_terms") dynamic invoiceTerms,
            @JsonKey(name: "status") String? status,
            @JsonKey(name: "app_order") String? appOrder,
            @JsonKey(name: "order_id") String? orderId,
            @JsonKey(name: "tax_report") String? taxReport,
            @JsonKey(name: "created_by") dynamic createdBy,
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
            _that.warehouseId,
            _that.initCode,
            _that.countId,
            _that.salesCode,
            _that.referenceNo,
            _that.salesDate,
            _that.dueDate,
            _that.salesStatus,
            _that.customerId,
            _that.otherChargesInput,
            _that.otherChargesTaxId,
            _that.otherChargesAmt,
            _that.discountToAllInput,
            _that.discountToAllType,
            _that.totDiscountToAllAmt,
            _that.subtotal,
            _that.roundOff,
            _that.grandTotal,
            _that.salesNote,
            _that.paymentStatus,
            _that.paidAmount,
            _that.companyId,
            _that.pos,
            _that.returnBit,
            _that.customerPreviousDue,
            _that.customerTotalDue,
            _that.quotationId,
            _that.couponId,
            _that.couponAmt,
            _that.invoiceTerms,
            _that.status,
            _that.appOrder,
            _that.orderId,
            _that.taxReport,
            _that.createdBy,
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
            @JsonKey(name: "warehouse_id") String? warehouseId,
            @JsonKey(name: "init_code") String? initCode,
            @JsonKey(name: "count_id") String? countId,
            @JsonKey(name: "sales_code") String? salesCode,
            @JsonKey(name: "reference_no") String? referenceNo,
            @JsonKey(name: "sales_date") String? salesDate,
            @JsonKey(name: "due_date") String? dueDate,
            @JsonKey(name: "sales_status") String? salesStatus,
            @JsonKey(name: "customer_id") String? customerId,
            @JsonKey(name: "other_charges_input") String? otherChargesInput,
            @JsonKey(name: "other_charges_tax_id") String? otherChargesTaxId,
            @JsonKey(name: "other_charges_amt") String? otherChargesAmt,
            @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
            @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
            @JsonKey(name: "tot_discount_to_all_amt")
            String? totDiscountToAllAmt,
            @JsonKey(name: "subtotal") String? subtotal,
            @JsonKey(name: "round_off") String? roundOff,
            @JsonKey(name: "grand_total") String? grandTotal,
            @JsonKey(name: "sales_note") String? salesNote,
            @JsonKey(name: "payment_status") String? paymentStatus,
            @JsonKey(name: "paid_amount") String? paidAmount,
            @JsonKey(name: "company_id") String? companyId,
            @JsonKey(name: "pos") String? pos,
            @JsonKey(name: "return_bit") dynamic returnBit,
            @JsonKey(name: "customer_previous_due") dynamic customerPreviousDue,
            @JsonKey(name: "customer_total_due") dynamic customerTotalDue,
            @JsonKey(name: "quotation_id") dynamic quotationId,
            @JsonKey(name: "coupon_id") dynamic couponId,
            @JsonKey(name: "coupon_amt") dynamic couponAmt,
            @JsonKey(name: "invoice_terms") dynamic invoiceTerms,
            @JsonKey(name: "status") String? status,
            @JsonKey(name: "app_order") String? appOrder,
            @JsonKey(name: "order_id") String? orderId,
            @JsonKey(name: "tax_report") String? taxReport,
            @JsonKey(name: "created_by") dynamic createdBy,
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
            _that.warehouseId,
            _that.initCode,
            _that.countId,
            _that.salesCode,
            _that.referenceNo,
            _that.salesDate,
            _that.dueDate,
            _that.salesStatus,
            _that.customerId,
            _that.otherChargesInput,
            _that.otherChargesTaxId,
            _that.otherChargesAmt,
            _that.discountToAllInput,
            _that.discountToAllType,
            _that.totDiscountToAllAmt,
            _that.subtotal,
            _that.roundOff,
            _that.grandTotal,
            _that.salesNote,
            _that.paymentStatus,
            _that.paidAmount,
            _that.companyId,
            _that.pos,
            _that.returnBit,
            _that.customerPreviousDue,
            _that.customerTotalDue,
            _that.quotationId,
            _that.couponId,
            _that.couponAmt,
            _that.invoiceTerms,
            _that.status,
            _that.appOrder,
            _that.orderId,
            _that.taxReport,
            _that.createdBy,
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
            @JsonKey(name: "warehouse_id") String? warehouseId,
            @JsonKey(name: "init_code") String? initCode,
            @JsonKey(name: "count_id") String? countId,
            @JsonKey(name: "sales_code") String? salesCode,
            @JsonKey(name: "reference_no") String? referenceNo,
            @JsonKey(name: "sales_date") String? salesDate,
            @JsonKey(name: "due_date") String? dueDate,
            @JsonKey(name: "sales_status") String? salesStatus,
            @JsonKey(name: "customer_id") String? customerId,
            @JsonKey(name: "other_charges_input") String? otherChargesInput,
            @JsonKey(name: "other_charges_tax_id") String? otherChargesTaxId,
            @JsonKey(name: "other_charges_amt") String? otherChargesAmt,
            @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
            @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
            @JsonKey(name: "tot_discount_to_all_amt")
            String? totDiscountToAllAmt,
            @JsonKey(name: "subtotal") String? subtotal,
            @JsonKey(name: "round_off") String? roundOff,
            @JsonKey(name: "grand_total") String? grandTotal,
            @JsonKey(name: "sales_note") String? salesNote,
            @JsonKey(name: "payment_status") String? paymentStatus,
            @JsonKey(name: "paid_amount") String? paidAmount,
            @JsonKey(name: "company_id") String? companyId,
            @JsonKey(name: "pos") String? pos,
            @JsonKey(name: "return_bit") dynamic returnBit,
            @JsonKey(name: "customer_previous_due") dynamic customerPreviousDue,
            @JsonKey(name: "customer_total_due") dynamic customerTotalDue,
            @JsonKey(name: "quotation_id") dynamic quotationId,
            @JsonKey(name: "coupon_id") dynamic couponId,
            @JsonKey(name: "coupon_amt") dynamic couponAmt,
            @JsonKey(name: "invoice_terms") dynamic invoiceTerms,
            @JsonKey(name: "status") String? status,
            @JsonKey(name: "app_order") String? appOrder,
            @JsonKey(name: "order_id") String? orderId,
            @JsonKey(name: "tax_report") String? taxReport,
            @JsonKey(name: "created_by") dynamic createdBy,
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
            _that.warehouseId,
            _that.initCode,
            _that.countId,
            _that.salesCode,
            _that.referenceNo,
            _that.salesDate,
            _that.dueDate,
            _that.salesStatus,
            _that.customerId,
            _that.otherChargesInput,
            _that.otherChargesTaxId,
            _that.otherChargesAmt,
            _that.discountToAllInput,
            _that.discountToAllType,
            _that.totDiscountToAllAmt,
            _that.subtotal,
            _that.roundOff,
            _that.grandTotal,
            _that.salesNote,
            _that.paymentStatus,
            _that.paidAmount,
            _that.companyId,
            _that.pos,
            _that.returnBit,
            _that.customerPreviousDue,
            _that.customerTotalDue,
            _that.quotationId,
            _that.couponId,
            _that.couponAmt,
            _that.invoiceTerms,
            _that.status,
            _that.appOrder,
            _that.orderId,
            _that.taxReport,
            _that.createdBy,
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
      @JsonKey(name: "warehouse_id") this.warehouseId,
      @JsonKey(name: "init_code") this.initCode,
      @JsonKey(name: "count_id") this.countId,
      @JsonKey(name: "sales_code") this.salesCode,
      @JsonKey(name: "reference_no") this.referenceNo,
      @JsonKey(name: "sales_date") this.salesDate,
      @JsonKey(name: "due_date") this.dueDate,
      @JsonKey(name: "sales_status") this.salesStatus,
      @JsonKey(name: "customer_id") this.customerId,
      @JsonKey(name: "other_charges_input") this.otherChargesInput,
      @JsonKey(name: "other_charges_tax_id") this.otherChargesTaxId,
      @JsonKey(name: "other_charges_amt") this.otherChargesAmt,
      @JsonKey(name: "discount_to_all_input") this.discountToAllInput,
      @JsonKey(name: "discount_to_all_type") this.discountToAllType,
      @JsonKey(name: "tot_discount_to_all_amt") this.totDiscountToAllAmt,
      @JsonKey(name: "subtotal") this.subtotal,
      @JsonKey(name: "round_off") this.roundOff,
      @JsonKey(name: "grand_total") this.grandTotal,
      @JsonKey(name: "sales_note") this.salesNote,
      @JsonKey(name: "payment_status") this.paymentStatus,
      @JsonKey(name: "paid_amount") this.paidAmount,
      @JsonKey(name: "company_id") this.companyId,
      @JsonKey(name: "pos") this.pos,
      @JsonKey(name: "return_bit") this.returnBit,
      @JsonKey(name: "customer_previous_due") this.customerPreviousDue,
      @JsonKey(name: "customer_total_due") this.customerTotalDue,
      @JsonKey(name: "quotation_id") this.quotationId,
      @JsonKey(name: "coupon_id") this.couponId,
      @JsonKey(name: "coupon_amt") this.couponAmt,
      @JsonKey(name: "invoice_terms") this.invoiceTerms,
      @JsonKey(name: "status") this.status,
      @JsonKey(name: "app_order") this.appOrder,
      @JsonKey(name: "order_id") this.orderId,
      @JsonKey(name: "tax_report") this.taxReport,
      @JsonKey(name: "created_by") this.createdBy,
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
  @JsonKey(name: "warehouse_id")
  final String? warehouseId;
  @override
  @JsonKey(name: "init_code")
  final String? initCode;
  @override
  @JsonKey(name: "count_id")
  final String? countId;
  @override
  @JsonKey(name: "sales_code")
  final String? salesCode;
  @override
  @JsonKey(name: "reference_no")
  final String? referenceNo;
  @override
  @JsonKey(name: "sales_date")
  final String? salesDate;
  @override
  @JsonKey(name: "due_date")
  final String? dueDate;
  @override
  @JsonKey(name: "sales_status")
  final String? salesStatus;
  @override
  @JsonKey(name: "customer_id")
  final String? customerId;
  @override
  @JsonKey(name: "other_charges_input")
  final String? otherChargesInput;
  @override
  @JsonKey(name: "other_charges_tax_id")
  final String? otherChargesTaxId;
  @override
  @JsonKey(name: "other_charges_amt")
  final String? otherChargesAmt;
  @override
  @JsonKey(name: "discount_to_all_input")
  final dynamic discountToAllInput;
  @override
  @JsonKey(name: "discount_to_all_type")
  final dynamic discountToAllType;
  @override
  @JsonKey(name: "tot_discount_to_all_amt")
  final String? totDiscountToAllAmt;
  @override
  @JsonKey(name: "subtotal")
  final String? subtotal;
  @override
  @JsonKey(name: "round_off")
  final String? roundOff;
  @override
  @JsonKey(name: "grand_total")
  final String? grandTotal;
  @override
  @JsonKey(name: "sales_note")
  final String? salesNote;
  @override
  @JsonKey(name: "payment_status")
  final String? paymentStatus;
  @override
  @JsonKey(name: "paid_amount")
  final String? paidAmount;
  @override
  @JsonKey(name: "company_id")
  final String? companyId;
  @override
  @JsonKey(name: "pos")
  final String? pos;
  @override
  @JsonKey(name: "return_bit")
  final dynamic returnBit;
  @override
  @JsonKey(name: "customer_previous_due")
  final dynamic customerPreviousDue;
  @override
  @JsonKey(name: "customer_total_due")
  final dynamic customerTotalDue;
  @override
  @JsonKey(name: "quotation_id")
  final dynamic quotationId;
  @override
  @JsonKey(name: "coupon_id")
  final dynamic couponId;
  @override
  @JsonKey(name: "coupon_amt")
  final dynamic couponAmt;
  @override
  @JsonKey(name: "invoice_terms")
  final dynamic invoiceTerms;
  @override
  @JsonKey(name: "status")
  final String? status;
  @override
  @JsonKey(name: "app_order")
  final String? appOrder;
  @override
  @JsonKey(name: "order_id")
  final String? orderId;
  @override
  @JsonKey(name: "tax_report")
  final String? taxReport;
  @override
  @JsonKey(name: "created_by")
  final dynamic createdBy;
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
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.initCode, initCode) ||
                other.initCode == initCode) &&
            (identical(other.countId, countId) || other.countId == countId) &&
            (identical(other.salesCode, salesCode) ||
                other.salesCode == salesCode) &&
            (identical(other.referenceNo, referenceNo) ||
                other.referenceNo == referenceNo) &&
            (identical(other.salesDate, salesDate) ||
                other.salesDate == salesDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.salesStatus, salesStatus) ||
                other.salesStatus == salesStatus) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.otherChargesInput, otherChargesInput) ||
                other.otherChargesInput == otherChargesInput) &&
            (identical(other.otherChargesTaxId, otherChargesTaxId) ||
                other.otherChargesTaxId == otherChargesTaxId) &&
            (identical(other.otherChargesAmt, otherChargesAmt) ||
                other.otherChargesAmt == otherChargesAmt) &&
            const DeepCollectionEquality()
                .equals(other.discountToAllInput, discountToAllInput) &&
            const DeepCollectionEquality()
                .equals(other.discountToAllType, discountToAllType) &&
            (identical(other.totDiscountToAllAmt, totDiscountToAllAmt) ||
                other.totDiscountToAllAmt == totDiscountToAllAmt) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.roundOff, roundOff) ||
                other.roundOff == roundOff) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.salesNote, salesNote) ||
                other.salesNote == salesNote) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.pos, pos) || other.pos == pos) &&
            const DeepCollectionEquality().equals(other.returnBit, returnBit) &&
            const DeepCollectionEquality()
                .equals(other.customerPreviousDue, customerPreviousDue) &&
            const DeepCollectionEquality()
                .equals(other.customerTotalDue, customerTotalDue) &&
            const DeepCollectionEquality()
                .equals(other.quotationId, quotationId) &&
            const DeepCollectionEquality().equals(other.couponId, couponId) &&
            const DeepCollectionEquality().equals(other.couponAmt, couponAmt) &&
            const DeepCollectionEquality()
                .equals(other.invoiceTerms, invoiceTerms) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appOrder, appOrder) ||
                other.appOrder == appOrder) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.taxReport, taxReport) ||
                other.taxReport == taxReport) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
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
        storeId,
        warehouseId,
        initCode,
        countId,
        salesCode,
        referenceNo,
        salesDate,
        dueDate,
        salesStatus,
        customerId,
        otherChargesInput,
        otherChargesTaxId,
        otherChargesAmt,
        const DeepCollectionEquality().hash(discountToAllInput),
        const DeepCollectionEquality().hash(discountToAllType),
        totDiscountToAllAmt,
        subtotal,
        roundOff,
        grandTotal,
        salesNote,
        paymentStatus,
        paidAmount,
        companyId,
        pos,
        const DeepCollectionEquality().hash(returnBit),
        const DeepCollectionEquality().hash(customerPreviousDue),
        const DeepCollectionEquality().hash(customerTotalDue),
        const DeepCollectionEquality().hash(quotationId),
        const DeepCollectionEquality().hash(couponId),
        const DeepCollectionEquality().hash(couponAmt),
        const DeepCollectionEquality().hash(invoiceTerms),
        status,
        appOrder,
        orderId,
        taxReport,
        const DeepCollectionEquality().hash(createdBy),
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'Datum(id: $id, storeId: $storeId, warehouseId: $warehouseId, initCode: $initCode, countId: $countId, salesCode: $salesCode, referenceNo: $referenceNo, salesDate: $salesDate, dueDate: $dueDate, salesStatus: $salesStatus, customerId: $customerId, otherChargesInput: $otherChargesInput, otherChargesTaxId: $otherChargesTaxId, otherChargesAmt: $otherChargesAmt, discountToAllInput: $discountToAllInput, discountToAllType: $discountToAllType, totDiscountToAllAmt: $totDiscountToAllAmt, subtotal: $subtotal, roundOff: $roundOff, grandTotal: $grandTotal, salesNote: $salesNote, paymentStatus: $paymentStatus, paidAmount: $paidAmount, companyId: $companyId, pos: $pos, returnBit: $returnBit, customerPreviousDue: $customerPreviousDue, customerTotalDue: $customerTotalDue, quotationId: $quotationId, couponId: $couponId, couponAmt: $couponAmt, invoiceTerms: $invoiceTerms, status: $status, appOrder: $appOrder, orderId: $orderId, taxReport: $taxReport, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      @JsonKey(name: "warehouse_id") String? warehouseId,
      @JsonKey(name: "init_code") String? initCode,
      @JsonKey(name: "count_id") String? countId,
      @JsonKey(name: "sales_code") String? salesCode,
      @JsonKey(name: "reference_no") String? referenceNo,
      @JsonKey(name: "sales_date") String? salesDate,
      @JsonKey(name: "due_date") String? dueDate,
      @JsonKey(name: "sales_status") String? salesStatus,
      @JsonKey(name: "customer_id") String? customerId,
      @JsonKey(name: "other_charges_input") String? otherChargesInput,
      @JsonKey(name: "other_charges_tax_id") String? otherChargesTaxId,
      @JsonKey(name: "other_charges_amt") String? otherChargesAmt,
      @JsonKey(name: "discount_to_all_input") dynamic discountToAllInput,
      @JsonKey(name: "discount_to_all_type") dynamic discountToAllType,
      @JsonKey(name: "tot_discount_to_all_amt") String? totDiscountToAllAmt,
      @JsonKey(name: "subtotal") String? subtotal,
      @JsonKey(name: "round_off") String? roundOff,
      @JsonKey(name: "grand_total") String? grandTotal,
      @JsonKey(name: "sales_note") String? salesNote,
      @JsonKey(name: "payment_status") String? paymentStatus,
      @JsonKey(name: "paid_amount") String? paidAmount,
      @JsonKey(name: "company_id") String? companyId,
      @JsonKey(name: "pos") String? pos,
      @JsonKey(name: "return_bit") dynamic returnBit,
      @JsonKey(name: "customer_previous_due") dynamic customerPreviousDue,
      @JsonKey(name: "customer_total_due") dynamic customerTotalDue,
      @JsonKey(name: "quotation_id") dynamic quotationId,
      @JsonKey(name: "coupon_id") dynamic couponId,
      @JsonKey(name: "coupon_amt") dynamic couponAmt,
      @JsonKey(name: "invoice_terms") dynamic invoiceTerms,
      @JsonKey(name: "status") String? status,
      @JsonKey(name: "app_order") String? appOrder,
      @JsonKey(name: "order_id") String? orderId,
      @JsonKey(name: "tax_report") String? taxReport,
      @JsonKey(name: "created_by") dynamic createdBy,
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
    Object? warehouseId = freezed,
    Object? initCode = freezed,
    Object? countId = freezed,
    Object? salesCode = freezed,
    Object? referenceNo = freezed,
    Object? salesDate = freezed,
    Object? dueDate = freezed,
    Object? salesStatus = freezed,
    Object? customerId = freezed,
    Object? otherChargesInput = freezed,
    Object? otherChargesTaxId = freezed,
    Object? otherChargesAmt = freezed,
    Object? discountToAllInput = freezed,
    Object? discountToAllType = freezed,
    Object? totDiscountToAllAmt = freezed,
    Object? subtotal = freezed,
    Object? roundOff = freezed,
    Object? grandTotal = freezed,
    Object? salesNote = freezed,
    Object? paymentStatus = freezed,
    Object? paidAmount = freezed,
    Object? companyId = freezed,
    Object? pos = freezed,
    Object? returnBit = freezed,
    Object? customerPreviousDue = freezed,
    Object? customerTotalDue = freezed,
    Object? quotationId = freezed,
    Object? couponId = freezed,
    Object? couponAmt = freezed,
    Object? invoiceTerms = freezed,
    Object? status = freezed,
    Object? appOrder = freezed,
    Object? orderId = freezed,
    Object? taxReport = freezed,
    Object? createdBy = freezed,
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
      warehouseId: freezed == warehouseId
          ? _self.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as String?,
      initCode: freezed == initCode
          ? _self.initCode
          : initCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countId: freezed == countId
          ? _self.countId
          : countId // ignore: cast_nullable_to_non_nullable
              as String?,
      salesCode: freezed == salesCode
          ? _self.salesCode
          : salesCode // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNo: freezed == referenceNo
          ? _self.referenceNo
          : referenceNo // ignore: cast_nullable_to_non_nullable
              as String?,
      salesDate: freezed == salesDate
          ? _self.salesDate
          : salesDate // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      salesStatus: freezed == salesStatus
          ? _self.salesStatus
          : salesStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      customerId: freezed == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String?,
      otherChargesInput: freezed == otherChargesInput
          ? _self.otherChargesInput
          : otherChargesInput // ignore: cast_nullable_to_non_nullable
              as String?,
      otherChargesTaxId: freezed == otherChargesTaxId
          ? _self.otherChargesTaxId
          : otherChargesTaxId // ignore: cast_nullable_to_non_nullable
              as String?,
      otherChargesAmt: freezed == otherChargesAmt
          ? _self.otherChargesAmt
          : otherChargesAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      discountToAllInput: freezed == discountToAllInput
          ? _self.discountToAllInput
          : discountToAllInput // ignore: cast_nullable_to_non_nullable
              as dynamic,
      discountToAllType: freezed == discountToAllType
          ? _self.discountToAllType
          : discountToAllType // ignore: cast_nullable_to_non_nullable
              as dynamic,
      totDiscountToAllAmt: freezed == totDiscountToAllAmt
          ? _self.totDiscountToAllAmt
          : totDiscountToAllAmt // ignore: cast_nullable_to_non_nullable
              as String?,
      subtotal: freezed == subtotal
          ? _self.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as String?,
      roundOff: freezed == roundOff
          ? _self.roundOff
          : roundOff // ignore: cast_nullable_to_non_nullable
              as String?,
      grandTotal: freezed == grandTotal
          ? _self.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      salesNote: freezed == salesNote
          ? _self.salesNote
          : salesNote // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: freezed == paymentStatus
          ? _self.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAmount: freezed == paidAmount
          ? _self.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _self.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      pos: freezed == pos
          ? _self.pos
          : pos // ignore: cast_nullable_to_non_nullable
              as String?,
      returnBit: freezed == returnBit
          ? _self.returnBit
          : returnBit // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerPreviousDue: freezed == customerPreviousDue
          ? _self.customerPreviousDue
          : customerPreviousDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      customerTotalDue: freezed == customerTotalDue
          ? _self.customerTotalDue
          : customerTotalDue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      quotationId: freezed == quotationId
          ? _self.quotationId
          : quotationId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      couponId: freezed == couponId
          ? _self.couponId
          : couponId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      couponAmt: freezed == couponAmt
          ? _self.couponAmt
          : couponAmt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      invoiceTerms: freezed == invoiceTerms
          ? _self.invoiceTerms
          : invoiceTerms // ignore: cast_nullable_to_non_nullable
              as dynamic,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      appOrder: freezed == appOrder
          ? _self.appOrder
          : appOrder // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      taxReport: freezed == taxReport
          ? _self.taxReport
          : taxReport // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
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

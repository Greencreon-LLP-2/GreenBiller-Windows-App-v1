import 'dart:convert';

class SalesOrderModel {
  final String message;
  final List<SaleOrderList> data;
  final int status;

  SalesOrderModel({
    required this.message,
    required this.data,
    required this.status,
  });

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) =>
      SalesOrderModel(
        message: json["message"],
        data: List<SaleOrderList>.from(
            json["data"].map((x) => SaleOrderList.fromJson(x))),
        status: json["status"],
      );
}

class SaleOrderList {
  final int id;
  final String uniqueOrderId;
  final String orderstatusId;
  final String storeId;
  final String userId;
  final String ifSales;
  final String salesId;
  final String? customerLatitude;
  final String? customerLongitude;
  final String shippingAddressId;
  final String? orderAddress;
  final String? rewardPoint;
  final String subTotal;
  final String? taxrate;
  final String? taxAmt;
  final String? deliveryCharge;
  final String? discount;
  final String? couponId;
  final String? couponAmount;
  final String? handlingCharge;
  final String orderTotalamt;
  final String ifRedeem;
  final String? redeemPoint;
  final String? redeemCash;
  final String? afterRedeemBillAmt;
  final String paymentMode;
  final String? mapDistance;
  final String? deliveryPin;
  final String deliveryboyId;
  final String? notifiAdmin;
  final String? notifiStore;
  final String notifiDeliveryboy;
  final String? deliveryTimesloteId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  SaleOrderList({
    required this.id,
    required this.uniqueOrderId,
    required this.orderstatusId,
    required this.storeId,
    required this.userId,
    required this.ifSales,
    required this.salesId,
    this.customerLatitude,
    this.customerLongitude,
    required this.shippingAddressId,
    this.orderAddress,
    this.rewardPoint,
    required this.subTotal,
    this.taxrate,
    this.taxAmt,
    this.deliveryCharge,
    this.discount,
    this.couponId,
    this.couponAmount,
    this.handlingCharge,
    required this.orderTotalamt,
    required this.ifRedeem,
    this.redeemPoint,
    this.redeemCash,
    this.afterRedeemBillAmt,
    required this.paymentMode,
    this.mapDistance,
    this.deliveryPin,
    required this.deliveryboyId,
    this.notifiAdmin,
    this.notifiStore,
    required this.notifiDeliveryboy,
    this.deliveryTimesloteId,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory SaleOrderList.fromJson(Map<String, dynamic> json) => SaleOrderList(
        id: json["id"],
        uniqueOrderId: json["unique_order_id"],
        orderstatusId: json["orderstatus_id"],
        storeId: json["store_id"],
        userId: json["user_id"],
        ifSales: json["if_sales"],
        salesId: json["sales_id"],
        customerLatitude: json["customer_latitude"],
        customerLongitude: json["customer_longitude"],
        shippingAddressId: json["shipping_address_id"],
        orderAddress: json["order_address"],
        rewardPoint: json["reward_point"],
        subTotal: json["sub_total"],
        taxrate: json["taxrate"],
        taxAmt: json["tax_amt"],
        deliveryCharge: json["delivery_charge"],
        discount: json["discount"],
        couponId: json["coupon_id"],
        couponAmount: json["coupon_amount"],
        handlingCharge: json["handling_charge"],
        orderTotalamt: json["order_totalamt"],
        ifRedeem: json["if_redeem"],
        redeemPoint: json["redeem_point"],
        redeemCash: json["redeem_cash"],
        afterRedeemBillAmt: json["after_redeem_bill_amt"],
        paymentMode: json["payment_mode"],
        mapDistance: json["map_distance"],
        deliveryPin: json["delivery_pin"],
        deliveryboyId: json["deliveryboy_id"],
        notifiAdmin: json["notifi_admin"],
        notifiStore: json["notifi_store"],
        notifiDeliveryboy: json["notifi_deliveryboy"],
        deliveryTimesloteId: json["delivery_timeslote_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        items: List<OrderItem>.from(
            json["items"].map((x) => OrderItem.fromJson(x))),
      );
}

class OrderItem {
  final int id;
  final String orderId;
  final String userId;
  final String storeId;
  final String itemId;
  final String sellingPrice;
  final String qty;
  final String taxRate;
  final String taxType;
  final String taxAmt;
  final String totalPrice;
  final String ifOffer;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.storeId,
    required this.itemId,
    required this.sellingPrice,
    required this.qty,
    required this.taxRate,
    required this.taxType,
    required this.taxAmt,
    required this.totalPrice,
    required this.ifOffer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        orderId: json["order_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        itemId: json["item_id"],
        sellingPrice: json["selling_price"],
        qty: json["qty"],
        taxRate: json["tax_rate"],
        taxType: json["tax_type"],
        taxAmt: json["tax_amt"],
        totalPrice: json["total_price"],
        ifOffer: json["if_offer"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}

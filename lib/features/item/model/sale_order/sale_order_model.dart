// credit_note_model.dart
import 'package:green_biller/features/item/model/item/item_model.dart';

class SaleOrderModel {
  final String orderNumber;
  final DateTime orderDate;
  final String customerName;
  final String? phoneNumber;
  final DateTime? reutrnBillDate;
  final String? returnNumber;
  final List<SaleOrderModelItem> items;
  final double totalAmount;
  final String? storeId;
  final String? customerId;
  SaleOrderModel({
    required this.orderNumber,
    required this.orderDate,
    required this.customerName,
    this.phoneNumber,
    this.reutrnBillDate,
    this.returnNumber,
    required this.items,
    required this.totalAmount,
    this.storeId,
    this.customerId,
  });

  double calculateTotal() {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }
}

class SaleOrderModelItem {
  final Item item;
  final double rate;
  final int quantity;
  final String unit;
  final double taxRate;
  final String taxType;

  double get subtotal => rate * quantity * (1 + (taxRate / 100));

  SaleOrderModelItem({
    required this.item,
    required this.rate,
    required this.quantity,
    required this.unit,
    required this.taxRate,
    required this.taxType,
  });
}

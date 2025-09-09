// credit_note_model.dart
import 'package:greenbiller/features/items/model/item_model.dart';

class CreditNote {
  final String returnNumber;
  final DateTime returnDate;
  final String customerName;
  final String? phoneNumber;
  final DateTime? invoiceDate;
  final String? invoiceNumber;
  final List<CreditNoteItem> items;
  final double totalAmount;
  final String? storeId;
  final String? customerId;
  CreditNote({
    required this.returnNumber,
    required this.returnDate,
    required this.customerName,
    this.phoneNumber,
    this.invoiceDate,
    this.invoiceNumber,
    required this.items,
    required this.totalAmount,
    this.storeId,
    this.customerId,
  });

  double calculateTotal() {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }
}

class CreditNoteItem {
  final Item item;
  final double rate;
  final int quantity;
  final String unit;
  final double taxRate;
  final String taxType;

  double get subtotal => rate * quantity * (1 + (taxRate / 100));

  CreditNoteItem({
    required this.item,
    required this.rate,
    required this.quantity,
    required this.unit,
    required this.taxRate,
    required this.taxType,
  });
}

// InvoiceItem Model
class InvoiceItem {
  final String name;
  final int qty;
  final String unit;
  final double price;
  final double total;
  final String taxName;
  final double taxRate;

  InvoiceItem({
    required this.name,
    required this.qty,
    required this.unit,
    required this.price,
    required this.total,
    required this.taxName,
    required this.taxRate,
  });
}
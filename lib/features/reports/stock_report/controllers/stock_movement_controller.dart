import 'package:flutter/material.dart';

class StockMovement {
  final String productName;
  final String type;
  final int quantity;
  final String date;
  final double value;

  StockMovement({
    required this.productName,
    required this.type,
    required this.quantity,
    required this.date,
    required this.value,
  });
}

class StockMovementController extends ChangeNotifier {
  String selectedStore = '';
  String selectedMovementType = 'All';
  bool isLoading = false;
  List<StockMovement> movements = [];

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final stores = [
    'Store 1',
    'Store 2',
    'Store 3',
    'Store 4',
  ];

  StockMovementController() {
    selectedStore = stores.first;
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  void updateStore(String store) {
    selectedStore = store;
    notifyListeners();
  }

  void updateMovementType(String type) {
    selectedMovementType = type;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final date = '${picked.day}/${picked.month}/${picked.year}';
      if (isStartDate) {
        startDateController.text = date;
      } else {
        endDateController.text = date;
      }
      notifyListeners();
    }
  }

  Future<void> generateReport(context) async {
    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end dates'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Sample data
    movements = [
      StockMovement(
        productName: 'Product A',
        type: 'In',
        quantity: 50,
        date: '15/03/2024',
        value: 2500.00,
      ),
      StockMovement(
        productName: 'Product B',
        type: 'Out',
        quantity: 30,
        date: '15/03/2024',
        value: 1500.00,
      ),
      StockMovement(
        productName: 'Product C',
        type: 'In',
        quantity: 100,
        date: '14/03/2024',
        value: 5000.00,
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}

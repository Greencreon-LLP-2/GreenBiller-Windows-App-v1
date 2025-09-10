class DashboardModel {
  final bool success;
  final String? message;
  final BusinessOverview? businessOverview;
  final List<SalesOverview>? salesOverviewLast7Days;
  final List<RecentTransaction>? recentTransactions;

  DashboardModel({
    required this.success,
    this.message,
    this.businessOverview,
    this.salesOverviewLast7Days,
    this.recentTransactions,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'] as bool,
      message: json['message'] as String?,
      businessOverview: json['business_overview'] != null
          ? BusinessOverview.fromJson(json['business_overview'])
          : null,
      salesOverviewLast7Days: json['sales_overview_last_7_days'] != null
          ? (json['sales_overview_last_7_days'] as List<dynamic>)
                .map((e) => SalesOverview.fromJson(e))
                .toList()
          : null,
      recentTransactions: json['recent_transactions'] != null
          ? (json['recent_transactions'] as List<dynamic>)
                .map((e) => RecentTransaction.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'business_overview': businessOverview?.toJson(),
      'sales_overview_last_7_days': salesOverviewLast7Days
          ?.map((e) => e.toJson())
          .toList(),
      'recent_transactions': recentTransactions
          ?.map((e) => e.toJson())
          .toList(),
    };
  }
}

class BusinessOverview {
  final double totalSales;
  final double salesChange;
  final String salesChangeType;
  final double totalDue;
  final double dueChange;
  final String dueChangeType;
  final int totalItems;
  final double itemsChange;
  final String itemsChangeType;
  final int totalCustomers;
  final double customersChange;
  final String customersChangeType;

  BusinessOverview({
    required this.totalSales,
    required this.salesChange,
    required this.salesChangeType,
    required this.totalDue,
    required this.dueChange,
    required this.dueChangeType,
    required this.totalItems,
    required this.itemsChange,
    required this.itemsChangeType,
    required this.totalCustomers,
    required this.customersChange,
    required this.customersChangeType,
  });

  factory BusinessOverview.fromJson(Map<String, dynamic> json) {
    return BusinessOverview(
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      salesChange: (json['sales_change'] as num?)?.toDouble() ?? 0.0,
      salesChangeType: json['sales_change_type'] as String? ?? '',
      totalDue: (json['total_due'] as num?)?.toDouble() ?? 0.0,
      dueChange: (json['due_change'] as num?)?.toDouble() ?? 0.0,
      dueChangeType: json['due_change_type'] as String? ?? '',
      totalItems: json['total_items'] as int? ?? 0,
      itemsChange: (json['items_change'] as num?)?.toDouble() ?? 0.0,
      itemsChangeType: json['items_change_type'] as String? ?? '',
      totalCustomers: json['total_customers'] as int? ?? 0,
      customersChange: (json['customers_change'] as num?)?.toDouble() ?? 0.0,
      customersChangeType: json['customers_change_type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_sales': totalSales,
      'sales_change': salesChange,
      'sales_change_type': salesChangeType,
      'total_due': totalDue,
      'due_change': dueChange,
      'due_change_type': dueChangeType,
      'total_items': totalItems,
      'items_change': itemsChange,
      'items_change_type': itemsChangeType,
      'total_customers': totalCustomers,
      'customers_change': customersChange,
      'customers_change_type': customersChangeType,
    };
  }
}

class SalesOverview {
  final String date;
  final double total;

  SalesOverview({required this.date, required this.total});

  factory SalesOverview.fromJson(Map<String, dynamic> json) {
    return SalesOverview(
      date: json['date'] as String,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'total': total};
  }
}

class RecentTransaction {
  final int id;
  final int? customerId;
  final double grandTotal;
  final double customerTotalDue;
  final String status;
  final String createdAt;
  final Customer? customer;

  RecentTransaction({
    required this.id,
    this.customerId,
    required this.grandTotal,
    required this.customerTotalDue,
    required this.status,
    required this.createdAt,
    this.customer,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      id: json['id'] as int,
      customerId: json['customer_id'] != null
          ? int.tryParse(json['customer_id'].toString())
          : null,
      grandTotal: (json['grand_total'] != null)
          ? double.tryParse(json['grand_total'].toString()) ?? 0.0
          : 0.0,
      customerTotalDue: (json['customer_total_due'] != null)
          ? double.tryParse(json['customer_total_due'].toString()) ?? 0.0
          : 0.0,
      status: json['status'].toString(), // keep it as string for flexibility
      createdAt: json['created_at'] as String,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'grand_total': grandTotal,
      'customer_total_due': customerTotalDue,
      'status': status,
      'created_at': createdAt,
      'customer': customer?.toJson(),
    };
  }
}

class Customer {
  final int id;
  final String customerName;
  final String? email;

  Customer({required this.id, required this.customerName, this.email});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      customerName: json['customer_name'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'customer_name': customerName, 'email': email};
  }
}

class SalesData {
  final DateTime day; 
  final double amount;
  SalesData(this.day, this.amount);
}

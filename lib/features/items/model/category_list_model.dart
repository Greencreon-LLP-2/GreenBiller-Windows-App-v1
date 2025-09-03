// category_list_model.dart

class CategoryListModel {
  final String? message;
  final List<CategoryModel>? categories;
  final int? total;
  final int? status;

  CategoryListModel({this.message, this.categories, this.total, this.status});

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(
      message: json['message'] as String?,
      categories: (json['data'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] is int
          ? json['total'] as int
          : int.tryParse(json['total']?.toString() ?? ''),
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    r'$categories': categories?.map((e) => e.toJson()).toList(),
    'total': total,
    'status': status,
  };
}

class CategoryModel {
  final int? id;
  final String? name;
  final int? itemCount;
  final bool? status;
  CategoryModel({this.id, this.name, this.itemCount, this.status});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] as String?,
      itemCount: json['item_count'] != null
          ? int.tryParse(json['item_count'].toString()) ?? 0
          : 0,
      status: json['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'item_count': itemCount,
  };
}

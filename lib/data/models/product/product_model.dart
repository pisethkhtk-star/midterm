import 'package:demo_access_refresh_token_app/data/models/product/product_category_model.dart';

class ProductModel {
  final int? id;
  final String name;
  final String? productCode;
  final ProductCategoryModel? category;
  final double price;
  final double cost;
  final double stockQuantity;
  final String? description;
  final String status;

  ProductModel({
    this.id,
    required this.name,
    this.productCode,
    this.category,
    this.price = 0.0,
    this.cost = 0.0,
    this.stockQuantity = 0.0,
    this.description,
    this.status = 'ACT',
  });

  bool get isInStock => stockQuantity > 0;
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 5;
  String get categoryName => category?.name ?? 'General';
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  factory ProductModel.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return ProductModel(name: '');
    }
    final map = Map<String, dynamic>.from(json);

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return ProductModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? 'Unnamed Product',
      productCode: map['productCode']?.toString(),
      category: map['category'] != null ? ProductCategoryModel.fromJson(map['category']) : null,
      price: parseDouble(map['price']),
      cost: parseDouble(map['cost']),
      stockQuantity: parseDouble(map['stockQuantity']),
      description: map['description']?.toString(),
      status: map['status']?.toString() ?? 'ACT',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (productCode != null) 'productCode': productCode,
      if (category != null) 'category': category?.toJson(),
      'price': price,
      'cost': cost,
      'stockQuantity': stockQuantity,
      if (description != null) 'description': description,
      'status': status,
    };
  }
}


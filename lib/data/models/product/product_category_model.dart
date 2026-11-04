class ProductCategoryModel {
  final int? id;
  final String name;

  ProductCategoryModel({
    this.id,
    required this.name,
  });

  factory ProductCategoryModel.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      return ProductCategoryModel(name: '');
    }
    final map = Map<String, dynamic>.from(json);
    return ProductCategoryModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}


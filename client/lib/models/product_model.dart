class Product {
  final int id;
  final String name;
  final String photo;
  final String category;
  final double? price;
  final String? unitOfMeasure;
  final String? unitOfCalculation;
  final double? averageWeight;

  Product({
    required this.id,
    required this.name,
    required this.photo,
    required this.category,
    this.price,
    this.unitOfMeasure,
    this.unitOfCalculation,
    this.averageWeight,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return Product(
      id: parseInt(json['id']),
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      category: json['category'] ?? '',
      price: parseDouble(json['price']),
      unitOfMeasure: json['unitOFMeasure'] as String?,
      unitOfCalculation: json['unitOfCalculation'] as String?,
      averageWeight: parseDouble(json['averageWeight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'category': category,
      'price': price,
      'unitOFMeasure': unitOfMeasure,
      'unitOfCalculation': unitOfCalculation,
      'averageWeight': averageWeight,
    };
  }
}

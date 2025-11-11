class ShoppingList {
  final int id;
  final String name;
  final double totalPrice;

  ShoppingList({
    required this.id,
    required this.name,
    required this.totalPrice,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    final totalPriceValue = json['totalPrice'];

    double parseTotalPrice(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ShoppingList(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      totalPrice: parseTotalPrice(totalPriceValue),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'totalPrice': totalPrice};
  }
}

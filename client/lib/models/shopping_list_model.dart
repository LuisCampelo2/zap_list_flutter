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
    return ShoppingList(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'totalPrice': totalPrice};
  }
}

import 'product_model.dart';
import 'shopping_list_model.dart';

class ShoppingListProduct {
  final int id;
  final int? quantity;
  final bool isChecked;
  final int shoppingListId;
  final int productId;
  final String? observation;
  final Product? product;
  final ShoppingList? shoppingList;

  ShoppingListProduct({
    required this.id,
    this.quantity,
    required this.isChecked,
    required this.shoppingListId,
    required this.productId,
    this.observation,
    this.product,
    this.shoppingList,
  });

  factory ShoppingListProduct.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ShoppingListProduct(
        id: 0,
        isChecked: false,
        shoppingListId: 0,
        productId: 0,
      );
    }

    return ShoppingListProduct(
      id: json['id'] ?? 0,
      quantity: json['quantity'],
      isChecked: json['isChecked'] ?? false,
      shoppingListId: json['shoppingListId'] ?? 0,
      productId: json['productId'] ?? 0,
      observation: json['observation'],
      product: json['Product'] != null
          ? Product.fromJson(json['Product'])
          : null,
      shoppingList: json['ShoppingList'] != null
          ? ShoppingList.fromJson(json['ShoppingList'])
          : null,
    );
  }
}

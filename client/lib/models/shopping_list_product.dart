import 'product_model.dart';
import 'shopping_list_model.dart';

class ShoppingListProduct {
  final int id;
  final int? quantity;
  final bool isChecked;
  final int shoppingListId;
  final int productId;
  final String? observation;
  final Product product;
  final ShoppingList shoppingList;

  ShoppingListProduct({
    required this.id,
    this.quantity,
    required this.isChecked,
    required this.shoppingListId,
    required this.productId,
    this.observation,
    required this.product,
    required this.shoppingList,
  });

  factory ShoppingListProduct.fromJson(Map<String, dynamic> json) {
    return ShoppingListProduct(
      id: json['id'],
      quantity: json['quantity'],
      isChecked: json['isChecked'],
      shoppingListId: json['shoppingListId'],
      productId: json['productId'],
      observation: json['observation'],
      product: Product.fromJson(json['Product']),
      shoppingList: ShoppingList.fromJson(json['ShoppingList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'isChecked': isChecked,
      'shoppingListId': shoppingListId,
      'productId': productId,
      'observation': observation,
      'Product': product.toJson(),
      'ShoppingList': shoppingList.toJson(),
    };
  }
}

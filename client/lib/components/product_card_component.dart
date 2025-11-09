import 'package:flutter/material.dart';
import 'package:zap_list_flutter/modals/lists_modal.dart';
import 'package:zap_list_flutter/controllers/list_controller.dart';
import 'package:zap_list_flutter/models/product_model.dart';
import 'package:zap_list_flutter/models/shopping_list_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ListController listController = ListController();

  ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'http://192.168.0.16:3000/imgs/${product.photo}',
              width: 148,
              height: 148,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFD6200),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              List<ShoppingList> lists = [];
              final productId = product.id;
              try {
                lists = await listController.fetchLists();
              } catch (e) {
                print("Erro ao buscar listas: $e");
              }
              ListsModal.show(context, lists, productId,product);
            },
            child: Text(
              'Adicionar à lista',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

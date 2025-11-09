import 'package:flutter/material.dart';
import 'package:zap_list_flutter/controllers/list_controller.dart';
import 'package:zap_list_flutter/modals/quantity_modal.dart';
import 'package:zap_list_flutter/models/product_model.dart';
import 'package:zap_list_flutter/models/shopping_list_model.dart';

class ListsModal {
  static void show(BuildContext context, List<ShoppingList> lists,int productId,Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Selecione uma Lista para adicionar o produto',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: lists.isEmpty
                ? const Text('Você ainda não possui listas')
                : ListView.builder(
              shrinkWrap: true,
              itemCount: lists.length,
              itemBuilder: (context, index) {
                final list = lists[index];
                return ListTile(
                  title: Text(list.name),
                  subtitle: Text(
                    'Total: R\$ ${list.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  onTap: () {
                    final listId = list.id;
                    Navigator.pop(context);
                    QuantityModal.show(context, listId: listId,productId: productId,product:product);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

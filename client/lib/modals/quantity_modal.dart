import 'package:flutter/material.dart';
import 'package:zap_list_flutter/controllers/list_controller.dart';
import 'package:zap_list_flutter/models/product_model.dart';

class QuantityModal {
  static void show(
    BuildContext context, {
    required int listId,
    required int productId,
    required Product product
  }) {
    int quantity = 1;
    ListController _listController = ListController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Quantos ${product.unitOfMeasure}s de ${product.name} você quer adicionar?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => quantity++);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _listController.addProductToList(
                      listId,
                      productId,
                      quantity,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

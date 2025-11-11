import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zap_list_flutter/controllers/list_controller.dart';
import 'package:zap_list_flutter/modals/create_list_modal.dart';
import 'package:zap_list_flutter/models/shopping_list_model.dart';
import 'package:zap_list_flutter/models/shopping_list_product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListsScreen extends StatefulWidget {
  final User user;

  const ListsScreen({super.key, required this.user});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<ShoppingList> lists = [];
  final Map<int, List<ShoppingListProduct>> listProducts = {};
  final ListController listController = ListController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final resLists = await listController.fetchLists();
      setState(() {
        lists = resLists;
      });
    } catch (e) {
      print('Erro ao buscar listas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas listas')),
      body: Column(
        children: [
          SizedBox(
            width: 266,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar Lista...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 7,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    CreateListModal.show(context);
                  },
                  child: const Text(
                    'Criar lista',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: lists.isEmpty
                ? const Center(child: Text('Você ainda não possui listas'))
                : ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      final list = lists[index];
                      final products = listProducts[list.id] ?? [];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final data = await listController
                                        .fetchListProducts(list.id);
                                    final fetchedProducts =
                                        data['products']
                                            as List<ShoppingListProduct>;
                                    setState(() {
                                      listProducts[list.id] = fetchedProducts;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        list.name,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.chevron_right,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            if (products.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                // 🔹 Aproxima imagens do título
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: products.length,
                                    itemBuilder: (context, productIndex) {
                                      final shoppingListProduct =
                                          products[productIndex];
                                      final product =
                                          shoppingListProduct.product;
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: product != null
                                            ? Image.network(
                                                '${dotenv.env['API_URL']}/imgs/${product.photo}',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

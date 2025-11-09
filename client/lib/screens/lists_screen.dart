import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zap_list_flutter/controllers/list_controller.dart';
import 'package:zap_list_flutter/modals/create_list_modal.dart';
import 'package:zap_list_flutter/models/shopping_list_model.dart';

class ListsScreen extends StatefulWidget {
  final User user;

  const ListsScreen({super.key, required this.user});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<ShoppingList> lists = [];
  final ListController listController = ListController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final res = await listController.fetchLists();
      setState(() {
        lists = res;
      });
    } catch (e) {
      print('Erro ao buscar listas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas listas')),
      body: Expanded(
        child: Column(
          children: [
            lists.isEmpty
                ? const Center(child: Text('Você ainda não possui listas'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: lists.length,
                      itemBuilder: (context, index) {
                        final list = lists[index];
                        return ListTile(title: Text(list.name), onTap: () {});
                      },
                    ),
                  ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                CreateListModal.show(context);
              },
              child: Text('Criar lista', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

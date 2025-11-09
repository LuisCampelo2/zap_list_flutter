import 'dart:async';
import 'package:dio/dio.dart';
import 'package:zap_list_flutter/models/shopping_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListController {
  final _controller = StreamController<List<ShoppingList>>.broadcast();
  final _dio = Dio(BaseOptions(baseUrl: 'http://192.168.0.16:3000'));
  List<ShoppingList>? _cache;

  Stream<List<ShoppingList>> get listsStream => _controller.stream;

  Future<List<ShoppingList>> fetchLists() async {
    if (_cache != null) {
      _controller.add(_cache!);
      return _cache!;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user!.getIdToken();
      final response = await _dio.get(
        '/api/lists',
        options: Options(
          headers: {'Authorization': 'Bearer $idToken'},
          extra: {'withCredentials': true},
        ),
      );

      final data = response.data as List;
      final lists = data.map((json) => ShoppingList.fromJson(json)).toList();

      _cache = lists;
      _controller.add(lists);
      return lists;
    } catch (e) {
      _controller.addError(e);
      rethrow;
    }
  }

  Future<void> createList(String name) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user!.getIdToken();
      final response = await _dio.post(
        '/api/shopping-lists',
        data: {'name': name},
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print(
          'Erro ao criar lista: ${dioError.response?.statusCode} - ${dioError.response?.data}',
        );
      } else {
        print('Erro ao criar lista: ${dioError.message}');
      }
    } catch (e, stack) {
      // Outros erros
      print('Erro inesperado: $e');
      print(stack);
    }
  }

  Future<void> addProductToList(int listId, int productId, int quantity,
      ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user!.getIdToken();
      final response = await _dio.post(
        '/api/shopping-list-add-product',
        data: {
          'shoppingListId': listId,
          'productId': productId,
          'quantity': quantity,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $idToken'},
          extra: {'withCredentials': true},
        ),
      );
    } catch (e) {
        print('erro ao adicionar produto');
    }
  }

  void dispose() => _controller.close();
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:zap_list_flutter/models/shopping_list_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zap_list_flutter/models/shopping_list_product.dart';

class ListController {
  final _controller = StreamController<List<ShoppingList>>.broadcast();
  final _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL']?? 'http://localhost:3000'));
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

  Future<Map<String, dynamic>> fetchListProducts(int id) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user!.getIdToken();

      final res = await _dio.get(
        '/api/list/$id/productsList',
        options: Options(
          headers: {'Authorization': 'Bearer $idToken'},
          extra: {'withCredentials': true},
        ),
      );

      return {
        'products': (res.data['products'] as List)
            .map((json) => ShoppingListProduct.fromJson(json))
            .toList(),
        'list': ShoppingList.fromJson(res.data['list']),
      };
    } catch (e) {
      print('Erro ao buscar produtos da lista: $e');
      rethrow;
    }
  }


  void dispose() => _controller.close();
}

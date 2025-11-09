import 'dart:async';
import 'package:dio/dio.dart';
import 'package:zap_list_flutter/models/product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductController {
  final _controller = StreamController<List<Product>>.broadcast();
  final _dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL']?? 'http://localhost:3000'));
  List<Product>? _cache;

  Stream<List<Product>> get productStream => _controller.stream;

  Future<List<Product>> fetchProducts() async {
    if (_cache != null) {
      _controller.add(_cache!);
      return _cache!;
    }

    try {
      final response = await _dio.get('/api/products');
      final data = response.data['products'] as List;
      final products = data.map((json) => Product.fromJson(json)).toList();

      _cache = products;
      _controller.add(products);
      return products;
    } catch (e) {
      _controller.addError(e);
      rethrow;
    }
  }

  void dispose() => _controller.close();
}

import 'dart:convert';

import '../model/product.dart';
import 'package:http/http.dart' as http;

class Apicall {
  static const _baseUrl = 'https://fakestoreapi.com';
  static const _categoryUrl = 'https://fakestoreapi.com/products/categories';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(
      {required String cateogryName}) async {
    final response = cateogryName == 'all'
        ? await http.get(Uri.parse('$_baseUrl/products'))
        : await http
            .get(Uri.parse('$_baseUrl/products/category/$cateogryName'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<String>> getcategoryAll() async {
    final response = await http.get(Uri.parse(_categoryUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.every((item) => item is String)) {
        List<String> stringData = List<String>.from(data);
        stringData.insert(0, "all");
        return stringData;
      } else {
        throw Exception('not all items are strings');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

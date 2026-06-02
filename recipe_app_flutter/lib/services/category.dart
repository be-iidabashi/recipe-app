import 'dart:convert';
import 'dart:io'; // 追加
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryService {
  final baseUrl = Uri.http('127.0.0.1:8000', '/api');

  Future<List<Category>> fetchAll() async {
    final response = await http.get(
      baseUrl.replace(path: '${baseUrl.path}/categories/'),
    );

    if (response.statusCode != 200) {
      throw Exception('カテゴリを取得するのに失敗しました');
    }

    final List<Object?> jsonData = json.decode(utf8.decode(response.bodyBytes));
    return jsonData
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Category> create(String name) async {
    final response = await http.post(
      baseUrl.replace(path: '${baseUrl.path}/categories/'),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('カテゴリを作成するのに失敗しました');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<void> update(Category category) async {
    final response = await http.put(
      baseUrl.replace(path: '${baseUrl.path}/categories/${category.id}/'),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('カテゴリの更新に失敗しました');
    }
  }

  Future<void> delete(int categoryId) async {
    final response = await http.delete(
      baseUrl.replace(path: '${baseUrl.path}/categories/$categoryId/'),
    );

    if (response.statusCode != 204) {
      throw Exception('カテゴリの削除に失敗しました');
    }
  }

}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  final baseUrl = Uri.http('127.0.0.1:8000', '/api');

  Future<List<Recipe>> fetchByCategory(int categoryId) async {
    final response = await http.get(
      baseUrl.replace(path: '${baseUrl.path}/categories/$categoryId/recipes/'),
    );

    if (response.statusCode != 200) {
      throw Exception('レシピを取得するのに失敗しました');
    }

    final List<Object?> jsonData = json.decode(utf8.decode(response.bodyBytes));
    return jsonData
        .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
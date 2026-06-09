import 'dart:convert';
import 'dart:io';
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

  Future<Recipe> create(
    String title,
    String instructions,
    int cookingTimeMinutes,
    int category,
  ) async {
    final response = await http.post(
      baseUrl.replace(path: '${baseUrl.path}/recipes/'),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode({
        'title': title,
        'instructions': instructions,
        'cooking_time_minutes': cookingTimeMinutes,
        'category': category,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('レシピを作成するのに失敗しました');
    }

    return Recipe.fromJson(jsonDecode(response.body));
  }

}
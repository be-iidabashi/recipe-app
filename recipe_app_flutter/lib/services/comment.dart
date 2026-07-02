import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/comment.dart';

class CommentService {
  final baseUrl = Uri.http('127.0.0.1:8000', '/api');
  // Android用
  // final baseUrl = Uri.http('10.0.2.2:8000', '/api');


  Future<List<Comment>> fetchAll(int recipeId) async {
    final response = await http.get(
      baseUrl.replace(path: '${baseUrl.path}/recipes/$recipeId/comments/'),
    );

    if (response.statusCode != 200) {
      throw Exception('コメントを取得するのに失敗しました');
    }

    final List<Object?> jsonData = json.decode(utf8.decode(response.bodyBytes));
    return jsonData
        .map((json) => Comment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> create(String text, int recipeId) async {
    final response = await http.post(
      baseUrl.replace(path: '${baseUrl.path}/recipes/$recipeId/comments/'),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode({'recipe': recipeId, 'text': text}),
    );

    if (response.statusCode != 201) {
      throw Exception('コメントを投稿するのに失敗しました');
    }
  }
}
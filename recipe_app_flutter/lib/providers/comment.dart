import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../services/comment.dart';

final commentProvider =
    FutureProvider.family<List<Comment>, int>((ref, recipeId) async {
  final comments = await CommentService().fetchAll(recipeId);
  return comments;
});
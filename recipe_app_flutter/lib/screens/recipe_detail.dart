import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../providers/comment.dart';
import '../services/comment.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レシピ詳細'),
      ),
      body: _RecipeDetailBody(recipe: recipe),
    );
  }
}

class _RecipeDetailBody extends StatelessWidget {
  const _RecipeDetailBody({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'レシピ名: ${recipe.title}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('調理時間: ${recipe.cookingTimeMinutes}分'),
          const SizedBox(height: 10),
          Text('説明: ${recipe.instructions}'),
          const SizedBox(height: 20),
          _RecipeCommentInput(recipeId: recipe.id),
          const SizedBox(height: 20),
          Expanded(
            child: _RecipeCommentsList(recipeId: recipe.id),
          ),
        ],
      ),
    );
  }
}

class _RecipeCommentInput extends ConsumerWidget {
  const _RecipeCommentInput({required this.recipeId});
  final int recipeId;

  Future<void> _postComment({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController commentController,
    required int recipeId,
  }) async {
    if (commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('コメントを入力してください')),
      );
      return;
    }

    try {
      await CommentService().create(commentController.text, recipeId);
      commentController.clear();
      if (!context.mounted) return;
      ref.invalidate(commentProvider(recipeId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('コメントを投稿しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController();

    return TextField(
      controller: commentController,
      decoration: InputDecoration(
        labelText: 'コメントを入力',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => _postComment(
            context: context,
            ref: ref,
            commentController: commentController,
            recipeId: recipeId,
          ),
        ),
      ),
    );
  }
}

class _RecipeCommentsList extends ConsumerWidget {
  const _RecipeCommentsList({required this.recipeId});
  final int recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentAsyncValue = ref.watch(commentProvider(recipeId));

    return commentAsyncValue.when(
      data: (comments) {
        if (comments.isEmpty) {
          return const Center(child: Text('コメントはまだありません'));
        }
        return ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              title: Text(comment.text),
              subtitle: Text(
                '投稿日: ${comment.createdAt.toLocal()}',
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('エラーが発生しました: $err'),
      ),
    );
  }
}
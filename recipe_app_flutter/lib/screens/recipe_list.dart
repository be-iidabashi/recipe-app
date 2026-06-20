import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../providers/recipe.dart';
import '../services/recipe.dart';
import 'recipe_form.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key, required this.categoryId});
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('レシピ一覧'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final asyncValue = ref.watch(recipeProvider(categoryId));
          return asyncValue.when(
            data: (recipes) => _RecipeTable(recipes: recipes),
            error: (error, stack) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () { // 追加
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeFormScreen(categoryId: categoryId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}

class _RecipeTable extends ConsumerWidget {
  const _RecipeTable({required this.recipes});
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(60),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(120),
        },
        border: TableBorder.all(color: Colors.grey),
        children: [
          const TableRow(
            decoration: BoxDecoration(color: Colors.grey),
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'ID',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'レシピ名',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  '操作',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ...recipes.map(
            (recipe) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(recipe.id.toString()),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      recipe.title,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () { // 追加
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                RecipeFormScreen(recipe: recipe),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async { // 追加
                          try {
                            await RecipeService().delete(recipe.id);
                            ref.invalidate(recipeProvider);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('レシピを削除しました')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラーが発生しました: $e')),
                            );
                          }
                        },

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
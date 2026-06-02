import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../providers/category.dart';
import '../services/category.dart';
import 'category_form.dart'; // 追加

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カテゴリ一覧'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final asyncValue = ref.watch(categoryProvider);
          return asyncValue.when(
            data: (categories) => _CategoryTable(categories: categories),
            error: (error, stack) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () { // 修正
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}

class _CategoryTable extends ConsumerWidget {
  const _CategoryTable({required this.categories});

  final List<Category> categories;

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
                  'カテゴリ名',
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
          ...categories.map(
            (category) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(category.id.toString()),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      category.name,
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
                                CategoryFormScreen(category: category),
                            ),
                          );
                        },
                      ),
                      IconButton( // 修正
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await CategoryService().delete(category.id);
                            ref.invalidate(categoryProvider);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('カテゴリを削除しました')),
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
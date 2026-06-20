import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../providers/recipe.dart';
import '../services/recipe.dart';

class RecipeFormScreen extends StatelessWidget {
  const RecipeFormScreen({
    super.key,
    this.recipe,
    this.categoryId,
  });

  final Recipe? recipe;
  final int? categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe == null ? 'レシピを作成' : 'レシピを編集'),
      ),
      body: _RecipeFormBody(
        recipe: recipe,
        categoryId: categoryId,
      ),
    );
  }
}

class _RecipeFormBody extends ConsumerStatefulWidget {
  const _RecipeFormBody({
    this.recipe,
    this.categoryId,
  });

  final Recipe? recipe;
  final int? categoryId;

  @override
  _RecipeFormBodyState createState() => _RecipeFormBodyState();
}

class _RecipeFormBodyState extends ConsumerState<_RecipeFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  int _cookingTime = 0;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.recipe?.title ?? '';
    _instructionsController.text = widget.recipe?.instructions ?? '';
    _cookingTime = widget.recipe?.cookingTimeMinutes ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    try {
      if (widget.recipe == null) { // 修正
        if (widget.categoryId == null) {
          throw Exception('カテゴリーIDが指定されていません');
        }
        await RecipeService().create(
          _titleController.text,
          _instructionsController.text,
          _cookingTime,
          widget.categoryId!,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('レシピが正常に作成されました')),
        );
      } else {
        final updatedRecipe = widget.recipe!.copyWith(
          title: _titleController.text,
          instructions: _instructionsController.text,
          cookingTimeMinutes: _cookingTime,
        );
        await RecipeService().update(updatedRecipe);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('レシピが正常に更新されました')),
        );
      }
      ref.invalidate(recipeProvider);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'レシピ名'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'レシピ名を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: '作り方'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '作り方を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                '調理時間: $_cookingTime 分',
                style: const TextStyle(fontSize: 16),
              ),
              Slider(
                value: _cookingTime.toDouble(),
                min: 0,
                max: 240,
                divisions: 48,
                label: '$_cookingTime 分',
                onChanged: (value) {
                  setState(() {
                    _cookingTime = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveRecipe(),
                  child: Text(widget.recipe == null ? '作成' : '更新'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
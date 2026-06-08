import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/recipe.dart';

final recipeProvider =
    FutureProvider.family<List<Recipe>, int>((ref, categoryId) async {
  final recipes = await RecipeService().fetchByCategory(categoryId);
  return recipes;
});
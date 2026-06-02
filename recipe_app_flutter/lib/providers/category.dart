import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/category.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final categories = await CategoryService().fetchAll();
  return categories;
});
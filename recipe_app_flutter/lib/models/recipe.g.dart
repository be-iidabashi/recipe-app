// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  instructions: json['instructions'] as String,
  cookingTimeMinutes: (json['cooking_time_minutes'] as num).toInt(),
  category: (json['category'] as num).toInt(),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'instructions': instance.instructions,
  'cooking_time_minutes': instance.cookingTimeMinutes,
  'category': instance.category,
};

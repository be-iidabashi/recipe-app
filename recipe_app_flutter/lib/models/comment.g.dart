// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  recipe: (json['recipe'] as num).toInt(),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'created_at': instance.createdAt.toIso8601String(),
  'recipe': instance.recipe,
};

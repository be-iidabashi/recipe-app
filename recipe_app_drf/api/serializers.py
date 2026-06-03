from rest_framework import serializers
from .models import Category, Recipe

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category  # 使用する Django モデルを指定
        fields = ['id', 'name']  # シリアライザで使用するフィールドを指定

class RecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recipe
        fields = ['id', 'title', 'instructions', 'cooking_time_minutes', 'category']

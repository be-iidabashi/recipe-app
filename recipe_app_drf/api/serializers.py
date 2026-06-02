from rest_framework import serializers
from .models import Category

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category  # 使用する Django モデルを指定
        fields = ['id', 'name']  # シリアライザで使用するフィールドを指定
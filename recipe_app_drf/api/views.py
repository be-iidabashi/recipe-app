from rest_framework import mixins, viewsets
from rest_framework.generics import ListAPIView # 追加
from .models import Category, Recipe # Recipe 追加
from .serializers import CategorySerializer, RecipeSerializer # RecipeSerializer 追加

class CategoryViewSet(
    mixins.ListModelMixin,
    mixins.CreateModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet,
):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer

class RecipeViewSet(
    # mixins.RetrieveModelMixin, ## api/recipes/1 のレシピ1件GET用
    # mixins.ListModelMixin, ## api/recipes/ のレシピ全件GET用
    mixins.CreateModelMixin,
    mixins.UpdateModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet,
):
    queryset = Recipe.objects.all()
    serializer_class = RecipeSerializer

class RecipeListView(ListAPIView):
    serializer_class = RecipeSerializer

    def get_queryset(self):
        category_id = self.kwargs['category_id']
        return Recipe.objects.filter(category__id=category_id)
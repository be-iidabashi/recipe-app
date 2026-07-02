from rest_framework import mixins, viewsets
from rest_framework.generics import ListAPIView, ListCreateAPIView
from .models import Category, Recipe, Comment
from .serializers import CategorySerializer, RecipeSerializer, CommentSerializer

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
    
class CommentListCreateView(ListCreateAPIView):
    queryset = Comment.objects.all()
    serializer_class = CommentSerializer

    def get_queryset(self):
        recipe_id = self.kwargs['recipe_id']
        return Comment.objects.filter(recipe_id=recipe_id)

    def perform_create(self, serializer):
        recipe_id = self.kwargs['recipe_id']
        serializer.save(recipe_id=recipe_id)
from django.urls import path, include
from rest_framework.routers import DefaultRouter

from . import views

router = DefaultRouter()
router.register('categories', views.CategoryViewSet)
router.register('recipes', views.RecipeViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path(
        "categories/<int:category_id>/recipes/",
        views.RecipeListView.as_view(),
        name="recipes",
    ),
]
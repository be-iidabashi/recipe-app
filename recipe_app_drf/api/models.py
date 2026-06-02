from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Recipe(models.Model):
    title = models.CharField(max_length=200)
    instructions = models.TextField()
    category = models.ForeignKey(
        Category, on_delete=models.CASCADE, related_name="recipes"
    )
    cooking_time_minutes = models.IntegerField()

    def __str__(self):
        return self.title
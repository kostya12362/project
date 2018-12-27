from django.contrib.auth import get_user_model
from django.db import models

User = get_user_model()


class Repo(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    deep_link = models.URLField(max_length=2048)
    relative_dir = models.CharField(max_length=32)

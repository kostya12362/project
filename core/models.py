from django.contrib.auth import get_user_model
from django.db import models
from django.contrib.auth.models import AbstractUser



class CustomUser(AbstractUser):
	middlename = models.CharField(max_length=100, blank=True)
	group = models.CharField(max_length=10, blank=True)

class Repo(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    deep_link = models.URLField(max_length=2048)
    relative_dir = models.CharField(max_length=32)

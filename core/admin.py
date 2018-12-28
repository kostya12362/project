from django.contrib import admin
from .models import CustomUser
from django.contrib.auth import get_user_model

admin.site.register(CustomUser)
# Register your models here.

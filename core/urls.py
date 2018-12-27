from django.contrib.auth.decorators import login_required
from django.urls import path
from . import views
from django.contrib.auth import views as auth_views


urlpatterns = [
    path('signup/', views.signup, name='signup'),
    path('', login_required(views.MainView.as_view()), name='main'),
    path('signin/', auth_views.LoginView.as_view(), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('repo/<int:pk>/', login_required(views.RepoView.as_view()), name='repo'),
]

import os
import random
import string

from django.contrib.auth import login, authenticate
from django.contrib.auth.forms import UserCreationForm
from django.shortcuts import render, redirect
from django.urls import reverse_lazy
from django.views.generic import ListView, CreateView, DetailView
from django.conf import settings

from git import Repo as GitRepo

from .forms import AddRepoForm
from .models import Repo


def signup(request):
	if request.method == 'POST':
		form = UserCreationForm(request.POST)
		if form.is_valid():
			form.save()
			username = form.cleaned_data.get('username')
			raw_password = form.cleaned_data.get('password1')
			user = authenticate(username=username, password=raw_password)
			login(request, user)
			return redirect('main')
	else:
		form = UserCreationForm()
	return render(request, 'signup.html', {'form': form})


class MainView(CreateView, ListView):
	template_name = 'main.html'
	success_url = reverse_lazy('main')
	form_class = AddRepoForm

	def get_queryset(self):
		return Repo.objects.filter(user=self.request.user)

	def form_valid(self, form):
		repo = form.save(commit=False)
		repo.user = self.request.user

		repo_dir = ''.join(random.choice(string.ascii_letters + string.digits)
						   for _ in range(10))
		repo.relative_dir = repo_dir

		repo.save()

		GitRepo.clone_from(repo.deep_link, os.path.join(settings.REPOS_DIR, repo_dir))
		return redirect(self.success_url)


def main():
	v = MainView()


class RepoView(DetailView):
	model = Repo
	template_name = 'repo.html'
	success_url = reverse_lazy('main')

	def get(self, request, *args, **kwargs):
		if 'remove' in request.GET.keys():
			self.get_object().delete()
			return redirect(self.success_url)
		elif 'generate' in request.GET.keys():
			generate_doc(self.get_object().relative_dir)
		elif 'update' in request.GET.keys():
			repo = GitRepo(os.path.join(settings.REPOS_DIR, self.get_object().relative_dir))
			o = repo.remotes.origin
			o.pull()

		return super().get(request, *args, **kwargs)

	def get_context_data(self, *args, **kwargs):
		context = super().get_context_data(*args, **kwargs)

		docs = []
		for path, dirs, files in os.walk('docs/repos/' + self.get_object().relative_dir):
			for filename in files:
				if '__init__' not in filename:
					fullpath = os.path.join(path, filename)
					docs.append(self.get_object().relative_dir + fullpath.split(self.get_object().relative_dir)[-1])
		context['docs'] = docs
		return context


def generate_doc(repo_name):
	os.system("pycco repos/" + repo_name + "/**/*.py -p")
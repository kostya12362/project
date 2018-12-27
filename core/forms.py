from django import forms

from core.models import Repo


class AddRepoForm(forms.ModelForm):
    class Meta:
        model = Repo
        fields = ('deep_link',)

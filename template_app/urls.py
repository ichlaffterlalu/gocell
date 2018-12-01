from django.urls import re_path
from .views import index
#url for app
urlpatterns = [
    re_path(r'^$', index, name='index'),
]

from django.urls import path
from todo import views
from todo.views import todoview, TodoListView

urlpatterns = [
    path('', views.Home, name='Home'),
    path('todoview', todoview.as_view()),
    path('TodoListView',TodoListView.as_view()),
    path('update_items/<int:pk>',views.update_items,name='update_items'),
    path('delete_items/<int:pk>/delete',views.delete_items,name='delete_items'),

]
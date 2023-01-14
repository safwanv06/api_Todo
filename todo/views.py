
from django.http import HttpResponse
from django.shortcuts import render
from rest_framework import status, viewsets, generics
from rest_framework.decorators import api_view
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from todo.models import Todo
from todo.serializer import todoserializer


# Create your views here.
def Home(request):
    return HttpResponse('hello')
class todoview(APIView):
    def post(self,request):
        serializer=todoserializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"status":"success","data":serializer.data},status=status.HTTP_200_OK)
        else:
            return Response({"status": "error", "data": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
class TodoListView(generics.ListCreateAPIView):
    queryset=Todo.objects.all()
    serializer_class=todoserializer


@api_view(['POST'])
def update_items(request,pk):
    item=Todo.objects.get(pk=pk)
    data=todoserializer(instance=item,data=request.data)
    if data.is_valid():
        data.save()
        return Response(data.data)
    else:
        return Response(status=status.HTTP_404_NOT_FOUND)
@api_view(['DELETE'])
def delete_items(request,pk):
    item=get_object_or_404(Todo,pk=pk)
    item.delete()
    return Response({"message":"deleted"},status=status.HTTP_202_ACCEPTED)


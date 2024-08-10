import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/screens/home/blocs/todo_list/todo_list_bloc.dart';

int generateTodoIndex(BuildContext context){
  final TodoListState todoListState = context.read<TodoListBloc>().state;
  if (todoListState.todoList.isEmpty) return 1;
  return int.parse(todoListState.todoList.first.id) + 1;
}